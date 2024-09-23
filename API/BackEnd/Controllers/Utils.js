const database = require('../DB/connectDb');

const teste = 'SHOW DATABASES';
const util = (sql) =>{
    return new Promise((resolve, reject)=>{
        database.query(sql, (err, result, fields)=>{
            err? console.error('Util error -->', err):((JSON.stringify(result))=>{resolve()});
        });
    });
}
// const util = (sql) =>{
//     return new Promise((resolve, reject)=>{
//         database.query(sql, (err, result, fields)=>{
//             if(err){
//                 console.error(err);
//                 reject(err);
//             }
//             const jsonResult = JSON.stringify(result);
//             resolve(jsonResult);
//         });
//     });
// }