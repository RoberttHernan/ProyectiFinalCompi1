"use strict";
/**
 * Genera el html del reporte de tokens para los errores
 *
 */
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
exports.__esModule = true;
exports.errores = void 0;
var errores = /** @class */ (function (_super) {
    __extends(errores, _super);
    function errores() {
        return _super.call(this) || this;
    }
    errores.add = function (err) {
        this.prototype.push(err);
    };
    errores.verificarerror = function () {
        if (this.prototype.length > 0) {
            return "Se Detectaron Errores de Compilacion";
        }
        return "Compilacion Sin Errores";
    };
    errores.geterror = function () {
        var cad = "";
        cad += "<div align=\"center\">";
        cad += "<h1>Reporte de Errores</h1>";
        cad += "<table border=\"2\" align=\"center\">";
        cad += "<tr>";
        cad += "<th>TIPO DE ERROR</th><th>DESCRIPCION</th><th>LINEA</th><th>COLUMNA</th>\n";
        cad += "</tr>";
        for (var i = 0; i < this.prototype.length; i++) {
            cad += "<tr>";
            cad += "<td>" + this.prototype[i].gettipo() + "</td><td>" +
                this.prototype[i].getdescripcion() + "</td><td>" +
                this.prototype[i].getlinea() + "</td><td>" +
                this.prototype[i].getColuma() + "</td>";
            cad += "</tr>";
        }
        cad += "</table>";
        cad += "</div>";
        return cad;
    };
    errores.clear = function () {
        while (this.prototype.length > 0) {
            this.prototype.pop();
        }
    };
    return errores;
}(Array));
exports.errores = errores;
//# sourceMappingURL=errores.js.map