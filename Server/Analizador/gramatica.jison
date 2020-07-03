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

"="         return 'IGUAL';
"=="        return 'DOBLEIGUAL';
"<"         return 'MAYOR';
">"         return 'MENOR';
"!="        return 'DIFERENTEDE';
"<="        return 'MENORIGUAL';
">="        return 'MAYORIGUAL';
"&&"        return 'AND';
"||"        return 'OR';
"!"         return 'NOT';

"+"         return 'MAS';
"-"         return 'MENOS';
"/"         return 'DIV';
"*"         return 'MULTI';
"++"        return 'INCREMENTO';
"--"        return  'DECREMENTO';


\"[^\"]*\"		{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+  		return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]*	return 'IDENTIFICADOR';
[0-9]+"."[0-9]+    	return 'DECIMAL';


\s+     {}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] {}


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
        var raiz = new Nodo_aux.Nodo("RAIZ");
        raiz.agregarHijo($1);
        $$ = raiz; 
        return $$;

        
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
                var cont = new Nodo_aux.Nodo("CONT");
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
        |Sent_DoWhile   {$$ = $1;}
        |Sent_Main      {$$ = $1;}    
        |error  
        {
                var er = new Nodo_aux.Nodo("Error");

             Errores_1.errores.add(new nodoError_1.NodoError('Sintactico',yytext,this._$.first_line,this._$.first_column));
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
;
Sent_DoWhile: RESDO Bloque RESWHILE PABRE Expresion PCIERRA 
;
Sent_For: RESFOR PABRE Init_For PYC Expresion PYC End_For PYC PCIERRA Bloque
;
Init_For: Declaracion
        |Asignacion
;
End_For: Asignacion
        |IDENTIFICADOR INCREMENTO
        |IDENTIFICADOR DECREMENTO
;
/*--------------------------------------Sentencias de control*/
Sent_If: Lista_Condiciones RESELSE Bloque
        |Lista_Condiciones
;
Lista_Condiciones: Lista_Condiciones RESELSE RESIF PABRE Expresion PCIERRA Bloque
        |RESIF PABRE Expresion PCIERRA Bloque
;
Sent_Switch : RESWHILE PABRE Expresion PCIERRA CABRE Lista_Casos CCIERRA
;
Lista_Casos: Lista_Casos Caso
        |Caso
;
Caso : RESCASE Expresion DOSPUNTOS Lista_Instrucciones 
        RESDEFAULT DOSPUNTOS Lista_Instrucciones
;
/*--------------------------------------Metodos y funciones--------------------------------*/
Sent_Metodo: RESVOID IDENTIFICADOR PABRE PCIERRA Bloque
{
        var metod = new Nodo_aux.Nodo("Metodo");
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
        |TipoDato IDENTIFICADOR PABRE ListaParametros PCIERRA Bloque
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
        |Expresion
;
Sent_Llamada : IDENTIFICADOR PABRE PCIERRA
        | IDENTIFICADOR PABRE Lista_Argumentos PCIERRA
;
Sent_Return: RESRETURN Expresion
        | RESRETURN
;
Sent_Imprimir : RESCONSOLE PUNTO RESWRITE PABRE Expresion PCIERRA
;
Sent_Main: RESVOID RESMAIN PABRE PCIERRA CABRE Lista_Instrucciones CCIERRA
;
/*-----------------------------------------------Expresiones y Tipos de Dato-------------------*/
Expresion : Expresion MAS Expresion    
        |Expresion MENOS Expresion    
        |Expresion MULTI Expresion
        |Expresion DIV Expresion
        |Expresion MAYOR Expresion
        |Expresion MENOR Expresion
        |Expresion DIFERENTEDE Expresion
        |Expresion DOBLEIGUAL Expresion
        |Expresion MAYORIGUAL Expresion
        |Expresion MENORIGUAL Expresion
        |Expresion AND Expresion
        |Expresion OR Expresion
        |NOT Expresion
        |PABRE Expresion PCIERRA 
        |MENOS Expresion %prec UMenos
        |MAS Expresion %prec UMas
        |ENTERO 
        {
                var temp = new Nodo_aux.Nodo("EXPRESION");
                var temp2 = new Nodo_aux.Nodo("PRIMITIVO");
                temp.agregarHijo(temp2);
                $$= temp;
        }
        |DECIMAL
        |CADENA
        |RESTRUE
        |RESFALSE
        |IDENTIFICADOR
        |IDENTIFICADOR INCREMENTO
        |IDENTIFICADOR DECREMENTO
        |IDENTIFICADOR PABRE PCIERRA
        |IDENTIFICADOR PABRE Lista_Argumentos PCIERRA

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





