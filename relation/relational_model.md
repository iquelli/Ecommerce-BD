# Relational Model

- Customer(<ins>cust_no</ins>, name, email, phone, address)
    - UNIQUE(email)

- Order(<ins>order_no</ins>, date, cust_no)
    - cust_no: FK(Customer) NOT NULL
    - **(IC-2)**: Any order_no in Order must exist in contains

- Sale(<ins>order_no</ins>, cust_no)
    - order_no: FK(Order)
    - cust_no: FK(Customer)
    - **(IC-1)**: Customers can only pay for the Sale of an Order they have placed themselves

- Product(<ins>sku</ins>, name, description, price)
    - **(IC-3)**: Any sku in Product must exist in Supplier

- EAN_Product(<ins>sku</ins>, ean)
    - sku: FK(Product)

- contains(<ins>order_no</ins>, <ins>sku</ins>, qty)
    - order_no: FK(Order)
    - sku: FK(Product)

- Supplier(<ins>TIN</ins>, sku, address, name, supply_contract_date)
    - sku: FK(Product) NOT NULL

- Department(<ins>name</ins>)

- Workplace(<ins>address</ins>, lat, long)
    - UNIQUE(lat, long)

- Warehouse(<ins>address</ins>)
    - address: FK(Workplace)

- delivery(<ins>sku</ins>, <ins>TIN</ins>, <ins>address</ins>)
    - sku: FK(Product)
    - TIN: FK(Suplier)
    - address: FK(Warehouse)

- Office(<ins>address</ins>)
    - address: FK(Workplace)

- Employee(<ins>ssn</ins>, TIN, bdate, name)
    - UNIQUE(TIN)
    - **(IC-4)**: Any ssn in employee must exist in works

- works(<ins>ssn</ins>, <ins>address</ins>, name)
    - ssn: FK(Employee)
    - address: FK(Workplace)
    - name: FK(Department) NOT NULL

- process(<ins>ssn</ins>, <ins>order_no</ins>)
    - ssn: FK(Employee)
    - order_no: FK(Order)

# Doubts

> Grandes dúvidas relativamente à delivery, pois o sku provavelmente não está ligado ao tin do supplier.
Como o supplier tem cardinalidade de 1 e participação obrigatória com produto, isto complica a associação
entre Warehouse e a agregação.

> Ainda não percebi bem como é que ternárias são representadas, tipo o "works". Supostamente uma ternária
é equivalente a uma agregação (T07 - Modelação E-A - Parte IV no slide 10), mas depois a representação no
modelo relacional da ternária parece não ser equivalente à da dessa agregação.
