USE ecommerce;
-- ============================================================
-- 1. RECUPERAÇÕES SIMPLES (SELECT)
-- ============================================================

-- Pergunta: Quais são todos os clientes cadastrados?
SELECT * FROM Clients;

-- Pergunta: Quais produtos estão cadastrados na plataforma?
SELECT idProduct, Pname, Category, Avaliacao, Size FROM Product;

-- Pergunta: Quais são todas as formas de pagamento cadastradas?
SELECT * FROM Payments;

-- ============================================================
-- 2. FILTROS COM WHERE
-- ============================================================

-- Pergunta: Quais pedidos foram confirmados?
SELECT * FROM Orders
WHERE OrderStatus = 'Confirmado';

-- Pergunta: Quais produtos têm avaliação acima de 4?
SELECT Pname, Category, Avaliacao
FROM Product
WHERE Avaliacao > 4;

-- Pergunta: Quais produtos são classificados para crianças?
SELECT Pname, Category, Avaliacao
FROM Product
WHERE Classification_kids = TRUE;

-- Pergunta: Quais entregas ainda estão aguardando envio?
SELECT * FROM Delivery
WHERE DeliveryStatus = 'Aguardando envio';

-- Pergunta: Quais pedidos foram pagos com Pix ou Crédito?
SELECT o.idOrder, o.OrderStatus, o.sendValue, p.Typepayment
FROM Orders o
JOIN Payments p ON o.idOrderPayment = p.idPayment
WHERE p.Typepayment IN ('Pix', 'Credito');

-- ============================================================
-- 3. ATRIBUTOS DERIVADOS (EXPRESSÕES)
-- ============================================================

-- Pergunta: Qual o valor total de cada pedido considerando frete fixo de R$10?
SELECT 
    idOrder,
    sendValue,
    sendValue + 10 AS totalComFrete
FROM Orders;

-- Pergunta: Qual a classificação textual de cada produto com base na avaliação?
SELECT 
    Pname,
    Avaliacao,
    CASE 
        WHEN Avaliacao >= 4.5 THEN 'Excelente'
        WHEN Avaliacao >= 4.0 THEN 'Bom'
        WHEN Avaliacao >= 3.5 THEN 'Regular'
        ELSE 'Ruim'
    END AS ClassificacaoAvaliacao
FROM Product;

-- Pergunta: Qual o valor total do frete acumulado por status de pedido?
SELECT 
    OrderStatus,
    COUNT(*) AS qtdPedidos,
    SUM(sendValue) AS freteTotal,
    Round(AVG(sendValue),2) AS freteMedio
FROM Orders
GROUP BY OrderStatus;

-- ============================================================
-- 4. ORDENAÇÕES (ORDER BY)
-- ============================================================

-- Pergunta: Quais produtos têm as melhores avaliações?
SELECT Pname, Avaliacao
FROM Product
ORDER BY Avaliacao DESC;

-- Pergunta: Quais clientes estão ordenados alfabeticamente?
SELECT pf.Pname, pf.Minit, pf.Lname, pf.CPF
FROM Clients c
JOIN ClientPF pf ON c.idClient = pf.idClient
ORDER BY pf.Lname ASC, pf.Pname ASC;

-- Pergunta: Quais pedidos tiveram maior frete?
SELECT idOrder, idOrderClient, sendValue, OrderStatus
FROM Orders
ORDER BY sendValue DESC;

-- ============================================================
-- 5. AGRUPAMENTOS E HAVING
-- ============================================================

-- Pergunta: Quantos pedidos foram feitos por cada cliente?
SELECT 
	pf.Pname AS cliente,
    COUNT(o.idOrder) AS totalPedidos
FROM Clients c
JOIN ClientPF pf ON c.idClient = pf.idClient
LEFT JOIN Orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient, pf.Pname ORDER BY totalPedidos DESC;

-- Pergunta: Quais clientes fizeram mais de 1 pedido?
SELECT 
    idOrderClient,
    COUNT(*) AS totalPedidos
FROM Orders
GROUP BY idOrderClient
HAVING totalPedidos > 1;

-- Pergunta: Quais categorias de produtos têm média de avaliação acima de 4?
SELECT 
    Category,
    COUNT(*) AS qtdProdutos,
    ROUND(AVG(Avaliacao), 2) AS mediaAvaliacao
FROM Product
GROUP BY Category
HAVING mediaAvaliacao > 4
ORDER BY mediaAvaliacao DESC;

-- Pergunta: Quais fornecedores fornecem mais de 1 produto?
SELECT 
    s.SocialName AS fornecedor,
    COUNT(ps.idPSProduct) AS qtdProdutos,
    SUM(ps.Quantity) AS totalQuantidade
FROM Supplier s
JOIN ProductSupplier ps ON s.idSupplier = ps.idPSSupplier
GROUP BY s.idSupplier, s.SocialName
HAVING qtdProdutos > 1
ORDER BY qtdProdutos DESC;

-- ============================================================
-- 6. JUNÇÕES (JOINS)
-- ============================================================

-- Pergunta: Quais clientes fizeram quais pedidos e qual o status?
SELECT 
	pf.Pname AS cliente, 
    o.idOrder AS pedido, 
    o.OrderStatus AS Ostatus, 
    o.sendValue AS frete
FROM Clients c
JOIN ClientPF pf ON c.idClient = pf.idClient
JOIN Orders o ON c.idClient = o.idOrderClient;

-- Pergunta: Quais produtos foram pedidos, em que quantidade e para qual pedido?
SELECT 
    o.idOrder AS pedido,
    p.Pname AS produto,
    p.Category AS categoria,
    po.poQuantidade AS quantidade,
    po.poStatus AS statusEstoque
FROM Orders o
JOIN ProductOrder po ON o.idOrder = po.idPOOrder
JOIN Product p ON p.idProduct = po.idPOProduct;

-- Pergunta: Quais fornecedores fornecem quais produtos?
SELECT 
    s.SocialName AS fornecedor,
    p.Pname AS produto,
    ps.Quantity AS quantidadeFornecida
FROM Supplier s
JOIN ProductSupplier ps ON s.idSupplier = ps.idPSSupplier
JOIN Product p ON p.idProduct = ps.idPSProduct
ORDER BY s.SocialName;

-- Pergunta: Qual o status de entrega e código de rastreio de cada pedido por cliente?
SELECT 
	pf.Pname AS cliente, 
    o.idOrder AS pedido, 
    o.OrderStatus AS statusPedido, 
    d.DeliveryStatus AS statusEntrega, 
    d.TrackingCode AS rastreio
FROM Clients c
JOIN ClientPF pf ON c.idClient = pf.idClient
JOIN Orders o ON c.idClient = o.idOrderClient
JOIN Delivery d ON d.idDeliveryOrder = o.idOrder;

-- Pergunta: Algum vendedor PJ também é fornecedor (mesmo CNPJ)?
SELECT 
    sj.SocialName AS vendedor,
    s.SocialName AS fornecedor,
    sj.CNPJ
FROM SellerPJ sj
JOIN Supplier s ON sj.CNPJ = s.CNPJ;

-- Pergunta: Quais produtos estão em estoque, em qual localização e com qual quantidade?
SELECT 
    p.Pname AS produto,
    p.Category AS categoria,
    ps.StorageLocation AS localizacao,
    ps.Quantity AS quantidadeEmEstoque,
    sl.Location AS uf
FROM Product p
JOIN StorageLocation sl ON p.idProduct = sl.idLProduct
JOIN ProductStorage ps ON ps.idProductStorage = sl.idLstorage
ORDER BY ps.Quantity DESC;

-- Pergunta: Qual o detalhamento completo de um pedido — cliente, produto, pagamento e entrega?
SELECT 
	pf.Pname AS cliente, 
	o.idOrder AS pedido, 
    p.Pname AS produto,
    po.poQuantidade AS qtdItens, 
    pay.Typepayment AS formaPagamento, 
    o.sendValue AS frete,
    d.DeliveryStatus AS statusEntrega, 
    d.TrackingCode AS rastreio
FROM Clients c
JOIN ClientPF pf ON c.idClient = pf.idClient
JOIN Orders o ON c.idClient = o.idOrderClient
JOIN ProductOrder po ON o.idOrder = po.idPOOrder
JOIN Product p ON p.idProduct = po.idPOProduct
JOIN Payments pay ON o.idOrderPayment = pay.idPayment
JOIN Delivery d ON d.idDeliveryOrder = o.idOrder;

-- ============================================================
-- 7. SUBQUERIES E CONSULTAS AVANÇADAS
-- ============================================================

-- Pergunta: Quais produtos nunca foram incluídos em nenhum pedido?
SELECT p.idProduct, p.Pname, p.Category
FROM Product p
WHERE p.idProduct NOT IN (
    SELECT DISTINCT idPOProduct FROM ProductOrder
);

-- Pergunta: Quais clientes ainda não fizeram nenhum pedido?
SELECT c.idClient, pf.Pname, pf.Lname
FROM Clients c
JOIN ClientPF pf ON c.idClient = pf.idClient
LEFT JOIN Orders o ON c.idClient = o.idOrderClient
WHERE o.idOrder IS NULL;

-- Pergunta: Qual o cliente que mais gastou em frete?
SELECT 
	pf.Pname AS cliente, 
    SUM(o.sendValue) AS totalFrete
FROM Clients c
JOIN ClientPF pf ON c.idClient = pf.idClient
JOIN Orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient, pf.Pname
ORDER BY totalFrete DESC LIMIT 1;

-- Pergunta: Relação completa de produtos com seus fornecedores e localização em estoque?
SELECT 
    p.Pname AS produto,
    p.Category AS categoria,
    sup.SocialName AS fornecedor,
    ps_loc.StorageLocation AS estoque,
    ps_loc.Quantity AS qtdEstoque
FROM Product p
LEFT JOIN ProductSupplier psup ON p.idProduct = psup.idPSProduct
LEFT JOIN Supplier sup ON sup.idSupplier = psup.idPSSupplier
LEFT JOIN StorageLocation sl ON p.idProduct = sl.idLProduct
LEFT JOIN ProductStorage ps_loc ON ps_loc.idProductStorage = sl.idLstorage
ORDER BY p.Pname;
