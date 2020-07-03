"use strict";
exports.__esModule = true;
exports.NodoError = void 0;
var NodoError = /** @class */ (function () {
    function NodoError(tipo, descripcion, linea, columna) {
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.linea = (linea + 1);
        this.columna = (columna + 1);
    }
    NodoError.prototype.gettipo = function () {
        return this.tipo;
    };
    NodoError.prototype.getdescripcion = function () {
        return this.descripcion;
    };
    NodoError.prototype.getlinea = function () {
        return this.linea;
    };
    NodoError.prototype.getColuma = function () {
        return this.columna;
    };
    return NodoError;
}());
exports.NodoError = NodoError;
//# sourceMappingURL=NodoError.js.map