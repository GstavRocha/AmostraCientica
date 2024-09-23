const db = require('../DB/connectDb');

let resultado = {
    'result': null,
    'campo': null
}
module.exports = util = (sql) =>{
    try{
        db.query(sql, (err, result, fields) =>{
            if(err){ return callback(err, null)}
            resultado.result = JSON.stringify(result);
            resultado. campo = JSON.stringify(fields);
            console.log(resultado, '--> dentro de Util')
            return resultado;
           })
    }catch(error){
        console.error(error);
    }
}
module.exports = utilHeader = (param) =>{
    result = param;
    campo = param;
    return new Promise ((resolve, reject)=>{
        try{
            const headers ={
                'Content-type':'text/html',
                'x-custom-Header': `${result}`
            }
            // console.log('ok UtilHeader--->',headers)
            resolve(headers)
        }catch(err){
            console.error('UtilHeader--->',err);
            reject(err)
        }
    })
}