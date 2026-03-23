use ecommerce;

-- Inserindo dados em Clients
INSERT INTO Clients (Address, ClientType) VALUES
('BA', 'PF'),
('SP', 'PJ'),
('RJ', 'PF'),
('MG', 'PF'),
('PE', 'PJ'),
('CE', 'PF');

-- Inserindo dados em ClientPF
INSERT INTO ClientPF (idClient, Pname, Minit, Lname, CPF, Contact) VALUES 
(1, 'Ana', 'M', 'Silva', '12345678901', '75999980001'),
(3, 'Carlos', 'R', 'Oliveira', '34567890123', '75999970012'),
(4, 'Maria', 'A', 'Pereira', '45678901234', '75999960023'),
(6, 'Julia', 'C', 'Almeida', '67890123456', '75999950034');

-- Inserindo dados em ClientPJ
INSERT INTO ClientPJ (idClient, SocialName, CNPJ, Contact) VALUES 
(2, 'Roupas de Vó', '44144789000164', '11999990002'),
(5, 'Xs IPhones', '44244345000154', '11999840032');

-- Inserindo dados em Product
INSERT INTO Product (Pname, Classification_kids, Category, Avaliacao, Size) VALUES
('Celular', false, 'Eletrônico', 4.5, 'M'),
('Notebook', false, 'Eletrônico', 4.7, 'G'),
('Camisa', false, 'Vestimento', 4.0, 'M'),
('Boneca', true, 'Brinquedos', 4.8, 'P'),
('Arroz', false, 'Alimentos', 3.9, 'G'),
('Sabonete', false, 'Higiene', 4.2, 'P'),
('Sofa', false, 'Móveis', 4.3, 'G'),
('Bicicleta', true, 'Brinquedos', 4.6, 'G');

-- Inserindo dados em Supplier
INSERT INTO Supplier (SocialName, CNPJ, Contact) VALUES
('Fornecedor A', '11111111000111', '75999990001'),
('Fornecedor B', '22222222000122', '75999990002'),
('Fornecedor C', '33333333000133', '75999990003'),
('Empresa Zilar', '66666666000166', '75999990003');

-- Inserindo dados em Seller
INSERT INTO Seller (location, Contact) VALUES
('BA', '75988880001'),
('SP', '11988880002'),
('RJ', '21988880003'),
('MG', '31988880004');

-- Inserindo dados em SellerPF
INSERT INTO SellerPF (idSeller, Pname, Minit, Lname, CPF) VALUES
(1, 'Pedro', 'A', 'Lima', '78901234567');

-- Inserindo dados em SellerPJ
INSERT INTO SellerPJ (idSeller, SocialName, CNPJ) VALUES
(2, 'Empresa Marilu', '44444444000144'),
(3, 'Empresa TypeVendas', '55555555000155'),
(4, 'Empresa Zilar', '66666666000166');

-- Inserindo dados em Payments
INSERT INTO Payments (idPaymentClient, Typepayment, limitAvailable) VALUES
(1, 'Pix', NULL),
(2, 'Credito', 3000.00),
(3, 'Debito', NULL),
(4, 'Boleto', NULL);

-- Inserindo dados em Orders
INSERT INTO Orders (idOrderClient, OrderStatus, Orderdescription, sendValue, idOrderPayment) VALUES
(1, 'Confirmado', 'Compra celular', 20.00, 1),
(2, 'Em processamento', 'Compra notebook', 25.00, 2),
(3, 'Confirmado', 'Compra roupas', 15.00, 3),
(4, 'Cancelado', 'Compra brinquedo', 10.00, 4),
(1, 'Em processamento', 'Compra notebook', 25.00, 2);

INSERT INTO Delivery (idDeliveryOrder, DeliveryStatus, TrackingCode) VALUES
(1, 'Entregue', 'BR123'),
(2, 'Em transporte', 'BR456'),
(3, 'Aguardando envio', 'BR789'),
(4, 'Em transporte', 'BR321');

-- Inserindo dados em ProductOrder
INSERT INTO ProductOrder (idPOProduct, idPOOrder, poQuantidade, poStatus) VALUES
(1, 1, 1, 'Disponivel'),
(2, 2, 1, 'Disponivel'),
(3, 3, 2, 'Disponivel'),
(4, 4, 1, 'Sem estoque');

-- Inserindo dados em ProductStorage
INSERT INTO ProductStorage (StorageLocation, Quantity) VALUES
('Salvador', 100),
('Feira de Santana', 40),
('Sâo Paulo', 80),
('Santos', 50),
('Rio de Janeiro', 60),
('Niterói', 30);

-- Inserindo dados em StorageLocation
INSERT INTO StorageLocation (idLProduct, idLstorage, Location) VALUES
(1, 1, 'BA'),
(2, 2, 'SP'),
(3, 3, 'RJ');

-- Inserindo dados em ProductSupplier
INSERT INTO ProductSupplier (idPSSupplier, idPSProduct, Quantity) VALUES
(1, 1, 50),
(1, 2, 40),
(2, 3, 30),
(2, 4, 20),
(3, 5, 60);

-- Inserindo dados em ProductSeller
INSERT INTO ProductSeller (idSeller, idProduct, ProductQuantity) VALUES
(1, 1, 10),
(2, 2, 15);