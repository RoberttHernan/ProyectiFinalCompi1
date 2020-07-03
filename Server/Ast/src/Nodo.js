"use strict";
exports.__esModule = true;
exports.Nodo = void 0;
var Nodo = /** @class */ (function () {
    function Nodo(nombre) {
        this.nombre = nombre;
        this.ListaHijos = [];
    }
    Nodo.prototype.agregarHijo = function (hijo) {
        this.ListaHijos.push(hijo);
    };
    Nodo.prototype.getNombre = function () {
        return this.nombre;
    };
    Nodo.prototype.getListaHijos = function () {
        return this.ListaHijos;
    };
    return Nodo;
}());
exports.Nodo = Nodo;
//# sourceMappingURL=Nodo.js.map