.mode column
.headers on
PRAGMA foreign_keys = ON;

DROP TABLE if exists Utilizador;
CREATE TABLE Utilizador(    
	userId SERIAL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR UNIQUE,
	password VARCHAR NOT NULL
);

DROP TABLE if exists Administrador;
CREATE TABLE Administrador(
	userId FOREIGN KEY REFERENCES Utilizador(userId)
);

DROP TABLE if exists ClienteRegistado;
CREATE TABLE ClienteRegistado(
	userId REFERENCES User(userId) ON DELETE CASCADE,
	nome TEXT NOT NULL,
	email TEXT NOT NULL,
	dataDeNascimento DATE NOT NULL,
	userState TEXT NOT NULL 
);

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
    paisId FOREIGN KEY REFERENCES Pais(paisId),
    tipoId FOREIGN KEY REFERENCES TipoDeProduto(tipoId)	
);

ALTER TABLE Produto 
(
ADD CONSTRAINT alcoolValido CHECK(alcool >0),
ADD CONSTRAINT volumevalido CHECK(volume >0),
ADD CONSTRAINT precoValido CHECK(preco >0)   
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
	tipo TEXT NOT NULL
);


DROP TABLE if exists Pais;
CREATE TABLE Pais(
    paisId SERIAL AUTO_INCREMENT PRIMARY KEY,
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
ADD CONSTRAINT numeroValido CHECK(numero>0)    
);


DROP TABLE if exists Carrinho;
CREATE TABLE Carrinho(
	carrinhoId SERIAL PRIMARY KEY,
	userId REFERENCES ClienteRegistado(userId) ON DELETE CASCADE
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
	userId FOREIGN KEY REFERENCES ClienteRegistado(userId) ON DELETE CASCADE
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
    tipoId SERIAL PRIMARY KEY,
	compraId FOREIGN KEY REFERENCES Compra(compraId),
	tipo TEXT NOT NULL
);

DROP TABLE if exists TipoDeEnvio;
CREATE TABLE TipoDeEnvio(
    tipoId SERIAL PRIMARY KEY,
	compraId FOREIGN KEY REFERENCES Compra(compraId),
	tipo TEXT NOT NULL
);



/*SELECTS*/

/*Buscar o conjunto username-password*/
SELECT username,password FROM Utilizador;

/*Produto*/
SELECT * FROM Produto;


/* Produto-Preco*/
SELECT nome,preco FROM Produto;

/*Selecionar toda a informação sobre o cliente que faz um dado comentario*/
SELECT ClienteRegistado.*, Comentario.texto FROM Comentario,ClienteRegistado 
WHERE Comentario.userId = ClienteRegistado.userId;

/*Selecionar info de Clientes Registados*/
SELECT * FROM Utilizador, ClienteRegistado
WHERE Utilizador.userId = ClienteRegistado.userId;

/*Selecionar info de ClientePremium*/
SELECT * FROM Utilizador, ClienteRegistado, ClientePremium
WHERE (Utilizador.userId = ClienteRegistado.userId) AND (Utilizador.userId = ClientePremium.userId);

/*Selecionar Produtos com igual TIPO*/
SELECT Produto.nome,TipoDeProduto.tipo FROM Produto,TipoDeProduto
WHERE (Produto.tipoId = TipoDeProduto.tipoId); 

/*Selecionar quantidade do produto*/
SELECT Quantidade.numero, Produto.* FROM Quantidade, Produto,
WHERE (Quantidade.produtoId = Produto.produtoId);

/*Selecionar produtos do Carrinho*/
SELECT Produto.* FROM Carrinho, Carrinho_Produto, Produto
WHERE (Produto.produtoId = Carrinho_Produto.produtoId) AND (Carrinho_Produto.carrinhoId = Carrinho.carrinhoId)


/*Selecionar produtos da Compra*/
SELECT Produto.* FROM Compra, Compra_Produto, Produto
WHERE (Produto.produtoId = Compra_Produto.produtoId) AND (Compra_Produto.compraId = Compra.compraId);

/*Selecionar carrinho do cliente*/
SELECT Carrinho.* FROM ClienteRegistado 
WHERE ClienteRegistado.userId = Carrinho.userId;

/*Selecionar produto por pais*/
SELECT Produto* FROM Produto, Pais
WHERE Produto.paisId = Pais.paisId;

/*DELETES*/

/*Eliminar quantidade escolhida de um dado produto*/
DELETE Carrinho_Produto.produtoId, Quantidade.* FROM Quantidade,
WHERE Carrinho_Produto.produtoId = Quantidade.produtoId;

/*Eliminar Ratings de um dado produto*/
DELETE * FROM Rating 
WHERE Produto.produtoId = Rating.produtoId;



/*UPDATES*/

/*Update nome e email de um cliente*/
UPDATE  Utilizador SET nome = 'EU', email= 'eu@gmail.com' FROM Utilizador,ClienteRegistado
     WHERE Utilizador.id = ClienteRegistado.sales_id;

/*Update de rating de um produto*/
UPDATE Rating SET rate='4.5' FROM Rating,Produto
     WHERE Rating.produtoId = Produto.produtoId;

/*Update comentario de um produto feito por um Cliente*/
UPDATE Comentario SET texto='novoComent' FROM Comentario,Produto,ClienteRegistado
     WHERE(Comentario.produtoId = Produto.produtoId) AND (Comentario.userId = ClienteRegistado.userId);

/*Update preco de produto com tipo BEERS*/
UPDATE Produto SET preco=preco*1.15 FROM Produto,TipoDeProduto
    WHERE TipoDeProduto.tipo ='Beer' AND Produto.tipoId = TipoDeProduto.tipoId;

/**/
UPDATE 

/*INDEXES*/

DROP INDEX Utilizador.Ind_Prim_Utilizador;
CREATE INDEX Ind_Prim_Utilizador
ON Utilizador(userId);



DROP INDEX Produto.Ind_Prim_Produto;
CREATE INDEX Ind_Prim_Produto
on Produto(produtoId);

DROP INDEX Comentario.Ind_Prim_Comentario;
CREATE INDEX Ind_Prim_Comentario
on Comentario(comentarioid);

DROP INDEX TipoDeProduto.Ind_Prim_TipoDeProduto;
CREATE INDEX Ind_Prim_TipoDeProduto
on TipoDeProduto(tipoId);

DROP INDEX Pais.Ind_Prim_Pais;
CREATE INDEX Ind_Prim_Pais
on Pais(paisId);

DROP INDEX Rating.Ind_Prim_Rating;
CREATE INDEX Ind_Prim_Rating
on Rating(ratingId);

DROP INDEX Quantidade.Ind_Prim_Quantidade;
CREATE INDEX Ind_Prim_Quantidade
on Quantidade(quantidadeId);

DROP INDEX TipoDeProduto.Ind_Prim_TipoDeProduto;
CREATE INDEX Ind_Prim_TipoDeProduto
on TipoDeProduto(tipoId);

DROP INDEX Carrinho.Ind_Prim_Carrinho;
CREATE INDEX Ind_Prim_Carrinho
on Carrinho(carrinhoId);

DROP INDEX Compra.Ind_Prim_Compra;
CREATE INDEX Ind_Prim_Compra
on Compra(compraId);

DROP INDEX TipoDePagamento.Ind_Prim_TipoDePagamento;
CREATE INDEX Ind_Prim_TipoDePagamento
on TipoDePagamento(tipoId);

DROP INDEX TipoDeEnvio.Ind_Prim_TipoDeEnvio;
CREATE INDEX Ind_Prim_TipoDeEnvio
on TipoDeEnvio(tipoId);

CLUSTER Produto USING preco;
CLUSTER Pais USING nome;



/*INSERTS*/

insert into Utilizador values(1, 'Totas', 'pass');
insert into Utilizador values(2, 'postas', 'pass');
insert into Utilizador values(3, 'costas', 'pass');


insert into Administrador values(1);


insert into ClienteRegistado values(2, 'Tiago', 'tiaguinho@gamil.com', '1990-01-01', 'Ativo');
insert into ClienteRegistado values(3, 'Raul', 'costinha@gamil.com', '1987-05-11', 'Ativo');

insert into TipoDeProduto values(1, 'Wine');
insert into TipoDeProduto values(2, 'Beer');
insert into TipoDeProduto values(3, 'Spirit');
insert into TipoDeProduto values(4, 'Cider');

insert into Produto values(1, 'Adelaide Hills McLaren Vale Chardonnay', 'path', 8.08, 'Fresh and elegant, this wine has good fruit weight and aromas including apple and white peach, a lovely texture and a savoury, mealy edge.
The acidity is nicely balanced, giving the wine good length on the finish.', 12.7, 75, 30, 1, 1);
insert into Produto values(2, 'McLaren Vale Shiraz', 'path', 7.48, 'This deep coloured Shiraz is youthful and vibrant, with a lovely dark fruit and spiced plum character on the nose.
The oak supports rather than masks the fruit, which is bright and lively yet plush and fleshy on the palate.
The tannins are ripe and silky, giving the wine a texture that is unusual at this price.', 14, 75, 30, 1, 1);
insert into Produto values(3, 'Prima Mano Primitivo', 'path', 13.10, 'Prima Mano has intense jammy plum and raspberry flavours, a black cherry scented nose, and a long, persistent sweet fruit finish with excellent purity.
Modern in style, it nevertheless retains a very Italian identity, with a characteristic bitter twist on the finish.', 14.5, 75, 30, 98,1);
insert into Produto values(4, 'Aleatico di Puglia Passito', 'path', 16.19, 'Deep ruby red in colour with perfumes of red rose petals and dried cherries giving way to a dark, black cherry and spice character on the palate with rounded tannins and a characteristic bitter twist.
Sweet and luscious but not cloying, it has dried fruit and cinnamon perfumes on the finish.', 13.5, 50, 30, 98, 1);
insert into Produto values(5, 'Fiano Greco', 'path', 8.06, 'Fiano gives the A Mano Bianco white peach and floral perfumes, Falanghina adds citrus blossom aromas and Verdeca lends a grapefruit character.
The palate is complex and zesty, with well balanced acidity and lovely body. Citrus notes continue on the finish.', 12, 75, 30, 97, 1);
insert into Produto values(6, '10 Saints', 'path', 39.10, 'Taking its name from the 11 parishes of Barbados, 10 of which are named after Saints, the 10 Saints Brewery was conceived in 2009 with the aim of combining the rum heritage of Barbados with a brilliant, refreshing lager.
A Professor of Brewing at the Heriot-Watt University in Edinburgh, and 10 Saints Master Brewer, Ian Herok, has spent years of product development and research into the oak ageing of beer to create this unique, premium lager from Barbados.
The production of 10 Saints is a slow and complex one, with the gradual infusion of flavours from wood to beer, a delicate process which creates 10 Saint s deep flavour and unique character. The barrels used in this process were originally used to age bourbon in Kentucky, before being shipped to Barbados for ageing rum.
This small batch craft lager uses two varieties of hop, namely Galena, a bittering hop used extensively in the USA, and Styrian Goldings (ex Slovenia), which provides enhanced bitter properties and a mild hop background aroma.
During the production process water is filtered through coral, before undergoing some reverse osmosis and the inclusion of a highly flocculent bottom fermenting yeast.
The following oak ageing in rum casks results in a full flavoured, golden premium beer with distinctive but rounded notes of rum, malt, vanilla, tropical spice and toasted oak.', 4.8, 35.5, 100, 98, 2);
insert into Produto values(7, 'St Stefanus - Blonde August', 'path', 2.39, 'St Stefanus is an unpasteurised high fermentation beer that has been refermented in the bottle.
It is brewed using three different yeasts, one of which is the Jermanus yeast strain from Sint Stefanus. This combined with the unique process, gives the beer its distinct flavour.
The artisan recipe takes three months to complete before cellar release, creating a smoth beer with a depth of flavour that cannot be duplicated by quicker, more modern methods.', 7, 33, 30, 44, 2);
insert into Produto values(8, 'Pistonhead', 'path', 1.30, 'Straw golden colour with a malty nose and a hint of dark loaf.
A full bodied malt flavour with a balanced and distinct bitterness.', 4.6, 33, 300, 64, 2);
insert into Produto values(9, 'BrewDog', 'path', 3.99, 'Hints of caramel and toffee on the nose, followed by some astringent pine and biscuit malt on the palate, coupled with some soft honey flavours.', 9.2, 33, 150, 45, 2);
insert into Produto values(10, 'Shepherd Neame - Masterbrew', 'path', 1.75, 'This is the beer that Shepherd Neame is best known for in the brewery s Kentish heartland - a distinctive, mid-brown bitter ale, with all the hoppy aroma you would expect of a beer brewed in the heart of the hop country.
Well balanced, with a taste that s been described as "wonderfully aggressive, tinged with sweetness".
Master Brew is brewed using only the finest Kentish barley and hops, and is the best-selling cask ale brewed in Kent.
A clean, dry, refreshing, session bitter, having a touch of sweetness, but displaying an assertive and vibrant hop with a lingering bitter finish.', 4, 50, 222, 45, 2);
insert into Produto values(11, 'Appleton Estate - Signature Blend', 'path', 20.15, 'Appleton Estate Signature Blend is a blended rum, which means it is a combination of several rums of different styles and ages and does not have an age statement.
A beautiful harvest gold and amber colour, with remarkable clarity and brilliance.
Perfectly balanced complex citrus, fruity and sweet notes, with subtle orange peel, dried apricot, fresh peach, and a hint of molasses and woody notes.
Finishes as serenely as it started in the mouth. Its the perfect accompaniment for memorable rum cocktails or simply mixed with cola and an orange peel garnish.', 40, 70, 100, 45, 3);
insert into Produto values(12, 'Rebel Yell - Small Batch Rye Bourbon', 'path', 29.05, 'Produced and sold in limited quantities, small batch rye offers smooth, spicy rye flavour with enough backbone to stand up to classic cocktails.
Tasting: Mildly woody with a sweet and surprising spice.', 45, 70, 100, 59, 3);
insert into Produto values(13, 'Rebel Yell - Small Batch Rye Bourbon', 'path', 29.05, 'Produced and sold in limited quantities, small batch rye offers smooth, spicy rye flavour with enough backbone to stand up to classic cocktails.
Tasting: Mildly woody with a sweet and surprising spice.', 45, 70, 100, 66, 3);
insert into Produto values(14, 'Anno - Anno Elderflower & Vodka', 'path', 31.48, 'Carrying on Anno s fine tradition of lovingly hand-crafting each product, Anno Elderflower and Vodka is the second delectable offering from Anno Distillers, Kent s first ever micro-distillers.
Taking inspiration from Anno s home among the stunning Kent countryside, they have responsibly sourced from local growers the finest elderflower the Garden of England has to offer.', 29, 70, 111, 45, 3);
insert into Produto values(15, 'Chase Distillery - Marmalade Vodka', 'path', 34.10, 'Chase Distillery Marmalade Vodka is made by marinating fine English marmalade preserve with Chase Potato Vodka and infusing it with fresh Seville orange peel in a bespoke Alembic copper pot still.
Declared to be delicious by connoisseurs of fine spirits, Chase Marmalade Vodka is clear with a slight golden hue. It exudes zesty oranges aromas and has a naturally rich bitter-sweet flavour and a warm velvety mouth feel. It makes for a luxurious Breakfast Martini or is refreshing simply sipped neat over ice.
The distillery originally produced a limited edition marmalade vodka of 1000 bottles in order to commemorate the second anniversday of the launch of the original Chase Vodka.', 40, 70, 99, 45, 3);
insert into Produto values(16, 'Henneys - Dry Cider', 'path', 0.89, 'Henneys cider is fermented from a blend of 100% fresh pressed juice from carefully selected, genuine Cider Apples varieties.
Unlike some cider makers, Hennys do not use concentrated juice or supplementary fermentation sugars and no artificial flavourings or sweeteners are added.
The result is a fruity, crisp, refreshing drink enjoyable on its own or with food. Allergen advice: contains sulphites.', 6, 50, 120, 45, 4);
insert into Produto values(17, 'Bulmers - Pear Cider', 'path', 2.11, 'Bulmers Pear has a refreshingly light pear taste - crisp with plenty of fruity character.', 4.5, 56.8, 123, 1, 4);
insert into Produto values(18, 'Herrljunga - Pear Cider', 'path', 1.68, 'Herrljunga Cider Pear is a pure Swedish cider made of high quality pear wine and spring water from the well of Herrljunga.
Pale straw in colour with a crisp character of ripe pears balanced by a sweet lingering finish.', 4.5, 50, 253, 45, 4);
insert into Produto values(19, 'Jeremiah Weed - Kentucky Style Cider Brew Ginger', 'path', 2.11, 'Made with apple cider and spirit, blended with lemon, spices and a kick of root ginger.', 4, 50, 253, 12, 4);
insert into Produto values(20, 'Westons - Wyld Wood Organic Cider', 'path', 2.10, 'This cider is produced using organic cider apples and matured in old oak vats which results in an easy to drink cider with a ripe apple aroma and a refreshing well balanced taste.
Suitable for vegetarians, vegans and coeliacs.', 6.5, 50, 83, 45, 4);

insert into Comentario values(1, 2, 3, '2016-04-11', 'adoro <3');

INSERT INTO pais VALUES (1,'Australia'),(2,'Malta'),(3,'Malaysia'),(4,'Botswana'),(5,'Pitcairn Islands'),(6,'Canada'),(7,'Cambodia'),(8,'Philippines'),(9,'Serbia'),(10,'Saint Lucia');
INSERT INTO pais VALUES (11,'Latvia'),(12,'Kentucky'),(13,'Lesotho'),(14,'Tuvalu'),(15,'Thailand'),(16,'Liechtenstein'),(17,'Timor-Leste'),(18,'Svalbard and Jan Mayen Islands'),(19,'Sierra Leone'),(20,'Åland Islands');
INSERT INTO pais VALUES (21,'Laos'),(22,'Egypt'),(23,'Oman'),(24,'Zambia'),(25,'French Southern Territories'),(26,'Bangladesh'),(27,'Saint Helena, Ascension and Tristan da Cunha'),(28,'Germany'),(29,'Finland'),(30,'Serbia');
INSERT INTO pais VALUES (31,'Guyana'),(32,'Guinea-Bissau'),(33,'Germany'),(34,'Austria'),(35,'Cape Verde'),(36,'Burundi'),(37,'Indonesia'),(38,'Belarus'),(39,'Vanuatu'),(40,'Bolivia');
INSERT INTO pais VALUES (41,'Niue'),(42,'Venezuela'),(43,'Romania'),(44,'Belgium'),(45,'United Kingdom'),(46,'Solomon Islands'),(47,'Mozambique'),(48,'Åland Islands'),(49,'Luxembourg'),(50,'Lebanon');
INSERT INTO pais VALUES (51,'Sao Tome and Principe'),(52,'Oman'),(53,'Kiribati'),(54,'Suriname'),(55,'Palau'),(56,'Turks and Caicos Islands'),(57,'French Guiana'),(58,'Botswana'),(59,'Jamaica'),(60,'Mauritius');
INSERT INTO pais VALUES (61,'El Salvador'),(62,'Guatemala'),(63,'Saint Barthélemy'),(64,'Sweden'),(65,'Antarctica'),(66,'E.U.A.'),(67,'Belarus'),(68,'Korea, South'),(69,'Mali'),(70,'Egypt');
INSERT INTO pais VALUES (71,'Comoros'),(72,'Switzerland'),(73,'Saint Lucia'),(74,'Sri Lanka'),(75,'Cook Islands'),(76,'Puerto Rico'),(77,'Reunion'),(78,'Azerbaijan'),(79,'Bangladesh'),(80,'Burundi');
INSERT INTO pais VALUES (81,'Paraguay'),(82,'Burundi'),(83,'Honduras'),(84,'Bahamas'),(85,'Kazakhstan'),(86,'Marshall Islands'),(87,'Papua New Guinea'),(88,'Chad'),(89,'Martinique'),(90,'Iceland');
INSERT INTO pais VALUES (91,'Estonia'),(92,'Guadeloupe'),(93,'Estonia'),(94,'Poland'),(95,'Hungary'),(96,'Libya'),(97,'Greek'),(98,'Italy'),(99,'Peru'),(100,'Turkey');


