.mode column
.headers on
PRAGMA foreign_keys = ON;

DROP TABLE if exists Utilizador;
CREATE TABLE Utilizador(
    
	userId SERIAL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR UNIQUE,
	password VARCHAR NOT NULL,
);

DROP TABLE if exists Administrador;
CREATE TABLE Administrador
(
userId FOREIGN KEY REFERENCES Utilizador(userId)
);

DROP TABLE if exists ClienteRegistado;
CREATE TABLE ClienteRegistado(
	userId REFERENCES User(userId) ON DELETE CASCADE,
	nome TEXT NOT NULL,
	email TEXT NOT NULL,
	dataDeNascimento DATE NOT NULL,
	userState TEXT NOT NULL, 
);

ALTER TABLE ClienteRegistado(
ADD CHECK(dataDeNascimento>0) 
)

DROP TABLE if exists ClientePremium;
CREATE TABLE ClientePremium(
	userId REFERENCES ClienteRegistado(userId) ON DELETE CASCADE,
	premium boolean /*fazer trigger que quando os gastos forem, acho que vamos precisar de variavel gastos em user*/
);

DROP TABLE if exists Produto;
CREATE TABLE Produto(
	produtoId SERIAL AUTO_INCREMENT PRIMARY KEY,
	nome TEXT NOT NULL,
	imagem TEXT NOT NULL,
	preco FLOAT NOT NULL,
	descricao TEXT NOT NULL, 
	alcool FLOAT NOT NULL, 
	volume FLOAT NOT NULL,
	stock FLOAT NOT NULL,
    tipoId FOREIGN KEY REFERENCES TipoDeProduto(tipoId)	
);

ALTER TABLE Produto 
(
ADD CHECK(alcool >0),
ADD CHECK(volume >0),
ADD CHECK(volume >0)   
);

DROP TABLE if exists Comentario;
CREATE TABLE Comentario(
	comentarioid SERIAL  AUTO_INCREMENT PRIMARY KEY,	
	userId FOREIGN KEY REFERENCES ClienteRegistado(userId) ON DELETE CASCADE,
	produtoId FOREIGN KEY REFERENCES Produto(produtoId),
    data DATE NOT NULL,
	texto TEXT NOT NULL
);


DROP TABLE if exists TipoDeProduto;
CREATE TABLE TipoDeProduto(
    tipoId SERIAL AUTO_INCREMENT PRIMARY KEY,
	produtoId REFERENCES Produto(produtoId),
	tipo TEXT NOT NULL
);

DROP TABLE if exists Pais;
CREATE TABLE Pais(
    paisId SERIAL AUTO_INCREMENT PRIMARY KEY,
	produtoId REFERENCES Produto(produtoId),
	pais TEXT NOT NULL
);

DROP TABLE if exists Rating;
CREATE TABLE Rating(
	ratingId SERIAL AUTO_INCREMENT PRIMARY KEY,
	userId REFERENCES ClientePremium(userId) ON DELETE CASCADE,
	produtoId REFERENCES Produto(produtoId),
	rate FLOAT NOT NULL
);


DROP TABLE if exists Produto_Rating;
CREATE TABLE Produto_Rating
(
produtoId FOREIGN KEY REFERENCES Produto(produtoId),
ratingId FOREIGN KEY REFERENCES Rating(ratingId)    
);

CREATE TABLE Quantidade
(
quantidadeId SERIAL AUTO_INCREMENT PRIMARY KEY,
numero INTEGER,
produtoId REFERENCES Produto(produtoId)    
);

ALTER TABLE Quantidade
(
ADD CHECK(numero>0)    
);

ALTER TABLE Quantidade
(
ADD CHECK(numero >0),
);

DROP TABLE if exists Carrinho;
CREATE TABLE Carrinho(
	carrinhoId SERIAL PRIMARY KEY,
	userId REFERENCES ClienteRegistado(userId) ON DELETE CASCADE,
);

DROP TABLE if exists Carrinho_Produto;
CREATE TABLE Carrinho_Produto
(
carrinhoId FOREIGN KEY References Carrinho(carrinhoId),
produtoId FOREIGN KEY References Produto(produtoId)
);


DROP TABLE if exists Compra;
CREATE TABLE Compra(
	compraId SERIAL AUTO_INCREMENT PRIMARY KEY,
	userId FOREIGN KEY REFERENCES ClienteRegistado(userId) ON DELETE CASCADE,
);

DROP TABLE if exists Compra_Produto;
CREATE TABLE Compra_Produto
(
compraId FOREIGN KEY REFERENCES Compra(compraId),
produtoId FOREIGN KEY REFERENCES Produto(password)    
); 

DROP TABLE if exists Compra_Carrinho;
CREATE TABLE Compra_Carrinho
(
compraId FOREIGN KEY REFERENCES Compra(compraId),
carrinhoId FOREIGN KEY REFERENCES Carrinho(carrinhoId)   
);


DROP TABLE if exists TipoDePagamento;
CREATE TABLE TipoDePagamento(
	compraId FOREIGN KEY REFERENCES Compra(compraId),
	tipo TEXT NOT NULL
);

DROP TABLE if exists TipoDeEnvio;
CREATE TABLE TipoDeEnvio(
	compraId FOREIGN KEY REFERENCES Compra(compraId),
	tipo TEXT NOT NULL
);

CREATE TABLE TipoDeEnvio
(
compraId FOREIGN KEY Compra(compraId),
tipo TEXT NOT NULL    
);



