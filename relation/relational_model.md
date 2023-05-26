# Relational Model

- customer(<ins>cust_no</ins>, name, email, phone, address)
    - UNIQUE(email)

- package(<ins>package_no</ins>, date, cust_no)
    - cust_no: FK(customer) NOT NULL
    - **(IC-6)**: Any package_no in package must exist in contains.
    - **(IC-7)**: When a package is removed from the database it must also be removed from sale if present.

- sale(<ins>package_no</ins>)
    - package_no: FK(package)

- pay(<ins>package_no</ins>, cust_no)
    - package_no: FK(sale)
    - cust_no: FK(customer) NOT NULL
    - **(IC-1)**: cust_no must exist in the package identified by package_no.

- product(<ins>sku</ins>, name, description, price)
    - **(IC-8)**: Any sku in product must exist in supplier.
    - **(IC-9)**: When a product is removed from the database it must also be removed from ean_product if present.

- ean_product(<ins>sku</ins>, ean)
    - sku: FK(product)

- contains(<ins>package_no</ins>, <ins>sku</ins>, qty)
    - package_no: FK(package)
    - sku: FK(product)

- supplier(<ins>tin</ins>, name, address, sku, supply_contract_date)
    - sku: FK(product) NOT NULL

- department(<ins>name</ins>)

- workplace(<ins>address</ins>, lat, long)
    - UNIQUE(lat, long)
    - **(IC-10)**: When a workplace is removed from the database it must also be removed from warehouse and/or office if present.

- warehouse(<ins>address</ins>)
    - address: FK(workplace)

- delivery(<ins>address</ins>, <ins>tin</ins>)
    - address: FK(warehouse)
    - tin: FK(suplier)

- office(<ins>address</ins>)
    - address: FK(workplace)

- employee(<ins>ssn</ins>, tin, b_date, name)
    - UNIQUE(tin)
    - **(IC-11)**: Any ssn in employee must exist in works.

- works(<ins>ssn</ins>, <ins>name</ins>, <ins>address</ins>)
    - ssn: FK(employee)
    - name: FK(department)
    - address: FK(workplace)

- process(<ins>ssn</ins>, <ins>package_no</ins>)
    - ssn: FK(employee)
    - package_no: FK(package)
