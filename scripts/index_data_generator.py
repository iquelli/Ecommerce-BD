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
import psycopg2
import psycopg2.extras

# DBMS configs
DB_HOST = "localhost"
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
        if random.random() <= 0.80
        else time.mktime(time.strptime("2023/01/01", time_format))
    )
    end_time = time.mktime(time.strptime("2023/06/06", time_format))
    random_time = start_time + prop * (end_time - start_time)
    return time.strftime(time_format, time.localtime(random_time))


def index_data_generator():
    SIZE_ORDERS = 20000
    SIZE_PRODUCT = 100000
    SIZE_CONTAINS = 0

    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        order_no_data = tuple(10**6 + i for i in range(SIZE_ORDERS))
        data = tuple(
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
        )  # 1111 `cust_no` is Joaquim Souza, very rich individual

        SKU_data = tuple(random_str(25) for _ in range(SIZE_PRODUCT))
        data += tuple(
            sum(
                (
                    (
                        SKU_data[i],
                        f"A{random_str(19)}"
                        if random.random() <= 0.2
                        else random_str(20),
                        random.randint(0, 5000) / 100
                        if random.random() <= 0.8
                        else random.randint(5000, 10**7) / 100,
                        random.randint(10**12, 10**13 - 1),
                    )
                    for i in range(SIZE_PRODUCT)
                ),
                (),
            )
        )

        for order_no in order_no_data:
            r = random.randint(1, 5)
            SIZE_CONTAINS += r
            random_SKU_data = set()
            while len(random_SKU_data) < r:
                random_SKU_data.add(random.choice(SKU_data))
            data += tuple(
                sum(
                    (
                        (
                            order_no,
                            random_SKU_data.pop(),
                            random.randint(1, 10**2),
                        )
                        for _ in range(r)
                    ),
                    (),
                )
            )

        query = f"""
        BEGIN TRANSACTION;

        INSERT INTO orders(order_no, cust_no, date) VALUES
        {",".join("(%s, %s, %s)" for _ in range(SIZE_ORDERS))};

        INSERT INTO product(SKU, name, price, ean) VALUES
        {",".join("(%s, %s, %s, %s)" for _ in range(SIZE_PRODUCT))};

        INSERT INTO contains(order_no, SKU, qty) VALUES
        {",".join("(%s, %s, %s)" for _ in range(SIZE_CONTAINS))};

        END TRANSACTION;
        """
        cursor.execute(query, data)
    except Exception as e:
        raise e
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


index_data_generator()
