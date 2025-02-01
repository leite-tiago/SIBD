-- ----------------------------------------------------------------------------
-- SIBD 2024/2025 Etapa 2 Grupo 29 Turma 11
-- Nuno Nobre Nº 61823, Rodrigo Frutuoso Nº 61865, Simão Alexandre Nº61874, Tiago Leite Nº 61863
-- cada aluno contribuiu igualmente para a conclusão deste trabalho
-- RIAs: 5,13,14,15,16,17,21,22,23,24,25,26,27,28,29,30,33,34
-- RIAs nao suportadas: 2,3,4,6,9,10,11,12,32,35
-- ----------------------------------------------------------------------------

-- 1ª Parte - DROP TABLE --
DROP TABLE loja CASCADE CONSTRAINTS;
DROP TABLE ficha_de_equipamento CASCADE CONSTRAINTS;
DROP TABLE equipamento CASCADE CONSTRAINTS;
DROP TABLE fatura CASCADE CONSTRAINTS;
DROP TABLE pessoa CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE empregado CASCADE CONSTRAINTS;
DROP TABLE do_tipo CASCADE CONSTRAINTS;
DROP TABLE usa CASCADE CONSTRAINTS;
DROP TABLE emite CASCADE CONSTRAINTS;
DROP TABLE venda CASCADE CONSTRAINTS;

-- 2ª Parte - CREATE TABLE --

CREATE TABLE loja (
    NIPC         CHAR(9) CONSTRAINT nn_loja_nipc NOT NULL,
    Nome         VARCHAR2(30) CONSTRAINT nn_loja_nome NOT NULL,
    Telefone     CHAR(9) CONSTRAINT nn_loja_telefone NOT NULL,
    Email        VARCHAR2(30) CONSTRAINT nn_loja_email NOT NULL,
    CONSTRAINT pk_loja PRIMARY KEY (NIPC),
    CONSTRAINT ck_loja_nipc CHECK (LENGTH(NIPC) = 9), --Ria 13
    CONSTRAINT un_loja_nome UNIQUE (Nome), --Ria 14
    CONSTRAINT un_loja_telefone UNIQUE (Telefone), --Ria 16
    CONSTRAINT ck_loja_telefone CHECK (Telefone > 0 AND LENGTH(Telefone) = 9), --Ria 15
    CONSTRAINT un_loja_email UNIQUE (Email) --Ria 17
);

CREATE TABLE ficha_de_equipamento (
    EAN                 CHAR(13) CONSTRAINT nn_ficha_equipamento_ean NOT NULL,
    Marca               VARCHAR2(30) CONSTRAINT nn_ficha_equipamento_marca NOT NULL,
    Modelo              VARCHAR2(30) CONSTRAINT nn_ficha_equipamento_modelo NOT NULL,
    Tipo                VARCHAR2(30) CONSTRAINT nn_ficha_equipamento_tipo NOT NULL,
    Ano_de_lancamento   NUMBER,
    Preco_de_lancamento NUMBER CHECK (Preco_de_lancamento > 0), --Ria 30
    CONSTRAINT pk_ficha_de_equipamento PRIMARY KEY (EAN),
    CONSTRAINT ck_ficha_equipamento_ean CHECK (LENGTH(EAN) = 13) --Ria 29
);

CREATE TABLE equipamento (
    EAN                 CHAR(13) CONSTRAINT nn_equipamento_ean NOT NULL,
    Numero_de_Exemplar  NUMBER CHECK (Numero_de_Exemplar > 0),
    Estado_de_conservacao CHAR(3) CONSTRAINT nn_equipamento_estado NOT NULL CHECK (Estado_de_conservacao IN ('bom', 'mau')),--Ria 33
    Preco_na_Loja       NUMBER CHECK (Preco_na_Loja > 0),--Ria 34
    Data_na_Loja        DATE,
    CONSTRAINT pk_equipamento PRIMARY KEY(EAN, Numero_de_Exemplar),
    CONSTRAINT fk_equipamento_usa FOREIGN KEY (EAN) REFERENCES ficha_de_equipamento(EAN) ON DELETE CASCADE,
    CONSTRAINT ck_equipamento_ean CHECK (LENGTH(EAN) = 13) --Ria 29
);

CREATE TABLE fatura (
    NIPC                CHAR(9) CONSTRAINT nn_fatura_nipc NOT NULL,
    Numero_Sequencial   NUMBER CHECK (Numero_Sequencial > 0),
    Data                DATE,
    nif_empregado       CHAR(9),
    nif_cliente         CHAR(9),
    CONSTRAINT pk_fatura PRIMARY KEY(Numero_Sequencial, NIPC),
    CONSTRAINT fk_fatura_loja FOREIGN KEY (NIPC) REFERENCES loja(NIPC) ON DELETE CASCADE,
    CONSTRAINT fk_fatura_empregado FOREIGN KEY (nif_empregado) REFERENCES empregado (NIF) ON DELETE NO ACTION,
    CONSTRAINT fk_fatura_cliente FOREIGN KEY (nif_cliente) REFERENCES cliente (NIF) ON DELETE NO ACTION
);


CREATE TABLE pessoa (
    NIF         CHAR(9) CONSTRAINT nn_pessoa_nif NOT NULL,
    Nome        VARCHAR2(30) CONSTRAINT nn_pessoa_nome NOT NULL,
    Telemovel   CHAR(9) CONSTRAINT nn_pessoa_telemovel NOT NULL,
    Genero      VARCHAR2(9) CHECK (Genero IN ('masculino', 'feminino')),--Ria 22
    CONSTRAINT pk_pessoa PRIMARY KEY (NIF), --Ria 5
    CONSTRAINT ck_pessoa_nif CHECK (LENGTH(NIF) = 9), --Ria 21
    CONSTRAINT ck_pessoa_telemovel CHECK (LENGTH(Telemovel) = 9), -- Ria 23
    CONSTRAINT un_pessoa_telemovel UNIQUE (Telemovel) -- Ria 24
);

CREATE TABLE cliente (
    NIF CHAR(9),
    CONSTRAINT pk_cliente PRIMARY KEY (NIF), --Ria 5
    CONSTRAINT fk_cliente_pessoa FOREIGN KEY (NIF) REFERENCES pessoa(NIF) ON DELETE CASCADE
);

CREATE TABLE empregado (
    NIF                 CHAR(9),
    Data_de_Nascimento  DATE,
    Numero_interno      NUMBER(5) CHECK (Numero_interno > 0), --Ria 27
    NIC                 CHAR(8) CHECK (LENGTH(NIC) = 8),
    CONSTRAINT pk_empregado PRIMARY KEY (NIF), --Ria 5
    CONSTRAINT fk_empregado_pessoa FOREIGN KEY (NIF) REFERENCES pessoa(NIF) ON DELETE CASCADE,
    CONSTRAINT un_empregado_numero_interno UNIQUE (Numero_interno), --Ria 28
    CONSTRAINT ck_empregado_nic CHECK (LENGTH(NIC) = 8), --Ria 25
    CONSTRAINT un_empregado_nic UNIQUE (NIC) --Ria 26
);

CREATE TABLE usa (
    EAN CHAR(13) NOT NULL CHECK (LENGTH(EAN) = 13),
    NIPC CHAR(9) NOT NULL CHECK (LENGTH(NIPC) = 9),
    CONSTRAINT pk_usa PRIMARY KEY(EAN, NIPC),
    CONSTRAINT fk_usa_ficha_equipamento FOREIGN KEY (EAN) REFERENCES ficha_de_equipamento(EAN),
    CONSTRAINT fk_usa_loja FOREIGN KEY (NIPC) REFERENCES loja(NIPC)
);

CREATE TABLE do_tipo (
    EAN CHAR(13) NOT NULL CHECK (LENGTH(EAN) = 13),
    NIPC CHAR(9) NOT NULL CHECK (LENGTH(NIPC) = 9),
    Numero_de_Exemplar NUMBER CHECK (Numero_de_Exemplar > 0),
    CONSTRAINT pk_do_tipo PRIMARY KEY(EAN, NIPC, Numero_de_Exemplar),
    CONSTRAINT fk_do_tipo_usa FOREIGN KEY (EAN, Numero_de_Exemplar) REFERENCES equipamento(EAN, Numero_de_Exemplar)
);

CREATE TABLE emite (
    NIPC CHAR(9) NOT NULL CHECK (LENGTH(NIPC) = 9),
    Numero_Sequencial NUMBER,
    CONSTRAINT pk_emite PRIMARY KEY (NIPC, Numero_Sequencial),
    FOREIGN KEY (NIPC) REFERENCES loja(NIPC)
);

CREATE TABLE venda (
    empregado_NIF CHAR(9) CHECK (LENGTH(empregado_NIF) = 9),
    cliente_NIF CHAR(9) CHECK (LENGTH(cliente_NIF) = 9),
    CONSTRAINT pk_venda PRIMARY KEY(empregado_NIF, cliente_NIF),
    CONSTRAINT fk_venda_empregado FOREIGN KEY (empregado_NIF) REFERENCES empregado(NIF),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_NIF) REFERENCES cliente(NIF)
);

-- 3ª Parte - INSERT INTO --

-- Tabela Loja
INSERT INTO loja (NIPC, Nome, Telefone, Email) VALUES ('123456789', 'TechStore Lisboa', '912345678', 'lisboa@techstore.pt');
INSERT INTO loja (NIPC, Nome, Telefone, Email) VALUES ('987654321', 'TechStore Porto', '987654321', 'porto@techstore.pt');


-- Tabela Ficha_de_Equipamento
INSERT INTO ficha_de_equipamento (EAN, Marca, Modelo, Tipo, Ano_de_lancamento, Preco_de_lancamento) VALUES ('1234567890123', 'Apple', 'iPhone 12', 'Smartphone', 2020, 999.99);
INSERT INTO ficha_de_equipamento (EAN, Marca, Modelo, Tipo, Ano_de_lancamento, Preco_de_lancamento) VALUES ('9876543210987', 'Samsung', 'Galaxy S21', 'Smartphone', 2021, 899.99);

-- Tabela Equipamento
INSERT INTO equipamento (EAN, Numero_de_Exemplar, Estado_de_conservacao, Preco_na_Loja, Data_na_Loja) VALUES ('1234567890123', 1, 'bom', 699.99, TO_DATE('2023-01-15', 'YYYY-MM-DD'));
INSERT INTO equipamento (EAN, Numero_de_Exemplar, Estado_de_conservacao, Preco_na_Loja, Data_na_Loja) VALUES ('9876543210987', 1, 'mau', 499.99, TO_DATE('2023-02-10', 'YYYY-MM-DD'));

-- Tabela Fatura
INSERT INTO fatura (NIPC, Numero_Sequencial, Data) VALUES ('123456789', 1, TO_DATE('2023-03-01', 'YYYY-MM-DD'));
INSERT INTO fatura (NIPC, Numero_Sequencial, Data) VALUES ('987654321', 2, TO_DATE('2023-03-02', 'YYYY-MM-DD'));

-- Tabela Pessoa
INSERT INTO pessoa (NIF, Nome, Telemovel, Genero) VALUES ('111111111', 'Joao Silva', '912345678', 'masculino');
INSERT INTO pessoa (NIF, Nome, Telemovel, Genero) VALUES ('222222222', 'Maria Costa', '987654321', 'feminino');
INSERT INTO pessoa (NIF, Nome, Telemovel, Genero) VALUES ('333333333', 'Jose Almeida', '923456789', 'masculino');
INSERT INTO pessoa (NIF, Nome, Telemovel, Genero) VALUES ('444444444', 'Ana Ribeiro', '934567890', 'feminino');

-- Tabela Cliente
INSERT INTO cliente (NIF) VALUES ('111111111');
INSERT INTO cliente (NIF) VALUES ('222222222');

-- Tabela Empregado
INSERT INTO empregado (NIF, Data_de_Nascimento, Numero_interno, NIC) VALUES ('333333333', TO_DATE('1990-05-10', 'YYYY-MM-DD'), 12345, '12345678');
INSERT INTO empregado (NIF, Data_de_Nascimento, Numero_interno, NIC) VALUES ('444444444', TO_DATE('1985-08-20', 'YYYY-MM-DD'), 54321, '87654321');

-- Tabela Usa
INSERT INTO usa (EAN, NIPC) VALUES ('1234567890123', '123456789');
INSERT INTO usa (EAN, NIPC) VALUES ('9876543210987', '987654321');

-- Tabela Do_Tipo
INSERT INTO do_tipo (EAN, NIPC, Numero_de_Exemplar) VALUES ('1234567890123', '123456789', 1);
INSERT INTO do_tipo (EAN, NIPC, Numero_de_Exemplar) VALUES ('9876543210987', '987654321', 1);

-- Tabela Emite
INSERT INTO emite (NIPC, Numero_Sequencial) VALUES ('123456789', 1);
INSERT INTO emite (NIPC, Numero_Sequencial) VALUES ('987654321', 2);

-- Tabela Venda
INSERT INTO venda (empregado_NIF, cliente_NIF) VALUES ('333333333', '111111111');
INSERT INTO venda (empregado_NIF, cliente_NIF) VALUES ('444444444', '222222222');
