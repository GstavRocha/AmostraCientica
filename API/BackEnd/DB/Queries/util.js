const conn = require('../connectDb.js');
module.exports = util = (param) =>{
    return new Promise((resolve,reject)=>{
        conn.query(param,function(err, result){
            err? reject(err): resolve(JSON.stringify(result));
        })
    })
}