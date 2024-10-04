const db = require('../DB/connectDb.js');
const util = require('../Controllers/Utils.js')
const Trabalho = require('../Classes/TrabalhoClass.js');
const EventEmitter = require('node:events');

const event = new EventEmitter();

class TrabalhoModel {
    constructor(){
    }
    async AllTrabalhos(){
        let sql = 'SELECT * FROM tbTrabalhos;';
        const rows = util(sql, db);
        const trabalhosArray = Array.isArray(rows) ? rows : Object.values(rows);
        const trabalhos = trabalhosArray.map(row=>{
            return new Trabalho(row.id, row.titulo, row.descricao, row.local);
        });
        return trabalhos;
    }
}
const teste = new TrabalhoModel();
teste.AllTrabalhos().then(result => console.log(result));