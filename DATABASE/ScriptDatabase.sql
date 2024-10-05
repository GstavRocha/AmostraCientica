create table tbAlunos
(
    idAlunos          int auto_increment
        primary key,
    nomeAluno         varchar(60) not null,
    Responsavel       varchar(60) not null comment 'responśavel financeiro cadastrado',
    NumeroResponsavel varchar(60) not null,
    Turma             varchar(60) not null
);

create table tbProfessores
(
    idProfessores int auto_increment
        primary key,
    nomeProfessor varchar(50) not null
);

create table tbGruposdeTrabalho
(
    idGrupos         int auto_increment
        primary key,
    nomeGrupo        varchar(30) not null,
    idProfessorGrupo int         not null,
    idAlunosGrupo    int         not null,
    constraint fk_AlunosGrupo
        foreign key (idAlunosGrupo) references tbAlunos (idAlunos),
    constraint fk_tbProfessorGrupo
        foreign key (idProfessorGrupo) references tbProfessores (idProfessores)
);

create table tbTrabalhos
(
    idTrabalhos    int auto_increment
        primary key,
    tituloTrabalho varchar(200) not null,
    descricao      text         not null,
    local          varchar(60)  not null,
    horario        timestamp    not null,
    idgrupo        int          not null,
    constraint fk_grupo_trabalho
        foreign key (idgrupo) references tbGruposdeTrabalho (idGrupos)
);

create table tbQrCode
(
    idQr         int auto_increment
        primary key,
    tipoQr       enum ('ass', 'apr') null comment 'ass: assistiu, apr: apresentou',
    idQrTrabalho int                 not null,
    qrCode       blob                not null,
    constraint fk_idTrabalho
        foreign key (idQrTrabalho) references tbTrabalhos (idTrabalhos)
);

create table tbEscaneamentos
(
    idEscaneamento   int auto_increment
        primary key,
    idQrCode         int                                 not null,
    idAluno          int                                 not null,
    dataEscaneamento timestamp default CURRENT_TIMESTAMP null,
    constraint tbEscaneamentos_ibfk_1
        foreign key (idQrCode) references tbQrCode (idQr),
    constraint tbEscaneamentos_ibfk_2
        foreign key (idAluno) references tbAlunos (idAlunos)
);

create index idAluno
    on tbEscaneamentos (idAluno);

create index idQrCode
    on tbEscaneamentos (idQrCode);

create definer = root@localhost trigger trgAtualizarPontuacao
    after insert
    on tbEscaneamentos
    for each row
BEGIN
    DECLARE idTrabalho INT;
    DECLARE pontosExistentes INT;

    -- Obter o id do trabalho associado ao QR code escaneado
    SELECT idQrTrabalho INTO idTrabalho
    FROM tbQrCode
    WHERE idQr = NEW.idQrCode;

    -- Verificar se o aluno já tem uma pontuação registrada para este trabalho
    SELECT pontos INTO pontosExistentes
    FROM tbPontuacoes
    WHERE idAluno = NEW.idAluno AND idTrabalhos = idTrabalho;

    IF pontosExistentes IS NULL THEN
        -- Se não houver pontuação, inserir nova pontuação
        INSERT INTO tbPontuacoes(idAluno, idTrabalhos, pontos, idVisitante)
        VALUES (NEW.idAluno, idTrabalho, 1, NULL); -- Adiciona 10 pontos por padrão, ajuste conforme necessário
    ELSE
        -- Se houver pontuação, incrementar a pontuação existente
        UPDATE tbPontuacoes
        SET pontos = pontos + 1 -- Incrementa a pontuação (ajuste o valor conforme necessário)
        WHERE idAluno = NEW.idAluno AND idTrabalhos = idTrabalho;
    END IF;
END;

create table tbVisitantes
(
    idVisitante          int auto_increment
        primary key,
    nomeVisitante        varchar(60)  not null,
    emailVisitante       varchar(100) not null,
    telefoneVisitante    varchar(15)  null,
    idTrabalhosVisitados int          not null,
    idQrCodeVisitados    int          not null,
    constraint fk_visistante_qrcode
        foreign key (idQrCodeVisitados) references tbQrCode (idQrTrabalho)
);

create table tbPontuacoes
(
    idPontuacao int auto_increment
        primary key,
    idAluno     int           not null,
    idTrabalhos int           not null,
    pontos      int default 0 not null,
    idVisitante int           not null,
    constraint fk_alunos_pontuacao
        foreign key (idAluno) references tbAlunos (idAlunos),
    constraint fk_trabalho_grupos
        foreign key (idTrabalhos) references tbTrabalhos (idTrabalhos),
    constraint fk_visitante_pontuacao
        foreign key (idVisitante) references tbVisitantes (idVisitante)
);

create index fk_visistante_pontuacao
    on tbVisitantes (idTrabalhosVisitados);

create definer = root@localhost view buscarAluno as
select `dbAmostra`.`tbAlunos`.`idAlunos`          AS `idAlunos`,
       `dbAmostra`.`tbAlunos`.`nomeAluno`         AS `nomeAluno`,
       `dbAmostra`.`tbAlunos`.`Responsavel`       AS `Responsavel`,
       `dbAmostra`.`tbAlunos`.`NumeroResponsavel` AS `NumeroResponsavel`,
       `dbAmostra`.`tbAlunos`.`Turma`             AS `Turma`
from `dbAmostra`.`tbAlunos`;

-- comment on column buscarAluno.Responsavel not supported: responśavel financeiro cadastrado

create definer = root@localhost view vwAlunosPontuacoes as
select `a`.`nomeAluno` AS `nomeAluno`, `t`.`tituloTrabalho` AS `tituloTrabalho`, `p`.`pontos` AS `pontos`
from ((`dbAmostra`.`tbAlunos` `a` join `dbAmostra`.`tbPontuacoes` `p`
       on ((`a`.`idAlunos` = `p`.`idAluno`))) join `dbAmostra`.`tbTrabalhos` `t`
      on ((`p`.`idTrabalhos` = `t`.`idTrabalhos`)));

create definer = root@localhost view vwPontos as
select `pt`.`pontos` AS `pontos`, `tr`.`tituloTrabalho` AS `tituloTrabalho`
from (`dbAmostra`.`tbPontuacoes` `pt` join `dbAmostra`.`tbTrabalhos` `tr`
      on ((`pt`.`idTrabalhos` = `tr`.`idTrabalhos`)));

create definer = root@localhost view vwPontosGrupos as
select `tT`.`tituloTrabalho` AS `tituloTrabalho`,
       `tg`.`nomeGrupo`      AS `nomeGrupo`,
       `pr`.`nomeProfessor`  AS `nomeProfessor`,
       `ta`.`nomeAluno`      AS `nomeAluno`,
       `tp`.`pontos`         AS `pontos`
from ((((`dbAmostra`.`tbGruposdeTrabalho` `tg` join `dbAmostra`.`tbProfessores` `pr`
         on ((`tg`.`idProfessorGrupo` = `pr`.`idProfessores`))) join `dbAmostra`.`tbAlunos` `ta`
        on ((`tg`.`idAlunosGrupo` = `ta`.`idAlunos`))) join `dbAmostra`.`tbTrabalhos` `tT`
       on ((`tg`.`idAlunosGrupo` = `tT`.`idgrupo`))) join `dbAmostra`.`tbPontuacoes` `tp`
      on ((`tp`.`idTrabalhos` = `tT`.`idTrabalhos`)));

create definer = root@localhost view vwProfessoresGrupos as
select `p`.`nomeProfessor` AS `nomeProfessor`, `g`.`nomeGrupo` AS `nomeGrupo`
from (`dbAmostra`.`tbProfessores` `p` join `dbAmostra`.`tbGruposdeTrabalho` `g`
      on ((`p`.`idProfessores` = `g`.`idProfessorGrupo`)));

create definer = root@localhost view vwQrTrabalhos as
select `qr`.`qrCode` AS `qrCode`, `tT`.`tituloTrabalho` AS `tituloTrabalho`, `tT`.`descricao` AS `descricao`
from (`dbAmostra`.`tbQrCode` `qr` join `dbAmostra`.`tbTrabalhos` `tT` on ((`qr`.`idQrTrabalho` = `tT`.`idTrabalhos`)));

create
    definer = root@localhost procedure spAtualizarAluno(IN spIdAluno int, IN spNomeAluno varchar(60),
                                                        IN spTurma varchar(60), IN spResponsavel varchar(60),
                                                        IN spNumero varchar(60))
BEGIN
    UPDATE tbAlunos
    SET nomeAluno = spNomeAluno, Turma = spTurma, Responsavel = spResponsavel, NumeroResponsavel = spNumero
    WHERE idAlunos = spIdAluno;
END;

create
    definer = root@localhost procedure spDeletarAluno(IN spIdAluno int)
BEGIN
    DELETE FROM tbAlunos WHERE idAlunos = spIdAluno;
END;

create
    definer = root@localhost procedure spDeletarQrCode(IN spIdQr int)
BEGIN
    DELETE FROM tbQrCode WHERE idQr = spIdQr;
END;

create
    definer = root@localhost procedure spInserirAluno(IN spNomeAluno varchar(60), IN spTurma varchar(60),
                                                      IN spResponsavel varchar(60), IN spNumero varchar(60))
BEGIN
    DECLARE chkUser varchar(60);
    SELECT al.nomeAluno into  chkUser from tbAlunos al where nomeAluno like  concat('%',spNomeAluno,'%');
    IF chkUser is not null then
        insert into tbAlunos(nomeAluno,Turma, Responsavel, NumeroResponsavel) values (spNomeAluno, spTurma, spResponsavel, spNumero);
        SELECT "USUARIO CRIADO" as RESULTADO;
    ELSE
        SELECT "USUARIO JA EXISTE" AS RESULTADO;
    end if ;
end;

create
    definer = root@localhost procedure spInserirProfessor(IN spNomeProfessor varchar(50))
BEGIN
    INSERT INTO tbProfessores(nomeProfessor) VALUES (spNomeProfessor);
END;

create
    definer = root@localhost procedure spInserirVisitante(IN spNomeVisitante varchar(60),
                                                          IN spEmailVisitante varchar(100),
                                                          IN spTelefoneVisitante varchar(15),
                                                          IN spIdTrabalhoVisitado int, IN spIdQrVisitado int)
BEGIN
    INSERT INTO tbVisitantes(nomeVisitante, emailVisitante, telefoneVisitante, idTrabalhosVisitados, idQrCodeVisitados)
    VALUES (spNomeVisitante, spEmailVisitante, spTelefoneVisitante, spIdTrabalhoVisitado, spIdQrVisitado);
END;

create
    definer = root@localhost procedure spQr(IN spQrCode blob, IN spQrIdTrabalho int, IN spTipoQr enum ('ass', 'apr'))
BEGIN
    DECLARE checkIdtrabalho int;
    SELECT qR.idQrTrabalho into checkIdtrabalho FROM tbQrCode qR inner join tbTrabalhos tT on qR.idQrTrabalho = tT.idTrabalhos where qR.idQrTrabalho = spQrIdTrabalho;
    IF checkIdtrabalho > 0 THEN
        SELECT 'Não pode Criar QR' AS RESULTADO;
    ELSE
         INSERT INTO tbQrCode(tipoQr, idQrTrabalho, qrCode) VALUES (spTipoQr,spQrIdTrabalho, spQrCode);
         SELECT 'QR adicionado' AS RESULTADO;
    end if;
end;

INSERT INTO tbAlunos( nomeAluno, Responsavel, NumeroResponsavel, Turma) VALUES ('gustavo','lucky','2323','6');

use dbAmostra;
drop procedure spInserirAluno;
drop procedure spAtualizarAluno;
alter table tbAlunos add column senha varchar(60) not null , add column login varchar(30), add column createAt timestamp default current_timestamp on update current_timestamp;
alter table tbAlunos drop column senha, drop column login;
select * from tbAlunos;

alter table tbAlunos add column idGrupoAlunos int;
ALTER TABLE tbAlunos
    ADD CONSTRAINT fk_idgrupoaluno
        FOREIGN KEY (idGrupoAlunos)
ALTER TABLE tbGruposdeTrabalho add column idTrabalhoGrupo int;
ALTER TABLE tbGruposdeTrabalho add constraint fk_trabalhoGrupo FOREIGN KEY (idTrabalhoGrupo) REFERENCES tbTrabalhos(idTrabalhos);
ALTER TABLE tbGruposdeTrabalho add constraint fk_trabalhoGrupo FOREIGN KEY (idTrabalhoGrupo) REFERENCES tbTrabalhos(idTrabalhos);
ALTER TABLE tbGruposdeTrabalho modify column idTrabalhoGrupo int unique;
CREATE TABLE tbResponsavel(
                              idResponsavel int primary key auto_increment not null,
                              nomeResponsavel varchar(10) not null,
                              tipoResponsavel ENUM('resp','visit') COMMENT 'resp - responsavel, visita - visitante'
);
ALTER TABLE tbAlunos DROP COLUMN NumeroResponsavel;
alter table tbAlunos add column idResponsavelAlunos int, add constraint fk_idAlunoResponsavel foreign key (idResponsavelAlunos) REFERENCES tbResponsavel(idResponsavel);
SELECT * FROM tbQrCode;
ALTER TABLE tbQrCode modify column idQrTrabalho int unique;
ALTER TABLE tbQrCode add constraint fk_idTrabalhoQr FOREIGN KEY (idQrTrabalho) REFERENCES tbTrabalhos(idTrabalhos);
ALTER TABLE tbEscaneamentos add constraint fk_tbEscaneamento FOREIGN KEY (idQrCode) REFERENCES  tbQrCode(idQr);
alter table tbProfessores add constraint fk_tbprofessoreTurma FOREIGN KEY (idTurma) REFERENCES tbAlunos(idAlunos);
ALTER TABLE tbProfessores add constraint fk_tbprofessorTbGrupoTrabalho foreign key (idGrupoTrabalho) REFERENCES tbGruposdeTrabalho(idGrupos);

ALTER TABLE tbProfessores add column idTurma int not null;
ALTER TABLE tbProfessores add column idGrupoTrabalho int not null;
ALTER TABLE tbGruposdeTrabalho add constraint fk_tbTrabalhosid FOREIGN KEY (idTrabalhoGrupo) REFERENCES tbTrabalhos(idTrabalhos);
DROP table tbPontuacoes;

CREATE TABLE tbPontos (
                          idPonto INT PRIMARY KEY,
                          idTrabalho INT,
                          idAluno INT,
                          nota DECIMAL(5,2),
                          FOREIGN KEY (idTrabalho) REFERENCES tbTrabalhos(idTrabalhos),
                          FOREIGN KEY (idAluno) REFERENCES tbAlunos(idAlunos),
                          UNIQUE (idTrabalho, idAluno) -- Cada aluno e trabalho podem ter uma nota
);




select * from tbGruposdeTrabalho;
ALTER TABLE  tbResponsavel ADD COLUMN idVisitante, ADD CONSTRAINT fk_tbVistanteResponsavel FOREIGN KEY (idVisitante) REFERENCES tbVisitantes(idVisitante);

DROP view buscarAluno;
ALTER TABLE tbResponsavel ADD COLUMN idVisitante, ADD CONSTRAINT fk_tbVistanteResponsavel FOREIGN KEY (idVisitante) REFERENCES tbVisitantes(idVisitante);
CREATE TABLE tbTurma(
                        idTurma int primary key auto_increment not null,
                        nomeTurma varchar(15) not null,
                        turno enum('nm', 'tr'),
                        segMento enum('f1','f2','md')
);


ALTER TABLE tbAlunos ADD CONSTRAINT fk_alunosTurmas FOREIGN KEY (idTurmaAlunos) REFERENCES tbTurma(idTurma);

SELECT * FROM tbAlunos;
SELECT * FROM tbResponsavel;
SELECT * FROM tbGruposdeTrabalho;
CREATE TABLE tbTurma(
  idTurma int not null AUTO_INCREMENT PRIMARY KEY,
    nomeTurma tinyint not null,
    segmentoTurma enum('f2','f1','me') not null ,
    tipoTurma character  not null,
    turno enum('man', 'ves')
);
SELECT * FROM tbAlunos;
SELECT * FROM tbTurma;
SELECT * FROM tbGruposdeTrabalho;
ALTER TABLE tbGruposdeTrabalho ADD COLUMN idTurmaGrupo int;
ALTER TABLE tbGruposdeTrabalho ADD CONSTRAINT fk_GrupoTurma FOREIGN KEY (idTurmaGrupo) REFERENCES tbTurma(idTurma);

SELECT tA.nomeAluno, tT.nomeTurma, tGT.nomeGrupo,SUM(tP.nota) as "Pontos Total"  FROM tbAlunos tA
    INNER JOIN tbResponsavel tR on tA.idResponsavelAlunos = tR.idResponsavel
    INNER JOIN tbTurma tT on tA.idAlunos = tT.idTurma
    INNER JOIN tbGruposdeTrabalho tGT on tA.idAlunos = tGT.idAlunosGrupo
    INNER JOIN tbPontos tP on tA.idAlunos = tP.idAluno
    GROUP BY tA.nomeAluno, tT.nomeTurma, tGT.nomeGrupo;
;
CREATE VIEW vwAlunosGruposPontos as
SELECT tA.nomeAluno, tT.nomeTurma, tGT.nomeGrupo,SUM(tP.nota) as "Pontos Total"  FROM tbAlunos tA
                                                                                          INNER JOIN tbResponsavel tR on tA.idResponsavelAlunos = tR.idResponsavel
                                                                                          INNER JOIN tbTurma tT on tA.idAlunos = tT.idTurma
                                                                                          INNER JOIN tbGruposdeTrabalho tGT on tA.idAlunos = tGT.idAlunosGrupo
                                                                                          INNER JOIN tbPontos tP on tA.idAlunos = tP.idAluno
GROUP BY tA.nomeAluno, tT.nomeTurma, tGT.nomeGrupo;
;
SELECT * FROM tbProfessores;
SELECT * FROM tbAlunos;
SELECT * FROM tbGruposdeTrabalho;
# para adcionar um trabalho preciso:
#
INSERT INTO tbTrabalhos(tituloTrabalho, descricao, local, horario) VALUES ()

INSERT INTO tbTrabalhos(tituloTrabalho, descricao, local, horario) VALUES
                                                                       ('Economia Circular: Reduzindo Desperdício', 'Discussão sobre como implementar práticas de economia circular em empresas, diminuindo o uso de recursos e o desperdício.', 'Auditório A', '2024-10-04 09:00:00'),
                                                                       ('Energias Renováveis: O Futuro Sustentável', 'Exploração das tecnologias emergentes em energia solar, eólica e outras fontes renováveis.', 'Sala Verde', '2024-10-04 11:00:00'),
                                                                       ('Agricultura Sustentável e Orgânica', 'Abordagem sobre práticas agrícolas que minimizam o impacto ambiental e promovem alimentos orgânicos.', 'Sala Azul', '2024-10-04 13:00:00'),
                                                                       ('Mobilidade Urbana Sustentável', 'Como cidades podem adotar transportes mais eficientes e menos poluentes.', 'Auditório B', '2024-10-05 09:00:00'),
                                                                       ('Desafios e Oportunidades da Reciclagem', 'Debate sobre a importância da reciclagem e inovações na reutilização de materiais.', 'Sala Verde', '2024-10-05 11:00:00'),
                                                                       ('Educação Ambiental: Formando Cidadãos Conscientes', 'Iniciativas de educação ambiental para promover uma sociedade mais consciente dos impactos ecológicos.', 'Sala Amarela', '2024-10-05 14:00:00'),
                                                                       ('Construção Sustentável: Edificações Verdes', 'Apresentação sobre o uso de tecnologias sustentáveis em construções para reduzir a pegada ecológica.', 'Sala Azul', '2024-10-06 10:00:00'),
                                                                       ('Preservação de Recursos Hídricos', 'Discussão sobre a importância de proteger fontes de água e como reduzir o consumo de água nas cidades.', 'Auditório C', '2024-10-06 12:00:00'),
                                                                       ('Impactos da Indústria no Meio Ambiente', 'Estudo sobre como a indústria pode minimizar suas emissões e poluentes para se alinhar com os objetivos sustentáveis.', 'Sala Verde', '2024-10-06 15:00:00'),
                                                                       ('Empreendedorismo Sustentável', 'Como criar negócios que tenham impacto positivo no meio ambiente e sejam financeiramente viáveis.', 'Auditório A', '2024-10-07 09:00:00');

SELECT * FROM tbTrabalhos;
DELIMITER
CREATE PROCEDURE spInsertTrabalho(in spTituloT varchar(60), in spDescrT TEXT, in spLocalt varchar(60), in spHorarioT timestamp)
BEGIN
    declare checkId int;
    SELECT tT.idTrabalhos INTO checkId
    FROM tbTrabalhos tT
    WHERE tT.tituloTrabalho
    LIKE CONCAT('%',spTituloT,'%') or tT.descricao LIKE CONCAT('%',spDescrT,'%');
    IF checkId > 0 THEN
        SELECT "ERRO ID ALREADY EXIST" as 'RESULT';
    ELSE
        INSERT INTO tbTrabalhos(tituloTrabalho, descricao, local, horario)
            VALUES (spTituloT, spDescrT, spLocalt, spHorarioT);
        SELECT "TRABAHOS ADICIONADOS" as "RESULT";
    end if;
end;
DELIMITER ;


call spInserTrabalho()
