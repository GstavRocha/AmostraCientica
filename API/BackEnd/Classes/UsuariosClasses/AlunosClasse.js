class AlunosClasse{
    constructor(idAluno, nomeAluno, senha, loginAluno, creadAt, idGrupo, idResponsavel, idTurmas)
    {
        this.idAluno = idAluno;
        this.nomeAluno = nomeAluno;
        this.senhaALuno = senha;
        this.loginAluno = loginAluno;
        this.criado = creadAt;
        this.idGrupo = idGrupo;
        this.idResponsavel = idResponsavel;
        this.idTurmas = idTurmas;

    }
    get Id()
    {
        return this.idAluno;
    }
    set Id(id)
    {
        this.idAluno = id;
    }
    get Nome()
    {
        return this.nomeAluno;
    }
    set Nome(nome)
    {
        this.nomeAluno = nome;
    }
    get Senha()
    {
        return this.senhaALuno;
    }
    set Senha(senha)
    {
        this.senhaALuno = senha;
    }
    get Login()
    {
        return this.loginAluno;
    }
    set Login(login)
    {
        this.loginAluno = login;
    }
    get Criado()
    {
        return this.criado;
    }
    set Criado(criado)
    {
        this.criado = criado;
    }
    get IdGrupo()
    {
        return this.idGrupo;
    }
    set IdGrupo(idgrp)
    {
        this.idGrupo = idgrp;
    }
    get IdResponsavel()
    {
        return this.idResponsavel;
    }
    set IdResponsavel(idResponsavel)
    {
        this.idResponsavel = idResponsavel;
    }
    get IdTurma()
    {
        return this.idTurmas;
    }
    set IdTurma(idTrms)
    {
        this.idTurmas = idTrms;
    }
}