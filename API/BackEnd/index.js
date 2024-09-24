
const express=require('express');
const cors = require('cors')
const api=express();
const userRouter = require('./Routers/UserRouters.js');
const port=3000;
require('dotenv').config()

api.use(cors());
api.use('/user', userRouter)


api.listen(port, ()=>{
    console.log('api rodando');
});
