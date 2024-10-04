const conn   = require('../DB/connectDb.js')
const util = require('./Utils.js');

const getAllUsers = () => {
    let SQL = 'SELECT * FROM tbAlunos;';
    return util(SQL, conn);
}
const addAluno = (nome, responsavel, numresponsavel, turma, nomeGrupo,) => {}
module.exports = controller = {getAllUsers};