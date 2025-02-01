-- ----------------------------------------------------------------------------
-- SIBD 2024/2025 Etapa 4 Grupo 29 Turma 11
-- Nuno Nobre Nº 61823, Rodrigo Frutuoso Nº 61865, Simão Alexandre Nº 61874, Tiago Leite Nº 61863
-- cada aluno contribuiu igualmente para a conclusão deste trabalho
-- ----------------------------------------------------------------------------
-- Utilizamos as tabelas dadas na etapa 3
-- Sistemas de Informação e Bases de Dados - António Ferreira, DI-FCUL.
-- Tabelas para a etapa 3 do projeto de SIBD de 2024/2025.
-- ----------------------------------------------------------------------------

--     Cliente (nif, nome, telemovel, genero, nascimento, localidade)
--       Ficha (ean, marca, modelo, tipo, ano, preco)
--      Fatura (numero, data, cliente)
-- Equipamento (ficha, exemplar, estado, preco, data, fatura)

-- ----------------------------------------------------------------------------
    DROP TABLE equipamento;
    DROP TABLE fatura;
    DROP TABLE cliente;
    DROP TABLE ficha;
    DROP SEQUENCE seq_fatura;--acrescentámos isto

    CREATE TABLE cliente (
     -- Adaptação, contendo atributos de Pessoa e, adicionalmente,
     -- o ano de nascimento do Empregado e a localidade da Morada.
     nif NUMBER (9),
     nome VARCHAR (80) CONSTRAINT nn_cliente_nome NOT NULL,
     telemovel NUMBER (9) CONSTRAINT nn_cliente_telemovel NOT NULL,
     genero CHAR (1), -- Pode não ser preenchido.
     nascimento NUMBER (4) CONSTRAINT nn_cliente_nascimento NOT NULL,
     -- Só o ano de nascimento.
     localidade VARCHAR (80) CONSTRAINT nn_cliente_localidade NOT NULL,
    --
     CONSTRAINT pk_cliente
     PRIMARY KEY (nif),
    --
     CONSTRAINT un_cliente_telemovel -- RIA 24, adaptada a esta tabela.
     UNIQUE (telemovel),
    --
     CONSTRAINT ck_cliente_nif -- RIA 21, adaptada a esta tabela.
     CHECK (nif BETWEEN 100000000 AND 999999999),
    --
     CONSTRAINT ck_cliente_telemovel -- RIA 23, adaptada a esta tabela.
     CHECK (telemovel BETWEEN 100000000 AND 999999999),
    --
     CONSTRAINT ck_cliente_genero -- RIA 22, adaptada a esta tabela.
     CHECK (genero IN ('F', 'M')), -- F(eminino), M(asculino), se preenchido.
    --
     CONSTRAINT ck_cliente_nascimento -- Impede erros básicos.
     CHECK (nascimento >= 1900)
    );
    -- ----------------------------------------------------------------------------
    CREATE TABLE ficha ( -- Ficha de equipamento.
     ean NUMBER (13),
     marca VARCHAR (80) CONSTRAINT nn_ficha_marca NOT NULL,
     modelo VARCHAR (80) CONSTRAINT nn_ficha_modelo NOT NULL,
    
     tipo VARCHAR (80) CONSTRAINT nn_ficha_tipo NOT NULL,
     ano NUMBER (4) CONSTRAINT nn_ficha_ano NOT NULL, -- De lançamento.
     preco NUMBER (7,2) CONSTRAINT nn_ficha_preco NOT NULL, -- De lançamento.
    --
     CONSTRAINT pk_ficha
     PRIMARY KEY (ean),
    --
     CONSTRAINT ck_ficha_ean -- RIA 29.
     CHECK (ean BETWEEN 1000000000000 AND 9999999999999),
    --
     CONSTRAINT ck_ficha_ano -- Impede erros básicos.
     CHECK (ano >= 1900),
    --
     CONSTRAINT ck_ficha_preco -- RIA 30.
     CHECK (preco > 0.0)
    );
    -- ----------------------------------------------------------------------------
    CREATE TABLE fatura (
     -- Simplificação, sem referência à Loja e ao Empregado.
     numero NUMBER (5),
     data DATE CONSTRAINT nn_fatura_data NOT NULL,
     cliente CONSTRAINT nn_fatura_cliente NOT NULL,
    --
     CONSTRAINT pk_fatura
     PRIMARY KEY (numero),
    --
     CONSTRAINT fk_fatura_cliente
     FOREIGN KEY (cliente)
     REFERENCES cliente (nif),
    --
     CONSTRAINT ck_fatura_numero -- RIA 35, parcialmente.
     CHECK (numero >= 1),
    --
     CONSTRAINT ck_fatura_data -- Não suporta RIA 12, mas impede erros
     CHECK (data >= TO_DATE('01.01.1900', 'DD.MM.YYYY')) -- básicos.
    );
    -- ----------------------------------------------------------------------------
    CREATE TABLE equipamento (
     -- Simplificação, sem referência à Loja, pelo que um
     -- Equipamento é uma entidade fraca de Ficha (de Equipamento).
     ficha,
     exemplar NUMBER (5),
     estado CHAR (3) CONSTRAINT nn_equipamento_estado NOT NULL,
     preco NUMBER (7,2) CONSTRAINT nn_equipamento_preco NOT NULL, -- Na loja.
     data DATE CONSTRAINT nn_equipamento_data NOT NULL, -- Na loja.
     fatura, -- Só é preenchida quando o equipamento for
     -- vendido a um cliente, no âmbito de uma fatura.
    --
     CONSTRAINT pk_equipamento
     PRIMARY KEY (ficha, exemplar),
    --
     CONSTRAINT fk_equipamento_ficha
     FOREIGN KEY (ficha)
     REFERENCES ficha (ean)
     ON DELETE CASCADE,
    --
     CONSTRAINT fk_equipamento_fatura
     FOREIGN KEY (fatura)
     REFERENCES fatura (numero),
    --
     CONSTRAINT ck_equipamento_exemplar -- RIA 32, parcialmente.
     CHECK (exemplar >= 1),
    --
     CONSTRAINT ck_equipamento_estado -- RIA 33.
     CHECK (estado IN ('BOM', 'MAU')),
    --
     CONSTRAINT ck_equipamento_preco -- RIA 34.
     CHECK (preco > 0.0),
    --
     CONSTRAINT ck_equipamento_data -- Não suporta RIA 11, mas impede erros
     CHECK (data >= TO_DATE('01.01.1900', 'DD.MM.YYYY')) -- básicos.
    );
    -- ---------------------------------------------------------------------------- 
    -- Sequência criada para a fatura
    CREATE SEQUENCE seq_fatura
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 9999
    NOCYCLE;
    -- ---------------------------------------------------------------------------- 
    -- às vezes sem isto não dava para visualizar as frases no SQL Developer
    SET SERVEROUTPUT ON 
    -- ---------------------------------------------------------------------------- 
    -- Nossos testes para testar as funções, primeiramente testamos cada função uma a uma
    -- e ao mesmo tempo a visualizar as tabelas, para ver se entraram/saíram dados corretamente.
    -- ---------------------------------------------------------------------------- 
    BEGIN
        
        -- 1. Registar os Clientes
        BEGIN
            pkg_loja.regista_cliente(987654321, 'João Banana', 912345678, 'M', 2001, 'Lisboa');
            pkg_loja.regista_cliente(123456789, 'Maria Oliveira', 987654321, 'F', 1998, 'Porto');
            DBMS_OUTPUT.PUT_LINE('Clientes registados com sucesso.');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao registar clientes: ' || SQLERRM);
        END;
    
        BEGIN
            FOR c IN (SELECT * FROM cliente) LOOP
                DBMS_OUTPUT.PUT_LINE('NIF: ' || c.nif || ', Nome: ' || c.nome || ', Telemóvel: ' || c.telemovel);
            END LOOP;
        END;
    
        -- 2. Registar as Fichas de Equipamento
        BEGIN
            pkg_loja.regista_ficha(1234567890123, 'Apple', 'iPhone 15', 'Smartphone', 2023, 999.99);
            pkg_loja.regista_ficha(9876543210123, 'Samsung', 'Galaxy S23', 'Smartphone', 2023, 899.99);
            DBMS_OUTPUT.PUT_LINE('Fichas de equipamento registadas com sucesso.');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao registar fichas de equipamento: ' || SQLERRM);
        END;
    
        BEGIN
            FOR f IN (SELECT * FROM ficha) LOOP
                DBMS_OUTPUT.PUT_LINE('EAN: ' || f.ean || ', Marca: ' || f.marca || ', Modelo: ' || f.modelo || 
                                     ', Tipo: ' || f.tipo || ', Ano: ' || f.ano || ', Preço: ' || f.preco);
            END LOOP;
        END;
    
        -- 3. Registar os Equipamentos
        DECLARE
            exemplar NUMBER;
            exemplar2 NUMBER;
            exemplar3 NUMBER;
        BEGIN
            exemplar := PKG_LOJA.regista_equipamento(1234567890123, 'MAU', 899.99);
            exemplar2 := PKG_LOJA.regista_equipamento(1234567890123, 'BOM', 999.99);
            exemplar3 := PKG_LOJA.regista_equipamento(9876543210123, 'MAU', 499.99);
    
            DBMS_OUTPUT.PUT_LINE('Novos exemplares registados: ' || exemplar || ', ' || exemplar2 || ', ' || exemplar3);
    
            FOR e IN (SELECT * FROM equipamento) LOOP
                DBMS_OUTPUT.PUT_LINE('Ficha: ' || e.ficha || ', Exemplar: ' || e.exemplar || ', Estado: ' || e.estado || 
                                     ', Preço: ' || e.preco || ', Data: ' || e.data);
            END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao registar equipamentos: ' || SQLERRM);
        END;
    
        -- 4. Registar uma Compra
        DECLARE
            numero_fatura NUMBER;
        BEGIN
            -- Cliente João compra iPhone 15
            numero_fatura := pkg_loja.regista_compra(987654321, 1234567890123, 1);
            DBMS_OUTPUT.PUT_LINE('Número da fatura para João (iPhone 15): ' || numero_fatura);
    
            FOR f IN (SELECT * FROM fatura WHERE numero = numero_fatura) LOOP
                DBMS_OUTPUT.PUT_LINE('Número da Fatura: ' || f.numero || ', Data: ' || f.data || ', Cliente: ' || f.cliente);
            END LOOP;
    
            -- Cliente Maria compra iPhone 15
            numero_fatura := pkg_loja.regista_compra(123456789, 1234567890123, 2);
            DBMS_OUTPUT.PUT_LINE('Número da fatura para Maria (iPhone 15): ' || numero_fatura);
    
            FOR f IN (SELECT * FROM fatura WHERE numero = numero_fatura) LOOP
                DBMS_OUTPUT.PUT_LINE('Número da Fatura: ' || f.numero || ', Data: ' || f.data || ', Cliente: ' || f.cliente);
            END LOOP;
    
            -- Cliente Maria compra Samsung Galaxy
            numero_fatura := pkg_loja.regista_compra(123456789, 9876543210123, 1, 2);
            DBMS_OUTPUT.PUT_LINE('Número da fatura para Maria (Samsung Galaxy): ' || numero_fatura);
    
            FOR f IN (SELECT * FROM fatura WHERE numero = numero_fatura) LOOP
                DBMS_OUTPUT.PUT_LINE('Número da Fatura: ' || f.numero || ', Data: ' || f.data || ', Cliente: ' || f.cliente);
            END LOOP;
    
            DBMS_OUTPUT.PUT_LINE('Compras registadas com sucesso.');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao registar as compras: ' || SQLERRM);
        END;
    
        -- 9. Listar Compras de um Cliente
        BEGIN
            DECLARE
                compras_cursor SYS_REFCURSOR;
                numero_fatura fatura.numero%TYPE;
                data_fatura fatura.data%TYPE;
                ean ficha.ean%TYPE;
                exemplar equipamento.exemplar%TYPE;
                marca ficha.marca%TYPE;
                modelo ficha.modelo%TYPE;
                preco ficha.preco%TYPE;
            BEGIN
                compras_cursor := pkg_loja.lista_compras(123456789);
                DBMS_OUTPUT.PUT_LINE('Compras da Maria:');
                LOOP
                    FETCH compras_cursor INTO numero_fatura, data_fatura, ean, exemplar, marca, modelo, preco;
                    EXIT WHEN compras_cursor%NOTFOUND;
                    DBMS_OUTPUT.PUT_LINE('Número da Fatura: ' || numero_fatura || ', Data: ' || data_fatura || 
                                         ', EAN: ' || ean || ', Exemplar: ' || exemplar || 
                                         ', Marca: ' || marca || ', Modelo: ' || modelo || 
                                         ', Preço: ' || preco);
                END LOOP;
                CLOSE compras_cursor;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Erro ao listar compras: ' || SQLERRM);
            END;
        END;
    
        -- 5. Remover uma Compra
        DECLARE
            linhas_restantes NUMBER;
        BEGIN
            linhas_restantes := pkg_loja.remove_compra(1); -- Fatura do João
            DBMS_OUTPUT.PUT_LINE('Compra removida com sucesso. Linhas restantes na fatura 1: ' || linhas_restantes);
    
            linhas_restantes := pkg_loja.remove_compra(2, 1234567890123, 2); -- Fatura da Maria (1º)
            DBMS_OUTPUT.PUT_LINE('Compra removida com sucesso. Linhas restantes na fatura 2: ' || linhas_restantes);
    
            linhas_restantes := pkg_loja.remove_compra(2); -- Fatura da Maria restante
            DBMS_OUTPUT.PUT_LINE('Compra removida com sucesso. Linhas restantes na fatura 2: ' || linhas_restantes);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao remover compra: ' || SQLERRM);
        END;
    
        -- 6. Remover um Equipamento
        BEGIN
            pkg_loja.remove_equipamento(1234567890123, 1); -- Remove o iPhone 1
            DBMS_OUTPUT.PUT_LINE('Equipamento removido com sucesso.');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao remover equipamento: ' || SQLERRM);
        END;
    
        -- 7. Remover uma Ficha
        BEGIN
            pkg_loja.remove_ficha(1234567890123); -- Remove o iPhone
            DBMS_OUTPUT.PUT_LINE('Ficha removida com sucesso.');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao remover ficha: ' || SQLERRM);
        END;
    
        -- 8. Remover um Cliente
        BEGIN
            pkg_loja.remove_cliente(987654321); -- Remove o João
            DBMS_OUTPUT.PUT_LINE('Cliente removido com sucesso.');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao remover cliente: ' || SQLERRM);
        END;
    
    END;
