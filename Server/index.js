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
var Variable_aux = require('./Ast/src/Variable');
var fs = require('fs'); 

var listaVariables=[];
var texoTraduccion; 


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
recorridoArbol(parseado);
var htmlVar = htmlVariables();

    lista.push(Errores_aux.errores.geterror());//Lista de errores en lista[0]
    lista.push(parseado);// Arbol Ast  en lista[1]
    lista.push(htmlVar);//Lista de variables en lista[2]

    
    
  
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
function recorridoArbol (raiz){
if (raiz.getNombre()== "DECLARACION"){
    
    var rHijos = raiz.getListaHijos();
   
    var tipo = rHijos[0].getListaHijos()[0].getNombre();
    var lista_var = rHijos[1];
    for (var i =0; i<lista_var.getListaHijos().length; i++){
        var identificador = lista_var.getListaHijos()[i];
        var vari = identificador.getListaHijos()[0].getNombre();
        var variable = new Variable_aux.Variable (vari, tipo);
        listaVariables.push(variable);
        
    }

    
}else {
    for (var i = 0; i<raiz.getListaHijos().length;i++){
        recorridoArbol(raiz.getListaHijos()[i]);
        
    }
}
}

function htmlVariables(){
    var texto = "<h1>ListaVariables</h1>";
    texto += "<table>";

    texto += "<tr>";
    texto += "<th>";
    texto += "No.";
    texto += "</th>";
    texto += "<th>";
    texto += "TIPO ";
    texto += "</th>";

    texto += "<th>";
    texto += "NOMBRE";
    texto += "</th>";
    texto += "</tr>";

    for(var i = 0; i< listaVariables.length ; i++){
        texto += "<tr>";
        
        texto += "<td>";
        texto += (i +1);
        texto += "</td>";

        texto += "<td>";
        texto += listaVariables[i].getTipo();
        texto += "</td>";

        texto += "<td>";
        texto += listaVariables[i].getNombre();
        texto += "</td>";

        texto += "</tr>";
    }
    texto+= "</table>";
    return texto;

}
function recorridoArbolTraduccion(raiz){
    
}
