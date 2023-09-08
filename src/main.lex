
%option noyywrap

%{

#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>
int numLines = 1;

// char varIds[30][30] = {};
// int actualId = 1;
// bool breakStrcmp = false;


typedef struct {
	char *nome;
	int escopo;
} identificador;
identificador ids[30];

int contaLeftBracket = 0;
int contaRightBracket = 0;
int indexIDS = 0;
int contaEscopos = 0;

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

	/* Ignore spaces and endline. */

{ENDLINE} 	numLines++;{ printf("\n\n------- Linha: %d\n", numLines); }

	/* Reserved words. */

#include|scanf|printf|do|while|for|if|else|switch|case|void|return|NULL|null|int|float|double|String|string|bool|break    { printf("[reserved_word, %s] ", yytext); }
{LIB_STDIO}|{LIB_CONIO}			{ printf("[external_library, %s] ", yytext); }

	/* Functions. */

{R_BRACKET}		{ printf("[r_bracket, %s] ", yytext); 
				contaRightBracket++;
				
				if(contaLeftBracket == contaRightBracket) {
					contaEscopos++;
				}

				}
{L_BRACKET}		{ printf("[l_bracket, %s] ", yytext);
				contaLeftBracket++;}
{L_PAREN}		{ printf("[l_paren, %s] ", yytext); }
{R_PAREN}		{ printf("[r_paren, %s] ", yytext); }
{COMMA}			{ printf("[comma, %s] ", yytext); }
{SEMICOLON}		{ printf("[semicolon, %s] ", yytext); }

 /* Comments. */

{COMMENT}						{}
"/*"([^*]|\*+[^*/])*\*+"/"		{}

	/* Numbers. */
	
{DIGIT}+ { printf("[num, %s] ", yytext);}
{DIGIT}+"."{DIGIT}+ {printf("[num, %s] ", yytext);}

	/* Conditional statements. */
	
{EQUAL} 		{ printf("[equal_op, %s] ", yytext); }
{LOGICAL}		{ printf("[logical_op, %s] ", yytext); }
{RELATIONAL}	{ printf("[relational_op, %s] ", yytext); }
{ARITMETIC}	    { printf("[arith_op, %s] ", yytext); }

	/* String. */
	
{STRING}	  { printf("[string_literal, %s] ", yytext); }

	/* Variables. */

{VAR}|{VAR_NO_POINTER}|{VAR_POINTER}|{VAR_POINTER_PARENT}			{ 

	// int i;
	// for (i = 0; i < sizeof(varIds); i++){
    //     if(strcmp(&yytext[0], varIds[i]) == 0){
	// 		printf("[id, %d] ", i);
	// 		breakStrcmp = true;
	// 		break;
	// 	}
	// }
	// if(!breakStrcmp){
	// 	strcpy(varIds[actualId], &yytext[0]);
	// 	printf("[id, %d] ", actualId);
	// 	actualId++;
	// }else{
	// 	breakStrcmp = false;
	// }
	;


	
	

	bool existe = false;
	for (int i = 0; i < 100; i++) {
		identificador atual = ids[i];
		if (strcmp(&yytext[0], atual.nome) == 0) {
			if(contaEscopos == atual.escopo) {
				printf("[id, %d] ", i);
				existe = true;
				break;
			}
		}
	}
	
	if(existe == false) {
		identificador novoID;
		novoID.nome = &yytext[0];
		if(contaLeftBracket == contaRightBracket) {
			novoID.escopo = 999; // nome de funcao
		} else {
			novoID.escopo = contaEscopos;
		}
		ids[indexIDS] = novoID;
		indexIDS++;
		printf("[id, %d] ", indexIDS);
	}


	}



%%

int main(int argc, char *argv[]){
	printf("----- Linha: 1\n", yytext);
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);


	printf("id table size: %d] ", indexIDS);


	return 0;
}



/*

1 - CalculoMedia
2 - NotaDaP1
3 - NotaDaP2
4 - Media
5 - VerificaNumero 
6 - num
7 - s
8 - AlterarVetor
9 - vetor
10 - elementos
11 - i
12 - main
13 - v
14 - pt
15 - i
16 - i

 */