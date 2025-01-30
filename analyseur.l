%{
#include "synt.tab.h"  
#include "table.h"
    #include "quad.h"
    extern nb_ligne;
    extern Col;
extern YYSTYPE yylval;
   
%}
lettre [a-zA-Z]
chiffre [0-9]
IDF [a-zA-Z][a-zA-Z0-9]*
cst_int [-+]?{chiffre}+
cst_char ({lettre}|{chiffre})
cst_string \"[^\"]*\"
cst_real [+-]?{chiffre}+\.{chiffre}+
commentaire "/*"([^*]|\*+[^*/])*\*+"/"


%%
writeln  { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return writeln;}  
Programme { rechercher(yytext,"Mot cle"," ",0,1);
printf("L'entite lexicale reconnue est %s \n", yytext);
Col= Col + strlen(yytext);
return mc_programme;}

BEGIN    {yylval.string=strdup(yytext);
rechercher(yytext,"Mot cle"," ",0,1);
printf("L'entite lexicale reconnue est %s \n", yytext);
Col= Col + strlen(yytext);
return begin;}
END     {yylval.string=strdup(yytext);
rechercher(yytext,"Mot cle"," ",0,1);
printf("L'entite lexicale reconnue est %s \n", yytext);
Col= Col + strlen(yytext);
return end;}


VAR {
rechercher(yytext,"Mot cle"," ",0, 1);
printf("L'entite lexicale reconnue est %s \n", yytext);
Col= Col + strlen(yytext);
return mc_var;}
readln { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_read;}
CONST { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_const;}

float { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_real;}

CHAR { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_char;}



int { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_integer;}



While { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_while;}
for       { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_for;}



if { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_if;}


else { printf("L'entite lexicale reconnue est %s \n", yytext);
rechercher(yytext,"Mot cle"," ",0, 1);
Col= Col + strlen(yytext);
return mc_else;}

{IDF}   { printf("L'entite lexicale reconnue est %s \n", yytext);
yylval.string=strdup(yytext);
rechercher(yytext,"IDF"," ",0,0);
Col= Col + strlen(yytext);
if (yyleng>7) printf ("\n Erreur Lexicale: IDF trop longue a la ligne %d a la colonne %d \n\n ",nb_ligne, Col);
return idf;}
{cst_int} { printf("L'entite lexicale reconnue est %s \n", yytext);
yylval.entier=atoi(yytext);
if (yylval.entier < -32768 || yylval.entier > 32767) {
        printf("\nErreur Lexicale: Valeur constante entiere hors limites [-32768, 32767] a la ligne %d, colonne %d\n\n", nb_ligne, Col);
       
    }
rechercher(yytext,"CONSTANT","INTEGER",atof(yytext),0);
Col= Col + strlen(yytext);
return cst_int;}

{cst_real} { printf("L'entite lexicale reconnue est %s \n", yytext);
yylval.real=atof(yytext);
if (yylval.real < -32768.0 || yylval.real > 32767.0) {
        printf("\nErreur Lexicale: Valeur constante entiere hors limites [-32768, 32767] a la ligne %d, colonne %d\n\n", nb_ligne, Col);
}
rechercher(yytext,"CONSTANT","REAL",atof(yytext),0);
Col= Col + strlen(yytext);
return cst_real;}

{commentaire} { printf("L'entite lexicale est reconnue comme commentaire \n");
char* str = yytext;
char *ptrChar=strchr(str,'\n'); // ptrChar un pointeur vers le caractere '\n' de la variable str
while (ptrChar!=NULL) {
nb_ligne++;
ptrChar=strchr(ptrChar+1,'\n');
}}

"=" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return aff;}

"!=" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return neq;}

"&&" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return and;}
"||" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return or;}      

"<" {  Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0, 2);
return mc_inf;}

">" { Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0, 2);
return mc_sup;}

"==" { Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0, 2);
return mc_eg;}

"<=" { Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0, 2);
return mc_infe;}

">=" { Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0, 2);
return mc_supe;}

       
":"         {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return colon;
             }
"[" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return crochet_ovr;}
"]" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return crochet_frm;}
"/" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return slash;}
"//" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return separateur;}
"+" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return plus;}
"-" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return moins;}
"*" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return etoile;}
"!"         {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return not;}
\'         {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return cote;}
"|" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return barre;}
"@" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return arobase;}
"(" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return parnths_ovr;}
")" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return parnths_frm;}
"{" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return acolad_ovr;}
"}" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return acolad_frm;}
";" {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return pvg;}
"," {Col= Col + strlen(yytext);
rechercher(yytext,"Separateur",0,0,2);
return vg;}




[ \t\r]+    ;
\n   {Col= 1; nb_ligne++;}
. {printf ("\n Entité lexicale non reconnue a ligne %d a la colonne %d \n\n",
 nb_ligne, Col);}
%%

