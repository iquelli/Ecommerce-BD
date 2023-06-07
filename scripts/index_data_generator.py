#
# 		File: index_data_generator.py
# 		Authors:
# 		        - Gonçalo Bárias (ist1103124)
# 		        - Raquel Braunschweig (ist1102624)
#               - Vasco Paisana (ist1102533)
# 		Group: 2
# 		Description: Populates the tables in order to test the indexes efficiency.

import random
import string
import time

## Libs postgres
import psycopg2
import psycopg2.extras

## DBMS configs
DB_HOST = "127.0.0.1"
DB_DATABASE = "postgres"
DB_USER = "postgres"
DB_PASSWORD = "postgres"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)


def random_str(size):
    return "".join(random.choice(string.ascii_letters) for _ in range(size))


def random_date(time_format, prop):
    start_time = (
        time.mktime(time.strptime("2000/01/01", time_format))
        if random.random() <= 0.60
        else time.mktime(time.strptime("2023/01/01", time_format))
    )
    end_time = time.mktime(time.strptime("2023/06/06", time_format))
    random_time = start_time + prop * (end_time - start_time)
    return time.strftime(time_format, time.localtime(random_time))


def index_data_generator():
    SIZE_ORDERS = 100000
    SIZE_PRODUCT = 250000
    SIZE_CONTAINS = 300000

    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        orders_query = f"""
        INSERT INTO orders(order_no, cust_no, date) VALUES
        {",".join("(%s, %s, %s)" for _ in range(SIZE_ORDERS))};
        """
        order_no_data = tuple(10**6 + i for i in range(SIZE_ORDERS))
        orders_data = tuple(
            sum(
                (
                    (
                        order_no_data[i],
                        1111,
                        random_date("%Y/%m/%d", random.random()),
                    )
                    for i in range(SIZE_ORDERS)
                ),
                (),
            )
        )
        # 1111 `cust_no` is Joaquim Souza, very rich individual

        product_query = f"""
        INSERT INTO product(sku, name, price, ean) VALUES
        {",".join("(%s, %s, %s, %s)" for _ in range(SIZE_PRODUCT))};
        """
        sku_data = tuple(random_str(25) for _ in range(SIZE_PRODUCT))
        product_data = tuple(
            sum(
                (
                    (
                        sku_data[i],
                        f"A{random_str(19)}"
                        if random.random() <= 0.5
                        else random_str(20),
                        random.randint(0, 10**7) / 100
                        if random.random() <= 0.5
                        else random.randint(5000, 10**7) / 100,
                        random.randint(10**12, 10**13 - 1),
                    )
                    for i in range(SIZE_PRODUCT)
                ),
                (),
            )
        )

        contains_query = f"""
        INSERT INTO contains(order_no, sku, qty) VALUES
        {",".join("(%s, %s, %s)" for _ in range(SIZE_CONTAINS))};
        """
        contains_data = tuple(
            sum(
                (
                    (
                        random.choice(order_no_data),
                        random.choice(sku_data),
                        random.randint(1, 10**2),
                    )
                    for _ in range(SIZE_CONTAINS)
                ),
                (),
            )
        )

        cursor.execute(orders_query, orders_data)
        cursor.execute(product_query, product_data)
        cursor.execute(contains_query, contains_data)
    except Exception as e:
        raise e
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


index_data_generator()
