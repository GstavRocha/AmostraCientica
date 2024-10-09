const queries = require('../DB/Queries/queries');
const {Query} = require("mysql/lib/protocol/sequences");
Queries = new queries();
class AlunosModel{
    constructor(id, nome, senha, login, createAt, idGrupo, idResponsavel, idTurma) {
        this.idAluno = id;
        this.nomeAluno = nome;
        this.senhaAluno = senha;
        this.loginAluno = login;
        this.criadoAluno = createAt;
        this.idAlunoGrupo = idGrupo;
        this.idAlunoResponsavel = idResponsavel;
        this.idAlunoTurma = idTurma;
        this.tabela= "Alunos";
    }
    get Id(){
        return this.idAluno;
    }
    set I(id){
        this.idAluno = id;
    }
    get Nome(){
        return this.nomeAluno;
    }
    set Nome(nome){
        this.nomeAluno = nome;
    }
    get Senha(){
        return this.senhaAluno;
    }
    set Senha(senha){
        this.senhaAluno = senha;
    }
    get Login(){
        return this.loginAluno;
    }
    set Login(login){
        this.loginAluno = login;
    }
    get DataCriado(){
        return this.criadoAluno;
    }
    set DataCriado(data){
        this.criadoAluno = data;
    }
    get IdGrupo(){
        return this.idAlunoGrupo;
    }
    set IdGrupo(idGrupo){
        this.idAlunoGrupo = idGrupo;
    }
    get IdAlunoResponsavel(){
        return this.idAlunoResponsavel;
    }
    set IdAlunoResponsavel(idResponsavel){
        this.idAlunoResponsavel = idResponsavel;
    }
    get IdAlunoTurma(){
        return this.idAlunoTurma;
    }
    set IdAlunoTurma(idTurma){
        this.idAlunoTurma = idTurma;
    }
    getIdAluno(id){
        let resultado = Queries.getOneId(this.tabela,id)
        return resultado.then(r=>console.log(r))
    }
}
let verificando = new AlunosModel();
verificando.getIdAluno(2);