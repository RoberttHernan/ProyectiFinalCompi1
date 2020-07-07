%{
let textoTraducido;

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


('[.]')               return 'CARACTER';
\"[^\"]*\"		{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+"."[0-9]+    	return 'DECIMAL';
[0-9]+  		return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]*	return 'IDENTIFICADOR';




[ \t\r\n\f] {}



<<EOF>>				return 'EOF';
.					{ console.error('Error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column);
                                        
                                                 }

/lex


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
        
  return $$ ;
        
} ;

/*-----------------------------------------Instrucciones y Bloque --------------------------------*/
Bloque : 
        CABRE CCIERRA
        {$$ = "\n";}
        |CABRE Lista_Instrucciones CCIERRA
        {
            $$ ="\n"+$2+"\n";
        }

        
;
Lista_Instrucciones: 
        Lista_Instrucciones Instruccion
        {
            $$ = $1 + $2;
        }
        |Instruccion 
        {
            $$ = $1;
        }

        
;


Instruccion: 
        Declaracion PYC   { $$ = $1 +"\n";}
        |Asignacion PYC   { $$ = $1+"\n";}     
        |Sent_Imprimir PYC      {$$ = $1 +"\n"}
        |RESBREAK PYC               
        |RESCONTINUE PYC 
        |Sent_Return PYC  {$$ = $1+"\n";}     
        |Sent_Metodo     {$$ = $1+"\n";}       
        |Sent_Funcion      {$$ = $1+"\n";}       
        |Sent_Llamada PYC     {$$ = $1+"\n";} 
        |IDENTIFICADOR INCREMENTO PYC {$$ = $1+"++\n";}
        |IDENTIFICADOR DECREMENTO PYC  {$$ = $1+"--\n";}
        |Sent_If  {$$ = $1+"\n";}  
        |Sent_Switch   {$$ = $1+"\n";}  
        |Sent_For     {$$ = $1+"\n";}    
        |Sent_While    {$$ = $1+"\n";}  
        |Sent_DoWhile PYC   {$$ = $1+"\n";}  
        |Sent_Main      {$$ = $1+"\n";}  
        |error  PYC
        {
                console.log('Sintactico',yytext,this._$.first_line,this._$.first_column);
                return;
                
                
        }
;

/*-----------------------------------Declaracion y Asignacion */
Declaracion: 
        TipoDato Lista_Identificador IGUAL Expresion
        {
            $$ = "var " +$2 +" = "+$4;
        }
        | TipoDato Lista_Identificador     
        {
            $$ = "var "+$2;
        }   
    
;
Lista_Identificador:
        Lista_Identificador COMA IDENTIFICADOR  
        {
            $$ = $1+","+$3;
        }
        |IDENTIFICADOR 
        {
            $$ = $1;
        }
;
Asignacion:
        IDENTIFICADOR IGUAL Expresion
        {
            $$ = $1 +" = "+ $3;
        }

;
/*----------------------------------------------Bucles------------------------------*/
Sent_While: RESWHILE PABRE Expresion PCIERRA Bloque
{
    $$= "while "+ $3 +":\n"+$5+"\n";
}
;
Sent_DoWhile: RESDO Bloque RESWHILE PABRE Expresion PCIERRA 
{
    $$ = "while True:\n"+$2 +"if("+$5+"):\nbreak";
}
;
Sent_For: RESFOR PABRE Init_For PYC Expresion PYC End_For PCIERRA Bloque
;
Init_For: Declaracion

        |Asignacion
;
End_For: Asignacion
        |IDENTIFICADOR INCREMENTO
        |IDENTIFICADOR DECREMENTO
;

/*--------------------------------------Sentencias de control----------------------------------*/
Sent_If: Lista_Condiciones RESELSE Bloque
    {
        $$ = $1 +"\nelse"+$3;
    }
        |Lista_Condiciones 
        {
            $$ = $1;
        }    
;
Lista_Condiciones: 
        Lista_Condiciones RESELSE RESIF PABRE Expresion PCIERRA Bloque
        {
            $$ = $1 +"elif " + $5+":" +$7;
        }
        |RESIF PABRE Expresion PCIERRA Bloque
        {
            $$ = "if "+ $3 +":" +$5 ;
        }
;
Sent_Switch : RESSWITCH PABRE Expresion PCIERRA CABRE Lista_Casos CCIERRA
{
    $$ = "def switch (case,"+$3+"):\nswitcher ={\n"+$6 +"\n}\n";
}
;
Lista_Casos: Lista_Casos Caso
{
    $$ = $1+$2;
}
        |Caso   {$$=$1;}
;
Caso : RESCASE Expresion DOSPUNTOS Lista_Instrucciones 
{
    $$ = $2 +" :" +$4+"\n";
}
        |RESDEFAULT DOSPUNTOS Lista_Instrucciones
        {
            $$ = 0 +": " +$3;
        }
;
/*--------------------------------------Metodos y funciones--------------------------------*/
Sent_Metodo: RESVOID IDENTIFICADOR PABRE PCIERRA Bloque
{
    $$ = "def "+ $2 + "():\n" + $5;
}
        |RESVOID IDENTIFICADOR PABRE ListaParametros PCIERRA Bloque
        {
            $$ = "def "+$2 +"("+$4+"):\n "+ $6;
        }
;
Sent_Funcion: TipoDato IDENTIFICADOR PABRE PCIERRA Bloque
{
    $$ = "def " +$2+ "():\n "+ $5;
}
        |TipoDato IDENTIFICADOR PABRE ListaParametros PCIERRA Bloque
        {
            $$ = "def "+$2 +"("+$4+"):\n"+ $6;
        }
;
ListaParametros:
ListaParametros COMA Parametro 
{
    $$ = $1 +"," +$3;
}
        |Parametro
        {$$ = $1;}

;
Parametro: 
TipoDato IDENTIFICADOR
{
    $$ = $2;
}
;
Lista_Argumentos : Lista_Argumentos COMA Expresion
{
    $$ = $1 +"," +$3;
}
        |Expresion
        {$$ = $1}

;
Sent_Llamada : IDENTIFICADOR PABRE PCIERRA
{
    $$ = $1 +"()";
}

        | IDENTIFICADOR PABRE Lista_Argumentos PCIERRA
        {
            $$ = $1 +"("+$3 +")";
        }
;
Sent_Return: RESRETURN Expresion
    {
        $$ = "return "+ $2;
    }
        | RESRETURN
        {
            $$ = "return";
        }
;
Sent_Imprimir : RESCONSOLE PUNTO RESWRITE PABRE Expresion PCIERRA
{
    $$ = "print("+$5+")";
}
;
Sent_Main: RESVOID RESMAIN PABRE PCIERRA Bloque
{
    $$ = "def main ():" +$5 + "if__name=\"__main__\":\"\n main()";
}
;

/*-----------------------------------------------Expresiones y Tipos de Dato-------------------*/
Expresion : Expresion MAS Expresion  {$$= $1+"+"+$3;}  
        |Expresion MENOS Expresion   {$$= $1+"-"+$3;}
        |Expresion MULTI Expresion {$$= $1+"*"+$3;}
        |Expresion DIV Expresion    {$$= $1+"/"+$3;}
        |Expresion MAYOR Expresion {$$= $1+">"+$3;}
        |Expresion MENOR Expresion {$$= $1+">"+$3;}
        |Expresion DIFERENTEDE Expresion {$$= $1+"!="+$3;}
        |Expresion DOBLEIGUAL Expresion {$$= $1+"=="+$3;}
        |Expresion MAYORIGUAL Expresion {$$= $1+">="+$3;}
        |Expresion MENORIGUAL Expresion {$$= $1+"<="+$3;}
        |Expresion AND Expresion {$$ = $1+" and " +$3;}
        |Expresion OR Expresion { $$ = $1 + " or "+$3;}
        |NOT Expresion {$$ = " not "+$2;}
        |PABRE Expresion PCIERRA        {$$ = "("+$2+")";}
        |MENOS Expresion %prec UMenos   
        |MAS Expresion %prec UMas
        |ENTERO 
        {
            $$ = $1;
        }
        |DECIMAL
        {
            $$ = $1;
        }
        |CADENA
        {
            $$ = "\""+$1+"\"";
        }
        |CARACTER
        {
            $$ = "\'"+$1+"\'";
        }
        |RESTRUE
        {
            $$ = "true";
        }
        |RESFALSE
        {
            $$ = "false";
        }
        |IDENTIFICADOR
        {
            $$ = $1;
        }
        |IDENTIFICADOR INCREMENTO
        {
            $$ = $1+"++";
        }
        |IDENTIFICADOR DECREMENTO
        {
            $$ = $1+"--";
        }
;
TipoDato: 
        RESINT
        {
            $$ = "var";
        }
        |RESDOUBLE
        {
            $$ = "var";
        }
        |RESSTRING
        {
            $$ = "var";
        }
        |RESBOOL
        {
            $$ = "var";
        }
        |RESCHAR
        {
            $$ = "var";
        }
;