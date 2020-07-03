class analisisError {
    private tipo: string ;
    private linea: string;
    private columna: string ;
    private descripcion: string ;

    constructor(tipo:string, linea:string,columna:string,descripcion: string){
        this.descripcion = descripcion;
        this.tipo =tipo;
        this.columna = columna;
        this.linea = linea;
    }
    getLinea():string {
        return this.linea;
    }

    getColumna():string {
        return this.columna;
    }
    getDescripcion():string {
        return this.descripcion;
    }

    getTipo():string {
        return this.tipo;
    }
    
}
export {analisisError};