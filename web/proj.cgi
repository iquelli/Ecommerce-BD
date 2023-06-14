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
        return render_template("index.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)


@_app.route("/customer/register", methods=["GET"])
def customer_register_get():
    try:
        return render_template("customer_register.html")
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)


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
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/customer/remove")
def customer_remove():
    dbConn = None
    cursor = None
    cust_no = request.args.get("customer")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "DELETE FROM customer WHERE cust_no = %s;"
        cursor.execute(query, (cust_no,))
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/customers")
def customers_list():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "SELECT * FROM customer;"
        cursor.execute(query)
        return render_template("customers.html", cursor=cursor, params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/order/register", methods=["GET"])
def order_register_get():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "SELECT * FROM product;"
        cursor.execute(query)
        return render_template(
            "order_register.html", cursor=cursor, params=request.args
        )
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/order/register", methods=["POST"])
def order_register_post():
    dbConn = None
    cursor = None
    cust_no = request.args.get("customer")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query_next_order_no = "SELECT MAX(order_no) + 1 FROM orders;"
        cursor.execute(query_next_order_no)
        [order_no] = cursor.fetchone()
        if order_no is None:
            order_no = "0"

        data = (order_no, cust_no, datetime.today().strftime("%Y-%m-%d"))
        NUM_PRODUCTS = 0
        # TODO: Add all products of the order to data with the right qty
        query = f"""
        BEGIN TRANSACTION;
        INSERT INTO orders(order_no, cust_no, date) VALUES (%s, %s, %s);
        INSERT INTO contains(order_no, SKU, qty) VALUES
        {",".join("(%s, %s, %s)" for _ in range(NUM_PRODUCTS))};
        END TRANSACTION;
        """
        cursor.execute(query, data)
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/orders")
def orders_lists():
    dbConn = None
    cursor = None
    cust_no = request.args.get("customer")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        if cust_no:
            query = "SELECT * FROM orders WHERE cust_no = %s;"
        else:
            query = "SELECT * FROM orders;"
        cursor.execute(query)
        return render_template("orders.html", cursor=cursor, params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/order/product/add", methods=["GET"])
def product_add_to_order_get():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "SELECT * FROM product;"
        cursor.execute(query)
        return render_template("order_edit.html", cursor=cursor, params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/order/product/add", methods=["POST"])
def product_add_to_order_post():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        sku = request.form["sku"]
        qty = request.form["qty"]
        query = "INSERT INTO contains(order_no, SKU, qty) VALUES (%s, %s, %s)"
        cursor.execute(query, (request.args.get("order"), sku, qty))
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/order/pay", methods=["GET"])
def perform_payment_get():
    try:
        return render_template("pay.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)


@_app.route("/order/pay", methods=["POST"])
def perform_payment_post():
    dbConn = None
    cursor = None
    cust_no = request.args.get("customer")
    order_no = request.args.get("order")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "INSERT INTO pay(order_no, cust_no) VALUES (%s, %s)"
        cursor.execute(query, (order_no, cust_no))
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/product/register", methods=["GET"])
def product_register_get():
    try:
        return render_template("product_register.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)


@_app.route("/product/register", methods=["POST"])
def product_register_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        sku = request.form["sku"]
        name = request.form["name"]
        description = request.form["description"]
        price = request.form["price"]
        ean = request.form["ean"]
        if sku == "" or name == "" or price == "" or ean == "":
            return redirect(url_for("product_register_get"))

        query = "INSERT INTO product(SKU, name, description, price, ean) VALUES (%s, %s, %s, %s, %s);"
        data = (sku, name, description, price, ean)
        cursor.execute(query, data)
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
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
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/product/edit", methods=["GET"])
def product_edit_get():
    try:
        return render_template("product_edit.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)


@_app.route("/product/edit", methods=["POST"])
def product_edit_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        sku = request.form["sku"]
        name = request.form["name"]
        description = request.form["description"]
        price = request.form["price"]
        ean = request.form["ean"]
        if sku == "" or name == "" or price == "" or ean == "":
            return redirect(url_for("product_edit_get"))

        query = """
        UPDATE product
        SET SKU = %s, name = %s, description = %s, price = %s, ean = %s
        WHERE SKU = %s
        """
        data = (sku, name, description, price, ean, request.args.get("product"))
        cursor.execute(query, data)
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/products")
def products_list():
    dbConn = None
    cursor = None
    order_no = request.args.get("order")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        if order_no:
            query = """
            SELECT * FROM product NATURAL JOIN contains
            WHERE order_no = %s;"""
        else:
            query = "SELECT * FROM product;"
        cursor.execute(query)
        return render_template("products.html", cursor=cursor, params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/supplier/register", methods=["GET"])
def supplier_register_get():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "SELECT * FROM product;"
        cursor.execute(query)
        return render_template(
            "supplier_register.html", cursor=cursor, params=request.args
        )
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        cursor.close()
        dbConn.close()


@_app.route("/supplier/register", methods=["POST"])
def supplier_register_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        tin = request.form["tin"]
        name = request.form["name"]
        address = request.form["address"]
        sku = request.form["sku"]
        date = request.form["date"]
        if sku == "":
            return redirect(url_for("supplier_register_get"))

        data = (tin, name, address, sku, date)
        query = "INSERT INTO supplier(TIN, name, adress, SKU, date) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, data)
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
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
        return render_template("success.html", params=request.args)
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@_app.route("/suppliers")
def suppliers_list():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "SELECT * FROM supplier;"
        cursor.execute(query)
        return render_template("suppliers.html", cursor=cursor, params=request.args)
    except Exception as e:
        return render_template("error.html", error=e, params=request.args)
    finally:
        cursor.close()
        dbConn.close()


CGIHandler().run(_app)
