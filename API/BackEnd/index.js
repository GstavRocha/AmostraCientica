
const express=require('express');
const cors = require('cors')
const app=express();
const router = require('./Routers/UserRouters.js');
const midlleRouter = require('./Middleware/Middle.js');

require('dotenv').config()
const port=process.env.APIPORT;

app.get('/', (req, res) => {
    res.send('success');
    res.status(200);
})
app.use(cors());
app.use('/routers', router);
app.use(midlleRouter);
app.listen(port, ()=>{
    console.log('api rodando');
});
