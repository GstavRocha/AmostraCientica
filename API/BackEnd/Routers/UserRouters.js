const UserControll = require('../Controllers/UserControllers.js');
const express = require('express');
const userRouter = express();

const router = express.Router();
router.get('/teste/', (res, req) =>{
    res.send('Hello World')
})
module.exports = router;