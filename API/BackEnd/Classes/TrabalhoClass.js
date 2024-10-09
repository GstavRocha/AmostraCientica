module.exports = class TrabalhoClass
{
    constructor(id, titulo, descricao, local)
    {
        this.id = id;
        this.titulo = titulo;
        this.descricao = descricao;
        this.local = local;
        this._horario = new Date().getTime();

    }
    get Id()
    {
        return this.id;
    }
    set Id(id)
    {
        this.id = id;
    }
    get Titulo()
    {
        return this.titulo;
    }
    set Titulo(titulo)
    {
        this.titulo = titulo;
    }
    get Descricao()
    {
        return this.descricao;
    }
    set Descricao(descricao)
    {
        this.descricao = descricao;
    }
    get Local()
    {
        return this.local;
    }
    set Local(local)
    {
        this.local = local;
    }
    get Horario()
    {
        return new Date(this._horario).toLocaleDateString();
    }
    set Horario(novoHorario)
    {
        if(novoHorario instanceof Date && !isNaN(novoHorario))
        {
            this._horario = novoHorario.getTime();
        }

    }
}
