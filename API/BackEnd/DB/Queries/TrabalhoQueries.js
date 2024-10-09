const util = require('./util.js');

module.exports = class Queries{
    constructor(){
        this._trabalhoId = null;
    };
    async getAlltrabalhos(){
        let sql = 'SELECT * FROM tbTrabalhos;';
        return await util(sql);
    };
    async geTrabalhoId(id){
        let sql = `CALL spTrabalho(${id});`;
        return await util(sql);
    };
    async insertTrabalho(titulo, descricao,local,Horario){
        let sql = `CALL spInsertTrabalho("${titulo}", "${descricao}","${local}", "${Horario}");`;
        return await util(sql);
    };
    async updateTrabalho(titulo,descricao,local,Horario){
        let sql = `ALTER TABLE tbTrabalhos MODIFY CO`
    }
    // falta a querie que lista as salas aos trabalhos
}

// let teste = new Queries();
// casa = teste.insertTrabalho('casa de chocolate','festa azuk', 'casa do carai ', '2024-10-05 07:18:00');
// casa.then(result => console.log(result));

