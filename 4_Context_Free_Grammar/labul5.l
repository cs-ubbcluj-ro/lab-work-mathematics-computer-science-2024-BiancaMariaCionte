%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

%}

%%

"<="        {return LESS_EQUAL;}
"<"         {return LESS;}

"="         {return EQUAL;}

"+"         {return PLUS;}
"*"         {return TIMES;}
"AND"       {return AND;}
"MOD"       {return MOD;}

"VAR"       {return VAR_K;}
"BEGIN"     {return BEGIN_K;}
"END"       {return END_K;}
"DO"        {return DO_K;}
"IF"        {return IF_K;}
"ELSE"      {return ELSE_K;}
"THEN"      {return THEN_K;}
"WHILE"     {return WHILE_K;}
"READ"      {return READ_K;}
"WRITE"     {return WRITE_K;}
"TRUE"      {return TRUE_K;}
"INT"       {return INT_K;}
"BOOL"      {return BOOL_K;}

":="        {return ASSIGN;}

[_a-zA-Z][_a-zA-Z0-9]* {return IDENTIFIER;}
[+-]?(([1-9][0-9]*)|0) {return INTCONST;}
[ \t\r\n]+  {/* ignore whitespace */}

\'[^\']\'  {return CHAR_LIT;}
\"[^\"\n]*\" {return STR_LIT;}

"("         {return LPAREN;}
")"         {return RPAREN;}
";"         {return SEMICOLON;}
"."         {return PERIOD;}
":"         {return TWO_DOTS;}
#[ \t]       {/* ignore whitespace */}
#[\r\n]      {/* ignore newlines */}
.           {return yytext[0];}

%%

int yywrap(void) {
    return 1;
}

