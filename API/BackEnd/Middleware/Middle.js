const express = require('express');
const router = express.Router()
try{
    router.use((req, res)=>{
        res.status(404).send('APPI Fail');
    })
    router.use((err, req, res , next)=>{
        console.log(err);
        console.error(err);
        res.status(500).send('ERROR server')
    })
}catch(error){
    console.error(' Erro on MidleWare',error);
}
module.exports = router;