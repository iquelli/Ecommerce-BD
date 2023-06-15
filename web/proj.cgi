#!/usr/bin/python3

#
# 		File: proj.cgi
# 		Authors:
# 		        - Gonçalo Bárias (ist1103124)
# 		        - Raquel Braunschweig (ist1102624)
#               - Vasco Paisana (ist1102533)
# 		Group: 2
# 		Description: Used to create the web app prototype.

from wsgiref.handlers import CGIHandler
from flask import Flask, render_template, request, redirect, url_for
from datetime import datetime
import psycopg2
import psycopg2.extras

# DBMS configs
DB_HOST = "db"
DB_DATABASE = "postgres"
DB_USER = "postgres"
DB_PASSWORD = "postgres"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)

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
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query_next_cust_no = "SELECT MAX(cust_no) + 1 FROM customer;"
        cursor.execute(query_next_cust_no)
        [cust_no] = cursor.fetchone()
        if cust_no is None:
            cust_no = "0"
        name = request.form["name"]
        email = request.form["email"]
        phone = request.form["phone"]
        address = request.form["address"]
        if name == "" or email == "":
            return redirect(url_for("customer_register_get"))

        data = (cust_no, name, email, phone, address)
        query = "INSERT INTO customer(cust_no, name, email, phone, address) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, data)
        return redirect(url_for("orders_list", user=cust_no))
    except Exception as e:
        return render_template(
            "error.html", error=e, params="customer", url=url_for("homepage")
        )
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/customer/login", methods=["GET"])
def customer_login_get():
    try:
        return render_template("customer_login.html")
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)


@_app.route("/customer/login", methods=["POST"])
def customer_login_post():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        cust_no = request.form["user"]
        email = request.form["email"]
        if cust_no == "" or email == "":
            return redirect(url_for("customer_login_get"))

        return redirect(url_for("orders_list", user=cust_no))
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/customer/remove")
def customer_remove():
    dbConn = None
    cursor = None
    cust_no = request.args.get("user")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "DELETE FROM customer WHERE cust_no = %s;"
        cursor.execute(query, (cust_no,))
        return redirect(url_for("homepage"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/customers")
def customers_list():
    dbConn = None
    cursor = None
    offset = int(request.args.get("offset", 0))

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "SELECT * FROM customer ORDER BY name OFFSET %s LIMIT %s;"
        cursor.execute(query, (offset, 10))
        return render_template(
            "customers.html", cursor=cursor, offset=offset, params=request.args
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/products", methods=["POST"])
def order_register():
    dbConn = None
    cursor = None
    cust_no = request.args.get("user")
    order_no = request.args.get("order")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        if order_no:
            data, num_products = (), len(request.form)
            for sku in request.form.keys():
                data += (order_no, sku, request.form[sku])
            query = f"""
            INSERT INTO contains(order_no, SKU, qty) VALUES
            {",".join("(%s, %s, %s)" for _ in range(num_products))};"""
            cursor.execute(query, data)
            return redirect(url_for("order_details_get", user=cust_no, order=order_no))

        query_next_order_no = "SELECT MAX(order_no) + 1 FROM orders;"
        cursor.execute(query_next_order_no)
        [order_no] = cursor.fetchone()
        if order_no is None:
            order_no = "0"

        data = (order_no, cust_no, datetime.today().strftime("%Y-%m-%d"))
        num_products = len(request.form)
        for sku in request.form.keys():
            data += (order_no, sku, request.form[sku])
        query = f"""BEGIN TRANSACTION;
        INSERT INTO orders(order_no, cust_no, date) VALUES (%s, %s, %s);
        INSERT INTO contains(order_no, SKU, qty) VALUES
        {",".join("(%s, %s, %s)" for _ in range(num_products))}; END TRANSACTION;"""
        cursor.execute(query, data)
        return redirect(url_for("order_details_get", user=cust_no, order=order_no))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/orders")
def orders_list():
    dbConn = None
    cursor = None
    offset = int(request.args.get("offset", 0))
    cust_no = request.args.get("user")
    payed = request.args.get("payed")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        if payed:
            query = """SELECT order_no, date, SUM(qty * price) FROM orders
            NATURAL JOIN pay NATURAL JOIN contains NATURAL JOIN product
            WHERE cust_no = %s GROUP BY order_no
            OFFSET %s LIMIT %s;"""
        else:
            query = """SELECT order_no, date, SUM(qty * price) FROM orders
            LEFT JOIN pay USING (order_no) NATURAL JOIN contains NATURAL JOIN product
            WHERE orders.cust_no = %s AND pay.order_no IS NULL GROUP BY order_no
            OFFSET %s LIMIT %s;"""
        cursor.execute(query, (cust_no, offset, 10))
        return render_template(
            "orders.html", cursor=cursor, offset=offset, params=request.args
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/order/edit", methods=["GET"])
def order_edit_get():
    dbConn = None
    cursor = None
    order_no = request.args.get("order")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = """
        SELECT * FROM product NATURAL JOIN contains
        WHERE order_no = %s ORDER BY price;"""
        cursor.execute(query, (order_no,))
        return render_template("order_edit.html", cursor=cursor, params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/order/edit", methods=["POST"])
def order_edit_post():
    dbConn = None
    cursor = None
    order_no = request.args.get("order")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "UPDATE contains SET qty = %s WHERE order_no = %s AND SKU = %s"
        for sku in request.form.keys():
            cursor.execute(query, (request.form[sku], order_no, sku))
        return redirect(url_for("homepage"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/order/details", methods=["GET"])
def order_details_get():
    dbConn = None
    cursor1 = None
    cursor2 = None
    order_no = request.args.get("order")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor1 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor2 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query1 = "SELECT SKU, name, price*qty FROM product NATURAL JOIN contains WHERE order_no = %s;"
        cursor1.execute(query1, (order_no,))
        query2 = "SELECT SUM(price*qty) FROM product NATURAL JOIN contains WHERE order_no = %s;"
        cursor2.execute(query2, (order_no,))
        [t_price] = cursor2.fetchone()

        return render_template(
            "order_details.html", cursor=cursor1, t_price=t_price, params=request.args
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor1.close()
        cursor2.close()
        dbConn.close()


@_app.route("/order/details", methods=["POST"])
def order_details_post():
    dbConn = None
    cursor = None
    cust_no = request.args.get("user")
    order_no = request.args.get("order")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "INSERT INTO pay(order_no, cust_no) VALUES (%s, %s)"
        cursor.execute(query, (order_no, cust_no))
        return redirect(
            url_for("orders_list", user=request.args.get("user"), payed=True)
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/product/register", methods=["GET"])
def product_register_get():
    try:
        return render_template("product_register.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/product/register", methods=["POST"])
def product_register_post():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        sku = request.form["sku"]
        name = request.form["name"]
        description = request.form["description"]
        price = request.form["price"]
        ean = request.form["ean"]
        if ean == "":
            ean = None
        if sku == "" or name == "" or price == "":
            return redirect(
                url_for("product_register_get", user=request.args.get("user"))
            )

        query = "INSERT INTO product(SKU, name, description, price, ean) VALUES (%s, %s, %s, %s, %s);"
        data = (sku, name, description, price, ean)
        cursor.execute(query, data)
        return redirect(url_for("homepage"))
    except Exception as e:
        return render_template(
            "error.html", error=e, params="product", url=url_for("homepage")
        )
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/product/remove")
def product_remove():
    dbConn = None
    cursor = None
    sku = request.args.get("product")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        if request.args.get("order"):
            query = "DELETE FROM contains WHERE SKU = %s AND order_no = %s;"
            cursor.execute(query, (sku, request.args.get("order")))
        else:
            query = "DELETE FROM product WHERE SKU = %s;"
            cursor.execute(query, (sku,))
        return redirect(url_for("homepage"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/product/edit")
def product_edit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        sku = request.form["sku"]
        name = request.form["name"]
        description = request.form["description"]
        price = request.form["price"]
        ean = request.form["ean"]
        if sku == "" or name == "" or price == "" or ean == "":
            return redirect(url_for("products_list", user=request.args.get("user")))

        query = """
        UPDATE product
        SET SKU = %s, name = %s, description = %s, price = %s, ean = %s
        WHERE SKU = %s"""
        data = (sku, name, description, price, ean, request.args.get("product"))
        cursor.execute(query, data)
        return redirect(url_for("homepage"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/products")
def products_list():
    dbConn = None
    cursor = None
    order_no = request.args.get("order")
    offset = int(request.args.get("offset", 0))

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        if order_no:
            query = """
            SELECT * FROM product LEFT JOIN contains USING (SKU)
            WHERE order_no != %s ORDER BY price OFFSET %s LIMIT %s;"""
            cursor.execute(query, (order_no, offset, 10))
        else:
            query = "SELECT * FROM product ORDER BY name;"
            query = "SELECT * FROM product ORDER BY name OFFSET %s LIMIT %s;"
            cursor.execute(query, (offset, 10))
        return render_template(
            "products.html", cursor=cursor, offset=offset, params=request.args
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/supplier/register", methods=["GET"])
def supplier_register_get():
    try:
        return render_template("supplier_register.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/supplier/register", methods=["POST"])
def supplier_register_post():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        tin = request.form["tin"]
        name = request.form["name"]
        address = request.form["address"]
        sku = request.form["sku"]
        date = request.form["date"]
        if sku == "":
            return redirect(
                url_for("supplier_register_get", user=request.args.get("user"))
            )

        data = (tin, name, address, sku, date)
        query = "INSERT INTO supplier(TIN, name, address, SKU, date) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, data)
        return redirect(url_for("homepage"))
    except Exception as e:
        return render_template(
            "error.html", error=e, params="supplier", url=url_for("homepage")
        )
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/supplier/remove")
def supplier_remove():
    dbConn = None
    cursor = None
    tin = request.args.get("supplier")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "DELETE FROM supplier WHERE TIN = %s;"
        cursor.execute(query, (tin,))
        return redirect(url_for("homepage"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/suppliers")
def suppliers_list():
    dbConn = None
    cursor = None
    offset = int(request.args.get("offset", 0))
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "SELECT * FROM supplier OFFSET %s LIMIT %s;"
        cursor.execute(query, (offset, 10))
        return render_template(
            "suppliers.html", cursor=cursor, offset=offset, params=request.args
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


CGIHandler().run(_app)
