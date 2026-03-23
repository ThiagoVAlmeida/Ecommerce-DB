-- drop database ecommerce;
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- CLIENTE
CREATE TABLE IF NOT EXISTS Clients(
	idClient INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	Address VARCHAR(30) NOT NULL,
    ClientType ENUM('PF', 'PJ') NOT NULL
);

-- ClientPF (Pessoa Física)
CREATE TABLE IF NOT EXISTS ClientPF (
    idClient INT PRIMARY KEY,
    Pname VARCHAR(10)NOT NULL,
    Minit VARCHAR(3) NOT NULL,
    Lname VARCHAR(20) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cpf_clientpf UNIQUE (CPF),
    CONSTRAINT fk_clientpf FOREIGN KEY (idClient)
        REFERENCES Clients(idClient)
        ON DELETE CASCADE
);

-- ClientPJ (Pessoa Jurídica)
CREATE TABLE IF NOT EXISTS ClientPJ (
    idClient INT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    Contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_clientpj UNIQUE (CNPJ),
    CONSTRAINT fk_clientpj FOREIGN KEY (idClient)
        REFERENCES Clients(idClient)
        ON DELETE CASCADE
);

-- PRODUTO
CREATE TABLE IF NOT EXISTS Product(
	idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(10),
    Classification_kids BOOL DEFAULT FALSE,
	Category ENUM('Eletrônico', 'Vestimento', 'Brinquedos', 'Alimentos', 'Higiene', 'Móveis') NOT NULL,
    Avaliacao FLOAT DEFAULT 0,
    Size VARCHAR(10)
);

-- PAGAMENTO
CREATE TABLE IF NOT EXISTS Payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idPaymentClient INT NOT NULL,
    Typepayment ENUM('Pix', 'Debito', 'Credito', 'Boleto') NOT NULL,
    limitAvailable DECIMAL(10,2),
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_client FOREIGN KEY (idPaymentClient) REFERENCES Clients(idClient)
    ON DELETE CASCADE
);

-- PEDIDO
CREATE TABLE IF NOT EXISTS Orders(
	idOrder INT AUTO_INCREMENT PRIMARY KEY,
	idOrderClient INT NOT NULL,
	OrderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
	Orderdescription VARCHAR(245),
    sendValue DECIMAL(10,2) DEFAULT 0,
    idOrderPayment INT NULL,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES Clients(idClient) 
    ON UPDATE CASCADE 
    ON DELETE RESTRICT,
    CONSTRAINT fk_orders_payment FOREIGN KEY (idOrderPayment) REFERENCES Payments(idPayment)
    ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Delivery(
	idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idDeliveryOrder INT NOT NULL,
    DeliveryStatus ENUM('Em transporte', 'Entregue', 'Aguardando envio') DEFAULT 'Aguardando envio',
    TrackingCode VARCHAR(45) UNIQUE,
    CONSTRAINT fk_delivery_order 
    FOREIGN KEY (idDeliveryOrder) REFERENCES Orders(idOrder)
    ON DELETE CASCADE
);

-- ESTOQUE
CREATE TABLE IF NOT EXISTS ProductStorage(
	idProductStorage INT AUTO_INCREMENT PRIMARY KEY,
	StorageLocation VARCHAR(255) NOT NULL,
	Quantity INT DEFAULT 0
);


-- FORNECEDOR
CREATE TABLE IF NOT EXISTS Supplier(
	idSupplier INT AUTO_INCREMENT PRIMARY KEY,
	SocialName VARCHAR(255) NOT NULL,
	CNPJ CHAR(15) NOT NULL,
    Contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);


-- VENDEDOR
CREATE TABLE IF NOT EXISTS Seller(
	idSeller INT AUTO_INCREMENT PRIMARY KEY,
	location VARCHAR(255),
    Contact CHAR(11) NOT NULL
);


-- VENDEDOR PF
CREATE TABLE IF NOT EXISTS SellerPF(
	idSeller INT PRIMARY KEY,
	Pname VARCHAR(10),
    Minit VARCHAR(3),
    Lname VARCHAR(20),
	CPF CHAR(11) UNIQUE,
    FOREIGN KEY (idSeller) REFERENCES Seller(idSeller)
    ON DELETE CASCADE
);

-- VENDEDOR PJ
CREATE TABLE IF NOT EXISTS SellerPJ(
	idSeller INT PRIMARY KEY,
	SocialName VARCHAR(255),
	CNPJ CHAR(15) UNIQUE,
    FOREIGN KEY (idSeller) REFERENCES Seller(idSeller)
    ON DELETE CASCADE
);

-- PRODUTO x VENDEDOR (N:N)
CREATE TABLE IF NOT EXISTS ProductSeller(
	idSeller INT,
	idProduct INT,
	ProductQuantity INT DEFAULT 1,
    PRIMARY KEY (idSeller, idProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idSeller) REFERENCES Seller(idSeller)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
    CONSTRAINT fk_procuct_product FOREIGN KEY (idProduct) REFERENCES Product(idProduct)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);

-- RELAÇÃO PRODUTO x PEDIDO (N:N)
CREATE TABLE IF NOT EXISTS ProductOrder(
	idPOProduct INT,
	idPOOrder INT,
	poQuantidade INT DEFAULT 1,
    poStatus ENUM('Disponivel', 'Sem estoque') default 'Disponivel',
    PRIMARY KEY (idPOProduct, idPOOrder),
    CONSTRAINT fk_po_product FOREIGN KEY (idPOProduct) REFERENCES Product(idProduct)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
    CONSTRAINT fk_po_order FOREIGN KEY (idPOOrder) REFERENCES Orders(idOrder)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);

-- PRODUTO x ESTOQUE (N:N)
CREATE TABLE IF NOT EXISTS StorageLocation(
	idLProduct INT,
	idLstorage INT,
	Location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLProduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLProduct) REFERENCES Product(idProduct)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES ProductStorage(idProductStorage)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);

-- PRODUTO x FORNECEDOR (N:N)
CREATE TABLE IF NOT EXISTS ProductSupplier(
	idPSSupplier INT,
	idPSProduct INT,
	Quantity int NOT NULL,
    PRIMARY KEY (idPSSupplier, idPSProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPSSupplier) REFERENCES Supplier(idSupplier)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPSProduct) REFERENCES Product(idProduct)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);

show tables;
