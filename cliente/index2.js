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
           

        }else{
            alert("Fallo la conexion");
        }
    });
 
   
function ReporteErrores(lista){
    var divisionError = document.getElementById('reporteErrores');
    divisionError.innerHTML = JSON.stringify(lista);
}
    
   
}