%define parse.error verbose
%{
	extern int yylex();
	void yyerror(const char*s);
	#include <stdio.h>
	#include <vector>
	#include <cstring>
	#include <iostream>
	#include <map>
	struct Entry {
		char *target="";
		char *prot="all";
		char *source="anywhere";
		char *dest="anywhere";
	};
	std::map<std::string, std::string> policy;
	std::vector<struct Entry> input;
	std::vector<struct Entry> forward;
	std::vector<struct Entry> output;
	void insert(char *chain, char *index);
	void del(char *chain, char *index);
	void display();
	struct Entry currEntry;
%}
%union {
	char c;
	char *str;
}

%token IPTABLES STOP
%token DELETE INSERT REPLACE POLICY PROTOCOL SOURCE DEST TARGET
%token <str> ARG
%type <str> optional
%start S;
%%

S	: S IPTABLES command STOP		{ currEntry = Entry(); }
	| %empty						{ }
	;

command	: INSERT ARG optional options		{ 
												// printf("INSERT `%s` `%s`\n", $2, $3);
												insert($2, $3);
											}
		| DELETE ARG ARG					{ 
												// printf("DELETE '%s' '%s'\n", $2, $3); 
												del($2, $3);
											}
		| REPLACE ARG ARG options			{
												// printf("REPLACE '%s' '%s'\n", $2, $3);
												insert($2, $3);
											}
		| POLICY ARG ARG options		{ 
												// printf("POLICY '%s' '%s'\n", $2, $3);
												policy[$2] = $3;
											}
		;

optional	: ARG					{ /*printf("`%s`\n", $1);*/$$ = $1; }
			| %empty				{ $$ = ""; }
			;

options	: options PROTOCOL optional {
										if(strcmp("", $3) != 0) {
											currEntry.prot = $3;
										}
 									}
		| options SOURCE optional 	{
										// printf("SOURCE %s\n", $3);
										if(strcmp("", $3) != 0) {
											currEntry.source = $3;
										}
									}
		| options DEST optional		{ 
										// printf("DEST %s\n", $3);
										if(strcmp("", $3) != 0) {
											currEntry.dest = $3;
										}
										
									}
		| options TARGET optional	{ 
										// printf("TARGET %s\n", $3);
										currEntry.target = $3;
									}
		| %empty
		;

%%

void yyerror(const  char *s){
	exit(1);
}

void del(char *chain, char *index) {
	int i = atoi(index)-1;
	if(strcmp(chain, "INPUT") == 0) {
		input.erase(input.begin() + i);
	}
	if(strcmp(chain, "OUTPUT") == 0) {
		output.erase(output.begin() + i);
	}
	if(strcmp(chain, "FORWARD") == 0) {
		forward.erase(forward.begin() + i);
	}
}

void insert(char *chain, char *index) {
	if(strcmp("", index) == 0) {
		index = "0";
	}
	int i = atoi(index)-1;
	// printf("%s, %d => Entry: %s, %s, %s, %s\n", chain, i, currEntry.target, currEntry.prot, currEntry.source, currEntry.dest);
	if(strcmp(chain, "INPUT") == 0) {
		// put it in input
		if(i < input.size()) {
			input[i] = currEntry;
		}
		else {
			input.resize(i+1);
			input[i] = currEntry;
		}
	}
	if(strcmp(chain, "OUTPUT") == 0) {
		// put it in input
		if(i < output.size()) {
			output[i] = currEntry;
		}
		else {
			output.resize(i+1);
			output[i] = currEntry;
		}
	}
	if(strcmp(chain, "FORWARD") == 0) {
		// put it in input
		if(i < forward.size()) {
			forward[i] = currEntry;
		}
		else {
			forward.resize(i+1);
			forward[i] = currEntry;
		}
	}
}

void display() {
	if(policy["INPUT"] == "") policy["INPUT"] = "ACCEPT";
	if(policy["FORWARD"] == "") policy["FORWARD"] = "ACCEPT";
	if(policy["OUTPUT"] == "") policy["OUTPUT"] = "ACCEPT";
	std::cout << "Chain INPUT (policy " << policy["INPUT"] << ")\n";
	std::cout << "target\tprot\tsource\tdestination\n";

	for(auto entry : input) {
		std::cout << entry.target << "\t" << entry.prot << "\t" << entry.source << "\t" << entry.dest << "\n";
	}

	std::cout << "\n\nChain FORWARD (policy " << policy["FORWARD"] << ")\n";
	std::cout << "target\tprot\tsource\tdestination\n";

	for(auto entry : forward) {
		std::cout << entry.target << "\t" << entry.prot << "\t" << entry.source << "\t" << entry.dest << "\n";
	}

	std::cout << "\n\nChain OUTPUT (policy " << policy["OUTPUT"] << ")\n";
	std::cout << "target\tprot\tsource\tdestination\n";

	for(auto entry : output) {
		std::cout << entry.target << "\t" << entry.prot << "\t" << entry.source << "\t" << entry.dest << "\n";
	}
}

int main(){
	yyparse();
	return 0;
}
