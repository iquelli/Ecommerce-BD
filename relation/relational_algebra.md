# Relational Algebra (4 queries)

__1. Liste o nome de todos os clientes que fizeram encomendas contendo produtos de preço superior a 50 € no ano de 2023.__

$customer \textunderscore ordering \textunderscore 2023 \\; \leftarrow \\; \sigma_{ \\; date \\; \geq \\; \text{'2023/01/01'} \\; \wedge \\; date \\; \leq \\; \text{'2023/12/31'} \\;}(Customer \bowtie Order)$

$customer \textunderscore ordering \textunderscore 2023 \textunderscore products \\; \leftarrow \\; customer \textunderscore ordering \textunderscore 2023 \bowtie contains$

$customer \textunderscore ordering \textunderscore 2023 \textunderscore products \textunderscore greater \textunderscore 50 \\; \leftarrow \\; \sigma_{ \\; price \\; > \\; 50 \\;}(customer \textunderscore ordering \textunderscore 2023 \textunderscore products \bowtie_{ \\; customer \textunderscore ordering \textunderscore 2023 \textunderscore products.sku \\; = \\; Product.sku} Product)$

$\Pi_{ \\; customer \textunderscore ordering \textunderscore 2023 \textunderscore products \textunderscore greater \textunderscore 50.name \\;}(customer \textunderscore ordering \textunderscore 2023 \textunderscore products \textunderscore greater \textunderscore 50)$

__2. Liste o nome de todos os empregados que trabalham em armazéns e não em escritórios e processaram encomendas em Janeiro de 2023.__

$employee \textunderscore processing \\; \leftarrow \\; \sigma_{ \\; date \\; \geq \\; \text{'2023/01/01'} \\; \wedge \\; date \\; \leq \\; \text{'2023/01/31'} \\;}(Employee \bowtie process \bowtie Order)$

$employee \textunderscore processing \textunderscore warehouse \\; \leftarrow \\; (employee \textunderscore processing \bowtie_{ \\; employee \textunderscore processing.ssn \\; = \\; works.ssn} works) \bowtie Warehouse$

$employee \textunderscore processing \textunderscore office \\; \leftarrow \\; (employee \textunderscore processing \bowtie_{ \\; employee \textunderscore processing.ssn \\; = \\; works.ssn} works) \bowtie Office$

$employee \textunderscore processing \textunderscore warehouse \textunderscore not \textunderscore office \\; \leftarrow \\; employee \textunderscore processing \textunderscore warehouse \\; - employee \textunderscore processing \textunderscore office$

$\Pi_{\\; name \\;}(employee \textunderscore processing \textunderscore warehouse \textunderscore not \textunderscore office)$


__3. Indique o nome do produto mais vendido.__

$products \textunderscore grouped \textunderscore qty \\; \leftarrow {}\_{sku \\; } G_{\\; sum(qty) \\; \mapsto \\; p \textunderscore qty \\;}(Product \bowtie contains \bowtie Sale)$

$\Pi_{\\; name \\;}(G_{\\; max(p \textunderscore qty) \\; \mapsto \\; p \textunderscore qty \\;}(products \textunderscore grouped \textunderscore qty) \bowtie products \textunderscore grouped \textunderscore qty \bowtie Product)$

__4. Indique o valor total de cada venda realizada.__

${}\_{order \textunderscore no \\; } G_{\\; sum(price) \\; \mapsto \\; total \textunderscore val \\;}(Sale \bowtie contains \bowtie Product)$
