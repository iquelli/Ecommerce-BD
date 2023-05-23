# Relational Algebra (4 queries)

__1. Liste o nome de todos os clientes que fizeram encomendas contendo produtos de preço superior a 50 € no ano de 2023.__

$customer \textunderscore ordering \textunderscore 2023 \\; \leftarrow \\; \sigma_{ \\; date \\; \geq \\; \text{'2023/01/01'} \\; \wedge \\; date \\; \leq \\; \text{'2023/12/31'} \\;}(customer \bowtie order)$

$customer \textunderscore ordering \textunderscore 2023 \textunderscore products \\; \leftarrow \\;  customer \textunderscore ordering \textunderscore 2023 \bowtie contains$

$\Pi_{ \\; customer \textunderscore ordering \textunderscore 2023 \textunderscore products.name \\;}(\sigma_{ \\; price \\; > \\; 50 \\;}(customer \textunderscore ordering \textunderscore 2023 \textunderscore products \bowtie_{ \\; customer \textunderscore ordering \textunderscore 2023 \textunderscore products.sku \\; = \\; product.sku} product))$

__2. Liste o nome de todos os empregados que trabalham em armazéns e não em escritórios e processaram encomendas em Janeiro de 2023.__

$employee \textunderscore processing \\; \leftarrow \\; \sigma_{ \\; date \\; \geq \\; \text{'2023/01/01'} \\; \wedge \\; date \\; \leq \\; \text{'2023/01/31'} \\;}(employee \bowtie process \bowtie order)$

$employee \textunderscore processing \textunderscore working \\; \leftarrow \\; employee \textunderscore processing \bowtie_{ \\; employee \textunderscore processing.ssn \\; = \\; works.ssn} works$

$\Pi_{\\; employee \textunderscore processing.name \\;}((employee \textunderscore processing \textunderscore working \bowtie warehouse) - (employee \textunderscore processing \textunderscore working \bowtie office))$


__3. Indique o nome do produto mais vendido.__

$products \textunderscore grouped \textunderscore qty \\; \leftarrow {}\_{sku \\; } G_{\\; sum(qty) \\; \mapsto \\; p \textunderscore qty \\;}(product \bowtie contains \bowtie sale)$

$\Pi_{\\; name \\;}(G_{\\; max(p \textunderscore qty) \\; \mapsto \\; p \textunderscore qty \\;}(products \textunderscore grouped \textunderscore qty) \bowtie products \textunderscore grouped \textunderscore qty \bowtie product)$

__4. Indique o valor total de cada venda realizada.__

${}\_{order \textunderscore no \\; } G_{\\; sum(price \\; * \\; qty) \\; \mapsto \\; total \textunderscore val \\;}( \Pi_{\\; order \textunderscore no, \\; sku, \\; price \\; * \\; qty \\;}(sale \bowtie contains \bowtie product))$

# Doubts

> Por exemplo no 2. temos employee_processing.ssn, mas uma vez que o ssn é do employee a maneira correta pode ter de ser employee.ssn.
