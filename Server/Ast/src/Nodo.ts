class Nodo{
    private nombre:string;
    private ListaHijos: Nodo[];


    constructor(nombre:string ){
        this.nombre= nombre;
        this.ListaHijos=[];
    }

    public agregarHijo(hijo:Nodo){
        this.ListaHijos.push(hijo);
    }
    public getNombre():string{
        return this.nombre;
    }
    public getListaHijos():Nodo[]{
        return this.ListaHijos;
    }
    //borrar esto si algo ocurre :((((
    public get nombre_():string{
        return this.nombre;
    }

    public get listaHijos_ (): Nodo[]{
        return this.ListaHijos;
    }
}
export{Nodo};