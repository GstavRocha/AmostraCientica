-- Database script: It is a script that creates the database and your tables. It isn't duppimg dabase.
# create database bdAmostra; // ja fiz
use dbAmostra;
create table tbAlunos(
    idAlunos int not null auto_increment primary key,
    nomeAluno varchar(60) not null,
    turno enum('td','mn') not null comment 'td: tarde, mn: manhã',
    diaNascimento int not null,
    mesNascimento int not null,
    anoNascimento int not null
);
create table tbPontuacoes(
    idPontuacao int not null auto_increment primary key,
    idAluno  int not null,
    idPalestra int not null,
    descricao varchar(100) not null,
    pontos int not null DEFAULT 0
);

create table tbPalestras(
    idPalestra int auto_increment not null primary key ,
    titulo varchar(50) not null,
    descricao varchar(100) not null,
    diaPalestras int not null,
    mesPalestras int not null,
    anoPalestras int not null
);
create table tbTrabalhos(
    idTrabalhos int auto_increment primary key not null,
    tituloTrabalho  varchar(30) not null,
    descricao text not null
);
create table tbProfessores(
    idProfessores int auto_increment primary key not null,
    nomeProfessor varchar(50) not null,
    idTrabalhosProfessores int not null,
    constraint fk_idTrabalhos foreign key (idTrabalhosProfessores)
    REFERENCES tbTrabalhos(idTrabalhos) ON DELETE  CASCADE -- DELETA EM CASCATA
);
CREATE TABLE tbPontuacoes(
    idPontuacoes int not null auto_increment primary key,
    idAlunoPontuacoes int not null,
    idPalestrasPontuacoes int not null,
    pontos int default 0,
    dataPontos timestamp default now(),
    constraint fk_Idalunos foreign key (idAlunoPontuacoes)
    references tbAlunos(idAlunos),
    constraint fk_IdPalestras foreign key (idPalestrasPontuacoes)
    references  tbPalestras(idPalestra)
);
create table tbQrCode(
    idQr int auto_increment not null primary key,
    tipoQr enum('ass','apr') comment 'ass: assistiu, apr: apresentou',
    idQrTrabalho int not null,
    idQrPalestra int not null,
    qrCode BLOB not null,
    constraint fk_idTrabalho foreign key (idQrTrabalho) references tbTrabalhos(idTrabalhos),
    constraint fk_idPalestra foreign key (idQrPalestra) references tbPalestras(idPalestra)
);
create table tbFeedback(
    idFeedback int not null primary key,
    idAlunoFeedback int not null references tbAlunos(idAlunos),
    idPalestraFeedback int not null references tbPalestras(idPalestra),
    likeDislike enum('like', 'dislike')
);
create table tbGruposdeTrabalho(
    idGrupos int not null auto_increment primary key,
    nomeGrupo varchar(30) not null
);
create table tbAssociacaoAlunosGrupos(
    idAssociacaoAlunosGrupo int not null auto_increment primary key,
    idAlunoAssociacao int not null references tbAlunos(idAlunos),
    idGrupoTrabalhoAssociacao int not null references tbGruposdeTrabalho(idGrupos)
);
CREATE TABLE tbVisitantes (
    idVisitante INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nomeVisitante VARCHAR(60) NOT NULL,
    emailVisitante VARCHAR(100) not null ,
    telefoneVisitante VARCHAR(15),
    idPalestraVisitada INT NOT NULL,
    constraint fk_idPalestraVisitada FOREIGN KEY (idPalestraVisitada)
        REFERENCES tbPalestras(idPalestra) ON DELETE CASCADE
);

select * from tbAlunos;
create database db_wordpress;
drop database db_wordpress;
create database wordpress;

SHOW DATABASES;


