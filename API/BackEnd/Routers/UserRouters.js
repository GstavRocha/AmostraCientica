const controller = require('../Controllers/UserControllers.js');
const express = require('express');
const util = require('./ultisRoutes.js');

const router = express.Router();

router.get('/getallusuarios', async (req, res) => {
    res.send( await controller.getAllUsers())
    console.log('ROTA: getAllusuarios -->',res.statusCode,' -->',res.statusMessage);
});
module.exports = router;
// preciso fazer com que ele retorne a rota completa;