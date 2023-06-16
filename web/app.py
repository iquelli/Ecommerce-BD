#!/usr/bin/python3

from flask import Flask, render_template, request, redirect, url_for
from datetime import datetime
import math
import psycopg
from psycopg_pool import ConnectionPool

# postgres://{user}:{password}@{hostname}:{port}/{database-name}
# the pool starts connecting immediately.
DATABASE_URL = "postgres://db:db@postgres/db"
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
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

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

        query = "INSERT INTO customer(cust_no, name, email, phone, address) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, (cust_no, name, email, phone, address))
        return redirect(url_for("orders_list", user=cust_no))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
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
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        cust_no = request.form["user"]
        if cust_no == "":
            return redirect(url_for("customer_login_get"))

        query = "SELECT * FROM customer WHERE cust_no = %s;"
        cursor.execute(query, (cust_no,))
        customer = cursor.fetchone()
        if customer is None:
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
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        query = "DELETE FROM customer WHERE cust_no = %s;"
        cursor.execute(query, (cust_no,))
        return redirect(url_for("customers_list", user="manager"))
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
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        query = "SELECT COUNT(*) FROM customer;"
        cursor.execute(query)
        [max] = cursor.fetchone()
        query = "SELECT * FROM customer ORDER BY name OFFSET %s LIMIT %s;"
        cursor.execute(query, (offset, 10))
        return render_template(
            "customers.html",
            cursor=cursor,
            offset=offset,
            max=math.ceil(max / 10 - 1) * 10,
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/order/register")
def order_register():
    dbConn = None
    cursor = None
    cust_no = request.args.get("user")
    try:
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        query_next_order_no = "SELECT MAX(order_no) + 1 FROM orders;"
        cursor.execute(query_next_order_no)
        [order_no] = cursor.fetchone()
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
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        if payed:
            query = """SELECT COUNT(*) FROM orders
            NATURAL JOIN pay WHERE cust_no = %s;"""
            cursor.execute(query, (cust_no,))
            [max] = cursor.fetchone()
            query = """SELECT order_no, date, SUM(qty * price) FROM orders
            NATURAL JOIN pay NATURAL JOIN contains NATURAL JOIN product
            WHERE cust_no = %s GROUP BY order_no
            OFFSET %s LIMIT %s;"""
        else:
            query = """SELECT COUNT(*) FROM orders
            LEFT JOIN pay USING (order_no) WHERE orders.cust_no = %s AND pay.order_no IS NULL;"""
            cursor.execute(query, (cust_no,))
            [max] = cursor.fetchone()
            query = """SELECT order_no, date, SUM(qty * price) FROM orders
            LEFT JOIN pay USING (order_no) NATURAL JOIN contains NATURAL JOIN product
            WHERE orders.cust_no = %s AND pay.order_no IS NULL GROUP BY order_no
            OFFSET %s LIMIT %s;"""
        cursor.execute(query, (cust_no, offset, 10))
        return render_template(
            "orders.html",
            cursor=cursor,
            offset=offset,
            max=math.ceil(max / 10 - 1) * 10,
            user=cust_no,
            payed=payed,
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/order/details", methods=["GET"])
def order_details_get():
    dbConn = None
    cursor1 = None
    cursor2 = None
    order_no = request.args.get("order")
    try:
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor1 = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)
        cursor2 = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        query1 = "SELECT SKU, name, qty, price*qty FROM product NATURAL JOIN contains WHERE order_no = %s;"
        cursor1.execute(query1, (order_no,))
        query2 = "SELECT SUM(price*qty) FROM product NATURAL JOIN contains WHERE order_no = %s;"
        cursor2.execute(query2, (order_no,))
        [t_price] = cursor2.fetchone()

        return render_template(
            "order_details.html",
            cursor=cursor1,
            t_price=t_price,
            user=request.args.get("user"),
            payed=request.args.get("payed"),
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
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

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
        return render_template("product_register.html")
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/product/register", methods=["POST"])
def product_register_post():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

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
        cursor.execute(query, (sku, name, description, price, ean))
        return redirect(url_for("products_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, params="product")
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
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        query = "DELETE FROM product WHERE SKU = %s;"
        cursor.execute(query, (sku,))
        return redirect(url_for("products_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/product/edit", methods=["POST"])
def product_edit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        sku = request.form["popup-sku"]
        description = request.form["popup-description"]
        price = request.form["popup-price"]
        if sku == "" or price == "":
            return redirect(url_for("products_list", user="manager"))

        query = "UPDATE product SET description = %s, price = %s WHERE SKU = %s"
        cursor.execute(query, (description, price, sku))
        return redirect(url_for("products_list", user="manager"))
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
    offset = int(request.args.get("offset", 0))

    try:
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        query = "SELECT COUNT(*) FROM product;"
        cursor.execute(query)
        [max] = cursor.fetchone()
        query = "SELECT * FROM product ORDER BY name OFFSET %s LIMIT %s;"
        cursor.execute(query, (offset, 10))
        return render_template(
            "products.html",
            cursor=cursor,
            offset=offset,
            max=math.ceil(max / 10 - 1) * 10,
            user=request.args.get("user"),
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/supplier/register", methods=["GET"])
def supplier_register_get():
    try:
        return render_template("supplier_register.html")
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))


@_app.route("/supplier/register", methods=["POST"])
def supplier_register_post():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        tin = request.form["tin"]
        name = request.form["name"]
        address = request.form["address"]
        sku = request.form["sku"]
        date = request.form["date"]
        if sku == "":
            return redirect(url_for("supplier_register_get", user="manager"))

        query = "INSERT INTO supplier(TIN, name, address, SKU, date) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, (tin, name, address, sku, date))
        return redirect(url_for("suppliers_list", user="manager"))
    except Exception as e:
        return render_template("error.html", error=e, params="supplier")
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
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        query = "DELETE FROM supplier WHERE TIN = %s;"
        cursor.execute(query, (tin,))
        return redirect(url_for("suppliers_list", user="manager"))
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
        dbConn = psycopg.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg.extras.DictCursor)

        query = "SELECT COUNT(*) FROM supplier;"
        cursor.execute(query)
        [max] = cursor.fetchone()
        query = "SELECT * FROM supplier OFFSET %s LIMIT %s;"
        cursor.execute(query, (offset, 10))
        return render_template(
            "suppliers.html",
            cursor=cursor,
            offset=offset,
            max=math.ceil(max / 10 - 1) * 10,
            params=request.args,
        )
    except Exception as e:
        return render_template("error.html", error=e, url=url_for("homepage"))
    finally:
        cursor.close()
        dbConn.close()


if __name__ == "__main__":
    _app.run()
