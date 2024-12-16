%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h" 

void yyerror(const char *s);
int yylex(void);

extern FILE *yyin;
extern int yylineno;

int production_index = 0; // To track production indexes
%}

/* Tokens */
%token LESS_EQUAL
%token LESS
%token EQUAL
%token PLUS
%token TIMES
%token AND
%token VAR_K
%token BEGIN_K
%token END_K
%token READ_K
%token WRITE_K
%token IF_K
%token THEN_K
%token ELSE
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
%token FALSE_K

/* Precedence and associativity */
%left PLUS
%left TIMES MOD
%nonassoc LESS LESS_EQUAL EQUAL
%right AND
%nonassoc THEN_K
%nonassoc ELSE

%%

program:
    VAR_K declaration_list SEMICOLON cmpdstmt PERIOD {
        printf("Program syntactic correct\n");
        printf("Production used: %d\n", ++production_index);
    }
    ;

declaration_list:
    declaration {
        printf("Production used: %d\n", ++production_index);
    }
    | declaration_list SEMICOLON declaration {
        printf("Production used: %d\n", ++production_index);
    }
    ;

declaration:
    IDENTIFIER TWO_DOTS type {
        printf("Production used: %d\n", ++production_index);
    }
    ;

type:
    BOOL_K {
        printf("Production used: %d\n", ++production_index);
    }
    | INT_K {
        printf("Production used: %d\n", ++production_index);
    }
    ;

cmpdstmt:
    BEGIN_K stmtlist END_K  {
        printf("Production used: %d\n", ++production_index);
    }
    ;

stmtlist:
    stmt {
        printf("Production used: %d\n", ++production_index);
    }
    | stmtlist SEMICOLON stmt {
        printf("Production used: %d\n", ++production_index);
    }
    | structdecl {
        printf("Production used: %d\n", ++production_index);
    }
    | /* empty */
    ;

stmt:
    simplstmt {
        printf("Production used: %d\n", ++production_index);
    }
    | structstmt {
        printf("Production used: %d\n", ++production_index);
    }
    ;

simplstmt:
    assignstmt {
        printf("Production used: %d\n", ++production_index);
    }
    | iostmt {
        printf("Production used: %d\n", ++production_index);
    }
    ;

assignstmt:
    IDENTIFIER ASSIGN expression {
        printf("Production used: %d\n", ++production_index);
    }
    ;

iostmt:
    READ_K LPAREN IDENTIFIER RPAREN {
        printf("Production used: %d\n", ++production_index);
    }
    | WRITE_K LPAREN expression RPAREN SEMICOLON {
        printf("Production used: %d\n", ++production_index);
    }
    ;

expression:
    expression PLUS term {
        printf("Production used: %d\n", ++production_index);
    }
    | term {
        printf("Production used: %d\n", ++production_index);
    }
    ;

term:
    term TIMES factor {
        printf("Production used: %d\n", ++production_index);
    }
    | factor {
        printf("Production used: %d\n", ++production_index);
    }
    ;

factor:
    LPAREN expression RPAREN {
        printf("Production used: %d\n", ++production_index);
    }
    | IDENTIFIER {
        printf("Production used: %d\n", ++production_index);
    }
    | INTCONST {
        printf("Production used: %d\n", ++production_index);
    }
    | CHAR_LIT {
        printf("Production used: %d\n", ++production_index);
    }
    | STR_LIT {
        printf("Production used: %d\n", ++production_index);
    }
    | TRUE_K {
        printf("Production used: %d\n", ++production_index);
    }
    | factor MOD factor {
        printf("Production used: %d\n", ++production_index);
    }
    | accessfield {
        printf("Production used: %d\n", ++production_index);
    }
    | FALSE_K {
        printf("Production used: %d\n", ++production_index);
    }
    ;

structstmt:
    ifstmt {
        printf("Production used: %d\n", ++production_index);
    }
    | whilestmt {
        printf("Production used: %d\n", ++production_index);
    }
    | cmpdstmt {
        printf("Production used: %d\n", ++production_index);
    }
    ;

ifstmt:
    IF_K condition THEN_K stmt ELSE stmt {
        printf("Matched IF-ELSE statement at line %d\n", yylineno);
        printf("Production used: %d\n", ++production_index);
    }
    | IF_K condition THEN_K stmt {
        printf("Matched IF statement without ELSE at line %d\n", yylineno);
        printf("Production used: %d\n", ++production_index);
    }
    ;

whilestmt:
    WHILE_K condition DO_K stmt {
        printf("Production used: %d\n", ++production_index);
    }
    ;

structdecl:
    STRUCT_K IDENTIFIER LPAREN fieldlist RPAREN {
        printf("Production used: %d\n", ++production_index);
    }
    ;

fieldlist:
    field {
        printf("Production used: %d\n", ++production_index);
    }
    | fieldlist SEMICOLON field {
        printf("Production used: %d\n", ++production_index);
    }
    | /* empty */ {
        printf("Production used: %d\n", ++production_index);
    }
    ;

field:
    IDENTIFIER TWO_DOTS type {
        printf("Production used: %d\n", ++production_index);
    }
    ;

accessfield:
    IDENTIFIER PERIOD IDENTIFIER {
        printf("Production used: %d\n", ++production_index);
    }
    ;

condition:
    relation_expr {
        printf("Production used: %d\n", ++production_index);
    }
    | relation_expr AND condition {
        printf("Production used: %d\n", ++production_index);
    }
    | IDENTIFIER AND condition {
        printf("Production used: %d\n", ++production_index);
    }
    | IDENTIFIER {
        printf("Production used: %d\n", ++production_index);
    }
    ;

relation_expr:
    expression relation expression {
        printf("Production used: %d\n", ++production_index);
    }
    ;

relation:
    LESS {
        printf("Production used: %d\n", ++production_index);
    }
    | LESS_EQUAL {
        printf("Production used: %d\n", ++production_index);
    }
    | EQUAL {
        printf("Production used: %d\n", ++production_index);
    }
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
