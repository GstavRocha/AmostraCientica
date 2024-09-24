const db = require('../DB/connectDb.js')
const util = require('./Utils.js');

try{
    const getAlunos = () => {
        try {
            const sql = 'SELECT * FROM tbAlunos;';
            return util(sql);
        } catch (error) {
            rconsole.error(error)
        } finally {
            console.info('Database -->', db.state);
        }
    };
    const addAluno = (nomeAluno,Responsavel, NumeroResponsavel, Turma) => {
        try {
            const sql = `INSERT INTO tbAlunos (nome,responsavel, curso) VALUES (${nomeAluno},${Responsavel},${NumeroResponsavel},${Turma});`;
            util(sql);
        } catch (error) {
            console.error('Erro ao adicionar aluno:', error);
        } finally {
            console.info('Database -->', db.state);
        }
    };
    const updateAluno = (idAlunos, nomeAluno,Responsavel, NumeroResponsavel, Turma) => {
        try {
            const sql = `UPDATE tbAlunos SET nomeAluno = ${nomeAluno}, Responsavel=${Responsavel}, NumeroResponsavel = ${NumeroResponsavel}, Turma = ${Turma} WHERE idAlunos = ${idAlunos};`;
            util(sql)    
        } catch (error) {
            console.error('Erro ao atualizar aluno:', error);
        } finally {
            console.info('Database -->', db.state);
        }
    };
    const deleteAluno =(idAlunos) => {
        try {
            const sql = `DELETE FROM tbAlunos WHERE idAlunos = ${idAlunos};`;
            util(sql)
        } catch (error) {
            console.error('Erro ao deletar aluno:', error);
        } finally {
            console.info('Database -->', db.state);
        }
    };
    module.exports= UserControll = {
        getAlunos,
        addAluno,
        updateAluno,
        deleteAluno
    }
}catch(error){
    console.error(error)
}finally{
    db.end();
    console.info('Database -->',db.state);
}