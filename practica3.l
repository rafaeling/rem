/*----- Sección de Declaraciones --------------*/
%{
#include <stdio.h>
#include <string>
#include <iostream>
#include <vector>

using namespace std;


%}

%%
	/*----- Sección de Reglas ----------------*/

"margin-left:100px;".*"\n"*[A-Z]*.*"\n"*[a-z]*.*"\n"*[A-Z]*.*"\n"*[a-z]*.*"\n"*"<br/>"		{
													cout << yytext << endl;
												}


							
\n				{}
.				{}

%%

	/*----- Sección de Procedimientos --------*/
int main (int argc, char *argv[]) {
	if (argc == 2) {
		yyin = fopen (argv[1], "rt");
		if (yyin == NULL) {
		printf ("El fichero %s no se puede abrir\n", argv[1]);
		exit (-1);
		}
	}else yyin = stdin;
	
	
	yylex ();
	
	
	
	return 0;
}


