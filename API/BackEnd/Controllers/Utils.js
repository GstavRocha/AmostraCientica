const database = require('../DB/connectDb');

const util = (sql) =>{
    return new Promise((resolve, reject)=>{
        try{
            database.query(sql, (err, result, fields)=>{
                console.log(fields);
                return err? (console.error(err),reject(err)): resolve(JSON.stringify(result));
            });
        }
        catch(error){
            console.error('Util erro -->', error)
            reject(error);
        }
    });
}
module.exports = util;
// PAREI AQUI
