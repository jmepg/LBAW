.mode column
.headers on
PRAGMA foreign_keys = ON;

DROP TABLE if exists Utilizador;
CREATE TABLE Utilizador(
	userId INTEGER PRIMARY KEY,
	password VARCHAR NOT NULL,
);

DROP TABLE if exists ClienteRegistado;
CREATE TABLE ClienteRegistado(
	userId REFERENCES User(userId) ON DELETE CASCADE,
	nome VARCHAR NOT NULL,
	email VARCHAR NOT NULL,
	dataDeNascimento DATE NOT NULL,
	userState VARCHAR NOT NULL, 
	compras anteriores array /*não sei se funca*/
);

DROP TABLE if exists ClientePremium;
CREATE TABLE ClientePremium(
	userId REFERENCES User(userId) ON DELETE CASCADE,
	premium boolean /*fazer trigger que quando os gastos forem, acho que vamos precisar de variavel gastos em user*/
);

DROP TABLE if exists Produto;
CREATE TABLE Produto(
	produtoid INTEGER PRIMARY KEY,
	nome VARCHAR NOT NULL,
	imagem VARCHAR NOT NULL,
	preco FLOAT NOT NULL,
	descricao VARCHAR NOT NULL, 
	alcool FLOAT NOT NULL, 
	volume FLOAT NOT NULL,
	stock FLOAT NOT NULL	
);

DROP TABLE if exists Comentario;
CREATE TABLE Comentario(
	comentarioid INTEGER PRIMARY KEY,	
	userId REFERENCES User(userId) ON DELETE CASCADE,
	produtoid REFERENCES Produto(produtoid),
	texto VARCHAR NOT NULL
);

/*vê a cena do comentario a ver se é assim*/

DROP TABLE if exists TipoDeProduto;
CREATE TABLE TipoDeProduto(
	produtoId REFERENCES Produto(produtoid),
	tipo VARCHAR NOT NULL
);

DROP TABLE if exists Pais;
CREATE TABLE Pais(
	produtoId REFERENCES Produto(produtoId),
	pais VARCHAR NOT NULL
);

DROP TABLE if exists Rating;
CREATE TABLE Rating(
	ratingId INTEGER PRIMARY KEY,
	userId REFERENCES User(userId) ON DELETE CASCADE,
	produtoId REFERENCES Produto(produtoId),
	voto INTEGER NOT NULL
);

/*ver o ratingID no A6 ou se está mal
como é que se vai fazer o voto a ser guardado e juntar ao dos outros utilizadores
fazemos um voto (da tabela rating) e depois 1 trigger para o colocar um atributo rate (novo atributo) no produto??
*/

DROP TABLE if exists ListProdutos;
CREATE TABLE ListProdutos(
	listId INTEGER PRIMARY KEY,
	produtoId REFERENCES Produto(produtoId)
	/*acho que não é nessessário o carrinhoId*/
);

DROP TABLE if exists Carrinho;
CREATE TABLE Carrinho(
	carrinhoId INTEGER PRIMARY KEY,
	userId REFERENCES User(userId) ON DELETE CASCADE,
	listId REFERENCES ListProdutos(listId)
);


DROP TABLE if exists Compra;
CREATE TABLE Compra(
	compraId INTEGER PRIMARY KEY,
	userId REFERENCES User(userId) ON DELETE CASCADE,
	carrinhoId REFERENCES Carrinho(carrinhoId)
);

DROP TABLE if exists TipoDePagamento;
CREATE TABLE TipoDePagamento(
	compraId REFERENCES Compra(compraId),
	tipo VARCHAR NOT NULL
);

DROP TABLE if exists TipoDeEnvio;
CREATE TABLE TipoDeEnvio(
	compraId REFERENCES Compra(compraId),
	tipo VARCHAR NOT NULL
);

DROP TABLE if exists EstadoDaCompra;
CREATE TABLE EstadoDaCompra(
	compraId REFERENCES Compra(compraId),
	estado VARCHAR NOT NULL
);

/*tenho duvidas em relação ao tipo pagamento envio e compra*/

