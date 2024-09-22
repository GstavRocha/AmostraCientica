const util = require('./Utils.js');

module.exports = getAlunos =()=>{
    let sql = 'SELECT * FROM vwAlunos;';
    console.log(sql);
    return util(sql);
}
getAlunos();

