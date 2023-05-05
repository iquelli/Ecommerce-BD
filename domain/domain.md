# Domain Description

## Client

- email
- client_number [not null, unique, immutable]
- telephone_contact
- name
- home_address
- packages
- payment_methods

- primary key (client_number)

## Package

- client_number
- products
- date [not null]
- package_number [not null, unique, immutable]

- foreign key (client_number) references client (client_number)

## Product

- sku (varchar) [not null]
- name [not unique]
- description
- price
- ean (varchar) [could be null]

## Payment Method

- name
- id_token

## Purchase

- package
- payment_method [has to match the client's payment_method]
- date

## Supplier

- name
- home_address
- tax_id

## Employee

- name [not null]
- birthday [not null]
- nif [not null]
- social_security_number [not null]
- department [not null if workplace is not null]
- workplace [not null if department is not null]

- Can workplace and department both be null? Probably not.

## Department

- employees

## Workplace

- address
- gps_coords
- employees

# Doubts (probably Integrity Constraints)

> "É necessário registar também qual a quantidade encomendada de cada produto."

> "Devido a restrições de privacidade, os operadores do sistema não podem ver os nomes dos clientes."

> "... perante a "gateway" de pagamento."

> "Neste sistema os clientes têm de introduzir mais do que um método de pagamento e cada método de pagamento tem de ter outro
método como substituto em caso de falha. Os métodos de pagamento são escolhidos de uma lista conhecida à priori."

> "Um cliente não pode pagar encomendas de outro cliente."

> "Cada fornecedor tem de ter um contrato para fornecer cada produto que fornce, estabelecido numa determinada data. No âmbito
de cada contrato os produtos podem ser entregues em um ou mais armazéns espalhados pelo país."

> "..., podendo estes últimos ser escritórios e/ou armazéns, espalhados de norte a sul do país."
