
const express=require('express');
const cors = require('cors')
const api=express();
const userRouter = require('./Routers/UserRouters.js');
const midlleRouter = require('./Middleware/Middle.js');

require('dotenv').config()
const port=process.env.APIPORT;

api.use(cors());
api.use('/routers/', userRouter);
api.use(midlleRouter);
api.get('/',(req,res)=>{
    res.send('teste');
    console.log(res.statusCode);
})


api.listen(port, ()=>{
    console.log('api rodando');
});
