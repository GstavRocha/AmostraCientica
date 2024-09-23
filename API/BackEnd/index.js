
const express=require('express');
const api=express();
const port=3000;
require('dotenv').config()
api.get('/',(req, res)=>{
    return {'hello': 'world'};
});

api.listen(port, ()=>{
    console.log('api rodando');
});
