create table tbTrabalhos
(
    idTrabalhos    int auto_increment
        primary key,
    tituloTrabalho varchar(200) not null,
    descricao      text         not null,
    local          varchar(60)  not null,
    horario        timestamp    not null
);

create table tbQrCode
(
    idQr         int auto_increment
        primary key,
    tipoQr       enum ('ass', 'apr') null comment 'ass: assistiu, apr: apresentou',
    idQrTrabalho int                 null,
    qrCode       blob                not null,
    constraint idQrTrabalho
        unique (idQrTrabalho),
    constraint fk_idTrabalhoQr
        foreign key (idQrTrabalho) references tbTrabalhos (idTrabalhos)
);

create table tbEscaneamentos
(
    idEscaneamento   int auto_increment
        primary key,
    idQrCode         int                                 not null,
    idAluno          int                                 not null,
    dataEscaneamento timestamp default CURRENT_TIMESTAMP null,
    constraint fk_tbEscaneamento
        foreign key (idQrCode) references tbQrCode (idQr)
);

create index idAluno
    on tbEscaneamentos (idAluno);

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

create table tbTurma
(
    idTurma   int auto_increment
        primary key,
    nomeTurma varchar(15)             not null,
    turno     enum ('nm', 'tr')       null,
    segMento  enum ('f1', 'f2', 'md') null,
    turma     char                    not null
);

create table tbGruposdeTrabalho
(
    idGrupos         int auto_increment
        primary key,
    nomeGrupo        varchar(30) not null,
    idProfessorGrupo int         not null,
    idAlunosGrupo    int         not null,
    idTrabalhoGrupo  int         null,
    idTurmaGrupo     int         null,
    constraint idTrabalhoGrupo
        unique (idTrabalhoGrupo),
    constraint fk_GrupoTurma
        foreign key (idTurmaGrupo) references tbTurma (idTurma),
    constraint fk_trabalhoGrupo
        foreign key (idTrabalhoGrupo) references tbTrabalhos (idTrabalhos)
);

create table tbVisitantes
(
    idVisitante          int auto_increment
        primary key,
    nomeVisitante        varchar(60)  not null,
    emailVisitante       varchar(100) not null,
    telefoneVisitante    varchar(15)  null,
    idTrabalhosVisitados int          not null,
    idQrCodeVisitados    int          not null
);

create table tbResponsavel
(
    idResponsavel   int auto_increment
        primary key,
    nomeResponsavel varchar(10)            not null,
    tipoResponsavel enum ('resp', 'visit') null comment 'resp - responsavel, visita - visitante',
    idVisitante     int                    null,
    constraint fk_tbVistanteResponsavel
        foreign key (idVisitante) references tbVisitantes (idVisitante)
);

create table tbAlunos
(
    idAlunos            int auto_increment
        primary key,
    nomeAluno           varchar(60)                         not null,
    senha               varchar(60)                         not null,
    login               varchar(30)                         null,
    createAt            timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    idGrupoAlunos       int                                 null,
    idResponsavelAlunos int                                 null,
    idTurmaAlunos       int                                 null,
    constraint fk_alunosTurmas
        foreign key (idTurmaAlunos) references tbTurma (idTurma),
    constraint fk_idAlunoResponsavel
        foreign key (idResponsavelAlunos) references tbResponsavel (idResponsavel),
    constraint fk_idgrupoaluno
        foreign key (idGrupoAlunos) references tbGruposdeTrabalho (idGrupos)
);

create table tbPontos
(
    idPonto    int           not null
        primary key,
    idTrabalho int           null,
    idAluno    int           null,
    nota       decimal(5, 2) null,
    constraint idTrabalho
        unique (idTrabalho, idAluno),
    constraint tbPontos_ibfk_1
        foreign key (idTrabalho) references tbTrabalhos (idTrabalhos),
    constraint tbPontos_ibfk_2
        foreign key (idAluno) references tbAlunos (idAlunos)
);

create index idAluno
    on tbPontos (idAluno);

create table tbProfessores
(
    idProfessores   int auto_increment
        primary key,
    nomeProfessor   varchar(50) not null,
    idTurma         int         null,
    idGrupoTrabalho int         null,
    constraint fk_tbprofessorTbGrupoTrabalho
        foreign key (idGrupoTrabalho) references tbGruposdeTrabalho (idGrupos),
    constraint fk_tbprofessoreTurma
        foreign key (idTurma) references tbAlunos (idAlunos)
);

create index fk_visistante_pontuacao
    on tbVisitantes (idTrabalhosVisitados);

create index fk_visistante_qrcode
    on tbVisitantes (idQrCodeVisitados);

create definer = root@localhost view vwAlunosGruposPontos as
select `tA`.`nomeAluno`  AS `nomeAluno`,
       `tT`.`nomeTurma`  AS `nomeTurma`,
       `tGT`.`nomeGrupo` AS `nomeGrupo`,
       sum(`tP`.`nota`)  AS `Pontos Total`
from ((((`dbAmostra`.`tbAlunos` `tA` join `dbAmostra`.`tbResponsavel` `tR`
         on ((`tA`.`idResponsavelAlunos` = `tR`.`idResponsavel`))) join `dbAmostra`.`tbTurma` `tT`
        on ((`tA`.`idAlunos` = `tT`.`idTurma`))) join `dbAmostra`.`tbGruposdeTrabalho` `tGT`
       on ((`tA`.`idAlunos` = `tGT`.`idAlunosGrupo`))) join `dbAmostra`.`tbPontos` `tP`
      on ((`tA`.`idAlunos` = `tP`.`idAluno`)))
group by `tA`.`nomeAluno`, `tT`.`nomeTurma`, `tGT`.`nomeGrupo`;

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

create definer = root@localhost view vwTrabalho as
select `dbAmostra`.`tbTrabalhos`.`idTrabalhos`    AS `idTrabalhos`,
       `dbAmostra`.`tbTrabalhos`.`tituloTrabalho` AS `tituloTrabalho`,
       `dbAmostra`.`tbTrabalhos`.`descricao`      AS `descricao`,
       `dbAmostra`.`tbTrabalhos`.`local`          AS `local`,
       `dbAmostra`.`tbTrabalhos`.`horario`        AS `horario`
from `dbAmostra`.`tbTrabalhos`;

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
    definer = root@localhost procedure spInsertTrabalho(IN spTituloT varchar(60), IN spDescrT text,
                                                        IN spLocalt varchar(60), IN spHorarioT timestamp)
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

create
    definer = root@localhost procedure spTrabalho(IN pId int)
BEGIN
    DECLARE checkId INT;
    SELECT idTrabalhos INTO checkId FROM tbTrabalhos WHERE idTrabalhos = pId;
    IF checkId is NOT NULL THEN
        SELECT * FROM vwTrabalho WHERE idTrabalhos=pId;
    ELSE
        SELECT "Não Existe" as RESULT;
    end if;
end;


