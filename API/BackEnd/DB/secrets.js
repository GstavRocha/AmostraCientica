const path = require('path');
const dotenv = require('dotenv');


dotenv.config({path: path.resolve(__dirname,'../.env')})

module.exports = {
    'DBLOCAL':process.env.DBLOCAL,
    'DBNOME': process.env.DBNAME,
    'DBUSER': process.env.DBUSER,
    'DBPORT': process.env.DBPORT,
    'DBPASS': process.env.DBPASS
};

