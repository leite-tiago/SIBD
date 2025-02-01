-- ----------------------------------------------------------------------------
-- SIBD 2024/2025 Etapa 3 Grupo 29 Turma 11
-- Nuno Nobre Nº 61823, Rodrigo Frutuoso Nº 61865, Simão Alexandre Nº61874, Tiago Leite Nº 61863
-- cada aluno contribuiu igualmente para a conclusão deste trabalho
-- ----------------------------------------------------------------------------
cliente(nif,nome,telemovel,genero,nascimento);
ficha(ean,marca,modelo,tipo,ano,preco);
fatura(numero,data,cliente.nif AS cliente);
equipamento(ficha.ean AS ficha,exemplar,estado,preco,data,fatura.numero AS fatura);
-- ----------------------------------------------------------------------------
-- 1) NIF, nome, e idade das clientes femininas com apelido Vieira, que compraram um ou mais
--    equipamentos usados do tipo Pen USB durante o ano de 2023. O EAN-13, número de
--    exemplar, marca, e modelo dos equipamentos também devem ser mostrados, bem como o
--    número e data das respetivas faturas. O resultado deve vir ordenado de forma ascendente
--    pela idade e nome das clientes, e de forma descendente pelo número das faturas e pela
--    marca e modelo dos equipamentos.

SELECT DISTINCT CL.nif, CL.nome, (2024 - CL.nascimento) AS idade, 
                FI.ean, EQ.exemplar, FI.marca, FI.modelo, 
                FA.numero AS numero_fatura, FA.data AS data_fatura
  FROM cliente CL, fatura FA, ficha FI, equipamento EQ
  WHERE (CL.nif = FA.cliente)
   AND (FA.numero = EQ.fatura)
   AND (EQ.ficha = FI.ean)
   AND (CL.genero = 'F')
   AND (CL.nome LIKE '% Vieira')
   AND (FI.tipo = 'Pen USB')
   AND (TO_CHAR(FA.data, 'YYYY') = '2023')
ORDER BY idade ASC, CL.nome ASC, FA.numero DESC, FI.marca DESC, FI.modelo DESC;

-- ----------------------------------------------------------------------------
-- 2) NIF e nome dos clientes masculinos que, considerando apenas compras efetuadas em
--    2023, ou não compraram equipamentos usados da marca Asus ou compra+ram equipamentos 
--    dessa marca até um máximo de duas ocasiões. Assuma que cada fatura representa uma
--    ocasião de compra, independentemente do número de equipamentos (em particular, da
--    marca Asus) mencionados na fatura. Adicionalmente, os clientes resultantes não podem ter
--    comprado equipamentos em mau estado de conservação, seja qual for a marca e o ano da
--    compra. O resultado deve vir ordenado pelo nome dos clientes de forma ascendente e pelo
--    NIF dos clientes de forma descendente.

SELECT DISTINCT CL.nif, CL.nome
  FROM cliente CL, fatura FA, equipamento EQ
 WHERE CL.nif = FA.cliente
   AND FA.numero = EQ.fatura
   AND CL.genero = 'M'
   AND TO_CHAR(FA.data, 'YYYY') = '2023'
   AND (EQ.marca <> 'Asus' 
        OR (EQ.marca = 'Asus' 
            AND (
                SELECT COUNT(DISTINCT FA2.numero)
                FROM fatura FA2, equipamento EQ2
                WHERE FA2.cliente = CL.nif
                  AND FA2.numero = EQ2.fatura
                  AND EQ2.marca = 'Asus'
                  AND TO_CHAR(FA2.data, 'YYYY') = '2023'
            ) <= 2
        )
    )
   AND NOT EXISTS (
        SELECT *
        FROM fatura FA3, equipamento EQ3
        WHERE FA3.cliente = CL.nif
          AND FA3.numero = EQ3.fatura
          AND EQ3.estado = 'MAU'
    )
ORDER BY CL.nome ASC, CL.nif DESC;

-- ----------------------------------------------------------------------------
-- 3) Fichas de equipamento (por exemplo, marca Apple e modelo iPhone 15) tais que todos os
--    clientes da localidade do Porto tenham comprado pelo menos um exemplar de equipamento usado, 
--    com as seguintes restrições adicionais: só fichas de equipamento tais que nenhum exemplar de 
--    equipamento (ainda na loja ou já comprado) tenha um preço de venda inferior a 50% do preço de 
--    lançamento, e as compras têm de ter sido realizadas entre as 10h e as 17h59. 
--    Nota: a data de uma fatura também guarda horas e minutos.

SELECT DISTINCT FI.marca, FI.modelo 
  FROM ficha FI, equipamento EQ, fatura FA, cliente CL
 WHERE (FI.ean = EQ.ficha)
    AND (EQ.fatura = FA.numero)
    AND (FA.cliente = CL.nif)
    AND (CL.localidade = 'Porto')
    AND (EQ.preco >= FI.preco * 0.5)
    AND (TO_CHAR(FA.data, 'HH24') BETWEEN '10' AND '17')
    AND NOT EXISTS (
        SELECT *
        FROM equipamento EQ2
        WHERE (EQ2.ficha = FI.ean)
          AND (EQ2.preco < EQ2.preco_lancamento * 0.5)
    )
GROUP BY FI.marca, FI.modelo
HAVING COUNT(DISTINCT CL.nif) = (SELECT COUNT(*) FROM cliente WHERE localidade = 'Porto');

-- ----------------------------------------------------------------------------
-- 4) NIF e nome dos clientes que gastaram mais dinheiro em compras de equipamentos usados
--    do tipo Telemóvel em cada ano, separadamente para clientes femininos e masculinos, 
--    devendo o género dos clientes e o total gasto em cada ano também aparecer no resultado. 
--    A ordenação do resultado deve ser pelo ano de forma descendente e pelo género dos clientes
--    de forma ascendente. No caso de haver mais do que um ou uma cliente com o mesmo máximo de 
--    dinheiro gasto num ano, devem ser mostrados todos esses clientes.

SELECT DISTINCT  CL.nif, CL.nome, CL.genero, TO_CHAR(FA.data, 'YYYY') AS ano, SUM(EQ.preco) AS total_gasto
FROM cliente CL, fatura FA, equipamento EQ, ficha FI
WHERE (CL.nif = FA.cliente)
   AND (FA.numero = EQ.fatura)
   AND (EQ.ficha = FI.ean)
   AND (FI.tipo = 'Telemóvel')
GROUP BY (CL.nif, CL.nome, CL.genero, TO_CHAR(FA.data, 'YYYY'))
HAVING SUM(EQ.preco) = (
    SELECT MAX(SUM(EQ2.preco))
    FROM cliente CL2, equipamento EQ2, fatura FA2, ficha FI2
    WHERE (CL2.nif = FA2.cliente)
      AND (EQ2.ficha = FI2.ean)
      AND (FA2.numero = EQ2.fatura)
      AND (FI2.tipo = 'Telemóvel')
      AND CL.genero = CL2.genero
      AND TO_CHAR(FA.data, 'YYYY') = TO_CHAR(FA2.data, 'YYYY')
    GROUP BY (CL2.nif, CL2.nome)
)
ORDER BY CL.genero ASC, TO_CHAR(FA.data, 'YYYY') DESC;
-- ----------------------------------------------------------------------------