%{
	#include"y.tab.h"
%}

NUMBER [1-9][0-9]*
PLAYER "P"{NUMBER}

%%
"N=="{NUMBER}	{ yylval.n = atoi(yytext+3); return N; }
"K=="{NUMBER}	{ yylval.n = atoi(yytext+3); return K; }

"R"				return ROCK;
"P"				return PAPER;
"S"				return SCISSOR;

{PLAYER}"=="	{
					yylval.str = (char *)malloc(yyleng * sizeof(char));
					memcpy(yylval.str, yytext, yyleng-2);
					return MOVELIST;
				}

{PLAYER}		{
					yylval.str = (char *)malloc(yyleng * sizeof(char));
					memcpy(yylval.str, yytext, yyleng);
					return PLAYER;
				}

.				;
\n				return NEW_LINE;

<<EOF>> 		{exit(0);}
%%

int yywrap(void){
	return 1;
}

