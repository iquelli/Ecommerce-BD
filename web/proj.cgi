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


@app.route("/product/insert", methods=["GET"])
def register_product_get():
    try:
        return render_template("addproduct.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/product/insert", methods=["POST"])
def register_product_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        sku = request.form["sku"]
        name = request.form["name"]
        description = request.form["description"]
        price = request.form["price"]
        ean = request.form["ean"]
        if sku == "" or name == "" or description == "" or price == "" or ean == "":
            return redirect("/proj.cgi/addproduct")
        query = "INSERT INTO product(SKU, name, description, price, ean) VALUES (%s, %s, %s, %s, %s);"
        data = (sku, name, description, price, ean)
        cursor.execute(query, data)
        return render_template("success.html", context="product")
    except Exception as e:
        return render_template("error.html", error=e, context="product")
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/product/remove", methods=["GET"])
def remove_product_get():
    try:
        return render_template("removeproduct.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/product/remove", methods=["POST"])
def remove_product_post():
    dbConn = None
    cursor = None
    sku = request.args.get("sku")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "DELETE FROM product WHERE SKU = %s;"
        cursor.execute(query, (sku,))
        return render_template("success.html", context="customer")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/product/edit", methods=["GET"])
def alter_product():
    try:
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
        return render_template("success.html", context="product")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/supplier/register", methods=["GET"])
def register_supplier_get():
    try:
        return render_template("registersupplier.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/supplier/register", methods=["POST"])
def register_supplier_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        tin = request.form["tin"]
        name = request.form["name"]
        address = request.form["address"]
        sku = request.form["product_sku"]
        date = request.form["date"]
        if tin == "" or name == "" or address == "" or sku == "" or date == "":
            return redirect("/proj.cgi/addretailer")
        data = (tin, name, address, sku, date)
        query = "INSERT INTO supplier(TIN, name, adress, SKU, date) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, data)
        return render_template("success.html", context="supplier")
    except Exception as e:
        return render_template("error.html", error=e, context="supplier")
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/supplier/remove", methods=["GET"])
def remove_supplier_get():
    try:
        return render_template("removesupplier.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/supplier/remove", methods=["POST"])
def remove_supplier_post():
    dbConn = None
    cursor = None
    tin = request.args.get("tin")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "DELETE FROM supplier WHERE TIN = %s;"
        cursor.execute(query, (tin,))
        return render_template("success.html", context="supplier")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/customer/register", methods=["GET"])
def register_customer_get():
    try:
        return render_template("registercustomer.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/customer/register", methods=["POST"])
def register_customer_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query_get_cust_no = "SELECT COALESCE(MAX(value), 0)+1 FROM customer;"
        cursor.execute(query_get_cust_no)
        cust_no = cursor.fetchone()
        name = request.form["name"]
        email = request.form["email"]
        address = request.form["address"]
        phone = request.form["phone"]
        if cust_no == "" or name == "" or email == "" or address == "" or phone == "":
            return redirect("/proj.cgi/registercustomer")
        data = (cust_no, name, address, email, phone)
        query = "INSERT INTO customer(cust_no, name, adress, product, date) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(query, data)
        return render_template("success.html", context="customer")
    except Exception as e:
        return render_template("error.html", error=e, context="customer")
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/customer/remove", methods=["GET"])
def remove_customer_get():
    try:
        return render_template("removecustomer.html")
    except Exception as e:
        return render_template("error.html", error=e)


@app.route("/customer/remove", methods=["POST"])
def remove_customer_post():
    dbConn = None
    cursor = None
    cust_no = request.args.get("cust_no")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "DELETE FROM customer WHERE cust_no = %s;"
        cursor.execute(query, (cust_no,))
        return render_template("success.html", context="customer")
    except Exception as e:
        return render_template("error.html", error=e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


CGIHandler().run(app)
