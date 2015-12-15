/*----- Sección de Declaraciones --------------*/
%{
#include <stdio.h>
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

vector<pair<string,int> > dic;

string adj_in[20] = {"un","una","algunas","ningún","pocos","muchas","escasos","demasiadas","bastantes","otras","tantos","todos","varias","demás","ambos","cada","demasiados","ciertos","tales","tantas"};

string adj_indefinidos[20] = {"mi","sus","nuestra","su","mis","tu","tus","tuyo","nuestras","vuestros","tuya","mía","suyas","nuestros","sus","su","míos","vuestras","mi","tus"};

string adj_demostrativos[20] = {"estas","aquellos","estos","este","esta","aquella","aquel","estas","estos","esta","aquel","aquella","aquellos","esas","esos","ese","esa","aquel","aquellas","estas"};

string calificativos_buenos[27] = {"calidad","barata","ligera","fuerte","fantastico","fantástico","rapido","agil","ágil","util","útil","rápido", "enorme","suave","amable", "bueno", "bonito", "impresionante","perfecto", "buen", "versátil", "versatil","aceptable","excelente","completo","insuperable","sobresaliente"};

string calificativos_malo[19] = {"es","lento","espantoso","horrible","frágil","fragil","diminuto", "sucio", "oxidado", "vacío", "triste", "feo", "demasiado", "malo", "débil", "debil", "difícil", "dificil","falta"};

string conjunciones[20] = {"a", "ante", "cabe", "con", "contra", "de", "desde", "en", "entre", "hacia", "hasta", "para", "por", "según", "si", "so", "sobre", "tras", "durante", "mediante"};

bool myfunction( const pair<string, int>& i, const pair<string, int>& j ) {
    if( i.second < j.second ) return false;
    if( j.second < i.second ) return true;
    return j.second < i.second;
}


int heuristica( vector<pair<string,int> > diccionario)
{

	int valor_heuristica = 0;


	for(int i = 0; i < diccionario.size(); i++)
	{
		bool encontrado = false;
	
		for(int j = 0 ; j < 19 && !encontrado; j++)
		{
			if(diccionario[i].first == calificativos_malo[j])
			{
				encontrado = true;

				diccionario[i].second = diccionario[i].second - 3; // Resto porque es un calificativo malo!!!
			}
		}

		

		for(int j = 0 ; j < 27 && !encontrado; j++)
		{
			if(diccionario[i].first == calificativos_buenos[j])
			{
				encontrado = true;

				diccionario[i].second = diccionario[i].second + 1; // Sumo porque es algo positivo!!!
			}
		}

		

		for(int j = 0 ; j < 20 && !encontrado; j++)
		{
			if(diccionario[i].first == adj_demostrativos[j])
			{
				encontrado = true;

				diccionario[i].second = 0; // Elimino algo inservible
			}
		}

		

		for(int j = 0 ; j < 20 && !encontrado; j++)
		{
			if(diccionario[i].first == adj_indefinidos[j])
			{
				encontrado = true;

				diccionario[i].second = 0; // Elimino algo inservible
			}
		}

		

		for(int j = 0 ; j < 20 && !encontrado; j++)
		{
			if(diccionario[i].first == adj_in[j])
			{
				encontrado = true;

				diccionario[i].second = 0; // Elimino algo inservible
			}
		}
		
		
		
		for(int j = 0 ; j < 20 && !encontrado; j++)
		{
			if(diccionario[i].first == conjunciones[j])
			{
				encontrado = true;
				diccionario[i].second = 0; // Elimino algo inservible
			}
		}
		
		encontrado = false;

	}



	for(int i = 0; i < diccionario.size(); i++)
	{
		if(diccionario[i].second > 0)
		valor_heuristica = valor_heuristica + diccionario[i].second;
	}
	
	return valor_heuristica;

}

void insert( string & cadena){

	bool enc = false;
	int inf=0; int sup = dic.size()-1;
	int centro = 0;
	
	while(inf<=sup && !enc){
	
		centro=(sup+inf)/2;
		
		if(dic[centro].first==cadena){
		
			enc = true;
		}	
		else if(cadena < dic[centro].first ){
			
			sup=centro-1;
		}
		else
		{
			inf=centro+1;
		}
	}
	
	if (!enc) {
	
		pair<string,int> aux;
		
		aux.first = cadena;
		
		aux.second = 0;
		
		dic.insert(dic.begin()+inf,aux);
		
		}
	else{
		dic[inf].second = dic[inf].second + 1;
	}


		
	
}

%}

%%
	/*----- Sección de Reglas ----------------*/
							
[a-z][a-z][a-z][a-z][a-z]*					{
									string cad = yytext;
									if (cad != "strong" && cad != "entajas" && cad != "esventajas" && cad != "sventajas" && cad != "para"){
										insert(cad);
									}
								}
[A-Z][a-z]						{
									string cad = yytext;
									if(cad == "Si" || cad == "No" || cad == "si" || cad == "no"){
										insert(cad);
									}
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
	
	cout << "Diccionario " << endl;
	
	int mayor = 0;
	
	int indice = 0;
	
	
	for(int i = 0 ; i < dic.size()-1 ; i++)
	{
		if(dic[i].second >= mayor)
		{
			mayor = dic[i].second;
			
			indice = i;
		}
	}
	
	cout << "La heuristica es " << heuristica(dic) << endl;
	
	cout << "La palabra más repetida es " << dic[indice].first << endl;
	
	sort(dic.begin(), dic.end(),myfunction);
	
	cout << "Las palabras más usadas son las siguientes " << endl;
	
	for(int i = 0 ; i < dic.size()-1 ; i++)
	{
		cout << dic[i].first << " " << dic[i].second << endl;
	}
	
	
	return 0;
}
