%{
	#include"y.tab.h" 
	void display();
%}

%%
"iptables"		{ /* printf("IPTABLES\n"); */ return IPTABLES; }

"-D"			return DELETE;
"-I"			return INSERT;
"-P"			return POLICY;
"-R"			return REPLACE;

"-p"			return PROTOCOL;
"-s"			return SOURCE;
"-d"			return DEST;
"-j"			return TARGET;


[^" "\n]*			{
					yylval.str = (char *) malloc(sizeof(char) * yyleng);
					memcpy(yylval.str, yytext, yyleng);
					return ARG;
				}

"\n"			return STOP;

[" "]			;

<<EOF>>										{ display();exit(0);}
%%

int yywrap(void){
	return 1;
}

