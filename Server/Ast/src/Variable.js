"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Variable = void 0;
var Variable = /** @class */ (function () {
    function Variable(nombre, tipo) {
        this.nombre = nombre;
        this.tipo = tipo;
    }
    Variable.prototype.getNombre = function () {
        return this.nombre;
    };
    Variable.prototype.getTipo = function () {
        return this.tipo;
    };
    return Variable;
}());
exports.Variable = Variable;
//# sourceMappingURL=Variable.js.map