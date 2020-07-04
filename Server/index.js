/**
 * Este servidor es el que se tiene que ejecutar 
 */

"use strict"
Object.defineProperty(exports, "__esModule", { value: true });

var express = require ('express');
var cors = require("cors");
var bodyParser = require('body-parser');
var analisis = require('./Analizador/gramatica');
var Errores_aux = require('./Ast/src/errores');  
var fs = require('fs'); 




var app = express();
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));


/**
 * Recibo los datos desde el lado del cliente mediante el index2.js
 */
app.post('/Ejecutar',(req,res)=>{
Errores_aux.errores.clear();
var lista = [];
var dato = req.body.dato;
var parseado = parser(dato);

    lista.push(Errores_aux.errores.geterror());
    imprimir(parseado);
    res.send(JSON.stringify(lista));







});


var servidor = app.listen (5000,function (){
console.log ("Servido corriendo");
});

function parser (texto){
    try {
        var respuesta = analisis.parse(texto);
        
        return respuesta;
    } catch (e) {
        
    }
}

function imprimir(raiz) {
    console.log(raiz.getNombre()); 
        for (var i = 0; i <raiz.getListaHijos().length; i++) {
            imprimir(raiz.getListaHijos()[i]);
    }
    
}
