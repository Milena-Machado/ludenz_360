
/*
ACABAMENTO
JOGO
EDICAO
CARTA
VENDA
ITEM_VENDA
ENDEREÇO
CLIENTE
USUARIO
FORMA_PAGAMENTO
*/

SET DATESTYLE TO POSTGRES, DMY;

DROP TABLE IF EXISTS jogo CASCADE;
DROP TABLE IF EXISTS acabamento CASCADE;
DROP TABLE IF EXISTS edicao CASCADE;
DROP TABLE IF EXISTS raridade CASCADE;
DROP TABLE IF EXISTS carta CASCADE;
DROP TABLE IF EXISTS carta_para_venda CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS endereco CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS forma_pagamento CASCADE;
DROP TABLE IF EXISTS venda CASCADE;
DROP TABLE IF EXISTS item_venda CASCADE;



CREATE TABLE jogo(
	id_jogo SERIAL PRIMARY KEY,
	nome_jogo VARCHAR(50) NOT NULL
);

CREATE TABLE acabamento (
	id_acab SERIAL PRIMARY KEY,
	tipo_acab VARCHAR(50) NOT NULL,
	id_jogo INTEGER REFERENCES jogo (id_jogo) ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE edicao (
	id_edicao SERIAL PRIMARY KEY,
	nome_edicao VARCHAR(100) NOT NULL,
	sigla_edicao VARCHAR(10) NOT NULL,
	numero_edicao INTEGER NOT NULL,
	id_jogo INTEGER REFERENCES jogo (id_jogo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE raridade (
	id_raridade SERIAL PRIMARY KEY,
	id_jogo INTEGER REFERENCES jogo (id_jogo) ON UPDATE CASCADE ON DELETE RESTRICT,
	sigla VARCHAR(50) NOT NULL,
	nome_exibicao VARCHAR(100)
);

CREATE TABLE carta(
	id_carta SERIAL PRIMARY KEY,
	nome_carta VARCHAR(100) NOT NULL,
	numeracao_carta VARCHAR(10) NOT NULL,
	url_imagem_carta VARCHAR(255) NULL,
	preco_mercado NUMERIC (10,2) ,
	id_edicao INTEGER REFERENCES edicao(id_edicao) ON UPDATE CASCADE ON DELETE RESTRICT,
	id_acab INTEGER REFERENCES acabamento(id_acab) ON UPDATE CASCADE ON DELETE RESTRICT,
	id_raridade INTEGER REFERENCES raridade(id_raridade) ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE carta_para_venda (
	id_carta_venda SERIAL PRIMARY KEY,
	id_carta INTEGER REFERENCES carta(id_carta),
	idioma CHAR(3) NOT NULL CHECK (idioma IN ('PT','EN','JP')),
	condicao VARCHAR (20) NOT NULL CHECK (condicao IN ('M', 'NM', 'SP', 'MP', 'HP', 'DMG')),
	estoque INTEGER NOT NULL CHECK (estoque >= 0),
	preco_negocio NUMERIC  (10,2),
	custo_carta NUMERIC (10,2)
);

CREATE TABLE usuario(
	id_usuario INTEGER PRIMARY KEY,
	nome_usuario VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL,
	senha VARCHAR(255) NOT NULL,
	status BOOLEAN NOT NULL,
	cargo VARCHAR(30) NOT NULL CHECK (cargo IN ('Admin', 'Gerente', 'Vendedor', 'Estoquista'))
);


CREATE TABLE cliente(
	id_cliente SERIAL PRIMARY KEY,
	nome_completo VARCHAR (100) NOT NULL,
	cpf VARCHAR(11) UNIQUE NOT NULL,
	telefone VARCHAR(20) NOT NULL,
	email VARCHAR(150) NOT NULL,
	data_nascimento DATE NOT NULL,
	genero CHAR(1) NOT NULL CHECK (genero IN ('F','M')),
	data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE endereco(
	id_endereco SERIAL PRIMARY KEY,
	cep VARCHAR(9) NOT NULL,
	lagradouro VARCHAR(100) NOT NULL,
	numero VARCHAR(20) NOT NULL,
	bairro VARCHAR(40) NOT NULL,
	cidade VARCHAR(30) NOT NULL,
	estado CHAR(2) NOT NULL,
	id_cliente INTEGER REFERENCES cliente(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT
);



CREATE TABLE forma_pagamento(
	id_forma_pagamento INTEGER PRIMARY KEY,
	forma_de_pagamento VARCHAR(30) NOT NULL
);

CREATE TABLE venda(
	id_venda SERIAL PRIMARY KEY,
	data_hora TIMESTAMP NOT NULL,
	valor_total NUMERIC(10,2) NOT NULL CHECK (valor_total >= 0),
	id_usuario INTEGER REFERENCES usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
	id_cliente INTEGER REFERENCES cliente(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT,
	id_forma_pagamento INTEGER REFERENCES forma_pagamento(id_forma_pagamento) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE item_venda(
	id_item_venda SERIAL PRIMARY KEY,
	quantidade NUMERIC (3) NOT NULL CHECK (quantidade > 0),
	preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
	subtotal NUMERIC(10,2) NOT NULL CHECK (subtotal >= 0),
	id_carta_venda INTEGER REFERENCES carta_para_venda(id_carta_venda) ON UPDATE CASCADE ON DELETE RESTRICT,
	id_venda INTEGER REFERENCES venda(id_venda) ON UPDATE CASCADE ON DELETE RESTRICT
);





--POPULANDOOOO JOGOO
INSERT INTO jogo (nome_jogo) VALUES 
	('Magic'),
	('One Piece'),
	('Pokemon')
;

--POPULANDO ACABAMENTOO
INSERT INTO acabamento(tipo_acab, id_jogo) VALUES 
	('Normal', 1),
	('Foil', 1),
	('Normal', 2),
	('Foil', 2),
	('Normal', 3),
	('Holofoil', 3),
	('Reverse Holofoil', 3)
	
;

--POPULANDO EDICAOOO
INSERT INTO edicao (nome_edicao, sigla_edicao, numero_edicao,id_jogo) VALUES 
	('Beta Edition', 'LEB', 17,1),
	('Universes Beyond: The Lord of the Rings', 'LTR', 23019,1),
	('Modern Horizons 3','MH3',23444,1),
	('Awakening of the New Era','OP05',23213,2),
	('Romance Dawn','OP01',3188,2),
	('Pillars of Strength','OP03',22890,2),
	('SV: Scarlet & Violet 151','MEW',23237,3),
	('XY - Evolutions','EVO',1842,3),
	('ME: 30th Celebration','30C',24722,3)
;

--POPULANDO RARIDADEEE
INSERT INTO raridade (id_jogo, sigla, nome_exibicao) VALUES
	(1, 'C', 'Common'),
	(1, 'U', 'Uncommon'),
	(1, 'R', 'Rare '),
	(1, 'M', 'Mythic Rare'),
	(1, 'L', 'Land'),
	(1, 'S', 'Special'),
	(1, 'T', 'Token'),
	(1, 'P', 'Promo'),
	(2,'C', 'Common'),
    (2,'UC', 'Uncommon'),
    (2,'R', 'Rare'),
    (2,'SR', 'Super Rare'),
    (2,'SEC', 'Secret Rare'),
    (2,'L', 'Leader'),
    (2,'SP', 'Special Rare'),
    (2,'TR', 'Treasure Rare'),
    (2,'P', 'Promo'),
	(2,'DON!!','DONN!!'),
	(3,'●', 'Common'),
    (3,'◆', 'Uncommon'),
    (3,'★', 'Rare'),
    (3,'★★', 'Double Rare'),
    (3,'★★ Silver', 'Ultra Rare'),
    (3,'1 ★ Gold', 'Illustration Rare'),
    (3,'2 ★ Gold', 'Special Illustration Rare'),
    (3,'3 ★ Gold', 'Hyper Rare'),
    (3,'★ PROMO', 'Promo'),
    (3,'Pink Star', 'ACE SPEC Rare'),
	(3,'★H','Holo Rare'),
	(3,'★ BREAK','Rare BREAK'),
	(3,'★ Secret','Secret Rare'),
	(3,'FR','Futuristic Rare'),
	(3, 'PR', 'Pikachu Rare'),
	(3, 'RGB', 'RBG Rare')
;

--POPULANDO CARTA COM CODIGOO

COPY carta (id_carta,
    nome_carta,
    numeracao_carta,
    url_imagem_carta,
    preco_mercado,
    id_edicao,
    id_acab,
    id_raridade)
	
FROM 'D:\Fatec Big Data\1 Semestre\projeto integrador\BD LUDENZ\CARTAS GERAIS\carta.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8',
    NULL 'NULL'
);


--POPULANDO ESTOQUEEE COM CODIGO

COPY carta_para_venda (id_carta,
    idioma,
    condicao,
  	estoque,
    preco_negocio,
	custo_carta)
	
FROM 'D:\Fatec Big Data\1 Semestre\projeto integrador\BD LUDENZ\CARTAS GERAIS\estoque_tcg_completo.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8',
    NULL 'NULL'
);




--POPULANDO USUARIOO
INSERT INTO usuario (id_usuario, nome_usuario, email, senha, status, cargo) VALUES
	(1, 'Mateus', 'mateus@ludenz360.com.br', 'admin123', true, 'Admin'),
	(2, 'Luiz', 'luiz@ludenz360.com.br', 'admin123', true, 'Admin')
;



--POPULANDO CLIENTEEEE
INSERT INTO cliente (nome_completo, cpf, telefone, email, data_nascimento, genero, data_cadastro) VALUES
	('Cliente Balcão', '00000000000', '00000000000', 'balcao@ludenz360.com.br', '1900-01-01', 'M', CURRENT_TIMESTAMP),
	('Rafael Ferreira Pereira', '05694734214', '11998037004', 'rafael.ferreira.pereira@exemplo.com', '1984-08-05', 'M', '2026-04-29 20:20:00'),
	('Gabriel Alves Souza', '04266382720', '11978551106', 'gabriel.alves.souza@exemplo.com', '1996-10-25', 'M', '2025-08-10 16:06:00'),
	('Ana Ferreira Ferreira', '05101016736', '11987843725', 'ana.ferreira.ferreira@exemplo.com', '1998-05-11', 'F', '2026-06-07 12:55:00'),
	('Rafael Silva Santos', '05574866646', '11939294290', 'rafael.silva.santos@exemplo.com', '2000-07-20', 'M', '2026-04-03 10:05:00'),
	('Pedro Ferreira Alves', '05630280922', '11928389591', 'pedro.ferreira.alves@exemplo.com', '1990-04-26', 'M', '2025-09-08 09:17:00'),
	('Mateus Silva Alves', '84582265539', '11957216661', 'mateus.silva.alves@exemplo.com', '2006-06-14', 'M', '2026-01-09 14:25:00'),
	('João Lima Santos', '26110826856', '11944233089', 'joao.lima.santos@exemplo.com', '1996-07-24', 'M', '2026-07-13 16:20:00'),
	('Camila Rodrigues Souza', '82972538405', '11943491551', 'camila.rodrigues.souza@exemplo.com', '1996-11-12', 'F', '2026-09-26 08:00:00'),
	('Aline Rodrigues Gomes', '94860861064', '11995262188', 'aline.rodrigues.gomes@exemplo.com', '1982-08-02', 'F', '2026-04-26 19:26:00'),
	('Pedro Silva Souza', '36597619771', '11932441619', 'pedro.silva.souza@exemplo.com', '1984-06-28', 'M', '2026-06-13 19:50:00'),
	('Luiz Gomes Lima', '93995411067', '11924955511', 'luiz.gomes.lima@exemplo.com', '1994-01-27', 'M', '2025-05-18 19:03:00'),
	('Pedro Lima Silva', '92273518979', '11964481531', 'pedro.lima.silva@exemplo.com', '1986-10-09', 'M', '2025-11-09 14:57:00'),
	('Felipe Souza Souza', '45441209303', '11953251548', 'felipe.souza.souza@exemplo.com', '1992-10-29', 'M', '2025-05-12 12:37:00'),
	('Aline Gomes Rodrigues', '80606380900', '11910427224', 'aline.gomes.rodrigues@exemplo.com', '1981-08-17', 'F', '2026-05-16 14:53:00'),
	('Carlos Alves Pereira', '29762375494', '11996101766', 'carlos.alves.pereira@exemplo.com', '1978-06-01', 'M', '2026-06-28 09:45:00'),
	('Felipe Rodrigues Pereira', '66192140170', '11998682003', 'felipe.rodrigues.pereira@exemplo.com', '2006-05-14', 'M', '2026-04-10 12:52:00'),
	('Mariana Oliveira Santos', '52795744163', '11926901208', 'mariana.oliveira.santos@exemplo.com', '1983-08-21', 'F', '2025-09-19 19:10:00'),
	('Rafael Rodrigues Lima', '58957015811', '11991895997', 'rafael.rodrigues.lima@exemplo.com', '1984-04-01', 'M', '2025-05-24 10:10:00'),
	('Mariana Pereira Silva', '18026031281', '11977085031', 'mariana.pereira.silva@exemplo.com', '2004-08-16', 'F', '2025-07-23 13:09:00'),
	('Beatriz Alves Ferreira', '23954761935', '11939595109', 'beatriz.alves.ferreira@exemplo.com', '1985-07-01', 'F', '2026-04-02 15:59:00'),
	('Carlos Santos Santos', '46880115496', '11923413900', 'carlos.santos.santos@exemplo.com', '1985-03-10', 'M', '2026-07-24 18:52:00'),
	('Ana Oliveira Silva', '39576856230', '11986164865', 'ana.oliveira.silva@exemplo.com', '1989-11-17', 'F', '2026-03-28 13:04:00'),
	('Aline Ferreira Silva', '63003300832', '11945643855', 'aline.ferreira.silva@exemplo.com', '2000-01-26', 'F', '2025-07-27 10:33:00'),
	('Camila Gomes Santos', '81601432574', '11993339485', 'camila.gomes.santos@exemplo.com', '1986-02-21', 'F', '2026-03-21 08:01:00'),
	('Beatriz Souza Souza', '77063323720', '11910985708', 'beatriz.souza.souza@exemplo.com', '2004-05-15', 'F', '2026-08-17 14:05:00'),
	('Lucas Martins Costa', '12345678901', '11988776655', 'lucas.martins.costa@exemplo.com', '1992-03-15', 'M', '2026-01-15 10:30:00'),
	('Juliana Almeida Ramos', '98765432100', '11977665544', 'juliana.almeida.ramos@exemplo.com', '1988-11-22', 'F', '2025-11-20 14:45:00'),
	('Marcos Vinicius Dias', '45612378933', '11966554433', 'marcos.vinicius.dias@exemplo.com', '1995-07-08', 'M', '2026-02-10 09:15:00'),
	('Fernanda Lima Mendes', '32165498711', '11955443322', 'fernanda.lima.mendes@exemplo.com', '1990-09-30', 'F', '2026-03-05 16:20:00'),
	('Thiago Ribeiro Silva', '15975345688', '11944332211', 'thiago.ribeiro.silva@exemplo.com', '1982-12-12', 'M', '2025-08-22 11:10:00'),
	('Larissa Castro Nogueira', '75315945622', '11933221100', 'larissa.castro.nogueira@exemplo.com', '1999-04-18', 'F', '2026-05-18 13:40:00'),
	('Roberto Carvalho Sousa', '85296374155', '11922110099', 'roberto.carvalho.sousa@exemplo.com', '1975-01-25', 'M', '2025-10-12 10:05:00'),
	('Patricia Gomes Rocha', '96385274177', '11911009988', 'patricia.gomes.rocha@exemplo.com', '1986-06-14', 'F', '2026-07-07 15:55:00'),
	('Diego Barbosa Lima', '14725836900', '11900998877', 'diego.barbosa.lima@exemplo.com', '2001-02-28', 'M', '2026-08-01 08:30:00'),
	('Carolina Martins Pinto', '25836914722', '11988775544', 'carolina.martins.pinto@exemplo.com', '1993-08-19', 'F', '2025-06-30 17:25:00'),
	('André Luiz Correia', '36914725844', '11977664433', 'andre.luiz.correia@exemplo.com', '1980-05-05', 'M', '2026-09-15 12:15:00'),
	('Vanessa Monteiro Castro', '47852963155', '11966553322', 'vanessa.monteiro.castro@exemplo.com', '1997-10-10', 'F', '2026-04-20 09:50:00'),
	('Eduardo Silva Freitas', '58963214766', '11955442211', 'eduardo.silva.freitas@exemplo.com', '1989-12-03', 'M', '2025-12-05 14:00:00'),
	('Amanda Nogueira Mendes', '69874125888', '11944331100', 'amanda.nogueira.mendes@exemplo.com', '2003-03-25', 'F', '2026-02-18 11:45:00'),
	('Marcelo Cunha Alves', '74185296399', '11933220099', 'marcelo.cunha.alves@exemplo.com', '1978-09-17', 'M', '2026-01-22 16:10:00'),
	('Tiago Lopes Martins', '78912345600', '11911223344', 'tiago.lopes.martins@exemplo.com', '1987-05-12', 'M', '2026-03-10 10:15:00'),
	('Paula Ribeiro Dias', '65478912311', '11922334455', 'paula.ribeiro.dias@exemplo.com', '1991-08-25', 'F', '2025-07-14 14:22:00'),
	('Igor Castro Silva', '32198765422', '11933445566', 'igor.castro.silva@exemplo.com', '1995-12-02', 'M', '2026-02-18 09:30:00'),
	('Fernanda Costa Alves', '14785236933', '11944556677', 'fernanda.costa.alves@exemplo.com', '1989-01-30', 'F', '2025-11-05 16:45:00'),
	('Rodrigo Nogueira Souza', '25896314744', '11955667788', 'rodrigo.nogueira.souza@exemplo.com', '1984-04-18', 'M', '2026-06-21 11:10:00'),
	('Camila Mendes Rocha', '36925814755', '11966778899', 'camila.mendes.rocha@exemplo.com', '1998-07-22', 'F', '2026-01-11 13:55:00'),
	('Victor Hugo Lima', '74125896366', '11977889900', 'victor.hugo.lima@exemplo.com', '2001-09-14', 'M', '2025-10-09 10:40:00'),
	('Letícia Barbosa Pinto', '85236974177', '11988990011', 'leticia.barbosa.pinto@exemplo.com', '1993-11-05', 'F', '2026-04-15 15:20:00'),
	('Marcelo Carvalho Gomes', '96314785288', '11999001122', 'marcelo.carvalho.gomes@exemplo.com', '1979-02-28', 'M', '2025-08-30 08:15:00'),
	('Renata Fernandes Cunha', '15926348799', '11900112233', 'renata.fernandes.cunha@exemplo.com', '1986-06-19', 'F', '2026-05-12 17:05:00'),
	('Bruno Almeida Freitas', '75395148600', '11911224455', 'bruno.almeida.freitas@exemplo.com', '1990-10-10', 'M', '2026-03-25 12:45:00'),
	('Tatiana Silva Correia', '95175384611', '11922335566', 'tatiana.silva.correia@exemplo.com', '1982-12-07', 'F', '2025-09-02 09:10:00'),
	('Leandro Monteiro Castro', '35715926822', '11933446677', 'leandro.monteiro.castro@exemplo.com', '1977-03-15', 'M', '2026-02-08 14:30:00'),
	('Sofia Lima Nogueira', '15326487933', '11944557788', 'sofia.lima.nogueira@exemplo.com', '2004-05-24', 'F', '2026-07-19 16:50:00'),
	('Caio Rodrigues Moura', '48625973144', '11955668899', 'caio.rodrigues.moura@exemplo.com', '1997-08-11', 'M', '2025-12-14 11:25:00'),
	('Priscila Alves Cardoso', '29475186355', '11966779900', 'priscila.alves.cardoso@exemplo.com', '1992-01-08', 'F', '2026-01-28 13:15:00'),
	('Fábio Souza Teixeira', '38192647566', '11977880011', 'fabio.souza.teixeira@exemplo.com', '1985-04-20', 'M', '2026-06-05 10:05:00'),
	('Daniela Castro Ribeiro', '83719462577', '11988991122', 'daniela.castro.ribeiro@exemplo.com', '1994-09-30', 'F', '2025-11-22 15:40:00'),
	('Ricardo Gomes Martins', '72538194688', '11999002233', 'ricardo.gomes.martins@exemplo.com', '1981-11-14', 'M', '2026-04-02 08:50:00'),
	('Elaine Barbosa Dias', '61427583999', '11900113344', 'elaine.barbosa.dias@exemplo.com', '1988-02-17', 'F', '2025-07-09 12:20:00'),
	('Guilherme Pinto Silva', '59384712600', '11911225566', 'guilherme.pinto.silva@exemplo.com', '1999-06-25', 'M', '2026-02-27 14:10:00'),
	('Natália Carvalho Alves', '48273659111', '11922336677', 'natalia.carvalho.alves@exemplo.com', '1996-12-12', 'F', '2026-08-14 16:35:00'),
	('Henrique Cunha Ferreira', '37162548022', '11933447788', 'henrique.cunha.ferreira@exemplo.com', '1991-03-05', 'M', '2025-10-18 09:45:00'),
	('Luana Fernandes Costa', '26051437933', '11944558899', 'luana.fernandes.costa@exemplo.com', '2000-07-08', 'F', '2026-05-20 11:55:00'),
	('Matheus Correia Santos', '15940326844', '11955669900', 'matheus.correia.santos@exemplo.com', '1993-10-22', 'M', '2026-01-05 13:25:00'),
	('Isabela Nogueira Mendes', '04839215755', '11966770011', 'isabela.nogueira.mendes@exemplo.com', '1989-01-15', 'F', '2025-12-25 15:15:00'),
	('Thiago Freitas Lima', '93728104666', '11977881122', 'thiago.freitas.lima@exemplo.com', '1983-05-28', 'M', '2026-03-12 10:30:00'),
	('Mônica Moura Rocha', '82617093577', '11988992233', 'monica.moura.rocha@exemplo.com', '1995-08-04', 'F', '2026-07-03 14:40:00'),
	('Roberto Cardoso Pinto', '71506982488', '11999003344', 'roberto.cardoso.pinto@exemplo.com', '1976-11-19', 'M', '2025-09-10 08:20:00'),
	('Cláudia Teixeira Barbosa', '60495871399', '11900114455', 'claudia.teixeira.barbosa@exemplo.com', '1987-02-11', 'F', '2026-06-18 16:10:00'),
	('Alexandre Ribeiro Cunha', '59384762000', '11911226677', 'alexandre.ribeiro.cunha@exemplo.com', '1990-06-30', 'M', '2026-04-22 12:00:00'),
	('Sara Martins Fernandes', '48273651911', '11922337788', 'sara.martins.fernandes@exemplo.com', '1998-09-14', 'F', '2025-11-29 09:55:00'),
	('Vinícius Alves Correia', '37162540822', '11933448899', 'vinicius.alves.correia@exemplo.com', '2002-12-07', 'M', '2026-02-15 14:05:00'),
	('Jéssica Dias Nogueira', '26051439733', '11944559900', 'jessica.dias.nogueira@exemplo.com', '1994-04-21', 'F', '2026-08-08 11:35:00'),
	('Douglas Silva Freitas', '15940328644', '11955660011', 'douglas.silva.freitas@exemplo.com', '1985-07-16', 'M', '2025-08-19 13:45:00'),
	('Carolina Souza Moura', '04839217555', '11966771122', 'carolina.souza.moura@exemplo.com', '1991-10-09', 'F', '2026-01-30 15:25:00'),
	('Sérgio Lima Cardoso', '93728106466', '11977882233', 'sergio.lima.cardoso@exemplo.com', '1979-01-02', 'M', '2026-05-04 10:15:00'),
	('Flávia Rocha Teixeira', '82617095377', '11988993344', 'flavia.rocha.teixeira@exemplo.com', '1988-03-27', 'F', '2025-12-11 16:50:00'),
	('Eduardo Pinto Castro', '71506984288', '11999004455', 'eduardo.pinto.castro@exemplo.com', '1996-06-18', 'M', '2026-03-23 09:05:00'),
	('Bianca Barbosa Gomes', '60495873199', '11900115566', 'bianca.barbosa.gomes@exemplo.com', '1999-09-05', 'F', '2026-07-28 14:10:00'),
	('Leonardo Cunha Martins', '59384762010', '11911227788', 'leonardo.cunha.martins@exemplo.com', '1982-11-23', 'M', '2025-10-06 11:20:00'),
	('Gisele Fernandes Ribeiro', '48273651921', '11922338899', 'gisele.fernandes.ribeiro@exemplo.com', '1993-02-14', 'F', '2026-06-09 15:30:00'),
	('Rafael Correia Alves', '37162540832', '11933449900', 'rafael.correia.alves@exemplo.com', '1986-05-08', 'M', '2026-01-14 08:45:00'),
	('Marina Nogueira Dias', '26051439743', '11944550011', 'marina.nogueira.dias@exemplo.com', '1997-08-01', 'F', '2025-07-25 12:55:00'),
	('Otávio Freitas Silva', '15940328654', '11955661122', 'otavio.freitas.silva@exemplo.com', '1990-12-19', 'M', '2026-04-18 10:00:00'),
	('Aline Moura Souza', '04839217565', '11966772233', 'aline.moura.souza@exemplo.com', '2001-03-11', 'F', '2026-08-22 14:25:00'),
	('Celso Cardoso Lima', '93728106476', '11977883344', 'celso.cardoso.lima@exemplo.com', '1975-07-29', 'M', '2025-11-03 16:40:00'),
	('Lorena Teixeira Rocha', '82617095387', '11988994455', 'lorena.teixeira.rocha@exemplo.com', '1984-10-06', 'F', '2026-02-06 09:15:00'),
	('Wesley Castro Pinto', '71506984298', '11999005566', 'wesley.castro.pinto@exemplo.com', '1995-01-24', 'M', '2026-05-29 11:35:00'),
	('Bárbara Gomes Barbosa', '60495873109', '11900116677', 'barbara.gomes.barbosa@exemplo.com', '1992-04-16', 'F', '2025-09-17 13:50:00'),
	('Thiago Costa Martins', '88029399291', '11925490896', 'thiago.costa.martins@exemplo.com', '1987-11-02', 'M', '2026-12-11 20:25:00'),
	('Letícia Souza Almeida', '76511649778', '11951178565', 'leticia.souza.almeida@exemplo.com', '1996-10-12', 'F', '2026-10-19 19:54:00'),
	('Rodrigo Lima Carvalho', '21575911914', '11918466580', 'rodrigo.lima.carvalho@exemplo.com', '2005-12-03', 'M', '2025-03-12 15:14:00'),
	('Amanda Ribeiro Pinto', '23688281290', '11984719805', 'amanda.ribeiro.pinto@exemplo.com', '1997-07-16', 'F', '2025-04-24 09:09:00'),
	('Gabriel Fernandes Cunha', '37991188264', '11940884070', 'gabriel.fernandes.cunha@exemplo.com', '1995-12-20', 'M', '2025-08-15 19:15:00'),
	('Carolina Moura Rocha', '74544172352', '11972443805', 'carolina.moura.rocha@exemplo.com', '1980-11-04', 'F', '2025-01-21 11:17:00'),
	('Lucas Cardoso Mendes', '10897576843', '11960350572', 'lucas.cardoso.mendes@exemplo.com', '1991-03-19', 'M', '2025-11-09 11:38:00'),
	('Juliana Freitas Silva', '83155528955', '11917137021', 'juliana.freitas.silva@exemplo.com', '1988-08-21', 'F', '2026-10-30 16:00:00'),
	('Marcos Barbosa Teixeira', '38221487650', '11928066325', 'marcos.barbosa.teixeira@exemplo.com', '1986-02-07', 'M', '2026-03-30 09:57:00'),
	('Fernanda Gomes Nogueira', '22012230529', '11975571072', 'fernanda.gomes.nogueira@exemplo.com', '1991-07-31', 'F', '2026-07-29 19:40:00'),
	('Rafael Alves Dias', '71901511949', '11931213246', 'rafael.alves.dias@exemplo.com', '1983-12-12', 'M', '2025-11-07 15:05:00'),
	('Camila Correia Santos', '40836220420', '11955370568', 'camila.correia.santos@exemplo.com', '1994-07-01', 'F', '2025-01-29 09:13:00'),
	('Felipe Nogueira Lima', '61106788396', '11987216564', 'felipe.nogueira.lima@exemplo.com', '2000-01-26', 'M', '2025-05-29 20:02:00'),
	('Aline Castro Souza', '62280002353', '11931483154', 'aline.castro.souza@exemplo.com', '1985-03-20', 'F', '2026-08-22 08:30:00'),
	('Pedro Martins Oliveira', '55511504929', '11931033906', 'pedro.martins.oliveira@exemplo.com', '1996-10-30', 'M', '2025-05-31 09:13:00'),
	('Mariana Cunha Ribeiro', '93643934253', '11957774525', 'mariana.cunha.ribeiro@exemplo.com', '1988-04-29', 'F', '2026-09-13 11:30:00'),
	('Luiz Pinto Fernandes', '17512252132', '11986796933', 'luiz.pinto.fernandes@exemplo.com', '1976-07-21', 'M', '2026-04-15 18:19:00'),
	('Beatriz Rocha Moura', '96082169143', '11961636578', 'beatriz.rocha.moura@exemplo.com', '2004-10-26', 'F', '2025-05-07 16:20:00'),
	('Carlos Mendes Cardoso', '25093221788', '11993518423', 'carlos.mendes.cardoso@exemplo.com', '1994-01-20', 'M', '2025-02-22 13:41:00'),
	('Ana Silva Freitas', '95025420538', '11998931975', 'ana.silva.freitas@exemplo.com', '1989-02-19', 'F', '2026-09-11 17:59:00'),
	('Mateus Teixeira Barbosa', '95553328772', '11926107287', 'mateus.teixeira.barbosa@exemplo.com', '1975-03-15', 'M', '2026-05-12 17:52:00'),
	('João Nogueira Gomes', '55066859896', '11988016769', 'joao.nogueira.gomes@exemplo.com', '1978-07-03', 'M', '2025-09-01 09:22:00'),
	('Aline Dias Alves', '16733816184', '11936238400', 'aline.dias.alves@exemplo.com', '1978-03-08', 'F', '2026-11-05 13:41:00'),
	('Pedro Santos Correia', '49815317490', '11952816895', 'pedro.santos.correia@exemplo.com', '1997-08-22', 'M', '2025-09-02 18:10:00'),
	('Luiz Lima Nogueira', '92683288916', '11922196154', 'luiz.lima.nogueira@exemplo.com', '1996-10-06', 'M', '2026-03-27 18:55:00'),
	('Pedro Souza Castro', '73470823830', '11996261699', 'pedro.souza.castro@exemplo.com', '2002-07-03', 'M', '2025-04-26 13:18:00'),
	('Felipe Oliveira Martins', '19732006875', '11997708051', 'felipe.oliveira.martins@exemplo.com', '1979-06-13', 'M', '2026-04-18 17:12:00');



--POPULANDO ENDEREÇOOO
INSERT INTO endereco (cep, lagradouro, numero, bairro, cidade, estado, id_cliente) VALUES
	('02022-810', 'Avenida Braz Leme', '2142', 'Santana', 'São Paulo', 'SP', 1),
	('04702-606', 'Avenida Santo Amaro', '2163 Apto 49', 'Santo Amaro', 'São Paulo', 'SP', 2),
	('04010-835', 'Rua Domingos de Morais', '1568 Apto 20', 'Vila Mariana', 'São Paulo', 'SP', 3),
	('04101-882', 'Rua Vergueiro', '666 Apto 86', 'Vila Mariana', 'São Paulo', 'SP', 4),
	('04260-088', 'Avenida Doutor Ricardo Jafet', '654', 'Ipiranga', 'São Paulo', 'SP', 5),
	('04010-041', 'Rua Domingos de Morais', '1149 Casa 47', 'Vila Mariana', 'São Paulo', 'SP', 6),
	('04101-989', 'Rua Vergueiro', '1441 Casa 15', 'Vila Mariana', 'São Paulo', 'SP', 7),
	('04015-033', 'Rua Joaquim Távora', '1670 Casa 44', 'Vila Mariana', 'São Paulo', 'SP', 8),
	('04021-678', 'Rua Sena Madureira', '1737 Casa 12', 'Vila Clementino', 'São Paulo', 'SP', 9),
	('04021-209', 'Rua Sena Madureira', '2247', 'Vila Clementino', 'São Paulo', 'SP', 10),
	('04021-495', 'Rua Sena Madureira', '805', 'Vila Clementino', 'São Paulo', 'SP', 11),
	('04021-154', 'Rua Sena Madureira', '1607 Apto 46', 'Vila Clementino', 'São Paulo', 'SP', 12),
	('04015-864', 'Rua Joaquim Távora', '1567 Casa 85', 'Vila Mariana', 'São Paulo', 'SP', 13),
	('04101-883', 'Rua Vergueiro', '2058', 'Vila Mariana', 'São Paulo', 'SP', 14),
	('04010-526', 'Rua Domingos de Morais', '411', 'Vila Mariana', 'São Paulo', 'SP', 15),
	('04260-152', 'Avenida Doutor Ricardo Jafet', '1686 Casa 118', 'Ipiranga', 'São Paulo', 'SP', 16),
	('03081-692', 'Rua Tuiuti', '656 Casa 66', 'Tatuapé', 'São Paulo', 'SP', 17),
	('04015-577', 'Rua Joaquim Távora', '2164 Casa 117', 'Vila Mariana', 'São Paulo', 'SP', 18),
	('04260-186', 'Avenida Doutor Ricardo Jafet', '513', 'Ipiranga', 'São Paulo', 'SP', 19),
	('05406-187', 'Rua Teodoro Sampaio', '1856', 'Pinheiros', 'São Paulo', 'SP', 20),
	('04702-057', 'Avenida Santo Amaro', '928 Casa 2', 'Santo Amaro', 'São Paulo', 'SP', 21),
	('03081-317', 'Rua Tuiuti', '540', 'Tatuapé', 'São Paulo', 'SP', 22),
	('04015-243', 'Rua Joaquim Távora', '1376 Apto 22', 'Vila Mariana', 'São Paulo', 'SP', 23),
	('04260-049', 'Avenida Doutor Ricardo Jafet', '512 Casa 55', 'Ipiranga', 'São Paulo', 'SP', 24),
	('05406-506', 'Rua Teodoro Sampaio', '1028 Casa 115', 'Pinheiros', 'São Paulo', 'SP', 25),
	('01310-100', 'Avenida Paulista', '1578 Apto 101', 'Bela Vista', 'São Paulo', 'SP', 27),
	('05001-000', 'Rua Cardoso de Almeida', '920', 'Perdizes', 'São Paulo', 'SP', 28),
	('03126-000', 'Rua da Mooca', '2500 Casa 3', 'Mooca', 'São Paulo', 'SP', 29),
	('04538-133', 'Avenida Brigadeiro Faria Lima', '3477 Apto 44', 'Itaim Bibi', 'São Paulo', 'SP', 30),
	('01414-001', 'Rua Haddock Lobo', '1327 Apto 42', 'Cerqueira César', 'São Paulo', 'SP', 31),
	('02033-020', 'Avenida General Ataliba Leonel', '1205', 'Santana', 'São Paulo', 'SP', 32),
	('05422-001', 'Rua dos Pinheiros', '458 Casa 2', 'Pinheiros', 'São Paulo', 'SP', 33),
	('04085-000', 'Avenida dos Bandeirantes', '3000', 'Indianópolis', 'São Paulo', 'SP', 34),
	('01228-200', 'Avenida Angélica', '2016 Apto 71', 'Consolação', 'São Paulo', 'SP', 35),
	('03318-000', 'Rua Itapura', '1200', 'Tatuapé', 'São Paulo', 'SP', 36),
	('04543-011', 'Avenida Presidente Juscelino Kubitschek', '1400 Apto 95', 'Vila Nova Conceição', 'São Paulo', 'SP', 37),
	('01506-000', 'Rua da Glória', '344 Casa 1', 'Liberdade', 'São Paulo', 'SP', 38),
	('05010-000', 'Rua Turiaçu', '800', 'Perdizes', 'São Paulo', 'SP', 39),
	('04111-001', 'Rua Domingos de Morais', '2564 Apto 33', 'Vila Mariana', 'São Paulo', 'SP', 40),
	('02011-200', 'Avenida Cruzeiro do Sul', '3200 Casa 5', 'Santana', 'São Paulo', 'SP', 41),
	('04515-001', 'Avenida Rouxinol', '120', 'Moema', 'São Paulo', 'SP', 42),
	('05036-040', 'Rua Guaicurus', '854', 'Lapa', 'São Paulo', 'SP', 43),
	('04138-001', 'Rua Bosque da Saúde', '345 Apto 12', 'Saúde', 'São Paulo', 'SP', 44),
	('03611-000', 'Avenida Amador Bueno da Veiga', '1800 Casa 4', 'Penha', 'São Paulo', 'SP', 45),
	('04266-000', 'Rua Bom Pastor', '985 Apto 88', 'Ipiranga', 'São Paulo', 'SP', 46),
	('03318-010', 'Rua Apucarana', '1520', 'Tatuapé', 'São Paulo', 'SP', 47),
	('05416-001', 'Rua Fradique Coutinho', '633 Apto 54', 'Pinheiros', 'São Paulo', 'SP', 48),
	('05508-000', 'Avenida Vital Brasil', '1100', 'Butantã', 'São Paulo', 'SP', 49),
	('04313-000', 'Avenida Engenheiro George Corbisier', '875 Casa 2', 'Jabaquara', 'São Paulo', 'SP', 50),
	('03134-001', 'Avenida Professor Luiz Ignácio Anhaia Mello', '2500', 'Vila Prudente', 'São Paulo', 'SP', 51),
	('04711-130', 'Rua Américo Brasiliense', '1780 Apto 90', 'Santo Amaro', 'São Paulo', 'SP', 52),
	('04534-001', 'Rua Joaquim Floriano', '820', 'Itaim Bibi', 'São Paulo', 'SP', 53),
	('01302-000', 'Rua Augusta', '2500 Apto 101', 'Cerqueira César', 'São Paulo', 'SP', 54),
	('01224-001', 'Avenida Higienópolis', '768', 'Higienópolis', 'São Paulo', 'SP', 55),
	('05001-100', 'Avenida Francisco Matarazzo', '1500 Casa 10', 'Água Branca', 'São Paulo', 'SP', 56),
	('02011-000', 'Rua Voluntários da Pátria', '2211', 'Santana', 'São Paulo', 'SP', 57),
	('03166-000', 'Rua Fernando Falcão', '101 Apto 33', 'Mooca', 'São Paulo', 'SP', 58),
	('04012-001', 'Rua Eça de Queiroz', '555', 'Vila Mariana', 'São Paulo', 'SP', 59),
	('01502-000', 'Avenida Liberdade', '900 Apto 22', 'Liberdade', 'São Paulo', 'SP', 60),
	('04561-001', 'Rua Flórida', '1500', 'Brooklin', 'São Paulo', 'SP', 61),
	('04602-000', 'Rua Vieira de Morais', '1100 Casa 5', 'Campo Belo', 'São Paulo', 'SP', 62),
	('05616-000', 'Avenida Giovanni Gronchi', '4500 Apto 112', 'Morumbi', 'São Paulo', 'SP', 63),
	('04515-030', 'Rua Araguari', '300', 'Moema', 'São Paulo', 'SP', 64),
	('05073-000', 'Rua Pio XI', '1250 Apto 41', 'Alto da Lapa', 'São Paulo', 'SP', 65),
	('04144-000', 'Rua das Rosas', '210', 'Praça da Árvore', 'São Paulo', 'SP', 66),
	('03632-000', 'Rua Maria Carlota', '85 Casa 7', 'Vila Esperança', 'São Paulo', 'SP', 67),
	('04208-000', 'Rua Silva Bueno', '2100', 'Ipiranga', 'São Paulo', 'SP', 68),
	('03306-000', 'Rua Tuiuti', '2000 Apto 15', 'Tatuapé', 'São Paulo', 'SP', 69),
	('05411-000', 'Rua Cardeal Arcoverde', '1750', 'Pinheiros', 'São Paulo', 'SP', 70),
	('05501-000', 'Avenida Corifeu de Azevedo Marques', '3200 Casa 11', 'Butantã', 'São Paulo', 'SP', 71),
	('04321-000', 'Avenida Jabaquara', '2050', 'Saúde', 'São Paulo', 'SP', 72),
	('03127-000', 'Rua Oratório', '1340 Apto 56', 'Mooca', 'São Paulo', 'SP', 73),
	('04719-001', 'Rua Verbo Divino', '1000', 'Chácara Santo Antônio', 'São Paulo', 'SP', 74),
	('04531-000', 'Rua Tabapuã', '900 Casa 2', 'Itaim Bibi', 'São Paulo', 'SP', 75),
	('01311-000', 'Avenida Paulista', '900 Apto 77', 'Bela Vista', 'São Paulo', 'SP', 76),
	('01238-000', 'Rua Maranhão', '450', 'Higienópolis', 'São Paulo', 'SP', 77),
	('05005-000', 'Rua Palestra Itália', '500 Apto 31', 'Perdizes', 'São Paulo', 'SP', 78),
	('02010-000', 'Rua Alfredo Pujol', '1020', 'Santana', 'São Paulo', 'SP', 79),
	('03162-000', 'Rua dos Trilhos', '1500 Casa 9', 'Mooca', 'São Paulo', 'SP', 80),
	('04013-000', 'Rua Pelotas', '800 Apto 62', 'Vila Mariana', 'São Paulo', 'SP', 81),
	('01511-000', 'Rua Galvão Bueno', '600', 'Liberdade', 'São Paulo', 'SP', 82),
	('04571-000', 'Avenida Engenheiro Luiz Carlos Berrini', '1400', 'Brooklin', 'São Paulo', 'SP', 83),
	('04601-000', 'Rua Barão de Jaceguai', '300 Casa 3', 'Campo Belo', 'São Paulo', 'SP', 84),
	('05650-000', 'Avenida Morumbi', '6000 Apto 88', 'Morumbi', 'São Paulo', 'SP', 85),
	('04524-000', 'Avenida Ibirapuera', '2500', 'Moema', 'São Paulo', 'SP', 86),
	('05051-000', 'Rua Tito', '1100 Apto 14', 'Vila Romana', 'São Paulo', 'SP', 87),
	('04138-020', 'Rua Carneiro da Cunha', '750', 'Vila da Saúde', 'São Paulo', 'SP', 88),
	('03610-000', 'Avenida Penha de França', '400 Casa 12', 'Penha', 'São Paulo', 'SP', 89),
	('04218-000', 'Rua Cisplatina', '500 Apto 21', 'Ipiranga', 'São Paulo', 'SP', 90),
	('03310-000', 'Rua Serra de Bragança', '1300', 'Tatuapé', 'São Paulo', 'SP', 91),
	('01415-000', 'Rua Bela Cintra', '1000', 'Consolação', 'São Paulo', 'SP', 92),
	('05414-012', 'Rua Cristiano Viana', '456', 'Pinheiros', 'São Paulo', 'SP', 93),
	('04531-081', 'Rua Bandeira Paulista', '789', 'Itaim Bibi', 'São Paulo', 'SP', 94),
	('01311-200', 'Avenida Brigadeiro Luís Antônio', '2500', 'Bela Vista', 'São Paulo', 'SP', 95),
	('04012-110', 'Rua Cubatão', '321', 'Vila Mariana', 'São Paulo', 'SP', 96),
	('02022-011', 'Rua Voluntários da Pátria', '1500', 'Santana', 'São Paulo', 'SP', 97),
	('03318-050', 'Rua Emília Marengo', '654', 'Tatuapé', 'São Paulo', 'SP', 98),
	('04101-300', 'Rua Apeninos', '987', 'Aclimação', 'São Paulo', 'SP', 99),
	('05005-030', 'Rua Caraíbas', '120', 'Perdizes', 'São Paulo', 'SP', 100),
	('04571-010', 'Avenida Engenheiro Luís Carlos Berrini', '1500', 'Brooklin', 'São Paulo', 'SP', 101),
	('01238-010', 'Rua Itacolomi', '45', 'Higienópolis', 'São Paulo', 'SP', 102),
	('05411-001', 'Rua Artur de Azevedo', '800', 'Pinheiros', 'São Paulo', 'SP', 103),
	('04021-001', 'Rua Borges Lagoa', '1050', 'Vila Clementino', 'São Paulo', 'SP', 104),
	('03126-010', 'Rua Visconde de Inhomerim', '333', 'Mooca', 'São Paulo', 'SP', 105),
	('04601-002', 'Rua Conde de Porto Alegre', '777', 'Campo Belo', 'São Paulo', 'SP', 106),
	('01511-001', 'Rua da Glória', '222', 'Liberdade', 'São Paulo', 'SP', 107),
	('05036-041', 'Rua Faustolo', '555', 'Lapa', 'São Paulo', 'SP', 108),
	('04218-040', 'Rua Lino Coutinho', '888', 'Ipiranga', 'São Paulo', 'SP', 109),
	('03610-001', 'Rua Padre Benedito de Camargo', '999', 'Penha', 'São Paulo', 'SP', 110),
	('05508-010', 'Rua Alvarenga', '111', 'Butantã', 'São Paulo', 'SP', 111);

--POPULANDO FORMA DE PAGAMENTOOO
INSERT INTO forma_pagamento(id_forma_pagamento,forma_de_pagamento) VALUES
	(1,'PIX'),
	(2,'Cartão de Crédito'),
	(3,'Cartão de Débito'),
	(4,'Dinheiro')
;


COPY venda (
    data_hora,
    valor_total,
    id_usuario,
    id_cliente,
    id_forma_pagamento
)
FROM 'D:\Fatec Big Data\1 Semestre\projeto integrador\BD LUDENZ\CARTAS GERAIS\venda.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8',
    NULL 'NULL'
);



--POPULANDO ITEMM_VENDAAAAAA

COPY item_venda (
    quantidade,
    preco_unitario,
    subtotal,
    id_carta_venda,
    id_venda
)
FROM 'D:\Fatec Big Data\1 Semestre\projeto integrador\BD LUDENZ\CARTAS GERAIS\item_venda.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8',
    NULL 'NULL'
);



--CODIGO PARA MANTER O SERIAL DE carta_para_venda;venda;item_venda...........

SELECT setval(pg_get_serial_sequence('carta','id_carta'), (SELECT MAX(id_carta) FROM carta));
SELECT setval(pg_get_serial_sequence('venda','id_venda'), (SELECT MAX(id_venda) FROM venda));
SELECT setval(pg_get_serial_sequence('item_venda','id_item_venda'), (SELECT MAX(id_item_venda) FROM item_venda));


--SELECT DAS TABELAS

SELECT * FROM jogo ;
SELECT * FROM acabamento ;
SELECT * FROM edicao ;
SELECT * FROM raridade ;
SELECT * FROM carta ;
SELECT * FROM carta_para_venda ;
SELECT * FROM usuario ;
SELECT * FROM endereco ;
SELECT * FROM cliente ;
SELECT * FROM forma_pagamento ;
SELECT * FROM venda ;
SELECT * FROM item_venda ;

-- ===================================================================== # ===================================================================== # =====================
-- ===================================================================== # ===================================================================== # =====================
--CONSULTAS/INTERAÇÕES QUE UTILIZAMOS NO PROGRAMA DA LUDENZ
-- 1) ARQUIVO DE VENDAS

--Listar formas de pagamento
SELECT id_forma_pagamento, forma_de_pagamento  
FROM forma_pagamento 
ORDER BY id_forma_pagamento;

--Buscar cartas disponíveis no estoque
SELECT cv.id_carta_venda,
       c.nome_carta,
       e.sigla_edicao,
       cv.idioma,
       cv.condicao,
       cv.estoque,
       cv.preco_negocio
FROM carta_para_venda cv
    INNER JOIN carta c ON cv.id_carta = c.id_carta
    LEFT JOIN edicao e ON c.id_edicao = e.id_edicao
WHERE c.nome_carta ILIKE '%busca%' AND cv.estoque > 0
ORDER BY c.nome_carta
LIMIT 100;


--Buscar URL da imagem da carta
SELECT c.url_imagem_carta 
FROM carta_para_venda cv 
INNER JOIN carta c ON cv.id_carta = c.id_carta 
WHERE cv.id_carta_venda = 1;


--Buscar cliente pelo CPF
SELECT id_cliente, nome_completo 
FROM cliente 
WHERE cpf = '00000000000';


--Conferir dados e estoque antes de adicionar ao carrinho
SELECT c.nome_carta, cv.idioma, cv.condicao, cv.estoque, cv.preco_negocio 
FROM carta_para_venda cv 
INNER JOIN carta c ON cv.id_carta = c.id_carta 
WHERE cv.id_carta_venda = 1;


--Registrar cabeçalho da venda
INSERT INTO venda (data_hora, valor_total, id_usuario, id_cliente, id_forma_pagamento) 
VALUES (NOW(), 50.00, 1, 1, 1) 
RETURNING id_venda;


--Registrar cada item da venda
INSERT INTO item_venda (quantidade, preco_unitario, subtotal, id_carta_venda, id_venda) 
VALUES (2, 25.00, 50.00, 1, 10);

--Baixar saldo do estoque
UPDATE carta_para_venda 
SET estoque = estoque - 2 
WHERE id_carta_venda = 1;


-- 2) ARQUIVO DE VENDAS_REALIZADAS
--Listar historico de vendas
SELECT v.id_venda, 
       TO_CHAR(v.data_hora, 'DD/MM/YYYY HH24:MI'),
       c.nome_completo,
       u.nome_usuario,
       f.forma_de_pagamento,
       v.valor_total
FROM venda v
    LEFT JOIN cliente c ON v.id_cliente = c.id_cliente
    LEFT JOIN usuario u ON v.id_usuario = u.id_usuario
    LEFT JOIN forma_pagamento f ON v.id_forma_pagamento = f.id_forma_pagamento
ORDER BY v.data_hora DESC, v.id_venda DESC;


--Listar itens de uma venda selecionada
SELECT c.nome_carta,
       cv.idioma,
       cv.condicao,
       i.quantidade,
       i.preco_unitario,
       i.subtotal
FROM item_venda i
    INNER JOIN carta_para_venda cv ON i.id_carta_venda = cv.id_carta_venda
    INNER JOIN carta c ON cv.id_carta = c.id_carta
WHERE i.id_venda = 1
ORDER BY i.id_item_venda;

-- 3) ARQUIVO DE LOGIN
--Validar credenciais de login
SELECT id_usuario, nome_usuario, cargo 
FROM usuario 
WHERE nome_usuario = 'Mateus' AND senha = '123';


-- 4) ARQUIVO DE CLIENTES
--Listar/buscar clientes
SELECT id_cliente, nome_completo, cpf, telefone, email 
FROM cliente 
WHERE nome_completo ILIKE '%busca%' OR cpf ILIKE '%busca%'
ORDER BY nome_completo;


--Cadastrar novo cliente
INSERT INTO cliente (nome_completo, cpf, telefone, email) 
VALUES ('Nome do Cliente', '12345678900', '11999999999', 'email@exemplo.com');

--Atualizar cadastro de cliente
UPDATE cliente 
SET nome_completo = 'Novo Nome', cpf = '12345678900', telefone = '11988888888', email = 'novo@exemplo.com' 
WHERE id_cliente = 2;

--Excluir cliente
DELETE FROM cliente 
WHERE id_cliente = 2;


-- 5) ARQUIVO DE CARTAS
--listar/buscar cartas do catalogo
SELECT c.id_carta, c.nome_carta, e.sigla_edicao, c.raridade, c.preco_mercado, c.url_imagem_carta 
FROM carta c 
LEFT JOIN edicao e ON c.id_edicao = e.id_edicao 
WHERE c.nome_carta ILIKE '%busca%' 
ORDER BY c.nome_carta;

--adicionar lote/exemplar (da tabela cartas) ao estoque
INSERT INTO carta_para_venda (id_carta, idioma, condicao, estoque, preco_negocio) 
VALUES (1, 'PT', 'NM', 10, 35.50);

--Atualizar preço ou quantidade em estoque
UPDATE carta_para_venda 
SET idioma = 'EN', condicao = 'MP', estoque = 15, preco_negocio = 30.00 
WHERE id_carta_venda = 1;

--Remover item do estoque
DELETE FROM carta_para_venda 
WHERE id_carta_venda = 1;

-- 6) ARQUIVO DO ESTOQUE
--Listar carta para vendas(ESTOQUE)
SELECT cv.id_carta_venda, c.nome_carta, e.sigla_edicao, cv.idioma, cv.condicao, cv.estoque, cv.preco_negocio 
FROM carta_para_venda cv 
INNER JOIN carta c ON cv.id_carta = c.id_carta 
LEFT JOIN edicao e ON c.id_edicao = e.id_edicao 
WHERE c.nome_carta ILIKE '%busca%' 
ORDER BY c.nome_carta;

-- ===================================================================== # ===================================================================== # =====================
-- ===================================================================== # ===================================================================== # =====================

--CONSULTAS QUE UTILIZEI PARA CONFERIR SE ESTAVA TUDO CORRETO


-- CARTAS QUE NÃO ESTÃO A VENDA (ESTOQUE)
SELECT 
    c.id_carta,
    c.nome_carta,
    e.sigla_edicao,
    c.id_raridade
FROM carta c
LEFT JOIN edicao e ON c.id_edicao = e.id_edicao
WHERE c.nome_carta NOT IN (
    SELECT c2.nome_carta
    FROM carta_para_venda cv
    INNER JOIN carta c2 ON cv.id_carta = c2.id_carta
)
ORDER BY c.nome_carta;



--SELECT PARA VER O MAXIMO DE VENDAS, CARTA_PARA_VENDA, E CARTAS
SELECT COUNT(*) FROM carta;
SELECT COUNT(*) FROM carta_para_venda;
SELECT COUNT(*) FROM venda;


-- VERIFICAR TOTAL DE VENDAS/ PRIMEIRA VENDA/ ULTIMA VENDA / FATURAMENTO
SELECT COUNT(*) AS total_vendas, MIN(data_hora) AS primeira_venda, MAX(data_hora) AS ultima_venda, ROUND(SUM(valor_total), 2) AS faturamento 
FROM venda 
WHERE data_hora >= TIMESTAMP '2025-11-09 00:00:00' AND data_hora < TIMESTAMP '2026-11-9 00:00:00';
SELECT c.id_carta, 
	c.nome_carta, 
	c.numeracao_carta, 
	j.nome_jogo,
    e.sigla_edicao, 
	a.tipo_acab, 
	r.nome_exibicao, 
	c.preco_mercado
FROM carta c
	LEFT JOIN carta_para_venda cv ON cv.id_carta = c.id_carta
	LEFT JOIN edicao e ON c.id_edicao = e.id_edicao
	LEFT JOIN jogo j ON e.id_jogo = j.id_jogo
	LEFT JOIN acabamento a ON c.id_acab = a.id_acab
	LEFT JOIN raridade r ON c.id_raridade = r.id_raridade
WHERE cv.id_carta IS NULL
ORDER BY c.nome_carta;



SELECT nome_carta FROM carta WHERE nome_carta ILIKE '%animate%' LIMIT 5;




-- PROCURAR VENDAS QUE TIVERAM MAIS DE 5 TIPOS DE CARTAS DIFERENTES
SELECT 
    v.id_venda,
    TO_CHAR(v.data_hora, 'DD/MM/YYYY HH24:MI') AS data_hora,
    c.nome_completo AS cliente,
    u.nome_usuario AS vendedor,
    f.forma_de_pagamento AS pagamento,
    COUNT(i.id_item_venda) AS qtd_cartas_diferentes,
    v.valor_total
FROM venda v
INNER JOIN item_venda i ON v.id_venda = i.id_venda
LEFT JOIN cliente c ON v.id_cliente = c.id_cliente
LEFT JOIN usuario u ON v.id_usuario = u.id_usuario
LEFT JOIN forma_pagamento f ON v.id_forma_pagamento = f.id_forma_pagamento
GROUP BY v.id_venda, v.data_hora, c.nome_completo, u.nome_usuario, f.forma_de_pagamento, v.valor_total
HAVING COUNT(i.id_item_venda) > 4
ORDER BY qtd_cartas_diferentes DESC, v.id_venda DESC;



--CARTA MAIS CARA NO ESTOQUE
SELECT 
    cv.id_carta_venda,
    c.nome_carta,
    e.sigla_edicao,
    cv.idioma,
    cv.condicao,
    cv.estoque,
    cv.preco_negocio AS preco
FROM carta_para_venda cv
INNER JOIN carta c ON cv.id_carta = c.id_carta
LEFT JOIN edicao e ON c.id_edicao = e.id_edicao
WHERE cv.preco_negocio IS NOT NULL
ORDER BY cv.preco_negocio DESC
LIMIT 1;