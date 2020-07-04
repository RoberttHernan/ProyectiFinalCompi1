"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.analisisError = void 0;
var analisisError = /** @class */ (function () {
    function analisisError(tipo, linea, columna, descripcion) {
        this.descripcion = descripcion;
        this.tipo = tipo;
        this.columna = columna;
        this.linea = linea;
    }
    analisisError.prototype.getLinea = function () {
        return this.linea;
    };
    analisisError.prototype.getColumna = function () {
        return this.columna;
    };
    analisisError.prototype.getDescripcion = function () {
        return this.descripcion;
    };
    analisisError.prototype.getTipo = function () {
        return this.tipo;
    };
    return analisisError;
}());
exports.analisisError = analisisError;
//# sourceMappingURL=analisisError.js.map