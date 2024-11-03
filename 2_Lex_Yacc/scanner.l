
%{
#include <stdio.h>
#include <string.h>

typedef struct {
    char token[257];
    int symbolTableCode;
} PIF;

typedef struct {
    char token[257];
    int index;
} ST;

ST SymbolTable[100];
int stLength = 0;

PIF ProgramInternalForm[300];
int pifLength = 0;

int errorFound = 0;
int lineNumber = 1;

int addToST(char* token) {
    for(int i = 0; i < stLength; i++) {
        if(strcmp(SymbolTable[i].token, token) == 0) {
            return SymbolTable[i].index;
        }
    }
    strcpy(SymbolTable[stLength].token, token);
    SymbolTable[stLength].index = stLength;
    stLength++;
    return stLength - 1;
}

void addToPIF(char* token, int stCode) {
    strcpy(ProgramInternalForm[pifLength].token, token);
    ProgramInternalForm[pifLength].symbolTableCode = stCode;
    pifLength++;
}

void showSymbolTable() {
    printf(" SYMBOL TABLE \n\n");
    for(int i = 0; i < stLength; i++) {
        printf("%s\t%d\n", SymbolTable[i].token, SymbolTable[i].index);
    }
    printf(" END ST \n\n\n");
}

void showProgramInternalForm() {
    printf(" PROGRAM INTERNAL FORM \n\n");
    for(int i = 0; i < pifLength; i++) {
        printf("%s\t%d\n", ProgramInternalForm[i].token, ProgramInternalForm[i].symbolTableCode);
    }
    printf(" END PIF \n\n\n");
}
%}


DIGIT           [0-9]
ID              [a-zA-Z_][a-zA-Z0-9_]*
INT             [0-9]+
BOOL            TRUE|FALSE
KEYWORD         VAR|BEGIN|END|READ|WRITE|WHILE|DO|IF|THEN|STRUCT|MOD
OPERATOR        :=|\\+|\\-|\\*|\\/|<|>|<=|>=|=|AND
COMMENT         \\/\\/[^\\n]*

%%

VAR             { addToPIF("VAR", -1); }
BEGIN           { addToPIF("BEGIN", -1); }
END             { addToPIF("END", -1); }
READ            { addToPIF("READ", -1); }
WRITE           { addToPIF("WRITE", -1); }
WHILE           { addToPIF("WHILE", -1); }
DO              { addToPIF("DO", -1); }
IF              { addToPIF("IF", -1); }
THEN            { addToPIF("THEN", -1); }
STRUCT          { addToPIF("STRUCT", -1); }
MOD             { addToPIF("MOD", -1); }


TRUE            { addToPIF("TRUE", -1); }
FALSE           { addToPIF("FALSE", -1); }

":="            { addToPIF(":=", -1); }
"+"           { addToPIF("+", -1); }
"-"           { addToPIF("-", -1); }
"*"           { addToPIF("*", -1); }
"<"             { addToPIF("<", -1); }
">"             { addToPIF(">", -1); }
"<="            { addToPIF("<=", -1); }
">="            { addToPIF(">=", -1); }
"="             { addToPIF("=", -1); }
"AND"           { addToPIF("AND", -1); }
";"             { addToPIF(";", -1); }
":"             { addToPIF(":", -1); }
"("             { addToPIF("(", -1); }
")"             { addToPIF(")", -1); }
"."             { addToPIF(".", -1); }
"{"             { addToPIF("{", -1); }
"}"             { addToPIF("}", -1); }

"\"" { int stCode = addToST("\""); addToPIF("QUOTE", stCode); }


{ID}            { int stCode = addToST(yytext); addToPIF("ID", stCode); }
{INT}           { int stCode = addToST(yytext); addToPIF("CONST", stCode); }



\n              { lineNumber++; }


[ \t\r]+        { /* Ignore whitespace */ }


.               { errorFound = 1; printf("Lexical error at line %d: Unrecognized symbol '%s'\n", lineNumber, yytext); }
%%


int main(int argc, char** argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Could not open file");
            return 1;
        }
        yyin = file;
    }

    yylex();

    if (errorFound == 0) {
        showSymbolTable();
        showProgramInternalForm();
    }

    return 0;
}





