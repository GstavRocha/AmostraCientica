const express = require('express');
const router = express.Router()
try{
    router.use((req, res)=>{
        res.status(404).send('API Fail');
    })
    router.use((req, res , next)=>{
        res.status(500).send('ERROR server')
    })
}catch(error){
    console.error(' Erro on MidleWare',error);
}
module.exports = router;