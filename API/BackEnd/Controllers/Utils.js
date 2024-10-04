module.exports = util = (param, dbconn) =>{
    return new Promise((resolve, reject) => {
        dbconn.query(param,function(err,result){
            err? reject(err): resolve(JSON.stringify(result));
        })
    })
}
module.exports = util;