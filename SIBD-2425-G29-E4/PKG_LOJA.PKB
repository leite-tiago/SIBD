-- ----------------------------------------------------------------------------
-- SIBD 2024/2025 Etapa 4 Grupo 29 Turma 11
-- Nuno Nobre Nº 61823, Rodrigo Frutuoso Nº 61865, Simão Alexandre Nº61874, Tiago Leite Nº 61863
-- cada aluno contribuiu igualmente para a conclusão deste trabalho
-- ----------------------------------------------------------------------------
-- Lista de Exceções:
-- -20000: Erro desconhecido.
-- -20001: Violação de restrição CHECK.
-- -20002: Violação de chave estrangeira.
-- -20003: Violação de chave primária.
-- -20004: Valor não pode ser nulo.
-- -20005: Violação de chave única.
-- -20006: Idade do cliente é inferior a 16 anos.
-- -20007: Cliente com este NIF já existe.
-- -20008: Ano de lançamento do equipamento é posterior ao ano atual.
-- -20009: A data da fatura deve ser posterior à data de colocação do equipamento na loja.
-- -20010: A fatura não pertence ao cliente fornecido.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY pkg_loja IS

    -- Procedimento privado para converter exceções Oracle em mensagens mais inteligíveis
    PROCEDURE tratar_excecao IS
        codigo_erro NUMBER := SQLCODE;
        BEGIN
            IF codigo_erro = -2290 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Violação de restrição CHECK.');
            ELSIF codigo_erro = -2291 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Violação de chave estrangeira.');
            ELSIF codigo_erro = -2292 THEN
                RAISE_APPLICATION_ERROR(-20003, 'Violação de chave primária.');
            ELSIF codigo_erro = -1400 THEN
                RAISE_APPLICATION_ERROR(-20004, 'Valor não pode ser nulo.');
            ELSIF codigo_erro = -1 THEN
                RAISE_APPLICATION_ERROR(-20005, 'Violação de chave única.');
            ELSE
                RAISE_APPLICATION_ERROR(-20000, 'Erro desconhecido.');
            END IF;
    END tratar_excecao;

    PROCEDURE regista_cliente(
        nif_in IN cliente.nif%TYPE,
        nome_in IN cliente.nome%TYPE,
        telemovel_in IN cliente.telemovel%TYPE,
        genero_in IN cliente.genero%TYPE,
        nascimento_in IN cliente.nascimento%TYPE,
        localidade_in IN cliente.localidade%TYPE) 
        IS
        contador NUMBER;
    BEGIN
        IF (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - nascimento_in) < 16 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Idade do cliente é inferior a 16 anos.');
        END IF;

        SELECT COUNT(*) INTO contador FROM cliente WHERE nif = nif_in;
        IF contador > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Cliente com este NIF já existe.');
        END IF;

        INSERT INTO cliente (nif, nome, telemovel, genero, nascimento, localidade)
        VALUES (nif_in, nome_in, telemovel_in, genero_in, nascimento_in, localidade_in);
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END regista_cliente;

    PROCEDURE regista_ficha(
        ean_in IN ficha.ean%TYPE,
        marca_in IN ficha.marca%TYPE,
        modelo_in IN ficha.modelo%TYPE,
        tipo_in IN ficha.tipo%TYPE,
        ano_in IN ficha.ano%TYPE,
        preco_in IN ficha.preco%TYPE) 
        IS
        contador INTEGER;
    BEGIN
        IF ano_in > TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) THEN
            RAISE_APPLICATION_ERROR(-20008, 'Ano de lançamento do equipamento é posterior ao ano atual.');
        END IF;

        SELECT COUNT(*) INTO contador FROM ficha FI WHERE (FI.ean = ean_in);

        IF contador > 0 THEN
            UPDATE ficha FI
            SET FI.marca = marca_in, FI.modelo = modelo_in, FI.tipo = tipo_in, FI.ano = ano_in, FI.preco = preco_in
            WHERE (FI.ean = ean_in);
        ELSE
            INSERT INTO ficha (ean, marca, modelo, tipo, ano, preco)
            VALUES (ean_in, marca_in, modelo_in, tipo_in, ano_in, preco_in);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END regista_ficha;

    FUNCTION regista_equipamento(
        ean_in IN equipamento.ficha%TYPE,
        estado_in IN equipamento.estado%TYPE,
        preco_in IN equipamento.preco%TYPE,
        data_in IN equipamento.data%TYPE := SYSDATE
    ) RETURN NUMBER IS
        exemplar_novo equipamento.exemplar%TYPE;
    BEGIN
        SELECT COALESCE(MAX(EQ.exemplar) + 1, 1) INTO exemplar_novo
        FROM equipamento EQ
        WHERE EQ.ficha = ean_in;
    
        INSERT INTO equipamento (ficha, exemplar, estado, preco, data, fatura)
        VALUES (ean_in, exemplar_novo, estado_in, preco_in, data_in, NULL);
    
        RETURN exemplar_novo;
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END regista_equipamento;
    
    FUNCTION regista_compra(
        cliente_in IN cliente.nif%TYPE,
        ean_in IN ficha.ean%TYPE,
        exemplar_in IN equipamento.exemplar%TYPE,
        fatura_in IN fatura.numero%TYPE := NULL
    ) RETURN NUMBER IS
        numero_da_fatura fatura.numero%TYPE;
        data_de_colocacao equipamento.data%TYPE;
        preco equipamento.preco%TYPE;
        cliente_da_fatura cliente.nif%TYPE;
    BEGIN
        SELECT EQ.data INTO data_de_colocacao FROM equipamento EQ WHERE (EQ.ficha = ean_in) AND (EQ.exemplar = exemplar_in);
    
        IF SYSDATE < data_de_colocacao THEN
            RAISE_APPLICATION_ERROR(-20009, 'A data da fatura deve ser posterior à data de colocação do equipamento na loja.');
        END IF;
    
        SELECT EQ.preco INTO preco FROM equipamento EQ WHERE (EQ.ficha = ean_in) AND (EQ.exemplar = exemplar_in);
    
        IF fatura_in IS NULL THEN
            SELECT seq_fatura.NEXTVAL INTO numero_da_fatura FROM dual;
            INSERT INTO fatura (numero, data, cliente)
            VALUES (numero_da_fatura, SYSDATE, cliente_in);
        ELSE
            numero_da_fatura := fatura_in;        
            
            SELECT FA.cliente INTO cliente_da_fatura FROM fatura FA WHERE FA.numero = fatura_in;
            IF cliente_da_fatura != cliente_in THEN
                RAISE_APPLICATION_ERROR(-20010, 'A fatura não pertence ao cliente fornecido.');
            END IF;
        END IF;
        
        UPDATE equipamento EQ SET EQ.fatura = numero_da_fatura WHERE (ean_in=EQ.ficha) AND (exemplar_in=EQ.exemplar);
    
        RETURN numero_da_fatura;
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END regista_compra;

    FUNCTION remove_compra (
        fatura_in IN fatura.numero%TYPE,
        ean_in IN ficha.ean%TYPE := NULL,
        exemplar_in IN equipamento.exemplar%TYPE := NULL
    ) RETURN NUMBER IS
        contador NUMBER;
        resultado NUMBER; --variável apenas para remover as compras, não vai ser necessária em nada
    BEGIN
        IF ean_in IS NULL AND exemplar_in IS NULL THEN
            FOR r IN (SELECT EQ.ficha, EQ.exemplar FROM equipamento EQ 
                    WHERE (EQ.fatura = fatura_in)) LOOP
                resultado := remove_compra(fatura_in, r.ficha, r.exemplar);
            END LOOP;
        ELSE
            DELETE FROM equipamento EQ
            WHERE (EQ.fatura = fatura_in)
            AND (EQ.ficha = ean_in)
            AND (EQ.exemplar = exemplar_in);
    
            UPDATE equipamento EQ
            SET EQ.fatura = NULL
            WHERE (EQ.ficha = ean_in)
            AND (EQ.exemplar = exemplar_in);
        END IF;
    
        SELECT COUNT(*) INTO contador FROM equipamento EQ WHERE (EQ.fatura = fatura_in);
    
        IF contador = 0 THEN
            DELETE FROM fatura FA
            WHERE (FA.numero = fatura_in);
        END IF;
    
        RETURN contador;
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END remove_compra;

    PROCEDURE remove_equipamento (
        ean_in IN equipamento.ficha%TYPE,
        exemplar_in IN equipamento.exemplar%TYPE) 
        IS
        contador NUMBER;
        fatura_numero fatura.numero%TYPE;
        resultado NUMBER; --variável apenas para remover as compras, não vai ser necessária em nada

    BEGIN
        SELECT COUNT(*) INTO contador
        FROM equipamento EQ
        WHERE (EQ.ficha = ean_in)
        AND (EQ.exemplar = exemplar_in)
        AND (EQ.fatura IS NOT NULL);

        IF contador > 0 THEN
            SELECT EQ.fatura INTO fatura_numero FROM equipamento EQ WHERE EQ.ficha = ean_in AND EQ.exemplar = exemplar_in;
            resultado := remove_compra(fatura_numero, ean_in, exemplar_in);
        END IF;
    
        DELETE FROM equipamento EQ
        WHERE (EQ.ficha = ean_in)
        AND (EQ.exemplar = exemplar_in);
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END remove_equipamento;

    PROCEDURE remove_ficha(
        ean_in IN ficha.ean%TYPE) 
        IS
    BEGIN
        FOR r IN (SELECT EQ.exemplar FROM equipamento EQ WHERE (EQ.ficha = ean_in)) LOOP
            remove_equipamento(ean_in, r.exemplar);
        END LOOP;
    
        DELETE FROM ficha FI
        WHERE (FI.ean = ean_in);
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END remove_ficha;

    PROCEDURE remove_cliente(
        nif_in IN cliente.nif%TYPE) 
        IS
        linhas_restantes NUMBER;
    BEGIN
        FOR r IN (SELECT FA.numero FROM fatura FA WHERE (FA.cliente = nif_in)) LOOP
            linhas_restantes := remove_compra(r.numero);
        END LOOP;
    
        DELETE FROM cliente CL
        WHERE (CL.nif = nif_in);
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END remove_cliente;

    FUNCTION lista_compras(
        cliente_in IN cliente.nif%TYPE
    ) RETURN SYS_REFCURSOR IS
        compras_cursor SYS_REFCURSOR;
    BEGIN
        OPEN compras_cursor FOR
            SELECT FA.numero, FA.data, EQ.ficha, EQ.exemplar, FI.marca, FI.modelo, EQ.preco
            FROM fatura FA, equipamento EQ, ficha FI
            WHERE (FA.numero = EQ.fatura)
            AND (EQ.ficha = FI.ean)
            AND (FA.cliente = cliente_in)
            ORDER BY FA.data DESC, EQ.preco DESC;
    
        RETURN compras_cursor;
    EXCEPTION
        WHEN OTHERS THEN
            tratar_excecao;
    END lista_compras;

END pkg_loja;