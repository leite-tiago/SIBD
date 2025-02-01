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

CREATE OR REPLACE PACKAGE pkg_loja IS

    PROCEDURE regista_cliente(
        nif_in IN cliente.nif%TYPE,
        nome_in IN cliente.nome%TYPE,
        telemovel_in IN cliente.telemovel%TYPE,
        genero_in IN cliente.genero%TYPE,
        nascimento_in IN cliente.nascimento%TYPE,
        localidade_in IN cliente.localidade%TYPE
    );

    PROCEDURE regista_ficha(
        ean_in IN ficha.ean%TYPE,
        marca_in IN ficha.marca%TYPE,
        modelo_in IN ficha.modelo%TYPE,
        tipo_in IN ficha.tipo%TYPE,
        ano_in IN ficha.ano%TYPE,
        preco_in IN ficha.preco%TYPE
    );

    FUNCTION regista_equipamento(
        ean_in IN equipamento.ficha%TYPE,
        estado_in IN equipamento.estado%TYPE,
        preco_in IN equipamento.preco%TYPE,
        data_in IN equipamento.data%TYPE := SYSDATE
    ) RETURN NUMBER;

    FUNCTION regista_compra(
        cliente_in IN cliente.nif%TYPE,
        ean_in IN ficha.ean%TYPE,
        exemplar_in IN equipamento.exemplar%TYPE,
        fatura_in IN fatura.numero%TYPE := NULL
    ) RETURN NUMBER;

    FUNCTION remove_compra(
        fatura_in IN fatura.numero%TYPE,
        ean_in IN ficha.ean%TYPE := NULL,
        exemplar_in IN equipamento.exemplar%TYPE := NULL
    ) RETURN NUMBER;

    PROCEDURE remove_equipamento(
        ean_in IN equipamento.ficha%TYPE,
        exemplar_in IN equipamento.exemplar%TYPE
    );

    PROCEDURE remove_ficha(
        ean_in IN ficha.ean%TYPE
    );

    PROCEDURE remove_cliente(
       nif_in IN cliente.nif%TYPE
    );

    FUNCTION lista_compras(
        cliente_in IN cliente.nif%TYPE
    ) RETURN SYS_REFCURSOR;
END pkg_loja;