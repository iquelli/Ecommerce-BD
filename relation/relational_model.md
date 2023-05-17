- Customer(<ins>cust_no</ins>, name, email, phone, address)
    - UNIQUE(email)

- Order(<ins>order_no</ins>, date, cust_no)
    - cust_no: FK(Customer) NOT NULL
    - **IC-2**: any order_no in Order must exist in contains

- Sale(<ins>order_no</ins>)
    - order_no: FK(Order)

- pay(<ins>order_no</ins>, cust_no)
    - order_no: FK(Sale)
    - cust_no: FK(Customer)
    - **IC-1**: Customers can only pay for the Sale of an Order they have placed themselves

- Employee(<ins>ssn</ins>, TIN, bdate, name, dpt, wp)
    - UNIQUE(TIN)
    - dpt: FK(Department)
    - wp: FK(Workplace)
    - **IC-3**: any ssn in employee must exist in works

- process(<ins>ssn</ins>, <ins>order_no</ins>)
    - ssn: FK(Employee)
    - order_no: FK(Order)

- Department(<ins>name</ins>)

- Workplace(<ins>address</ins>, lat, long)
    - UNIQUE(lat, long)

- works(<ins>name</ins>, <ins>ssn</ins>, <ins>address</ins>)
    - name: FK(Department)
    - ssn: FK(Employee)
    - address: FK(Workplace)

- Warehouse(<ins>address</ins>)
    - address: FK(Workplace)

- Office(<ins>address</ins>)
    - address: FK(Workplace)

- Product(<ins>sku</ins>, name, description, price)
    - **IC-4**: any sku in Product must exist in supply-contract

- contains(<ins>order_no</ins>, <ins>sku</ins>, qty)
    - order_no: FK(Order)
    - sku: FK(Product)

- Ean_product(<ins>sku</ins>, ean)
    - sku: FK(Product)

- Supplier(<ins>TIN</ins>, <ins>sku</ins>, address, name)
    - sku: FK(Product) NOT NULL

- delivery(<ins>address</ins>, <ins>TIN</ins>, <ins>sku</ins>)
    - address: FK(Warehouse)
    - TIN: FK(Suplier)
    - sku: FK(Product)
