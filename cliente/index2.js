

var vent_focus="pestana1";
function get_vent(){
return vent_focus;
}



function Conexion (){
    var url = 'http://localhost:5000/Ejecutar';
    var ta=document.getElementById(get_vent());
    var contenido=ta.value;

    $.post(url, {dato: contenido},(req,res)=>{
        if (res.toString()=="success"){
            var lista = JSON.parse(req);
            ReporteErrores(lista[0]);
            
            ReporteAst(lista[1]);
            ReporteVariables(lista[2]);
            
           
            
           

        }else{
            alert("Fallo la conexion");
        }
    });
 
   
function ReporteErrores(lista){
    var divisionError = document.getElementById('reporteErrores');
    divisionError.innerHTML = JSON.stringify(lista);
}
function ReporteVariables(texto){
    var divisionVariables = document.getElementById('reporteVariables');
    divisionVariables.innerHTML =texto;
}
function ReporteAst (raiz){
    var cadena = "<ul class='jstree-container-ul jstree-children' role='group' >";
    cadena += generalAst(raiz);
    cadena += "</ul>";

    var divAst = document.getElementById('ArbolAst');
    divAst.innerHTML= cadena;
}
function generalAst (raiz){
    var cadena = "<li role=\"treeitem\" data-jstree='{ \"opened\" : true }' aria-selected='false' aria-level='1' aria-labelledby='jl_1_anchor' aria-expanded='true' class='jstree-node jstree-last jstree-open' id='jl_1'>";
    cadena += "<i class='jstree-icon jstree-ocl' role='presentation'></i>" ;
    cadena += "<a class='jstree-anchor' href='#' tabindex='-1' >";
    cadena += "<i class='jstree-icon jstree-themeicon' role='presentation'></i>";
    cadena += raiz.nombre;
    cadena += "</a>";
    if (raiz.ListaHijos.length >0){
        cadena += "<ul role=\"group\" class=\"jstree-container-ul jstree-children \">";
        for(var i = 0; i < raiz.ListaHijos.length; i++){
            cadena += generalAst(raiz.ListaHijos[i]);
        } 
        cadena += "</ul>";
    }
    cadena += "</li>";
    return cadena;
}

   
}