# Relational Model

- customer(<ins>cust_no</ins>, name, email, phone, address)
    - UNIQUE(email)

- order(<ins>order_no</ins>, date, cust_no)
    - cust_no: FK(customer) NOT NULL
    - **(IC-2)**: Any order_no in order must exist in contains.

- sale(<ins>order_no</ins>, cust_no)
    - order_no: FK(order)
    - cust_no: FK(customer)
    - **(IC-1)**: Customers can only pay for the sale of an order they have placed themselves.

- product(<ins>sku</ins>, name, description, price)
    - **(IC-3)**: Any sku in product must exist in supplier.

- ean_product(<ins>sku</ins>, ean)
    - sku: FK(product)

- contains(<ins>order_no</ins>, <ins>sku</ins>, qty)
    - order_no: FK(order)
    - sku: FK(product)

- supplier(<ins>tin</ins>, sku, address, name, supply_contract_date)
    - sku: FK(product) NOT NULL

- department(<ins>name</ins>)

- workplace(<ins>address</ins>, lat, long)
    - UNIQUE(lat, long)

- warehouse(<ins>address</ins>)
    - address: FK(workplace)

- delivery(<ins>sku</ins>, <ins>tin</ins>, <ins>address</ins>)
    - sku: FK(product)
    - tin: FK(suplier)
    - address: FK(warehouse)

- office(<ins>address</ins>)
    - address: FK(workplace)

- employee(<ins>ssn</ins>, tin, b_date, name)
    - UNIQUE(tin)
    - **(IC-4)**: Any ssn in employee must exist in works.

- works(<ins>ssn</ins>, <ins>address</ins>, name)
    - ssn: FK(employee)
    - address: FK(workplace)
    - name: FK(department) NOT NULL

- process(<ins>ssn</ins>, <ins>order_no</ins>)
    - ssn: FK(employee)
    - order_no: FK(order)

# Doubts

> Grandes dúvidas relativamente à delivery, pois o sku provavelmente não está ligado ao tin do supplier.
Como o supplier tem cardinalidade de 1 e participação obrigatória com produto, isto complica a associação
entre Warehouse e a agregação.

> Ainda não percebi bem como é que ternárias são representadas, tipo o "works". Supostamente uma ternária
é equivalente a uma agregação (T07 - Modelação E-A - Parte IV no slide 10), mas depois a representação no
modelo relacional da ternária parece não ser equivalente à da dessa agregação.
