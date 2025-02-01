--7
    --Indique afirmações verdadeiras (V) ou falsas (F) sobre diagramas de classes UML.
    --V Servem para representar estrutura, mais especificamente tipos de conceitos e suas associações.
    --V As classes associativas correspondem às agregações do modelo entidade-associação (EA).
    --F Permitem definir limites de participação numa associação, como de 2 até 5, tal como no modelo EA.
    --F Requerem a identificação explícita de chaves primárias, tal como no modelo EA.
    --V Admitem o uso de papéis nos extremos das associações, para facilitar a interpretação.

--11
    --Indique afirmações verdadeiras (V) ou falsas (F) sobre diagramas de classes UML.
    --V Pode ser usado para representar comportamento procedimental e paralelismo.
    --V As composições correspondem às entidades fracas do modelo entidade-associação (EA).
    --V Permite definir limites de participação de um objeto numa associação (ex. de 2 até 5).
    --F As subclasses correspondem às generalizações do modelo EA.
    --F As chaves primárias são escritas em texto sublinhado.

--12 
    --Indique afirmações verdadeiras (V) ou falsas (F) sobre o modelo entidade-associação (EA).
    --F As chaves primárias costumam ser escritas com um sublinhado a tracejado.
    --V Os papéis são usados para desambiguar a interpretação de associações entre entidades.
    --F Podem existir várias chaves primárias, mas apenas uma pode ser chave candidata.
    --V Os dois tipos de restrições em associações são de chave e de participação.
    --F A restrição de participação total é representada por uma linha com traço fino
--23
    Create table Z(
    A NUMBER (4),
    C VARCHAR(40),

    CONSTRAINT pk_X PRIMARY KEY (A) NOT NULL,
    CONSTRAINT fk_A_Z FOREIGN KEY (A) REFERENCES X(A) 
    );
    Create table R(
    A NUMBER (4) NOT NULL,
    E NUMBER (4) NOT NULL,
    D VARCHAR(40),

    CONSTRAINT pk_X PRIMARY KEY (A,E),
    CONSTRAINT fk_R_A FOREIGN KEY (A) REFERENCES Z(A)
    CONSTRAINT fk_R_D FOREIGN KEY (E) REFERENCES W(E)  
    );
    --b)
    INSERT INTO X(A,B) VALUES (1,’SIBD’);
    DELETE FROM W WHERE (E=2);
    SELECT * FROM X WHERE(A>=5);

--24
    CREATE TABLE Y{
    A NUMBER(4) NOT NULL,
    C NUMBER(4) NOT NULL,
    D VARCHAR(40),

    PRIMARY KEY  (A,C)
    FOREIGN KEY (A) REFERENCES X(A) 
    }

    CREATE TABLE Y{
    A NUMBER(4) NOT NULL,
    C NUMBER(4) NOT NULL,
    D VARCHAR(40),

    PRIMARY KEY  (A,C)
    FOREIGN KEY (A) REFERENCES X(A) 
    }

    --b)
    INSERT INTO Z(F,G) VALUES (2,’GB’);
    UPDATE X SET (B=‘IBD’) WHERE(A=1);
    SELECT * FROM Z WHERE(F<=8);

--25
    --Indique afirmações verdadeiras (V) ou falsas (F) sobre o desenho lógico de bases de dados. 
    --F Nunca se usa ON DELETE CASCADE na tradução de hierarquias para o modelo relacional. 
    --V Uma chave estrangeira pode referenciar qualquer chave candidata de outra tabela. 
    --V Alguns conjuntos de associações podem não dar origem a novas tabelas no modelo relacional. 
    --F Uma relação na 1FN com apenas um atributo não chave está sempre na terceira forma normal. 
    --F A criação de tabelas apenas para as especializações é adequada para todas as hierarquias. 
--26
    --Indique afirmações verdadeiras (V) ou falsas (F) sobre o desenho lógico de bases de dados. 
    --F Uma relação cuja chave tem um só atributo está automaticamente na segunda forma normal (2FN). 
    --F Os conjuntos de associações do modelo EA dão sempre origem a novas tabelas no modelo relacional. 
    --V Usa-se ON DELETE CASCADE na tradução de entidades fracas para o modelo relacional. 
    --V Uma tabela pode ter uma chave estrangeira que referencia a chave primária da própria tabela. 
    --V Uma vista tem sempre um comando SELECT associado.
--27
    CREATE TABLE R(
        A NUMBER(4) NOT NULL, 
        C NUMBER(4) NOT NULL, 

        PRIMARY KEY(A,C),
        FOREIGN KEY(A) REFERENCES X(A),
        FOREIGN KEY(C) REFERENCES Y(C),
    )

    CREATE TABLE S{
        A NUMBER(4) NOT NULL, 
        C NUMBER(4) NOT NULL, 
        E VARCHAR(40),
        F NUMBER(4) NOT NULL,

        PRIMARY KEY(A,C,F), 
        FOREIGN KEY(A,C) REFERENCES R,
        FOREIGN KEY(F) REFERENCES Z,
    }
--28
    -- Indique afirmações verdadeiras (V) ou falsas (F) sobre o desenho lógico de bases de dados. 
    --V A integridade de coluna é um refinamento da integridade de domínio. 
    --V As vistas podem ser usadas para restringir os dados que cada utilizador pode consultar. 
    --F Uma relação cuja chave tem um só atributo está automaticamente na terceira forma normal (3FN). 
    --F O comando para adicionar colunas a uma tabela da base de dados é UPDATE TABLE. 
    --V A restrição de integridade FOREIGN KEY aceita valores nulos

--29
    -- Preencha o texto em falta em cada afirmação sobre desenho lógico de bases de dados. 
    --• Dentro da cláusula CHECK de uma asserção estão sempre um ou mais comandos... de verificação de restrições
    --• A chave candidata de uma relação tem obrigatoriamente as restrições NOT NULL e... UNIQUE
    --• Dado um conjunto de chaves candidatas, a chave considerada primária costuma ser a que... é mais simples para a utilização
    --• Após a normalização de um esquema relacional, o número de relações resultante costuma ser... maior
    --• Uma vantagem de criar tabelas para a generalização e especializações de uma hierarquia é... não repetir atributos

--30
    --Indique afirmações verdadeiras (V) ou falsas (F) sobre o modelo relacional. 
    --F Uma chave estrangeira só pode referenciar a chave primária de outra tabela. 
    --F O comando para remover uma tabela da base de dados é DELETE TABLE. 
    --V Duas propriedades das chaves candidatas são a unicidade e a minimalidade. 
    --V Uma restrição declarativa que abrange várias tabelas designa-se asserção. 
    --V A integridade de domínio é um refinamento da integridade de coluna.

--31
    --Indique afirmações verdadeiras (V) ou falsas (F) sobre o desenho lógico de bases de dados. 
    --V A normalização de esquemas relacionais procura prevenir anomalias aquando de escritas de dados. 
    --F O comando ALTER TABLE não serve para remover restrições de integridade declarativas. 
    --V As vistas permitem que os utilizadores não se apercebam de eventuais alterações no esquema lógico. 
    --F Uma hierarquia do modelo EA pode ser traduzida criando novas tabelas apenas para as especializações. 
    --F A restrição de integridade FOREIGN KEY obriga sempre o preenchimento de valores.

--32
    CREATE TABLE R(
        C VARCHAR(40),
        A NUMBER(4) NOT NULL,
        D NUMBER(4) NOT NULL,
        F NUMBER(4) NOT NULL,


        PRIMARY KEY(A,D),
        FOREIGN KEY A REFERENCES X(A),
        FOREIGN KEY D REFERENCES Y(D)
        FOREIGN KEY D REFERENCES Z(F)
    )

--35
    --a) 
    -- A correção teria de ser feita em todas as linhas em que o piloto aparece, pois o nome pode estar presente 
    -- em várias temporadas.

    --b) 
    Piloto(passaporte_piloto, nome_piloto)
    Equipa(nome_equipa, data_fundação_equipa )
    PilotoEmTemporada(passaporte_piloto, ano_temporada, equipa.nome_equipa,cargo)

--40
    --b)
        Candidato(e-mail_candidato,nome_candidato)
        StartUp(e-mail_startup, nome_startup)
        Candidatura(id_seq_oferta, cargo_oferta,e-mail_startup, data_candidatura, e-mail_candidato)
 
--51
    --a)
        SELECT A.nome, A.número, (2025-A.nascimento) AS idade, A.país
        FROM Atleta A
        WHERE A.nome LIKE 'A%' 
        AND (2025 - A.nascimento) > 25
        AND NOT EXISTS (
            SELECT * 
            FROM Participa P1, Jogos J1
            WHERE P1.atleta = A.número
            AND P1.jogos = J1.edição
            AND J1.país = A.país
            AND P1.posição > 3
        )
        ORDER BY A.país ASC, A.número DESC;
--53
    Utente (número, nome, sexo, nascimento, localidade)
    Hospital (nome, localidade, camas)
    Internamento (utente.número AS utente, hospital.nome AS hospital, desde, até)
    Com (internamento.utente AS utente, internamento.hospital AS hospital,
        internamento.desde AS desde, sintoma)

    --a) 
        SELECT DISTINCT U.número, U.nome, U.sexo
        FROM Utente U, Internamento I, Com C
        WHERE(U.número=I.utente)
        AND(I.utente=C.utente)
        AND(C.sintome='febre')
        AND(TO_CHAR(I.até, 'YYYY') -TO_CHAR(I.desde, 'YYYY')=1)
        ORDER BY I.desde DESC, I.até DESC, I.utente ASC
    
    --b)
        SELECT DISTINCT U.número, U.nome, U.nascimento
        FROM Utente U, Internamento I
        WHERE(U.número=I.utente)
        AND(U.sexo='F')
        AND(U.nacimento>60)
        AND(U.nacimento<80)
        AND(U.nome LIKE '% A')
        AND(I.hospital <>'Lisboa')
    
    --c) 
        SELECT DISTINCT U.número, U.nome
        FROM Utente U, Hospital H, Internamento I
        WHERE(U.número=I.utente)
        AND(H.nome=I.hospital)
        AND(H.camas<(SELECT AVG(H2.camas) FROM Hospital H2)) 
        HAVING COUNT(DISTINCT H.nome) = (SELECT COUNT(H1.nome)
                            FROM Hospital H1
                            WHERE H1.camas 
                            < (SELECT AVG(H3.camas) FROM Hospital H3));

--55 
    --a)
        SELECT JO.nome, JO.nif, (2025-JO.nascimento) AS idade, JO.clube
        FROM Clube C, Jogo J, Jogadora JO, Participa P
        WHERE(JO.clube=C.sigla) 
        AND(C.sigla=P.visitante)
        AND(P.visitante=J.visitante)
        AND((2025-JO.nascimento)<25)
        AND(J.clube LIKE 'L%')
        AND NOT EXISTS(SELECT *
                        FROM Participa P2
                        WHERE(C.sigla=P2.visitante)
                        AND(JO.nif=P2.jogadora)
                        )
        ORDER BY JO.clube DESC, JO.nome DESC

    --b)
        SELECT JO.nome, JO.nif
        FROM Clube C, Jogo J, Jogadora JO, Participa P
        WHERE(C.sigla=P.visitante)
        AND P.jogadora = JO.nif
        AND(P.visitante=J.visitante)
        AND(JO.clube=P.casa)
        GROUP BY JO.nome, JO.nif
        HAVING(COUNT(DISTINCT(P.jogadora)))=(SELECT COUNT (*)
                                            FROM Jogo P2, 
                                            WHERE(P2.casa=JO.clube)
                                            )
    --c) 
        SELECT C.nome,
        FROM Clube C, Jogo J, Jogadora JO, Participa P
        WHERE(JO.nif=P.jogadora)
        AND(P.casa=C.sigla)
        AND(C.sigla=J.casa)
        GROUP BY C.sigla
        HAVING (COUNT(DISTINCT(C.sigla)))>10
                AND(COUNT(DISTINCT(P.jogadora))>(SELECT AVG(COUNT(DISTINCT(P2.jogadora)))
                                            FROM Clube C2, Participa P2
                                            WHERE (C2.sigla = P2.casa)
                                                    OR (C2.sigla = P2.visitante)
                                            GROUP BY C2.sigla
                                            ))


--82
    --Preencha o texto em falta em cada afirmação sobre gestão de transações pelo SGBD. 
    --• No strict two-phase locking o momento de libertação de locks é... 
    --• Em caso de falta, o gestor de recuperação garante durabilidade e... 
    --• A anomalia T1:READ(O), T2:WRITE(O), T1:READ(O) designa-se... Unrepeatable read
    --• No protocolo de recuperação ARIES, a última de três fases tem o nome de... 
    --• A sequência T1:WRITE(X), T2:WRITE(Y), T1:WRITE(Y), T2:WRITE(X), causa um..

--EXAME 2024 GRUPO 3
    --a)
        SELECT DISTINCT M.nome, M.nif, (2024-M.nascimento) AS idade, M.genero 
        FROM Motorista M
        WHERE(2024-M.nascimento <40)
        AND(M.nome LIKE 'D%')
        AND NOT EXISTS(SELECT *
                        FROM Viagem V1, Taxi T1
                        WHERE(M.nif = V1.motorista)
                        AND(V1.taxi=T1.matricula)
                        AND(T1.conforto = 'L')
                        )
        ORDER BY M.genero ASC, M.nif DESC;
    
    --b)
        CREATE VIEW minutos_conduzidos(nif_motorista, total_minutos) 
                    AS(SELECT M.nif, SUM(minutos_que_passaram(V.inicio,V.fim))
                        FROM Motorista M, Viagem V
                        WHERE(M.nif=V.motorista)
                        GROUP BY M.nif;
                    )

    

    --c)
        --1ºSOLUÇÃO
            SELECT M.nome, M.nif
            FROM Motorista M, Taxi T, minutos_conduzidos C
            WHERE((SELECT COUNT(DISTINCT V.taxi)
                FROM Viagem V
                WHERE V.motorista = M.nif) > 5)

            AND ((SELECT C.total_minutos
                FROM minutos_conduzidos C
                WHERE C.nif_motorista = M.nif) > 
                (SELECT AVG(C1.total_minutos)
                FROM minutos_conduzidos C1));
        --2ºSOLUÇÃO
            SELECT M.nome, M.nif
            FROM Motorista M, Taxi T, minutos_conduzidos C
            WHERE (M.nif = V.motorista)
            AND (M.nif = C.nif_motorista)
            GROUP BY M.nif, M.nome
            HAVING (COUNT(DISTINCT V.matrícula) > 5
                    AND
                    (C.total_minutos) > (
                        SELECT AVG(total_minutos) FROM minutos_conduzidos));
    
    --d)
        SELECT M.nome, M.nif, M.genero
        FROM Motorista M, Taxi T, Viagem V
        WHERE(M.nif=V.motorista)
        AND(M.localidade='Porto')
        AND(TO_CHAR(V.inicio,'YYYY')>=2022)
        AND(TO_CHAR(V.fim,'YYYY')<=2023)
        HAVING (COUNT (DISTINCT T.matriculas))=(SELECT COUNT (DISTINCT(T2.matricula))
                                FROM Taxi T2
                                WHERE(V.taxi=T2.matricula)
                                AND(T2.marca='Fiat')
                                );
    
--OUTRO QUALQUER


    ConcorrenteEmEdicao(nif_concorrente, nome_tvshow, ano edição, pais edição, 
    nome_concorrente, pais_origem_tvshow, ano_inicio_tvshow, data_concorreu).

    Pessoa(nif_concorrente,nome_concorrente)
    Programa(nome_tvshow,pais_origem_tvshow,ano_inicio_tvshow)
    EdiçãoPrograma(ano edição,nome_tvshow, pais edição)
    Concorrente(nif_concorrente,nome_tvshow,ano edição,pais edição,data_concorreu)

-- INTERROGAÇÕES
    cliente(nif,nome,telemovel,genero,nascimento);
    ficha(ean,marca,modelo,tipo,ano,preco);
    fatura(numero,data,cliente.nif AS cliente);
    equipamento(ficha.ean AS ficha,exemplar,estado,preco,data,fatura.numero AS fatura);
--  
      CREATE TABLE Z(
        C VARCHAR(40),
        A NUMBER(4),
        E NUMBER(4) NOT NULL,
        D VARCHAR(40),

        PRIMARY KEY(A),
        FOREIGN KEY A REFERENCES X(A),
        FOREIGN KEY E REFERENCES W(E) ON DELETE NO ACTION,
      )

      CREATE TABLE R(
        D VARCHAR(40),
        A NUMBER(4),
        E NUMBER(4) NOT NULL,

        PRIMARY KEY (A), 
        FOREIGN KEY A REFERENCES Z(A),
        FOREIGN KEY E REFERENCES W(E)
      )

    INSERT INTO X(A,B) VALUES (1,'SIBD');
    DELETE FROM W WHERE (E=2);
    SELECT * FROM X WHERE (A>=5);





