/**
 * Genera el html del reporte de tokens para los errores
 * 
 */


import { NodoError } from "./NodoError";

class errores extends Array<NodoError>{

    constructor(){
        super();
    }

    public static add(err:NodoError){
        this.prototype.push(err);
    }

    public static verificarerror():string{
        if(this.prototype.length>0){
            return "Se Detectaron Errores de Compilacion";
        }
        return "Compilacion Sin Errores";
    }

    public static geterror():string{
        var cad:string="";
                cad+="<div align=\"center\">";
                    cad+="<h1>Reporte de Errores</h1>";
                    cad+="<table border=\"2\" align=\"center\">";
                        cad+="<tr>";
                            cad+="<th>TIPO DE ERROR</th><th>DESCRIPCION</th><th>LINEA</th><th>COLUMNA</th>\n";
                        cad+="</tr>";
                        for(var i=0; i<this.prototype.length;i++){
                            cad+="<tr>";
                                cad+="<td>"+this.prototype[i].gettipo()+"</td><td>"+
                                this.prototype[i].getdescripcion()+"</td><td>"+
                                this.prototype[i].getlinea()+"</td><td>"+
                                this.prototype[i].getColuma()+"</td>";
                            cad+="</tr>";
                        }
                    cad+="</table>";
                cad+="</div>";

        return cad;
    }

    public static clear(){
        while(this.prototype.length>0){
            this.prototype.pop();
        }
    }
}

export{errores};