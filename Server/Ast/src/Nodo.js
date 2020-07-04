"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
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
    Object.defineProperty(Nodo.prototype, "nombre_", {
        //borrar esto si algo ocurre :((((
        get: function () {
            return this.nombre;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Nodo.prototype, "listaHijos_", {
        get: function () {
            return this.ListaHijos;
        },
        enumerable: false,
        configurable: true
    });
    return Nodo;
}());
exports.Nodo = Nodo;
//# sourceMappingURL=Nodo.js.map