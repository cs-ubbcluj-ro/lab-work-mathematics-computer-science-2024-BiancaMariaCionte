#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);

extern FILE *yyin;
extern int yylineno;
%}

/* Tokens */
%token LESS_EQUAL
%token LESS
%token EQUAL
%token PLUS
%token TIMES
%token AND
%token VAR
%token BEGIN_K
%token END_K
%token READ_K
%token WRITE_K
%token IF_K
%token THEN_K
%token ELSE_K
%token WHILE_K
%token DO_K
%token TRUE_K
%token INT_K
%token BOOL_K
%token TIMES_K
%token MOD
%token TWO_DOTS

%token LPAREN
%token RPAREN
%token SEMICOLON
%token PERIOD
%token STRUCT_K

%token IDENTIFIER
%token INTCONST
%token CHAR_LIT
%token STR_LIT
%token ASSIGN

/* Precedence and associativity */
%left PLUS
%left TIMES_K MOD
%nonassoc LESS LESS_EQUAL EQUAL
%left AND
%nonassoc THEN_K
%nonassoc ELSE_K

%%
program:
    VAR declaration_list cmpdstmt PERIOD {
        printf("Program syntactic correct\n");
    }
    ;

declaration_list:
    declaration
    | declaration_list SEMICOLON declaration
    ;

declaration:
    IDENTIFIER TWO_DOTS type SEMICOLON
    ;

type:
    BOOL_K
    | INT_K
    ;

cmpdstmt:
    BEGIN_K stmtlist END_K
    ;

stmtlist:
    stmt
    | stmtlist SEMICOLON stmt
    | structdecl
    | /* empty */
    ;

stmt:
    simplstmt
    | structstmt
    ;

simplstmt:
    assignstmt
    | iostmt
    ;

assignstmt:
    IDENTIFIER ASSIGN expression
    ;

iostmt:
    READ_K LPAREN IDENTIFIER RPAREN
    | WRITE_K LPAREN expression RPAREN
    ;

expression:
    expression PLUS term
    | term
    ;

term:
    term TIMES_K factor
    | factor
    ;

factor:
    LPAREN expression RPAREN
    | IDENTIFIER
    | INTCONST
    | CHAR_LIT
    | STR_LIT
    | factor MOD factor
    | accessfield
    ;

structstmt:
    ifstmt
    | whilestmt
    | cmpdstmt
    ;

ifstmt:
    IF_K condition THEN_K stmt
    | IF_K condition THEN_K stmt ELSE_K stmt
    ;

whilestmt:
    WHILE_K condition DO_K stmt
    ;

structdecl:
    STRUCT_K IDENTIFIER LPAREN fieldlist RPAREN


fieldlist:
    field
    | fieldlist SEMICOLON field
    | /* empty */
    ;

field:
    IDENTIFIER TWO_DOTS type
    ;

accessfield:
    IDENTIFIER PERIOD IDENTIFIER
    ;

condition:
    expression relation expression
    | expression AND expression
    ;

relation:
    LESS | LESS_EQUAL | EQUAL
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        printf("Using stdin instead of file\n");
        yyin = stdin;
    } else {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error opening file");
            exit(EXIT_FAILURE);
        }
    }

    if (yyparse() == 0) {
        printf("Program syntactic correct\n");
    } else {
        printf("Parsing failed.\n");
    }

    fclose(yyin);
    return 0;
}