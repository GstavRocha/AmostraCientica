const util = require('./Utils.js');

module.exports = getAlunos =()=>{
    let sql = 'SELECT * FROM vwAlunos;';
    console.log(util(sql))
    return util(sql);
}
getAlunos();

