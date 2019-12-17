%define parse.error verbose
%{
	#include <stdio.h>
	#include <iostream>
	#include <vector>
	#include <map>
	extern int yylex();
	void yyerror(const char*s);
	void show();
	void match(std::string);
	int numPlayers, numMoves;

	std::map<std::string, std::vector<int>> playerMoves;
	std::vector<int> currMoves;
	std::map<std::string, int> seekMap;
	std::map<std::string, int> winCount;
	std::string player1 = "";
%}
%union {
	char *str;
	int n;
}
%token ROCK PAPER SCISSOR NEW_LINE N K
%token <str> MOVELIST PLAYER
%type <n> move N K
%type <vec_int> moves;

%start S
%%
    S   : N NEW_LINE K NEW_LINE { numPlayers = $1; numMoves = $3; } 
			players matches				{ 
											std::cout << player1 << " is the winner of Rock, Paper, ";
											std::cout << "Scissors Competition held at Elan ";
											std::cout << "2020, IITH.\n";
											return 0;
										}
        ;
	
	players : players MOVELIST moves NEW_LINE		{ 
														playerMoves[$2] = currMoves;
														currMoves = std::vector<int>();
													}
			| %empty
			;

	moves	: moves move			{ }
			| %empty				{ }
			;
	
	move	: ROCK					{ currMoves.push_back(ROCK); }
			| PAPER					{ currMoves.push_back(PAPER); }
			| SCISSOR				{ currMoves.push_back(SCISSOR); }
	
	matches : matches PLAYER		{ match($2); }
			| %empty
			;
%%

void yyerror(const  char *s){
	exit(1);
}

int main(){
	yyparse();
	return 0;
}

std::string showMove(int p1) {
	return (p1 == ROCK ? "R" : (p1 == SCISSOR ? "S" : "P"));
}

void match(std::string player2) {
	if(player1 == "") {
		player1 = player2;
		return;
	}
	std::cout << player1 << " X " << player2 << "\n";

	// player1 vs player2
	int count = 0;
	int p1 = playerMoves[player1][seekMap[player1]%numMoves];
	int p2 = playerMoves[player2][seekMap[player2]%numMoves];
	while(p1 == p2 && count++ < numMoves) {
		std::cout << player1 << "(" << showMove(p1) << ") X " << player2 << "(" << showMove(p2) << ")-->T\n";
		seekMap[player1]++;
		seekMap[player2]++;
		p1 = playerMoves[player1][seekMap[player1]%numMoves];
		p2 = playerMoves[player2][seekMap[player2]%numMoves];
	}
	if(count >= numMoves) {
		std::cout << player1 << " X " << player2 << "-->";
		if(winCount[player1] < winCount[player2]) {
			player1 = player2;
		}
		std::cout << player1 << "\n";
		std::cout << "\n";
		return;
	}
	std::cout << player1 << "(" << showMove(p1) << ") X " << player2 << "(" << showMove(p2) << ")-->";
	// There is a contest where someone loses.

	seekMap[player1]++;
	seekMap[player2]++;
	if((p1 == ROCK && p2 == PAPER)
		|| (p1 == PAPER && p2 == SCISSOR)
		|| (p1 == SCISSOR && p2 == ROCK)) {
		// std::cout << player2 << "wins this round\n";
		std::cout << player2 << "\n";
		std::cout << player1 << " X " << player2 << "-->" << player2 << "\n";
		player1 = player2;
	}
	else {

		std::cout << player1 << "\n";
		std::cout << player1 << " X " << player2 << "-->" << player1 << "\n";
	}
	std::cout << "\n";

}