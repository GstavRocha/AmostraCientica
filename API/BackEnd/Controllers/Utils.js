const db = require('../DB/connectDb.js')
module.exports = util = (sql) =>{
    return new Promise((resolve, reject)=>{
        try{
            db.query(sql,(err, result, fields)=>{
                if(err){return reject(err)}
                RESULTADO ={
                    'res':JSON.stringify(result),
                    'field':JSON.stringify(fields)
                }
                return result?resolve(RESULTADO.res, RESULTADO.field):reject(err);
            })

        }catch(error){
            console.error('UTIL ERROR --> ', error)
            reject(error);
        }
    });
}
