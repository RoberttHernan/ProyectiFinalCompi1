class Variable{
    private nombre: string;
    private tipo :string;

    constructor (nombre: string, tipo: string){
        this.nombre = nombre;
        this.tipo = tipo;

    }

    getNombre (){
        return this.nombre;
    }
    getTipo(){
        return this.tipo;
    }

}
export{Variable};