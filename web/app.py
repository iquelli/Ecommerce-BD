#!/usr/bin/python3

from flask import Flask, render_template, request, redirect, url_for
from datetime import datetime
import math
import psycopg
from psycopg_pool import ConnectionPool
from psycopg.rows import namedtuple_row

# postgres://{user}:{password}@{hostname}:{port}/{database-name}
# the pool starts connecting immediately.
DATABASE_URL = "postgres://postgres:postgres@db/postgres"
pool = ConnectionPool(conninfo=DATABASE_URL)
_app = Flask(__name__)


# Runs the function once the root page is requested.
# The request comes with the folder structure setting ~/web as the root.
@_app.route("/")
def homepage():
    try:
        return render_template("index.html")
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/customer/register", methods=["GET"])
def customer_register_get():
    try:
        return render_template("customer_register.html")
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/customer/register", methods=["POST"])
def customer_register_post():
    try:
        query_next_cust_no = "SELECT MAX(cust_no) + 1 FROM customer;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                [cust_no] = cur.execute(query_next_cust_no).fetchone()
        if cust_no is None:
            cust_no = "0"
        name = request.form["name"]
        email = request.form["email"]
        phone = request.form["phone"]
        address = request.form["address"]
        if name == "" or email == "":
            return redirect(url_for("customer_register_get"))

        query = "INSERT INTO customer(cust_no, name, email, phone, address) VALUES (%s, %s, %s, %s, %s);"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (cust_no, name, email, phone, address))
            conn.commit()
        return redirect(url_for("orders_list", user=cust_no))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/customer/login", methods=["GET"])
def customer_login_get():
    try:
        return render_template("customer_login.html")
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)


@_app.route("/customer/login", methods=["POST"])
def customer_login_post():
    try:
        cust_no = request.form["user"]
        if cust_no == "":
            return redirect(url_for("customer_login_get"))

        query = "SELECT * FROM customer WHERE cust_no = %s;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                customer = cur.execute(query, (cust_no,)).fetchone()
        if customer is None:
            return redirect(url_for("customer_login_get"))
        return redirect(url_for("orders_list", user=cust_no))
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)


@_app.route("/customer/remove")
def customer_remove():
    cust_no = request.args.get("user")
    try:
        query = "DELETE FROM customer WHERE cust_no = %s;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (cust_no,))
            conn.commit()
        return redirect(url_for("customers_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/customers")
def customers_list():
    offset = int(request.args.get("offset", 0))
    try:
        query_1 = "SELECT COUNT(*) FROM customer;"
        query_2 = "SELECT * FROM customer ORDER BY name OFFSET %s LIMIT %s;"
        with pool.connection() as conn:
            cur = psycopg.ClientCursor(conn)
            [max] = cur.execute(query_1 + query_2, (offset, 10)).fetchone()
            cur.nextset()
            return render_template(
                "customers.html",
                cursor=cur,
                offset=offset,
                max=math.ceil(max / 10 - 1) * 10,
            )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/order/register")
def order_register():
    cust_no = request.args.get("user")
    try:
        query_next_order_no = "SELECT MAX(order_no) + 1 FROM orders;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                [order_no] = cur.execute(query_next_order_no).fetchone()
        if order_no is None:
            order_no = "0"

        data = (order_no, cust_no, datetime.today().strftime("%Y-%m-%d"))
        num_products = 0
        for key in request.args.keys():
            if key == "user" or key == "offset":
                continue
            data += (order_no, key, request.args.get(key))
            num_products += 1
        query = f"""BEGIN TRANSACTION;
        INSERT INTO orders(order_no, cust_no, date) VALUES (%s, %s, %s);
        INSERT INTO contains(order_no, SKU, qty) VALUES
        {",".join("(%s, %s, %s)" for _ in range(num_products))}; END TRANSACTION;"""
        with pool.connection() as conn:
            cur = psycopg.ClientCursor(conn)
            cur.execute(query, data)
            conn.commit()
        return redirect(url_for("order_details_get", user=cust_no, order=order_no))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/orders")
def orders_list():
    offset = int(request.args.get("offset", 0))
    cust_no = request.args.get("user")
    payed = request.args.get("payed")
    try:
        if payed:
            query = """SELECT COUNT(*) FROM orders
            NATURAL JOIN pay WHERE cust_no = %s;"""
            with pool.connection() as conn:
                with conn.cursor(row_factory=namedtuple_row) as cur:
                    [max] = cur.execute(query, (cust_no,)).fetchone()
            query = """SELECT order_no, date, SUM(qty * price) FROM orders
            NATURAL JOIN pay NATURAL JOIN contains NATURAL JOIN product
            WHERE cust_no = %s GROUP BY order_no
            OFFSET %s LIMIT %s;"""
        else:
            query = """SELECT COUNT(*) FROM orders
            LEFT JOIN pay USING (order_no) WHERE orders.cust_no = %s AND pay.order_no IS NULL;"""
            with pool.connection() as conn:
                with conn.cursor(row_factory=namedtuple_row) as cur:
                    [max] = cur.execute(query, (cust_no,)).fetchone()
            query = """SELECT order_no, date, SUM(qty * price) FROM orders
            LEFT JOIN pay USING (order_no) NATURAL JOIN contains NATURAL JOIN product
            WHERE orders.cust_no = %s AND pay.order_no IS NULL GROUP BY order_no
            OFFSET %s LIMIT %s;"""
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (cust_no, offset, 10))
                return render_template(
                    "orders.html",
                    cursor=cur,
                    offset=offset,
                    max=math.ceil(max / 10 - 1) * 10,
                    user=cust_no,
                    payed=payed,
                )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/order/details", methods=["GET"])
def order_details_get():
    order_no = request.args.get("order")
    try:
        query1 = "SELECT SUM(price*qty) FROM product NATURAL JOIN contains WHERE order_no = %s;"
        query2 = "SELECT SKU, name, qty, price*qty FROM product NATURAL JOIN contains WHERE order_no = %s;"
        with pool.connection() as conn:
            cur = psycopg.ClientCursor(conn)
            [t_price] = cur.execute(query1 + query2, (order_no, order_no)).fetchone()
            cur.nextset()
            return render_template(
                "order_details.html",
                cursor=cur,
                t_price=t_price,
                user=request.args.get("user"),
                payed=request.args.get("payed"),
            )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/order/details", methods=["POST"])
def order_details_post():
    cust_no = request.args.get("user")
    order_no = request.args.get("order")
    try:
        query = "INSERT INTO pay(order_no, cust_no) VALUES (%s, %s)"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (order_no, cust_no))
            conn.commit()
        return redirect(
            url_for("orders_list", user=request.args.get("user"), payed=True)
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/product/register", methods=["GET"])
def product_register_get():
    try:
        return render_template("product_register.html")
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/product/register", methods=["POST"])
def product_register_post():
    try:
        sku = request.form["sku"]
        name = request.form["name"]
        description = request.form["description"]
        price = request.form["price"]
        ean = request.form["ean"]
        if ean == "":
            ean = None
        if sku == "" or name == "" or price == "":
            return redirect(url_for("product_register_get", user="manager"))

        query = "INSERT INTO product(SKU, name, description, price, ean) VALUES (%s, %s, %s, %s, %s);"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (sku, name, description, price, ean))
            conn.commit()
        return redirect(url_for("products_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, params="product")


@_app.route("/product/remove")
def product_remove():
    sku = request.args.get("product")
    try:
        query = "DELETE FROM product WHERE SKU = %s;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (sku,))
            conn.commit()
        return redirect(url_for("products_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/product/edit", methods=["POST"])
def product_edit():
    try:
        sku = request.form["popup-sku"]
        description = request.form["popup-description"]
        price = request.form["popup-price"]
        if sku == "" or price == "":
            return redirect(url_for("products_list", user="manager"))

        query = "UPDATE product SET description = %s, price = %s WHERE SKU = %s"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (description, price, sku))
            conn.commit()
        return redirect(url_for("products_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/products")
def products_list():
    offset = int(request.args.get("offset", 0))
    try:
        query = "SELECT COUNT(*) FROM product;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                [max] = cur.execute(query).fetchone()
        query = "SELECT * FROM product ORDER BY name OFFSET %s LIMIT %s;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (offset, 10))
                return render_template(
                    "products.html",
                    cursor=cur,
                    offset=offset,
                    max=math.ceil(max / 10 - 1) * 10,
                    user=request.args.get("user"),
                )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/supplier/register", methods=["GET"])
def supplier_register_get():
    try:
        return render_template("supplier_register.html")
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/supplier/register", methods=["POST"])
def supplier_register_post():
    try:
        tin = request.form["tin"]
        name = request.form["name"]
        address = request.form["address"]
        sku = request.form["sku"]
        date = request.form["date"]
        if sku == "":
            return redirect(url_for("supplier_register_get", user="manager"))

        query = "INSERT INTO supplier(TIN, name, address, SKU, date) VALUES (%s, %s, %s, %s, %s);"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (tin, name, address, sku, date))
            conn.commit()
        return redirect(url_for("suppliers_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, params="supplier")


@_app.route("/supplier/remove")
def supplier_remove():
    tin = request.args.get("supplier")
    try:
        query = "DELETE FROM supplier WHERE TIN = %s;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (tin,))
            conn.commit()
        return redirect(url_for("suppliers_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/suppliers")
def suppliers_list():
    offset = int(request.args.get("offset", 0))
    try:
        query = "SELECT COUNT(*) FROM supplier;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                [max] = cur.execute(query).fetchone()
        query = "SELECT * FROM supplier OFFSET %s LIMIT %s;"
        with pool.connection() as conn:
            with conn.cursor(row_factory=namedtuple_row) as cur:
                cur.execute(query, (offset, 10))
                return render_template(
                    "suppliers.html",
                    cursor=cur,
                    offset=offset,
                    max=math.ceil(max / 10 - 1) * 10,
                    params=request.args,
                )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
