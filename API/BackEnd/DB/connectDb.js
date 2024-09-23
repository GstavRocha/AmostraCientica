const mysql = require('mysql');
const express = require('express');
const api = express();
const {DBLOCAL,DBNOME, DBUSER, DBPORT, DBPASS} = require('./secrets.js')
let conn;
try{
     conn = mysql.createConnection({host:DBLOCAL,database:DBNOME, user:DBUSER, password:DBPASS, port:DBPORT})
     conn.connect((error) => {
        error ? console.error('Não conectou -->', error) : console.log('Conectado com sucesso!');
      });
      module.exports = conn;
}catch(error){
    console.error('Connect db -->', error)
}