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

Cada cliente é identificado perante o sistema pelo seu e-mail e por um número de cliente.
Os números de cliente são únicos e imutáveis.
Também é guardado o contacto telefónico do cliente e o seu nome e morada.
Cada cliente pode efectuar uma ou mais encomendas, mas uma encomenda só pode estar associada a um cliente.
Cada cliente pode ter também diversos métodos de pagamento conhecidos pelo seu nome e que têm como atributo um "token" de identificação perante a "gateway" de pagamento.
Neste sistema os clientes têm de introduzir mais do que um método de pagamento e cada método de pagamento tem de ter outro método como substituto em caso de falha.
Uma encomenda que é paga pelo cliente passa a ser uma venda.
A venda é registrada sempre com o método de pagamento do cliente que fez a encomenda, na data em que o cliente efetuou o pagamento.
Um cliente não pode pagar encomendas de outro cliente.

## Package

- client_number
- products
- date [not null]
- package_number [not null, unique, immutable]

- foreign key (client_number) references client (client_number)

Cada cliente pode efectuar uma ou mais encomendas, mas uma encomenda só pode estar associada a um cliente.
Uma encomenda é constituída por diversos produtos.
Para cada encomenda é necessário registar a data da encomenda e o número de encomenda, sendo este último único e imutável.
É necessário registar também qual a quantidade encomendada de cada produto.

## Product

- sku (varchar) [not null]
- name [not unique]
- description
- price
- ean (varchar) [could be null]

Os produtos encomendados são identificados por um código alfanumérico conhecido como SKU ("stock keeping unit") e têm um nome, uma descrição e um preço.
Podem existir produtos com o mesmo nome.
Alguns produtos têm código EAN (informalmente conhecido como 'código de barras').

## Payment Method

- name
- id_token

Cada cliente pode ter também diversos métodos de pagamento conhecidos pelo seu nome e que têm como atributo um "token" de identificação perante a "gateway" de pagamento.
Neste sistema os clientes têm de introduzir mais do que um método de pagamento e cada método de pagamento tem de ter outro método como substituto em caso de falha.
Os métodos de pagamento são escolhidos de uma lista conhecida à priori.

## Purchase

- package
- payment_method [has to match the client's payment_method]
- date

Uma encomenda que é paga pelo cliente passa a ser uma venda.
A venda é registrada sempre com o método de pagamento do cliente que fez a encomenda, na data em que o cliente efetuou o pagamento.
Um cliente não pode pagar encomendas de outro cliente.

## Supplier

- name
- home_address
- tax_id

Existem fornecedores dos produtos com nome, endereço e identificação fiscal (Tax Identification Number) para fins de faturação.
Cada fornecedor tem de ter um contrato para fornecer cada produto que fornece, estabelecido numa determinada data.
No âmbito de cada contrato os produtos podem ser entregues em um ou mais armazéns espalhados pelo país.

## Employee

- name [not null]
- birthday [not null]
- nif [not null]
- social_security_number [not null]
- department [not null if workplace is not null]
- workplace [not null if department is not null]

- Can workplace and department both be null? Probably not.

As encomendas são processadas por empregados.
Relativamente a cada empregado é necessário registar o nome, data de nascimento, NIF, e número da segurança social.
Os empregados trabalham em departamentos e locais de trabalho, podendo estes últimos ser escritórios e/ou armazéns, espalhados de norte a sul do país.
Note-se que não é possível associar um empregado a um departamento sem o associar também a um local de trabalho, nem é possível associar um empregado a um local de trabalho sem o associar também a um departamento.

## Department

- employees

Os empregados trabalham em departamentos e locais de trabalho, podendo estes últimos ser escritórios e/ou armazéns, espalhados de norte a sul do país.

## Workplace

- address
- gps_coords
- employees

Os empregados trabalham em departamentos e locais de trabalho, podendo estes últimos ser escritórios e/ou armazéns, espalhados de norte a sul do país.
Todos os locais de trabalho têm um endereço e uma localização com coordenadas GPS conhecidas.
