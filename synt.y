%{
    int nb_ligne=1, Col=1;
char sauvType [20];
char sauvOpr[20];
int sauvConstInt=-1;
float sauvConstReal=-1;
int qc = 0; int valeur;
char buffer[20]; int t=0;
int NbrIdf =0;
typedef struct
{
char signFromatage;
char idf[20];
 
} compatibilite;

compatibilite tableau [20];
%}

%union {
         int entier;
         float real;
         char character;
         char* string;
          int boolVal;
}

%token  mc_programme <string>mc_process <string>mc_loop <string>mc_array and  not ne  vg  mc_var colon or mc_const mc_real mc_char mc_string pvg mc_integer mc_read mc_write mc_for mc_while mc_inf mc_sup mc_eg mc_infe mc_supe  mc_if  mc_else <string>idf <entier>cst_int <character>cst_char <real>cst_real <string>cst_string htag  crochet_ovr crochet_frm slash separateur plus moins aff etoile cote barre arobase parnths_ovr parnths_frm acolad_ovr acolad_frm  begin end neq
%type <string>EXPRESSION_ARTHMTQ OPERANDE
%type <entier> OPERATEUR
%type <string> OPERATEUR_logique COND
%left or  '||'      
%left and  '&&'    
%left mc_eg '==' neq '!='    
%left mc_sup mc_inf mc_supe mc_infe
%left plus moins  
%left etoile slash      
%right not
%start S
%token writeln readln
%%


S:  mc_programme idf  mc_var acolad_ovr PGM acolad_frm begin  LIST_INSTRUCTION  end
   { printf("\n Le programme est correcte syntaxiquement. \n"); YYACCEPT; }
   
;

;
PGM:
    LIST_DEC_VAR   LIST_DEC_CONST  
   |LIST_DEC_VAR
   |LIST_DEC_CONST  
   |LIST_DEC_CONST LIST_DEC_VAR
   |LIST_DEC_VAR LIST_DEC_CONST LIST_DEC_VAR
   |LIST_DEC_VAR LIST_DEC_CONST LIST_DEC_VAR  LIST_DEC_CONST
   |LIST_DEC_VAR LIST_DEC_CONST LIST_DEC_VAR  LIST_DEC_CONST LIST_DEC_VAR
   |LIST_DEC_CONST LIST_DEC_VAR LIST_DEC_CONST LIST_DEC_VAR  LIST_DEC_CONST LIST_DEC_VAR
   |LIST_DEC_CONST LIST_DEC_VAR LIST_DEC_CONST LIST_DEC_VAR  LIST_DEC_CONST LIST_DEC_VAR LIST_DEC_CONST

;
LIST_DEC_VAR: DEC_VAR pvg {strcpy(sauvType," ");}
        |DEC_VAR pvg LIST_DEC_VAR {strcpy(sauvType," ");}
;

DEC_VAR:TYPE  LIST_IDF
       
;
TYPE: mc_integer {strcpy(sauvType,"INTEGER");}
      |mc_real {strcpy(sauvType,"REAL");}
     
;

LIST_IDF: idf vg LIST_IDF
{
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d,la variable %s est deja declaree \n", nb_ligne, $1);}
}
| idf
{
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
}
| idf crochet_ovr cst_int crochet_frm vg LIST_IDF
{
if ($3<=0) printf("Erreur sementique a la ligne %d : un tableau ne peux pas avoir une taille inferieure ou egale a 0 \n", nb_ligne);
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);
         char tmp1[100], tmp2[100];
          sprintf(tmp1,"%d",$3);
          sprintf(tmp2,"%d",$3);
          quadr("BOUNDS",tmp1,tmp2,"");
          quadr("ADEC",$1,"","");}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
 }
| idf crochet_ovr cst_int crochet_frm
{
if ($3<=0) printf("Erreur sementique a la ligne %d : un tableau ne peux pas avoir une taille inferieure ou egale a 0 \n", nb_ligne);
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);
          char tmp1[100], tmp2[100];
          sprintf(tmp1,"%d",$3);
          sprintf(tmp2,"%d",$3);
          quadr("BOUNDS",tmp1,tmp2,"");
          quadr("ADEC",$1,"","");}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
}
;  



LIST_DEC_CONST:mc_const DEC_CST  LIST_DEC_CONST
              |mc_const DEC_CST
             
;

DEC_CST:LIST_IDF_CST
;
LIST_IDF_CST:
 idf aff cst_int pvg
 {
  strcpy(sauvType,"INTEGER");
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
CodeCst($1);
           char tmp[100];
            sprintf(tmp, "%d", $3); // Convert constant value to string
            quadr("=", tmp, "", $1);
}
|idf aff cst_int vg  LIST_IDF_CST
 {
  strcpy(sauvType,"CST_INTEGER");
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
CodeCst($1);
            char tmp[100];
            sprintf(tmp, "%d", $3); // Convert constant value to string
            quadr("=", tmp, "", $1);
}
|idf aff parnths_ovr cst_int parnths_frm pvg  {
  strcpy(sauvType,"CST_INTEGER");
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
CodeCst($1);
            char tmp[100];
            sprintf(tmp, "%d", $4); // Convert constant value to string
            quadr("=", tmp, "", $1);
}
|idf aff parnths_ovr cst_int parnths_frm vg LIST_IDF_CST   {
  strcpy(sauvType,"CST_INTEGER");
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
CodeCst($1);
            char tmp[100];
            sprintf(tmp, "%d", $4); // Convert constant value to string
            quadr("=", tmp, "", $1);
}
 | idf aff cst_real vg LIST_IDF_CST
 {

   strcpy(sauvType,"CST_REAL");
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
CodeCst($1);
             char tmp[100];
            sprintf(tmp, "%d", $3); // Convert constant value to string
            quadr("=", tmp, "", $1);
}
           
 
 | idf aff cst_real pvg
 {

  strcpy(sauvType,"REAL");
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
CodeCst($1);
             char tmp[100];
            sprintf(tmp, "%d", $3); // Convert constant value to string
            quadr("=", tmp, "", $1);
}
| idf aff parnths_ovr cst_real parnths_frm vg LIST_IDF_CST
 {

   strcpy(sauvType,"CST_REAL");
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
CodeCst($1);
             char tmp[100];
            sprintf(tmp, "%d", $3); // Convert constant value to string
            quadr("=", tmp, "", $1);
}
           
 
 | idf aff parnths_ovr cst_real parnths_frm pvg
 {

  strcpy(sauvType,"REAL");
if (rechercheNonDeclare($1)==0) {insererType($1,sauvType);}
else {printf("Erreur semantique 'double declaration' a la ligne %d, la variable %s est deja declaree \n", nb_ligne, $1);}
CodeCst($1);
             char tmp[100];
            sprintf(tmp, "%d", $3); // Convert constant value to string
            quadr("=", tmp, "", $1);
}
;
LIST_INSTRUCTION:INST LIST_INSTRUCTION
         |INST
;
INST: INST_AFF pvg
| INST_WHILE
| INST_CONDITION
| INST_FOR
| INST_READ pvg
| INST_WRITE pvg
;
INST_CONDITION: IF_SIMPLE
| IF_ELSE
;
IF_SIMPLE: mc_if parnths_ovr COND parnths_frm acolad_ovr LIST_INSTRUCTION acolad_frm
{
    // Générer un quadruple pour tester la condition du 'if'
    // On suppose que la condition est déjà évaluée et stockée dans une variable temporaire
    // Temp condition est 'temp_cond' (par exemple, un label généré pour la condition)
    quadr("BZ", "temp_cond", "", "end_if");  // Brancher si la condition est fausse

    // Quadruple pour marquer la fin du bloc 'if'
    quadr("LABEL", "end_if", "", "");
}
;

INST_WRITE :  writeln  parnths_ovr IDF_write parnths_frm 
IDF_write:idf
{   quadr("WRITE", $1, "", "");
strcpy(tableau[NbrIdf].idf,$1);
NbrIdf++;
}


|cst_int {
          char tmp[100];
            sprintf(tmp, "%d", $1); // Convert constant value to string
            quadr("readIn", tmp, "", "");
}
|cst_real{
          char tmp[100];
            sprintf(tmp, "%d", $1); // Convert constant value to string
            quadr("readIn", tmp, "", "");
}

;
IF_ELSE: mc_if parnths_ovr COND parnths_frm acolad_ovr LIST_INSTRUCTION acolad_frm mc_else acolad_ovr LIST_INSTRUCTION acolad_frm
{
    // Générer un quadruple pour tester la condition du 'if'
    quadr("BZ", "temp_cond", "", "else");  // Si la condition est fausse, sauter à 'else'

    // Générer un quadruple de saut pour éviter que le 'else' soit exécuté si le 'if' est vrai
    quadr("BR", "", "", "end_if");  // Sauter à la fin du bloc 'if'

    // Marquer la position du bloc 'else'
    quadr("LABEL", "else", "", "");
   
    // Marquer la fin de l'instruction complète (fin du 'if' et 'else')
    quadr("LABEL", "end_if", "", "");
}

;
INST_WHILE:
    mc_while parnths_ovr COND parnths_frm acolad_ovr LIST_INSTRUCTION acolad_frm
{
     quadr("LABEL", "while_start", "", "");
    quadr("LABEL", "condition_checkwhile", "", ""); // Label for checking the loop condition
    quadr("BZ", "temp_cond", "", "end_while"); // If condition is false, jump to end_while



    // 3. Re-evaluate condition (jump back to the condition check)
    quadr("BR", "", "", "condition_checkwhile"); // Jump back to condition_check to evaluate the condition again

    // 4. End of loop (if condition is false, exit the loop)
     quadr("LABEL", "end_while", "", "");
}

INST_FOR:
    mc_for parnths_ovr idf colon COND colon COND colon COND parnths_frm acolad_ovr LIST_INSTRUCTION acolad_frm
{
    // 1. Initialization (e.g., i = 0)
    quadr("=", "0", "", "i"); // Assign 0 to i (Initialization)

    // 2. Condition check (e.g., i < 10)
    quadr("LABEL", "condition_check", "", ""); // Label for checking the loop condition
    quadr("BZ", "temp_cond", "", "end_for"); // If i < 10 is false, jump to end_for

 

    // 4. Iteration (e.g., i++)
    quadr("=", "i + 1", "", "i"); // Increment i by 1 (Iteration step)

    // 5. Jump back to condition check
    quadr("BR", "", "", "condition_check"); // Jump back to condition_check to evaluate the condition again

    // 6. End of Loop
    quadr("LABEL", "end_for", "", ""); // Mark the end of the loop
}

;
COND: EXPRESSION_ARTHMTQ  COND
     |EXPRESSION_ARTHMTQ
     |EXPRESSION_ARTHMTQ OPERATEUR_logique EXPRESSION_ARTHMTQ
     |parnths_ovr EXPRESSION_ARTHMTQ OPERATEUR_logique EXPRESSION_ARTHMTQ  parnths_frm
     |EXPRESSION_ARTHMTQ OPERATEUR_logique EXPRESSION_ARTHMTQ COND
     |parnths_ovr EXPRESSION_ARTHMTQ OPERATEUR_logique EXPRESSION_ARTHMTQ  parnths_frm  COND
     
     
;

INST_READ: mc_read parnths_ovr IDF_READ parnths_frm 
IDF_READ:idf
{   quadr("READ", $1, "", "");
strcpy(tableau[NbrIdf].idf,$1);
NbrIdf++;
if(rechercheNonDeclare($1)==0){printf("Erreur semantique a la ligne  %d : la variable %s n'est pas declaree !!\n",nb_ligne,$1);}
}
;

|cst_int {
          char tmp[100];
            sprintf(tmp, "%d", $1); // Convert constant value to string
            quadr("readIn", tmp, "", "");
}
|cst_real{
          char tmp[100];
            sprintf(tmp, "%d", $1); // Convert constant value to string
            quadr("readIn", tmp, "", "");
}

;
INST_AFF:  

idf aff  COND
{
if (rechercheNonDeclare($1)==0 ){printf("Erreur semantique a la ligne  %d : la variable %s n'est pas declaree !!\n",nb_ligne,$1);}
 else{
                if ((CompType($1,"INTEGER")==0) && (CompType($1,"REAL")==0))
{printf("Erreur semantique a la ligne %d : ICOMPATIBILITE DE TYPE de la variable %s \n", nb_ligne, $1);}
if (VerifIdfConst($1)==1){printf("Erreur semantique a la ligne  %d : la variable %s est une constante, affectation impossible\n",nb_ligne,$1);}
{       char* temp = (char*)newTemp();
        sprintf(temp,"%s",$3);
        quadr(":=",temp," ",$1);t++;}

}  
            }
|parnths_ovr idf aff  COND parnths_frm
{
if (rechercheNonDeclare($1)==0 ){printf("Erreur semantique a la ligne  %d : la variable %s n'est pas declaree !!\n",nb_ligne,$1);}
 else{
                if ((CompType($1,"INTEGER")==0) && (CompType($1,"REAL")==0))
{printf("Erreur semantique a la ligne %d : ICOMPATIBILITE DE TYPE de la variable %s \n", nb_ligne, $1);}
if (VerifIdfConst($1)==1){printf("Erreur semantique a la ligne  %d : la variable %s est une constante, affectation impossible\n",nb_ligne,$1);}
} { char* temp = (char*)newTemp();
        sprintf(temp,"%s",$4);
        quadr(":=",temp," ",$1);t++;}
} 
           
;
 EXPRESSION_ARTHMTQ : OPERANDE OPERATEUR OPERANDE
                     
{ char* temp = (char*)newTemp();
        quadr(sauvOpr, $1, $3, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne);
sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|OPERANDE     {
        $$ = $1;  // Directly pass operand value
    }
;
|parnths_ovr OPERANDE parnths_frm OPERATEUR OPERANDE
{       char* temp = (char*)newTemp();
        quadr(sauvOpr, $2, $4, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne);
sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|OPERANDE OPERATEUR parnths_ovr OPERANDE parnths_frm
{    char* temp = (char*)newTemp();
        quadr(sauvOpr, $1, $3, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|parnths_ovr OPERANDE parnths_frm OPERATEUR parnths_ovr OPERANDE parnths_frm
{  char* temp = (char*)newTemp();
        quadr(sauvOpr, $2, $3, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|OPERANDE OPERATEUR OPERANDE OPERATEUR EXPRESSION_ARTHMTQ
{ char* temp = (char*)newTemp();
        quadr(sauvOpr, $1, $3, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|parnths_ovr OPERANDE parnths_frm {$$=$2;}
|parnths_ovr OPERANDE parnths_frm OPERATEUR OPERANDE OPERATEUR EXPRESSION_ARTHMTQ
{  char* temp = (char*)newTemp();
        quadr(sauvOpr, $2, $5, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|OPERANDE OPERATEUR parnths_ovr OPERANDE parnths_frm OPERATEUR EXPRESSION_ARTHMTQ
{  char* temp = (char*)newTemp();
        quadr(sauvOpr, $1, $4, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|parnths_ovr OPERANDE parnths_frm OPERATEUR parnths_ovr OPERANDE parnths_frm OPERATEUR EXPRESSION_ARTHMTQ
{ char* temp = (char*)newTemp();
        quadr(sauvOpr, $2, $6, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|parnths_ovr OPERANDE OPERATEUR OPERANDE parnths_frm
{ char* temp = (char*)newTemp();
        quadr(sauvOpr, $2, $4, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}
|parnths_ovr OPERANDE OPERATEUR OPERANDE parnths_frm OPERATEUR EXPRESSION_ARTHMTQ
{  char* temp = (char*)newTemp();
        quadr(sauvOpr, $2, $4, temp);
        $$ = temp;
if((strcmp(sauvOpr,"/")==0)&& sauvConstInt==0)
        {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstInt=-1;}
else if ((strcmp(sauvOpr,"/")==0)&& sauvConstReal==0) {printf(" Erreur semantique 'division par zero' a la ligne %d \n",nb_ligne); sauvConstReal=-1.0;}
}

;
OPERATEUR_logique:
'&&'
            {
          strcpy(sauvOpr,"&&");
           }
|'||' {
          strcpy(sauvOpr,"||");
         }


|'==' {
           strcpy(sauvOpr,"==");
               }

|'!='
       {
      strcpy(sauvOpr,"!=");
       }

;

OPERATEUR: plus
{
strcpy(sauvOpr,"+");
}
| moins
{
strcpy(sauvOpr,"-");
}
| slash
{
strcpy(sauvOpr,"/");
}
| etoile
{
strcpy(sauvOpr,"*");
}
| mc_eg {
           strcpy(sauvOpr,"==");
               }
| mc_inf{
           strcpy(sauvOpr,"<");
               }
| mc_sup{
           strcpy(sauvOpr,">");
               }
| mc_infe{
           strcpy(sauvOpr,"<=");
               }
| mc_supe{
           strcpy(sauvOpr,">=");
               }
|and
            {
          strcpy(sauvOpr,"&&");
           }
|or {
          strcpy(sauvOpr,"||");
         }
|neq
       {
      strcpy(sauvOpr,"!=");
       }
|not
       {
      strcpy(sauvOpr,"!");
       }
|'+' { strcpy(sauvOpr, "+"); }
| '-' { strcpy(sauvOpr, "-"); }
| '*' { strcpy(sauvOpr, "*"); }
| "==" { strcpy(sauvOpr, "=="); }
| "!=" { strcpy(sauvOpr, "!="); }
| "<" { strcpy(sauvOpr, "<"); }
| ">" { strcpy(sauvOpr, ">"); }
| "<=" { strcpy(sauvOpr, "<="); }
| ">=" { strcpy(sauvOpr, ">="); }
;
       
OPERANDE: idf
{   $$ = $1;
if (rechercheNonDeclare($1)==0 ){printf("Erreur semantique a la ligne  %d : la variable %s n'est pas declaree !!\n",nb_ligne,$1);}
}
| idf crochet_ovr cst_int crochet_frm
{  $$ = $1;
if ($3<=0) printf("Erreur sementique a la ligne %d : un tableau ne peux pas avoir une taille inferieure ou egale a 0 \n", nb_ligne);
if (rechercheNonDeclare($1)==0 ){printf("Erreur semantique a la ligne  %d : la variable %s n'est pas declaree !!\n",nb_ligne,$1);}
}
| idf crochet_ovr idf crochet_frm
{  $$ = $1;
if ($3<=0) printf("Erreur sementique a la ligne %d : un tableau ne peux pas avoir une taille inferieure ou egale a 0 \n", nb_ligne);
if (rechercheNonDeclare($3)==0 ){printf("Erreur semantique a la ligne  %d : la variable %s n'est pas declaree !!\n",nb_ligne,$3);}
if (rechercheNonDeclare($1)==0 ){printf("Erreur semantique a la ligne  %d : la variable %s n'est pas declaree !!\n",nb_ligne,$1);}

}
| cst_int
{     char buffer[20];
        sprintf(buffer, "%d", $1);
        $$ = strdup(buffer);  // Convert integer constant to string
sauvConstInt=$1;          
}  
| cst_real
{    char buffer[20];
        sprintf(buffer, "%.2f", $1);
        $$ = strdup(buffer);
sauvConstReal=$1;          
}  
;


%%
main ()
{
   initialisation();
   initialiseTableau(tableau);
   yyparse();
   printf("\n");
   afficher();
   print_quad();
 }
 yywrap ()
 {}
int yyerror ( char*  msg )  
{
    printf ("Erreur Syntaxique a la ligne %d a la colonne %d \n", nb_ligne,Col);
}

