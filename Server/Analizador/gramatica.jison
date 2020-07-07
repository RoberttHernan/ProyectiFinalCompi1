/*--------------Deficion lexica del lenguaje------------------*/
%{
let Errores_1 = require('../Ast/src/errores');
let nodoError_1=require('../Ast/src/NodoError');

let Nodo_aux = require('../Ast/src/Nodo');

let lista_variables = require('../Ast/src/Variable');

%}






%lex
%options case-insensitive 

%%

["/"]["/"][^\r\n]*[\n|\r|\r\n|\n\r]?        %{     %}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] {}



"int"  return 'RESINT';
"double"    return 'RESDOUBLE';
"char"      return 'RESCHAR';
"bool"      return 'RESBOOL';
"string"    return 'RESSTRING';
"void"      return 'RESVOID';
"main"      return 'RESMAIN';
"if"        return 'RESIF';
"Console"   return 'RESCONSOLE';
"Write"     return 'RESWRITE';
"else"      return 'RESELSE';
"switch"    return 'RESSWITCH';
"case"      return 'RESCASE';
"break"     return 'RESBREAK';
"default"   return 'RESDEFAULT';
"for"       return 'RESFOR';
"while"     return 'RESWHILE';
"do"        return 'RESDO';
"return"    return  'RESRETURN';
"continue"  return 'RESCONTINUE';
"true"      return 'RESTRUE';
"false"     return 'RESFALSE';

";"         return 'PYC';
"{"         return 'CABRE';
"}"         return 'CCIERRA';
"("         return 'PABRE';
")"         return 'PCIERRA';
","         return 'COMA';
"."         return 'PUNTO';
":"         return 'DOSPUNTOS';

"=="        return 'DOBLEIGUAL';
"<="        return 'MENORIGUAL';
">="        return 'MAYORIGUAL';
"="         return 'IGUAL';

"<"         return 'MAYOR';
">"         return 'MENOR';
"!="        return 'DIFERENTEDE';

"&&"        return 'AND';
"||"        return 'OR';
"!"         return 'NOT';

"++"        return 'INCREMENTO';
"--"        return  'DECREMENTO';
"+"         return 'MAS';
"-"         return 'MENOS';
"/"         return 'DIV';
"*"         return 'MULTI';


\'[^\']*\'		{ yytext = yytext.substr(1,yyleng-2); return 'CADENAHTML'; }
\"[^\"]*\"		{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+"."[0-9]+    	return 'DECIMAL';
[0-9]+  		return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]*	return 'IDENTIFICADOR';



[ \t\r\n\f] {}



<<EOF>>				return 'EOF';
.					{ //console.error('Error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column);
                                        Errores_1.errores.add(new nodoError_1.NodoError('Lexico',yytext,yylloc.first_line,yylloc.first_column));
                                                 }

/lex

/*---------------Analizador Sintactico-------------------------------------------*/
//Precedencia de operadores y asociacion


%left OR
%left AND
%left DOBLEIGUAL DIFERENTEDE
%left MENORIGUAL MAYORIGUAL MENOR MAYOR
%left MAS MENOS
%left MULTI DIV
%right INCREMENTO DECREMENTO
%right NOT UMenos UMas
%left PABRE PCIERRA


%start ini

%% 

ini: Lista_Instrucciones EOF {
       
       try{
        var raiz = new Nodo_aux.Nodo("RAIZ");
        raiz.agregarHijo($1);
        $$ = raiz; 
        return $$;
       }catch (error){}
        

        
} ;


/*-----------------------------------------Instrucciones y Bloque --------------------------------*/
Bloque : 
        CABRE CCIERRA
        {
                var lista = new Nodo_aux.Nodo("LISTA_INSTRUCCIONES");
                $$ = lista;
        }
        |CABRE Lista_Instrucciones CCIERRA
        {
                $$ =$2;
        }
        
;
Lista_Instrucciones: 
        Lista_Instrucciones Instruccion
        {
                var lista = $1;
                lista.agregarHijo($2);
                $$ = lista;
        }
        
        |Instruccion 
        {
                var lista = new Nodo_aux.Nodo("INSTRUCCION");
                lista.agregarHijo($1);
                $$ = lista;  
        }
        
;


Instruccion: 
        Declaracion PYC    {$$ = $1; }    
        |Asignacion PYC        {$$ = $1;}
        |Sent_Imprimir PYC      {$$ = $1;}
        |RESBREAK PYC           
        {
                var bre = new Nodo_aux.Nodo("BREAK");
                $$ = bre;
        }
       
        |RESCONTINUE PYC 
        {
                var cont = new Nodo_aux.Nodo("CONTINUE");
                $$ = cont;
        }
       
        |Sent_Return PYC    {$$ = $1;}    
        |Sent_Metodo            {$$ = $1;}
        |Sent_Funcion           {$$ = $1;}
        |Sent_Llamada PYC       {$$ = $1;}
        |IDENTIFICADOR INCREMENTO PYC
       {
               var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
               var incre = new Nodo_aux.Nodo("INCREMENTO");
               var varia = new Nodo_aux.Nodo($1+"");
               iden.agregarHijo(varia);
               incre.agregarHijo(iden);
               $$ = incre;

       }
        |IDENTIFICADOR DECREMENTO PYC
        {
               var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
               var decre = new Nodo_aux.Nodo("DECREMENTO");
               var varia = new Nodo_aux.Nodo($1+"");
               iden.agregarHijo(varia);
               incre.agregarHijo(iden);
               $$ = decre;

       }
       
        |Sent_If   {$$ = $1;}     
        |Sent_Switch    {$$ = $1;}
        |Sent_For       {$$ = $1;}
        |Sent_While     {$$ = $1;}
        |Sent_DoWhile PYC   {$$ = $1;}
        |Sent_Main      {$$ = $1;}    
        |error  
        {
               
                var er = new Nodo_aux.Nodo("Error");

             Errores_1.errores.add(new nodoError_1.NodoError('Sintactico luego de: ',yytext,this._$.first_line,this._$.first_column));
                $$ = er;

        }
;
/*-----------------------------------Declaracion y Asignacion */
Declaracion: 
        TipoDato Lista_Identificador IGUAL Expresion
        {
                var decla = new Nodo_aux.Nodo("DECLARACION");
                decla.agregarHijo($1);
                decla.agregarHijo($2);
                decla.agregarHijo($4);

                $$=decla;
        }
        | TipoDato Lista_Identificador 
        {
                var decla = new Nodo_aux.Nodo("DECLARACION");
                decla.agregarHijo($1);
                decla.agregarHijo($2);
                


                $$=decla;
                
                
        }
      
        
    
;
Lista_Identificador:
        Lista_Identificador COMA IDENTIFICADOR
        {
                var lista = $1;
                var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
                var varia = new Nodo_aux.Nodo($3+"");
                iden.agregarHijo(varia);
                lista.agregarHijo(iden);
                $$ = lista;
        
        }    
        |IDENTIFICADOR
        {
                var lista = new Nodo_aux.Nodo("LISTA_VARIABLES");
                var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
                var varia = new Nodo_aux.Nodo($1+"");
                iden.agregarHijo(varia);
                lista.agregarHijo(iden);
                $$ = lista;
                
        }
  
;
Asignacion:
         IDENTIFICADOR IGUAL Expresion
          {
                 var asigna = new Nodo_aux.Nodo("ASIGNACION");
                 var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
                 var expre = new Nodo_aux.Nodo("EXPRESION");
                 var varia = new Nodo_aux.Nodo($1+"");
                 iden.agregarHijo(varia);
                 expre.agregarHijo($3);
                 asigna.agregarHijo(iden);
                 asigna.agregarHijo(expre);

                 $$ = asigna;
                 }

;

/*----------------------------------------------Bucles------------------------------*/
Sent_While: RESWHILE PABRE Expresion PCIERRA Bloque
{
        var while_nombre = new Nodo_aux.Nodo("WHILE");
        var cond = new Nodo_aux.Nodo("CONDICION");
        var expr = new Nodo_aux.Nodo("EXPRESION");
        expr.agregarHijo($3);
        cond.agregarHijo(expr);

        while_nombre.agregarHijo(cond);
        while_nombre.agregarHijo($5);
        $$=while_nombre;
}
;
Sent_DoWhile: RESDO Bloque RESWHILE PABRE Expresion PCIERRA 
{
        var do_w = new Nodo_aux.Nodo("DO_WHILE");
        var cond = new Nodo_aux.Nodo("CONDICION");
        var expr = new Nodo_aux.Nodo("EXPRESION");
        expr.agregarHijo($5);
        cond.agregarHijo(expr);

        do_w.agregarHijo($2);
        do_w.agregarHijo(cond);
        $$=do_w;
}
;
Sent_For: RESFOR PABRE Init_For PYC Expresion PYC End_For PCIERRA Bloque
{
       
        var defFor = new Nodo_aux.Nodo("FOR");  
        var cond = new Nodo_aux.Nodo("CONDICION");
        var expr = new Nodo_aux.Nodo("EXPRESION");
        
        expr.agregarHijo($5);
        
        cond.agregarHijo(expr);

        defFor.agregarHijo($3);
        defFor.agregarHijo(cond);
        defFor.agregarHijo($7);
        defFor.agregarHijo($9);

        $$= defFor;
       
}
;
Init_For: Declaracion
{
        
        var init = new Nodo_aux.Nodo("INICIO");
        init.agregarHijo($1);
        
        $$ = init;
       
        
}
        |Asignacion
        {
            var init = new Nodo_aux.Nodo("INICIO");
            init.agregarHijo($1);
            $$ = init;    
        }
;
End_For: Asignacion
{
        var en_for = new Nodo_aux.Nodo("END_FOR");
        en_for.agregarHijo($1);
        $$ = en_for;


}
        |IDENTIFICADOR INCREMENTO
        {
                
                var en_for = new Nodo_aux.Nodo("END_FOR");
                var incre = new Nodo_aux.Nodo("INCREMENTO");
                var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
                var varia = new Nodo_aux.Nodo($1+"");
                iden.agregarHijo(varia);
                incre.agregarHijo(iden);
                en_for.agregarHijo(incre);
                $$ = en_for;
                
        }
        |IDENTIFICADOR DECREMENTO
        {
                var en_for = new Nodo_aux.Nodo("END_FOR");
                var decre = new Nodo_aux.Nodo("DECREMENTO");
                var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
                var varia = new Nodo_aux.Nodo($1+"");
                iden.agregarHijo(varia);
                decre.agregarHijo(iden);
                en_for.agregarHijo(decre);
                $$ = en_for;   
        }
;
/*--------------------------------------Sentencias de control*/
Sent_If: Lista_Condiciones RESELSE Bloque
{
        var sentIf =$1;
        var sElse = new Nodo_aux.Nodo("ELSE");
        sElse.agregarHijo($3);
        sentIf.agregarHijo(sElse);

        $$ = sentIf;
}
        |Lista_Condiciones      { $$ = $1;}
;
Lista_Condiciones: 
        Lista_Condiciones RESELSE RESIF PABRE Expresion PCIERRA Bloque
        {
                var listaCondiciones = $1;
                var elseIf = new Nodo_aux.Nodo("ELSE_IF");

                var cond = new Nodo_aux.Nodo("CONDICION");
                var expr = new Nodo_aux.Nodo("EXPRESION");
                expr.agregarHijo($5);
                cond.agregarHijo(expr);

                elseIf.agregarHijo(cond);
                elseIf.agregarHijo($7);
                listaCondiciones.agregarHijo(elseIf);
                $$ = listaCondiciones;
        }
        |RESIF PABRE Expresion PCIERRA Bloque
        {
                var defIf = new Nodo_aux.Nodo("SENTENCIA_IF");
                var tempIf = new Nodo_aux.Nodo("IF");
                var cond = new Nodo_aux.Nodo("CONDICION");
                var expr = new Nodo_aux.Nodo("EXPRESION");
                expr.agregarHijo($3);
                cond.agregarHijo(expr);
                tempIf.agregarHijo(cond);
                tempIf.agregarHijo($5);
                defIf.agregarHijo(tempIf);
                $$ = defIf;
                
        }
;
Sent_Switch : RESSWITCH PABRE Expresion PCIERRA CABRE Lista_Casos CCIERRA
{
        
        var swi = new Nodo_aux.Nodo("SENT_SWITCH");
        var param = new Nodo_aux.Nodo("PARAMETRO");
        var expr = new Nodo_aux.Nodo("EXPRESION");
        expr.agregarHijo($3);
        param.agregarHijo(expr);
        swi.agregarHijo(param);
        swi.agregarHijo($6);
        $$ = swi;
        
        
}
;
Lista_Casos: Lista_Casos Caso
{
       
        var lista = $1;
        lista.agregarHijo($2);
        $$ = lista;
}
        |Caso
        {
                
                var lista = new Nodo_aux.Nodo("LISTA_CASOS");
                lista.agregarHijo($1);
                $$ = lista;
        }
;
Caso : RESCASE Expresion DOSPUNTOS Lista_Instrucciones 
{
        
        var caso = new Nodo_aux.Nodo("CASO");
        var cond = new Nodo_aux.Nodo("CONDICION");
        var expr = new Nodo_aux.Nodo("EXPRESION");
        expr.agregarHijo($2);
        cond.agregarHijo(expr);
        caso.agregarHijo(cond);
        caso.agregarHijo($4);

        $$ = caso;
        

}
        |RESDEFAULT DOSPUNTOS Lista_Instrucciones
        {
                var def = new Nodo_aux.Nodo("DEFAULT");
                def.agregarHijo($3);
                $$ = def;
                
        }
;
/*--------------------------------------Metodos y funciones--------------------------------*/
Sent_Metodo: RESVOID IDENTIFICADOR PABRE PCIERRA Bloque
{
        var metod = new Nodo_aux.Nodo("METODO");
        var tipo = new Nodo_aux.Nodo("TIPO");
        var vo = new Nodo_aux.Nodo("VOID");
        tipo.agregarHijo(vo);

        var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
        var varia = new Nodo_aux.Nodo($2+"");
        iden.agregarHijo(varia);

        metod.agregarHijo(tipo);
        metod.agregarHijo(iden);
        metod.agregarHijo($5);

        $$ = metod;


}
        |RESVOID IDENTIFICADOR PABRE ListaParametros PCIERRA Bloque
        {
        var metod = new Nodo_aux.Nodo("METODO");
        var tipo = new Nodo_aux.Nodo("TIPO");
        var vo = new Nodo_aux.Nodo("VOID");
        tipo.agregarHijo(vo);

        var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
        var varia = new Nodo_aux.Nodo($2 + "");
        iden.agregarHijo(varia);

        metod.agregarHijo(tipo);
        metod.agregarHijo(iden);
        metod.agregarHijo($4);
        metod.agregarHijo($6);



        $$ = metod;
       

        

        }
;
Sent_Funcion: TipoDato IDENTIFICADOR PABRE PCIERRA Bloque
{
        var func = new Nodo_aux.Nodo("FUNCION");
        var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
        var varia = new Nodo_aux.Nodo($2 +"");
        iden.agregarHijo(varia);
        func.agregarHijo($1);
        func.agregarHijo(iden);
        func.agregarHijo($5);
        $$ = func;
}
        |TipoDato IDENTIFICADOR PABRE ListaParametros PCIERRA Bloque
        {
        var func = new Nodo_aux.Nodo("FUNCION");
        var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
        var varia = new Nodo_aux.Nodo($2 +"");
        iden.agregarHijo(varia);
        func.agregarHijo($1);
        func.agregarHijo(iden);
        func.agregarHijo($4);
        func.agregarHijo($6);
        $$ = func;
        }
;
ListaParametros:
ListaParametros COMA Parametro 
{
        var lista = $1;
        lista.agregarHijo($3);
        $$ = lista;
}
        |Parametro
        {
                var lista = new Nodo_aux.Nodo("LISTA_PARAMETROS");
                lista.agregarHijo($1);
                $$ = lista;
                
        }
;
Parametro: 
TipoDato IDENTIFICADOR
{
        
        var param = new Nodo_aux.Nodo("PARAMETRO");
       
        param.agregarHijo($1);

        var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
        
        var varia = new Nodo_aux.Nodo($2 + "");
        iden.agregarHijo(varia);
        param.agregarHijo(iden);

        $$ = param;
        
}
;
Lista_Argumentos : Lista_Argumentos COMA Expresion
{
        var lista_arg = $1;
        var expr = new Nodo_aux.Nodo("EXPRESION");
        expr.agregarHijo($3);
        lista_arg.agregarHijo(expr);
        $$ = lista_arg;
}
        |Expresion
        {
                var lista_arg = new Nodo_aux.Nodo("LISTA_ARGUMENTOS");
                var expr = new Nodo_aux.Nodo("EXPRESION");
                expr.agregarHijo($1);
                lista_arg.agregarHijo(expr);
                $$ = lista_arg;

        }
;
Sent_Llamada : IDENTIFICADOR PABRE PCIERRA
{
        var llama = new Nodo_aux.Nodo("LLAMADA");
        var ide = new Nodo_aux.Nodo("IDENTIFICADOR");
        var varia = new Nodo_aux.Nodo($1+"");
        ide.agregarHijo(varia);
        llama.agregarHijo(ide);
        $$ = llama;
}
        | IDENTIFICADOR PABRE Lista_Argumentos PCIERRA
        {
        var llama = new Nodo_aux.Nodo("LLAMADA");  
        var ide = new Nodo_aux.Nodo("IDENTIFICADOR");
        var varia = new Nodo_aux.Nodo($1+""); 
        ide.agregarHijo(varia);
        llama.agregarHijo(ide);
        llama.agregarHijo($3);
        $$ = llama;
        }
;
Sent_Return: RESRETURN Expresion
{
        var ret = new Nodo_aux.Nodo("RETURN");
        var expr = new Nodo_aux.Nodo("EXPRESION");
        expr.agregarHijo($2);
        ret.agregarHijo(expr);
        $$ = ret;
}
        | RESRETURN
        {
           var ret = new Nodo_aux.Nodo("RETURN");
           $$ = ret;     
        }
;
Sent_Imprimir : RESCONSOLE PUNTO RESWRITE PABRE Expresion PCIERRA
{
        var print = new Nodo_aux.Nodo("CONSOLE_WRITE");
        var expr = new Nodo_aux.Nodo ("EXPRESION");
        expr.agregarHijo($5);
        print.agregarHijo(expr);
        $$ = print;

}
;
Sent_Main: RESVOID RESMAIN PABRE PCIERRA Bloque
{
        var metod = new Nodo_aux.Nodo("METODO");
        var tipo = new Nodo_aux.Nodo("TIPO");
        var vo = new Nodo_aux.Nodo("MAIN");
        tipo.agregarHijo(vo);
        metod.agregarHijo(tipo);
        metod.agregarHijo($5);

        $$ = metod;
}
;
/*-----------------------------------------------Expresiones y Tipos de Dato-------------------*/
Expresion : Expresion MAS Expresion    
{
        var temp = new Nodo_aux.Nodo("OPERACION");
        var sum = new Nodo_aux.Nodo("SUMA");
        temp.agregarHijo(sum);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        sum.agregarHijo(temp2);
        sum.agregarHijo(temp3);
        temp.agregarHijo(sum);

        $$ = temp;
}
        |Expresion MENOS Expresion  
        {

        var temp = new Nodo_aux.Nodo("OPERACION");
        var res = new Nodo_aux.Nodo("RESTA");
        temp.agregarHijo(res);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        res.agregarHijo(temp2);
        res.agregarHijo(temp3);
        temp.agregarHijo(res);

        $$ = temp;
        }  
        |Expresion MULTI Expresion
        {

        var temp = new Nodo_aux.Nodo("OPERACION");
        var op = new Nodo_aux.Nodo("MULTI");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
        }
        |Expresion DIV Expresion
        {
        var temp = new Nodo_aux.Nodo("OPERACION");
        var op = new Nodo_aux.Nodo("DIV");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
        }
        |Expresion MAYOR Expresion
        {
        var temp = new Nodo_aux.Nodo("RELACION");
        var op = new Nodo_aux.Nodo("MAYOR");
        temp.agregarHijo(op);

        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
        }
        |Expresion MENOR Expresion
        {
        var temp = new Nodo_aux.Nodo("RELACION");
        var op = new Nodo_aux.Nodo("MENOR");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
        }
        |Expresion DIFERENTEDE Expresion
        {
        var temp = new Nodo_aux.Nodo("RELACION");
        var op = new Nodo_aux.Nodo("DIFERENTE_DE");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
        }
        |Expresion DOBLEIGUAL Expresion
        {
        var temp = new Nodo_aux.Nodo("RELACION");
        var op = new Nodo_aux.Nodo("COMPARACION");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
       
        }
        |Expresion MAYORIGUAL Expresion
        {
        var temp = new Nodo_aux.Nodo("RELACION");
        var op = new Nodo_aux.Nodo("MAYOR_IGUAL");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;     
        }
        |Expresion MENORIGUAL Expresion
        {
        var temp = new Nodo_aux.Nodo("RELACION");
        var op = new Nodo_aux.Nodo("MENOR_IGUAL");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
        }
        |Expresion AND Expresion
        {
        var temp = new Nodo_aux.Nodo("LOGICA");
        var op = new Nodo_aux.Nodo("AND");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
        }
        |Expresion OR Expresion
        {
        var temp = new Nodo_aux.Nodo("LOGICA");
        var op = new Nodo_aux.Nodo("OR");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($1);
        var temp3 = new Nodo_aux.Nodo("EXPRESION");
        temp3.agregarHijo($3);

        op.agregarHijo(temp2);
        op.agregarHijo(temp3);
        temp.agregarHijo(op);

        $$ = temp;
        }
        |NOT Expresion
        {
        var temp = new Nodo_aux.Nodo("LOGICA");
        var op = new Nodo_aux.Nodo("NOT");
        temp.agregarHijo(op);
        var temp2 = new Nodo_aux.Nodo("EXPRESION");
        temp2.agregarHijo($2);

       op.agregarHijo(temp2);

        $$ = temp;
        }
        |PABRE Expresion PCIERRA        {$$ = $2;}
        |MENOS Expresion %prec UMenos   
        {
                var temp = new Nodo_aux.Nodo("OPERACION");
                var temp2 = new Nodo_aux.Nodo("MENOS_UNARIO");
                var expr = new Nodo_aux.Nodo("EXPRESION");
                temp.agregarHijo(temp2);
                expr.agregarHijo(temp2);

                temp2.agregarHijo(expr);

                $$ = temp;
        }
        |MAS Expresion %prec UMas
        {
                var temp = new Nodo_aux.Nodo("OPERACION");
                var temp2 = new Nodo_aux.Nodo("MAS_UNARIO");
                var expr = new Nodo_aux.Nodo("EXPRESION");
                temp.agregarHijo(temp2);
                expr.agregarHijo(temp2);

                temp2.agregarHijo(expr);

                $$ = temp;
        }
        |ENTERO 
        {
                var temp = new Nodo_aux.Nodo("EXPRESION");
                var temp2 = new Nodo_aux.Nodo("PRIMITIVO");
                var ent = new Nodo_aux.Nodo($1+"");
                temp2.agregarHijo(ent);
                temp.agregarHijo(temp2);
                $$= temp;
        }
        |DECIMAL
        {
                var temp = new Nodo_aux.Nodo("EXPRESION");
                var temp2 = new Nodo_aux.Nodo("PRIMITIVO");
                var dec = new Nodo_aux.Nodo($1+"");
                temp2.agregarHijo(dec);
                temp.agregarHijo(temp2);
                $$= temp;     
        }
        |CADENA
        {
                var temp = new Nodo_aux.Nodo("EXPRESION");
                var temp2 = new Nodo_aux.Nodo("PRIMITIVO");
                var cad = new Nodo_aux.Nodo($1+"");
                temp2.agregarHijo(cad);
                temp.agregarHijo(temp2);
                $$= temp;
        }
        |CADENAHTML
        {
               
                var temp = new Nodo_aux.Nodo("EXPRESION");
                var temp2;
                if ($1.length == 1){
                temp2 = new Nodo_aux.Nodo("PRIMITIVO");
                }else{
                     temp2 = new Nodo_aux.Nodo("HTML");   
                }
                
               var car = new Nodo_aux.Nodo($1);
                temp2.agregarHijo(car);
               temp.agregarHijo(temp2);
                $$ = temp;  
        }
        |RESTRUE
        {

                var temp = new Nodo_aux.Nodo("EXPRESION");
                var temp2 = new Nodo_aux.Nodo("PRIMITIVO");
                var tru = new Nodo_aux.Nodo($1+"");
                temp2.agregarHijo(tru);
                temp.agregarHijo(temp2);
                
                
                $$= temp;
        }
        |RESFALSE
        {

                var temp = new Nodo_aux.Nodo("EXPRESION");
                var temp2 = new Nodo_aux.Nodo("PRIMITIVO");
                var fals = new Nodo_aux.Nodo($1+"");
                temp2.agregarHijo(fals);
                temp.agregarHijo(temp2);
                $$= temp;
        }
        |IDENTIFICADOR
        {
                var expr = new Nodo_aux.Nodo("EXPRESION");
                var iden = new Nodo_aux.Nodo("IDENTIFICADOR");
                var varia = new Nodo_aux.Nodo($1+"");
                iden.agregarHijo(varia);
                expr.agregarHijo(iden);
                $$ = expr;
                
                
        }
        |IDENTIFICADOR INCREMENTO
        {
                var expr = new Nodo_aux.Nodo("EXPRESION");
                var ide = new Nodo_aux.Nodo("IDENTIFICADOR");
                var incre = new Nodo_aux.Nodo("INCREMENTO");
                var varia = new Nodo_aux.Nodo($1+"");
                ide.agregarHijo(varia);
                expr.agregarHijo(ide);
                expr.agregarHijo(incre);
                $$ = expr;
        }
        |IDENTIFICADOR DECREMENTO
        {
                var expr = new Nodo_aux.Nodo("EXPRESION");
                var ide = new Nodo_aux.Nodo("IDENTIFICADOR");
                var decre = new Nodo_aux.Nodo("DECREMENTO");
                var varia = new Nodo_aux.Nodo($1+"");
                ide.agregarHijo(varia);
                expr.agregarHijo(ide);
                expr.agregarHijo(decre);
                $$ = expr;
        }
;
TipoDato: 
        RESINT
        {
                var temp = new Nodo_aux.Nodo("TIPO");
                var temp2 = new Nodo_aux.Nodo("INT");
                temp.agregarHijo(temp2);
                $$ = temp;
                
        }
        |RESDOUBLE
        {
                var temp = new Nodo_aux.Nodo("TIPO");
                var temp2 = new Nodo_aux.Nodo("DOUBLE");
                temp.agregarHijo(temp2);
                $$ = temp;
        }
        |RESSTRING
        {
                var temp = new Nodo_aux.Nodo("TIPO");
                var temp2 = new Nodo_aux.Nodo("STRING");
                temp.agregarHijo(temp2);
                $$ = temp;
        }
        |RESBOOL
        {
                var temp = new Nodo_aux.Nodo("TIPO");
                var temp2 = new Nodo_aux.Nodo("BOOL");
                temp.agregarHijo(temp2);
                $$ = temp;
        }
        |RESCHAR
        {
                
                var temp = new Nodo_aux.Nodo("TIPO");
                var temp2 = new Nodo_aux.Nodo("CHAR");
                temp.agregarHijo(temp2);
                $$ = temp;
                
        }

;





