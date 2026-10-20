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
	preco_mercado NUMERIC (10,2),
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
	preco_negocio NUMERIC (10,2)
);

CREATE TABLE usuario(
	id_usuario INTEGER PRIMARY KEY,
	nome_usuario VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL,
	senha_hash VARCHAR(255) NOT NULL,
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


SELECT COUNT(*) FROM carta;
SELECT COUNT(*) FROM carta_para_venda;
SELECT COUNT(*) FROM venda;

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
    preco_negocio)
	
FROM 'D:\Fatec Big Data\1 Semestre\projeto integrador\BD LUDENZ\CARTAS GERAIS\estoque_tcg_completo.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8',
    NULL 'NULL'
);




--POPULANDO USUARIOO
INSERT INTO usuario (id_usuario, nome_usuario, email, senha_hash, status, cargo) VALUES
	(1, 'Mateus', 'mateus@ludenz360.com.br', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', true, 'Admin'),
	(2, 'Luiz', 'luiz@ludenz360.com.br', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', true, 'Admin')
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
	('Beatriz Souza Souza', '77063323720', '11910985708', 'beatriz.souza.souza@exemplo.com', '2004-05-15', 'F', '2026-08-17 14:05:00')
;


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
	('05406-506', 'Rua Teodoro Sampaio', '1028 Casa 115', 'Pinheiros', 'São Paulo', 'SP', 25)
;



--POPULANDO FORMA DE PAGAMENTOOO
INSERT INTO forma_pagamento(id_forma_pagamento,forma_de_pagamento) VALUES
	(1,'PIX'),
	(2,'Cartão de Crédito'),
	(3,'Cartão de Débito'),
	(4,'Dinheiro')
;


-- VERIFICAR TOTAL DE VENDAS/ PRIMEIRA VENDA/ ULTIMA VENDA / FATURAMENTO

SELECT COUNT(*) AS total_vendas, MIN(data_hora) AS primeira_venda, MAX(data_hora) AS ultima_venda, ROUND(SUM(valor_total), 2) 
AS faturamento FROM venda WHERE data_hora >= TIMESTAMP '2026-04-19 00:00:00' AND data_hora < TIMESTAMP '2026-10-20 00:00:00';


-----------------------------------------------------------------------------------------------------------------
ROLLBACK;


-- ==============================================================================================================
-- GERADOR DE VENDAS FICTÍCIAS DE VENDAS


BEGIN;

DO $$
DECLARE
    v_dia DATE;
    v_fim DATE := DATE '2026-10-19';
    v_qtd_vendas INTEGER;
    v_i INTEGER;
    v_j INTEGER;
    v_num_itens INTEGER;
    v_qtd INTEGER;
    v_estoque INTEGER;
    v_id_carta_venda INTEGER;
    v_preco NUMERIC(10,2);
    v_subtotal NUMERIC(10,2);
    v_total NUMERIC(10,2);
    v_id_venda INTEGER;
    v_id_cliente INTEGER;
    v_id_usuario INTEGER;
    v_id_pagamento INTEGER;
    v_hora TIMESTAMP;
BEGIN
-- Tabela temporária para montar os itens de cada pedido.
    CREATE TEMP TABLE IF NOT EXISTS tmp_itens_venda (
        id_carta_venda INTEGER NOT NULL,
        quantidade INTEGER NOT NULL,
        preco_unitario NUMERIC(10,2) NOT NULL,
        subtotal NUMERIC(10,2) NOT NULL
    ) ON COMMIT DROP;

    FOR v_dia IN SELECT d::date
                 FROM generate_series(DATE '2026-04-19', v_fim, INTERVAL '1 day') AS d
    LOOP
-- Variação diária: não ficam exatamente 50 vendas todos os dias.
        v_qtd_vendas := 40 + floor(random() * 21)::integer;

        FOR v_i IN 1..v_qtd_vendas LOOP
            TRUNCATE tmp_itens_venda;
            v_total := 0;
-- Horário de funcionamento plausível: entre 09h e 21h59.
            v_hora := v_dia::timestamp
                      + make_interval(hours => 9 + floor(random() * 13)::integer,
                                      mins => floor(random() * 60)::integer,
                                      secs => floor(random() * 60)::integer);

-- Cliente Balcão (id 1) representa vendas anônimas.
-- Demais clientes só compram após data_cadastro.
            IF random() < 0.28 THEN
                v_id_cliente := 1;
            ELSE
                SELECT c.id_cliente INTO v_id_cliente
                FROM cliente c
                WHERE c.id_cliente <> 1
                  AND c.data_cadastro <= v_hora
                ORDER BY random()
                LIMIT 1;
                IF v_id_cliente IS NULL THEN
                    v_id_cliente := 1;
                END IF;
            END IF;

-- Só existem dois usuários no script fornecido.
            v_id_usuario := CASE WHEN random() < 0.65 THEN 1 ELSE 2 END;
-- Formas de pagamento: PIX, crédito, débito ou dinheiro.
            v_id_pagamento := CASE
                WHEN random() < 0.42 THEN 1
                WHEN random() < 0.72 THEN 2
                WHEN random() < 0.88 THEN 3
                ELSE 4
            END;

-- 1 a 3 linhas de itens por venda.
            v_num_itens := 1 + floor(random() * 3)::integer;

            FOR v_j IN 1..v_num_itens LOOP
                v_id_carta_venda := NULL;
                v_preco := NULL;
                v_subtotal := 0;

-- Cartas de baixo valor têm mais chance de aparecer.
-- Limita a R$ 20 para evitar cartas muito caras.
-- Quantidade maior é mais provável em cartas baratas.
                SELECT cpv.id_carta_venda, cpv.preco_negocio
                  INTO v_id_carta_venda, v_preco
                FROM carta_para_venda cpv
                WHERE cpv.estoque > 0
                  AND cpv.preco_negocio IS NOT NULL
                  AND cpv.preco_negocio BETWEEN 0.01 AND 20.00
                  AND NOT EXISTS (
                      SELECT 1 FROM tmp_itens_venda t
                      WHERE t.id_carta_venda = cpv.id_carta_venda
                  )
                ORDER BY
-- Favorece bastante as cartas baratas sem tornar a seleção fixa.
                  random() * (1.0 + cpv.preco_negocio * 2.5)
                LIMIT 1;

                IF v_id_carta_venda IS NULL THEN
                    EXIT;
                END IF;

                IF v_preco <= 1.00 THEN
                    v_qtd := 1 + floor(random() * 4)::integer; -- 1 a 4 cópias
                ELSIF v_preco <= 5.00 THEN
                    v_qtd := 1 + floor(random() * 3)::integer; -- 1 a 3 cópias
                ELSE
                    v_qtd := 1 + floor(random() * 2)::integer; -- 1 a 2 cópias
                END IF;

                -- Não vende mais cópias do que há em estoque.
                SELECT cpv.estoque INTO v_estoque
                FROM carta_para_venda cpv
                WHERE cpv.id_carta_venda = v_id_carta_venda;
                v_qtd := LEAST(v_qtd, v_estoque);

                IF v_qtd <= 0 THEN
                    CONTINUE;
                END IF;

                v_subtotal := ROUND(v_preco * v_qtd, 2);
                INSERT INTO tmp_itens_venda
                    (id_carta_venda, quantidade, preco_unitario, subtotal)
                VALUES
                    (v_id_carta_venda, v_qtd, v_preco, v_subtotal);
            END LOOP;

-- Se não foi possível selecionar nenhum item, não cria pedido vazio.
            SELECT COALESCE(SUM(subtotal), 0) INTO v_total FROM tmp_itens_venda;
            IF v_total <= 0 THEN
                CONTINUE;
            END IF;

            INSERT INTO venda (data_hora, valor_total, id_usuario, id_cliente, id_forma_pagamento)
            VALUES (v_hora, ROUND(v_total, 2), v_id_usuario, v_id_cliente, v_id_pagamento)
            RETURNING id_venda INTO v_id_venda;

            INSERT INTO item_venda (quantidade, preco_unitario, subtotal, id_carta_venda, id_venda)
            SELECT quantidade, preco_unitario, subtotal, id_carta_venda, v_id_venda
            FROM tmp_itens_venda;

-- Baixa o estoque somente depois de inserir os itens do pedido.
            UPDATE carta_para_venda cpv
            SET estoque = cpv.estoque - t.quantidade
            FROM tmp_itens_venda t
            WHERE cpv.id_carta_venda = t.id_carta_venda
              AND cpv.estoque >= t.quantidade;
        END LOOP;
    END LOOP;
END $$;

COMMIT;





--Conferência após executar:

SELECT COUNT(*) AS total_vendas,
       MIN(data_hora) AS primeira_venda,
       MAX(data_hora) AS ultima_venda,
       ROUND(SUM(valor_total), 2) AS faturamento
FROM venda
WHERE data_hora >= TIMESTAMP '2026-04-19 00:00:00'
  AND data_hora <  TIMESTAMP '2026-10-20 00:00:00';

SELECT v.id_venda, v.data_hora, v.valor_total,
       COUNT(iv.id_item_venda) AS linhas_itens,
       SUM(iv.quantidade) AS cartas_vendidas
FROM venda v JOIN item_venda iv ON iv.id_venda = v.id_venda
WHERE v.data_hora >= TIMESTAMP '2026-04-19 00:00:00'
  AND v.data_hora <  TIMESTAMP '2026-10-20 00:00:00'
GROUP BY v.id_venda, v.data_hora, v.valor_total
ORDER BY v.data_hora DESC LIMIT 20;







/*

SELECT
	c.id_carta,
	c.nome_carta ,
	c.numeracao_carta ,
	c.url_imagem_carta ,
	c.preco_mercado, 
	c.id_edicao ,
	c.id_acab ,
	c.id_raridade ,
	j.id_jogo
FROM carta c
INNER JOIN edicao e ON e.id_edicao = c.id_edicao
INNER JOIN jogo j ON j.id_jogo = e.id_jogo;


SELECT
	c.id_carta,
	c.nome_carta ,
	c.numeracao_carta ,
	c.url_imagem_carta ,
	c.preco_mercado ,
	c.id_edicao ,
	c.id_acab ,
	c.id_raridade 
FROM carta c
INNER JOIN edicao e ON e.id_edicao = c.id_edicao
INNER JOIN raridade r ON r.id_raridade = c.id_raridade
INNER JOIN acabamento a ON a.id_acab = c.id_acab
INNER JOIN jogo j ON j.id_jogo = e.id_jogo



SELECT
	c.nome_carta,
--	c.idioma,
	e.sigla_edicao,
	r.nome_exibicao,
	a.tipo_acab,
	j.nome_jogo
FROM carta c
INNER JOIN edicao e ON e.id_edicao = c.id_edicao
INNER JOIN raridade r ON r.id_raridade = c.id_raridade
INNER JOIN acabamento a ON a.id_acab = c.id_acab
INNER JOIN jogo j ON j.id_jogo = e.id_jogo
WHERE a.id_acab = 2;

SELECT * FROM jogo;
SELECT * FROM edicao;



SELECT
	c.nome_carta,
	cp.preco,
	cp.condicao,
	cp.estoque
FROM carta_para_venda cp
INNER JOIN carta c ON cp.id_carta = c.id_carta;



SELECT
	c.nome_carta,
	SUM (cp.estoque) AS Estoque
FROM carta c
INNER JOIN carta_para_venda cp ON c.id_carta = cp.id_carta
GROUP BY c.nome_carta;
*/