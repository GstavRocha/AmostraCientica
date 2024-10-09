const conn = require('../connectDb');
const util = require('./util');
module.exports = class Queries {
    constructor() {
    }

    getAllQuery(table) {
        let sql = `SELECT *
                   FROM ${table};`;
        return util(sql);
    }
    getOneId(table,idNumber)
    {
        let sql = `SELECT * FROM ${table} WHERE id = ${idNumber} ;`;
        return util(sql)
    }
    researchName(table, nomeBusca)
    {
        let sql = `SELECT * FROM ${table} as tb WHERE tb.nome LIKE CONCAT('%',"${nomeBusca}",'%');`;
        return util(sql);
    }
    deletePerID(tabela,iddelete)
    {
        let sql = `DELETE FROM ${tabela} WHERE id = ${iddelete};`;
        if(tabela == null || iddelete == null)
        {
            console.error("erro, campo vazio");
        }
        else
        {
            return util(sql);
        }
    }
    updateNomePerId(tabela, setNome,id)
    {
        let sql = `UPDATE ${tabela} SET nome = "${setNome}" WHERE id = ${id};`;
        if(tabela === null || setNome === null || id === null){
            console.error("Não pode excutar esta função");
        }
        return util(sql);
    }
    updateNomePerNome(table, setNome, nomeBusca)
    {
        let sql = `UPDATE ${table} SET nome="${setNome}" WHERE nome LIKE CONCAT("%","${nomeBusca}","%");`;
        if(table === null || setNome === null|| nomeBusca === null)
        {
            console.error("Não pode excutar esta função");
        }
        return util(sql);
    }
}


