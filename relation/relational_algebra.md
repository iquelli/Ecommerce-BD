# Relational Algebra (4 queries)

__1. Liste o nome de todos os clientes que fizeram encomendas contendo produtos de preço superior a 50 € no ano de 2023.__

$c \\; \leftarrow \\; \sigma_{ \\; date \\; \geq \\; \text{'2023/01/01'} \\; \wedge \\; date \\; \leq \\; \text{'2023/12/31'} \\;}(customer \bowtie package) \bowtie contains$

$\Pi_{ \\; customer.name \\;}(\sigma_{ \\; price \\; > \\; 50 \\;}(c \bowtie_{ \\; contains.sku \\; = \\; product.sku} product))$

__2. Liste o nome de todos os empregados que trabalham em armazéns e não em escritórios e processaram encomendas em Janeiro de 2023.__

$e \\; \leftarrow \\; \sigma_{ \\; date \\; \geq \\; \text{'2023/01/01'} \\; \wedge \\; date \\; \leq \\; \text{'2023/01/31'} \\;}(employee \bowtie process \bowtie package) \bowtie_{ \\; employee.ssn \\; = \\; works.ssn} works$

$\Pi_{\\; employee.name \\;}((e \bowtie warehouse) - (e \bowtie office))$


__3. Indique o nome do produto mais vendido.__

$p \\; \leftarrow {}\_{sku \\; } G_{\\; sum(qty) \\; \mapsto \\; p \textunderscore qty \\;}(product \bowtie contains)$

$\Pi_{\\; name \\;}(G_{\\; max(p \textunderscore qty) \\; \mapsto \\; p \textunderscore qty \\;}(p) \bowtie p \bowtie product)$

__4. Indique o valor total de cada venda realizada.__

${}\_{package \textunderscore no \\; } G_{\\; sum(price \\; * \\; qty) \\; \mapsto \\; total \textunderscore val \\;}( \Pi_{\\; package \textunderscore no, \\; sku, \\; price \\; * \\; qty \\;}(sale \bowtie contains \bowtie product))$
