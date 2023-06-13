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
from flask import Flask, render_template, request, redirect
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

app = Flask(__name__)


# Runs the function once the root page is requested.
# The request comes with the folder structure setting ~/web as the root.
@app.route("/")
def homepage():
    try:
        return render_template("index.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/customer/register", methods=["GET"])
def register_customer_get():
    try:
        return render_template("customer_register.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/customer/register", methods=["POST"])
def register_customer_post():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query_get_cust_no = "SELECT MAX(cust_no) + 1 FROM customer;"
        cursor.execute(query_get_cust_no)
        [cust_no] = cursor.fetchone()
        if cust_no is None:
            cust_no = "0"
        name = request.form["name"]
        email = request.form["email"]
        address = request.form["address"]
        phone = request.form["phone"]
        if name == "" or email == "":
            return redirect("/customer/register")
        data = (cust_no, name, email, phone, address)
        query = "INSERT INTO customer(cust_no, name, email, phone, adress) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, data)
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/customer/remove")
def remove_customer():
    dbConn = None
    cursor = None
    cust_no = request.args.get("cust_no")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "DELETE FROM customer WHERE cust_no = %s;"
        cursor.execute(query, (cust_no,))
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/customers")
def list_customers():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM customer;"
        cursor.execute(query)
        return render_template("customers.html", cursor=cursor)
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        cursor.close()
        dbConn.close()


@app.route("/order/register", methods=["GET"])
def register_order_get():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM product;"
        cursor.execute(query)
        return render_template("order_register.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        cursor.close()
        dbConn.close()


@app.route("/order/register", methods=["POST"])
def register_order_post():
    dbConn = None
    cursor = None
    cust_no = request.args.get("cust_no")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query_get_order_no = "SELECT MAX(order_no) + 1 FROM orders;"
        cursor.execute(query_get_order_no)
        [order_no] = cursor.fetchone()
        if order_no is None:
            order_no = "0"
        data = (order_no, cust_no, datetime.today().strftime("%Y-%m-%d"))
        # TODO: Add all products of the order to data with the right qty
        query = f"""
        BEGIN TRANSACTION;
        INSERT INTO orders(order_no, cust_no, date) VALUES (%s, %s, %s);
        INSERT INTO contains(order_no, SKU, qty) VALUES
        {",".join("(%s, %s, %s)" for _ in range(NUM_PRODUCTS))};
        END TRANSACTION;
        """
        cursor.execute(query, data)
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/order/remove")
def remove_order():
    dbConn = None
    cursor = None
    order_no = request.args.get("order_no")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "DELETE FROM orders WHERE order_no = %s;"
        cursor.execute(query, (order_no,))
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/orders")
def list_orders():
    dbConn = None
    cursor = None
    try:  # TODO: Need to also list orders by client
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM orders;"
        cursor.execute(query)
        return render_template("orders.html", cursor=cursor)
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        cursor.close()
        dbConn.close()


@app.route("/order/product/add", methods=["GET"])
def add_products_to_order_get():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM product;"
        cursor.execute(query)
        return render_template("order_edit.html", cursor=cursor)
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        cursor.close()
        dbConn.close()


@app.route("/order/product/add", methods=["POST"])
def add_products_to_order_post():
    try:
        pass  # TODO
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/order/product/remove")
def remove_products_from_order():
    try:
        pass  # TODO
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/order/pay", methods=["GET"])
def perform_payment_get():
    try:  # TODO: Needs to display pre defined payments methods
        return render_template("pay.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/order/pay", methods=["POST"])
def perform_payment_post():
    dbConn = None
    cursor = None
    cust_no = request.args.get("cust_no")
    order_no = request.args.get("order_no")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "INSERT INTO pay(order_no, cust_no) VALUES (%s, %s)"
        cursor.execute(query, (order_no, cust_no))
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/product/register", methods=["GET"])
def register_product_get():
    try:
        return render_template("product_register.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/product/register", methods=["POST"])
def register_product_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        sku = request.form["sku"]
        name = request.form["name"]
        description = request.form["description"]
        price = request.form["price"]
        ean = request.form["ean"]
        if sku == "" or name == "" or price == "" or ean == "":
            return redirect("/product/register")
        query = "INSERT INTO product(SKU, name, description, price, ean) VALUES (%s, %s, %s, %s, %s);"
        data = (sku, name, description, price, ean)
        cursor.execute(query, data)
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/product/remove")
def remove_product():
    dbConn = None
    cursor = None
    sku = request.args.get("sku")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "DELETE FROM product WHERE SKU = %s;"
        cursor.execute(query, (sku,))
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/product/edit", methods=["GET"])
def edit_product_get():
    try:
        return render_template("product_edit.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/product/edit", methods=["POST"])
def edit_product_post():
    try:  # TODO
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        sku = request.form["sku"]
        price = request.form["price"]
        description = request.form["description"]
        if price:
            cursor.execute(
                "UPDATE product SET price = %s WHERE SKU = %s;", (price, sku)
            )
        if description:
            cursor.execute(
                "UPDATE product SET description = %s WHERE SKU = %s;",
                (description, sku),
            )
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/products")
def list_products():
    try:
        pass  # TODO
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/supplier/register", methods=["GET"])
def register_supplier_get():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM product;"
        cursor.execute(query)
        return render_template("supplier_register.html", cursor=cursor)
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        cursor.close()
        dbConn.close()


@app.route("/supplier/register", methods=["POST"])
def register_supplier_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        tin = request.form["tin"]
        name = request.form["name"]
        address = request.form["address"]
        sku = request.form["sku"]  # TODO: We shouldn't get this from a form
        date = request.form["date"]
        if sku == "":
            return redirect("/supplier/register")
        data = (tin, name, address, sku, date)
        query = "INSERT INTO supplier(TIN, name, adress, SKU, date) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, data)
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/supplier/remove")
def remove_supplier():
    dbConn = None
    cursor = None
    tin = request.args.get("tin")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "DELETE FROM supplier WHERE TIN = %s;"
        cursor.execute(query, (tin,))
        return render_template("success.html")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/suppliers")
def list_suppliers():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM supplier;"
        cursor.execute(query)
        return render_template("suppliers.html", cursor=cursor)
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        cursor.close()
        dbConn.close()


CGIHandler().run(app)
