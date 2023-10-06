
%option noyywrap

%{

#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>
int numLines = 1;

char varIds[30][30] = {};
int actualId = 1;
bool breakStrcmp = false;

%}

ENDLINE     \r?\n
WORD        [A-Za-z_][A-Za-z_0-9]*
SPACE   	[ \t\f\r\n]*
ARRAY       \[[^\][]*\]
VAR         (\*{SPACE})*{WORD}({SPACE}{ARRAY})*
VAR_POINTER (\&){WORD}*
VAR_POINTER_PARENT \*{SPACE}\(([A-Za-z_0-9])+\)
VAR_NO_POINTER         {WORD}({SPACE}{ARRAY})*
DIGIT		[0-9]
STRING 		\"([^\\\"]|\\.)*\"

LIB_STDIO	<stdio.h>
LIB_CONIO	<conio.h>
EQUAL 		=
LOGICAL 	"||"|"&&"
RELATIONAL	"!="|"<"|"<="|"=="|">="|">"
ARITMETIC   "++"|"+"|"-"|"*"|"/"
COMMA		","
SEMICOLON	";"
L_BRACKET   "{"
R_BRACKET   "}"
L_PAREN		"("
R_PAREN		")"
COMMENT		"//"[^\n]*

%%





	/* ----- ESPAÇOS E ENDLINES ----- */
{ENDLINE} 	numLines++;{ printf("\n\n\n******** Linha: %d ********\n", numLines); }









	/* ----- PALAVRAS RESERVADAS E LIBS ----- */
#include|scanf|printf|do|while|for|if|else|switch|case|void|return|NULL|null|int|float|double|String|string|bool|break    { printf("[reserved_word, %s] ", yytext); }
{LIB_STDIO}|{LIB_CONIO}			{ printf("[external_library, %s] ", yytext); }








	/* ----- FUNÇÕES ----- */
{R_BRACKET}		{ printf("[r_bracket, %s] ", yytext); }
{L_BRACKET}		{ printf("[l_bracket, %s] ", yytext); }
{L_PAREN}		{ printf("[l_paren, %s] ", yytext); }
{R_PAREN}		{ printf("[r_paren, %s] ", yytext); }
{COMMA}			{ printf("[comma, %s] ", yytext); }
{SEMICOLON}		{ printf("[semicolon, %s] ", yytext); }









	/* ----- COMENTÁRIOS ----- */
{COMMENT}						{}
"/*"([^*]|\*+[^*/])*\*+"/"		{}









	/* ----- NÚMEROS ----- */
{DIGIT}+ { printf("[num, %s] ", yytext);}
{DIGIT}+"."{DIGIT}+ {printf("[num, %s] ", yytext);}











	/* ----- CONDICIONAIS ----- */
{EQUAL} 		{ printf("[equal_op, %s] ", yytext); }
{LOGICAL}		{ printf("[logical_op, %s] ", yytext); }
{RELATIONAL}	{ printf("[relational_op, %s] ", yytext); }
{ARITMETIC}	    { printf("[arith_op, %s] ", yytext); }

	
	
	



	
	/* ----- STRING ----- */
{STRING}	  { printf("[string_literal, %s] ", yytext); }







	/* ----- IDENTIFICADORES ----- */
{VAR}|{VAR_NO_POINTER}|{VAR_POINTER}|{VAR_POINTER_PARENT}			{ 
	int i;
	for (i = 0; i < sizeof(varIds); i++){
        if(strcmp(&yytext[0], varIds[i]) == 0){
			printf("[id, %s, %d] ", yytext, i);
			breakStrcmp = true;
			break;
		}
	}
	if(!breakStrcmp){
		strcpy(varIds[actualId], &yytext[0]);
		printf("[id, %s, %d] ", yytext, actualId);
		actualId++;
	}else{
		breakStrcmp = false;
	}
	;
}




%%

int main(int argc, char *argv[]){
	printf("----- Linha: 1\n", yytext);
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}

