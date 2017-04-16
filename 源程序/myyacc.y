/*�﷨������
/*˵������*/
%{
#include "stdio.h"
#include "string.h"
int reducecount=1;  /*��Լ����*/
#define AL 20

FILE *fguiyue,*fword; 
FILE *fin,*fout;
char fname[AL];
int err;
char c;
FILE *fzy=NULL;

extern char keyword[13][20];
extern int nchar;
extern int nword;
extern int line;		/*����*/

void printReduce(char *s);
%}

%union{/*������*/
char *ident;
int number;
}                      
%start program

/*�ս��*/
%token SYM_program
%token SYM_const
%token SYM_procedure
%token SYM_begin
%token SYM_end
%token SYM_write
%token SYM_read
%token SYM_do
%token SYM_call
%token <attr_while> SYM_while
%token SYM_if
%token SYM_else
%token SYM_then
%token SYM_repeat
%token SYM_until
%token SYM_ident
%token SYM_number
%token SYM_var
%token SYM_odd

%token OPR_constinit
%token OPR_become
%token OPR_plus
%token OPR_minus
%token OPR_times
%token OPR_slash
%token OPR_lss
%token OPR_leq
%token OPR_gtr
%token OPR_geq
%token OPR_neq
%token OPR_eql

%token BDY_lparen
%token BDY_rparen
%token BDY_comma
%token BDY_period
%token BDY_semicolon

/*���ս��*/
%type <number> whilesen
%type <number> ifsen
%type <number> relationop
%type <number> sonprogram

%left OPR_plus
%left OPR_minus
%left OPR_times
%left OPR_slash


/*���򲿷�*/

%%


/*<����>::=<�ֳ���> .*/
program:
	sonprogram BDY_period
		{
		printReduce("program->sonprogram BDY_period");}
	;

/*<�ֳ���>::=[<����˵������>][<����˵������>][<����˵������>]<���>*/	
sonprogram:
	sentence	
		{printReduce("sonprogram->sentence");}
	|constexplain
		{
                }
	sentence	
		{printReduce("sonprogram->constexplain sentence");}
	|varexplain
		{
                }
	sentence	
		{printReduce("sonprogram->varexplain sentence");}
	|proexplain 
		{
        }
	sentence	
		{printReduce("sonprogram->proexplain sentence");}
	|constexplain varexplain 
		{
                }
	sentence	
		{printReduce("sonprogram->constexplain varexplain sentence");}
	|varexplain proexplain 
		{
                }
	sentence		
		{printReduce("sonprogram->varexplain proexplain sentence");}
	|constexplain proexplain 
		{
                }
	sentence	
		{printReduce("sonprogram->constexplain proexplain sentence");}
	|constexplain varexplain proexplain 
		{
                }
	sentence	
		{printReduce("sonprogram->constexplain varexplain proexplain sentence");}
	;
	
/*<����˵������>::=<�޷ֺų���˵������>;*/
constexplain:
	noconstexplain	BDY_semicolon
		{printReduce("constexplain->noconstexplain BDY_semicolon");}
	;
	
/*<�޷ֺų���˵������>::=const<��������>{,<��������>}*/
noconstexplain:
	SYM_const constdefine	
		{
		printReduce("noconstexplain->SYM_const constdefine");}
	|noconstexplain BDY_comma constdefine
		{printReduce("noconstexplain->noconstexplain BDY_comma constdefine");}
	;
	
/*<��������>::=<��ʶ��>=<�޷�������>;*/
constdefine:
	SYM_ident OPR_constinit SYM_number
		{
		printReduce("constdefine->SYM_ident OPR_constinit SYM_number");}
	;
	
/*<����˵������>::=<�޷ֺű���˵������>*/
varexplain:
	novarexplain BDY_semicolon
		{printReduce("varexplain->novarexplain BDY_semicolon");}
	;
	
/*<�޷ֺű���˵������>::=var<��ʶ��>{<,��ʶ��>}*/
novarexplain:
	SYM_var SYM_ident	
		{
		printReduce("varexplain->SYM_var SYM_ident");}
	|novarexplain BDY_comma SYM_ident	
		{
		printReduce("novarexplain->novarexplain BDY_comma SYM_ident");}
	;
	
/*<����˵������>::=<�����ײ�><�ֳ���>{;����˵������}*/
proexplain:
	prohead sonprogram	
		{
		}
	BDY_semicolon
	{
		printReduce("proexplain->prohead sonprogram BDY_semicolon");}
	|proexplain  	
		{
		}
	prohead sonprogram BDY_semicolon 
		{
		printReduce("proexplain->proexplain prohead sonprogram BDY_semicolon ");}
	;
	
/*<�����ײ�>::=procedure<��ʶ��>;*/
prohead:
	SYM_procedure SYM_ident BDY_semicolon
		{
		printReduce("prohead->SYM_procedure SYM_ident BDY_semicolon");}
	;
	
/*<���>::=<��ֵ���>|<�������>|<while���>|<���̵������>|<�����>|<д���>|<�������>|<��>*/
sentence:
	assignsen
		{printReduce("sentence->assignsen ");}
	|ifsen
		{printReduce("sentence->ifsen ");}
	|whilesen
		{printReduce("sentence->whilesen ");}
	|callsen 
		{printReduce("sentence->callsen ");}
	|readsen 
		{printReduce("sentence->readsen ");}
	|writesen 
		{printReduce("sentence->writesen ");}
	|complexsen 
		{printReduce("sentence->complexsen ");}
	|BDY_semicolon 
		{printReduce("sentence->BDY_semicolon");}
	;
	
		
/*<��ֵ���>::=<��ʶ��>:=<���ʽ>;*/
assignsen:
	SYM_ident OPR_become expression 
		{
		printReduce("assignsen->SYM_ident OPR_become expression ");}
	;
	
/* <�м���>::={<+|-><��>}+ */
midxiang:
	OPR_plus term
	{
	printReduce("midxiang->OPR_plus term ");}
	|OPR_minus term
	{
	printReduce("midxiang->OPR_minus term ");}
	|OPR_minus term midxiang
	{
	printReduce("midxiang->OPR_minus term midxiang");}
	|OPR_plus term midxiang
	{
	printReduce("midxiang->OPR_plus term midxiang");}
	;
/*<���ʽ>::=[+|-]<��><�м���>*/
expression:
	term
		{
		printReduce("expression->term");}
	|OPR_plus term
		{
		printReduce("expression->OPR_plus term");}
	|OPR_minus term
		{
		printReduce("expression->OPR_minus term");}
	|term midxiang
		{
		printReduce("expression->term midxiang");}
	|OPR_plus term midxiang
		{
		printReduce("expression->OPR_plus term midxiang");}
	|OPR_minus term midxiang
		{
		printReduce("expression->OPR_minus term midxiang");}
	;
/* <�м�����>::={<*|/><����>}+*/
midfactor:
	OPR_times factor
		{
		printReduce("midfactor->OPR_times factor");}
	|OPR_slash factor
		{
		printReduce("midfactor->OPR_slash factor");}
	|OPR_times factor midfactor
		{
		printReduce("midfactor->OPR_times factor midfactor");}
	|OPR_slash factor midfactor
		{
		printReduce("midfactor->OPR_slash factor midfactor");}
/*<��>::=<����>{[*|/]<����>}*/
term:
	factor
		{printReduce("term->factor");}
	|factor midfactor
		{
		printReduce("term->factor midfactor");}
	;
	
/*<����>::=<��ʶ��>|<�޷�������>|������<���ʽ>��)��*/
factor:
        SYM_ident
		{
		printReduce("factor->SYM_ident");}
	|SYM_number
		{
		printReduce("factor->SYM_number");}
	|BDY_lparen expression BDY_rparen
		{printReduce("factor->BDY_lparen expression BDY_rparen");}
	;
	
/*<�������>::=if<����>then<���>*/
ifsen:
	SYM_if condition 
		{
                }
	SYM_then sentence
		{
		printReduce("ifsen->SYM_if condition SYM_then sentence");}
	;
	
/*<����>::=<���ʽ><��ϵ�����><���ʽ>*/
condition:
	expression relationop expression
		{printReduce("condition->expression relationop expression");}
	|SYM_odd expression
		{
		printReduce("condition->SYM_odd expression");}
	;
	
/*<��ϵ�����>::===|#|<|<=|>|>=*/
relationop:
         OPR_leq
		{
		printReduce("relationop->OPR_leq");}
	|OPR_lss
		{
		printReduce("relationop->OPR_lss");}
	|OPR_eql
		{
		printReduce("relationop->OPR_eql");}
	|OPR_gtr
		{
		printReduce("relationop->OPR_gtr");}
	|OPR_geq
		{
		printReduce("relationop->OPR_geq");}
	|OPR_neq
		{
		printReduce("relationop->OPR_neq");}
	;
	
/*<while���>::=while<����>do<���>*/
whilesen:
	SYM_while
		{
		}
	condition SYM_do 
		{
                }
	sentence
		{
		printReduce("whilesen->SYM_while condition SYM_do sentence");}
	;
	
/*<call���>::=call<��ʶ��>*/
callsen:
	SYM_call SYM_ident 
		{
		printReduce("callsen->SYM_call SYM_ident ");}
	;
	
/*<�����>::=read������<��ʶ���б�>��)��;*/
readsen:
	SYM_read 
		{
		}
	BDY_lparen identlist BDY_rparen
	{
		printReduce("readsen->SYM_read BDY_lparen identlist BDY_rparen ");}
	;

/*<��ʶ���б�>::=<��ʶ��>{,<��ʶ��>}*/
identlist:
	SYM_ident	
		{
		printReduce("identlist->SYM_ident");}
	|identlist BDY_comma SYM_ident
		{
		printReduce("identlist->identlist BDY_comma SYM_ident");}
	;

/*<���ʽ�б�>::=<���ʽ>{,<���ʽ>}*/
expressionlist:
	expression
		{printReduce("expressionlist->expression");}
	|expression BDY_comma expression
		{printReduce("expressionlist->expression BDY_comma expression");}
	;
	
/*<д���>::=write������<���ʽ�б�>��)��;*/
writesen:
	SYM_write BDY_lparen expressionlist BDY_rparen 
		{
		printReduce("writesen->SYM_write BDY_lparen expressionlist BDY_rparen ");}
	;
	
/*<�������>::=begin<�������>end*/
complexsen:
	SYM_begin
		{
		}
	sentencelist SYM_end 
		{
		
		
		printReduce("complexsen->SYM_begin sentencelist SYM_end");}
	;
	
/*<�������>::=<���>;{<���>;}*/
sentencelist:
	sentence BDY_semicolon
		{printReduce("sentencelist->sentence BDY_semicolon");}
	|sentencelist sentence BDY_semicolon
		{printReduce("sentencelist->sentencelist sentence BDY_semicolon");}
	|sentencelist BDY_semicolon
		{printReduce("sentencelist->sentencelist BDY_semicolon");}
	;
	
%%

void printReduce(char *s)
{
	printf("[%2d] %s\n",reducecount++,s);
	fprintf(fguiyue,"[%2d] %s\n",reducecount-1,s);
}
yyerror(char *s)
{
        err++;
	printf("%s\n",s);
}
void fileopen()
{
	printf("ϵͳ��ʼ��....\n");
	if((fword=fopen("fword.txt","w"))==NULL){
		printf("fword.txt�޷��򿪣�\n");
		exit(0);
		}
	if((fguiyue=fopen("fguiyue.txt","w"))==NULL){
		printf("fguiyue.txt�޷��򿪣�\n");
		exit(0);
		}
	printf("ϵͳ��ʼ���ɹ���\n");
	printf("������Ҫ���Ե��ļ������磺1.txt����\n");
	scanf("%s",fname);
	fin=fopen(fname,"r");
	while(fin==NULL){
		printf("����������������룺\n");
		scanf("%s",fname);
		fin=fopen(fname,"r");
	}
	
	printf("\n�ļ���ȡ�ɹ���\n");
	printf("�ļ���������:\n");
	fzy = fin;
	while(fscanf(fzy,"%c",&c)!=EOF)
	{
		printf("%c",c);
	}
	printf("\n");
	fzy = NULL;
	fclose(fin);
	
	fin=fopen(fname,"r");
	setInputDirect(fin); /*������������*/
	
	getch();
}
void fileclose()
{
	fprintf(fword,"��������%d\t������%d\t�ַ�����%d\n",nword,line,nchar);
	fclose(fword);
	fclose(fguiyue);
	fclose(fin);
    getch();
	exit(0);
}
void main(void)
{

	
	printf("-------------------------------------------------------\n");
	printf("|       PL/0�������Ĵʷ��������﷨����              |\n");
	printf("|                                                     |\n");
	printf("|                      �ƿ�141 ������  �ƿ�142 ��ӱ   |\n");
	printf("-------------------------------------------------------\n");
	err=0;    
	fileopen();
	
	printf("\n��Լ����:\n");
	yyparse();
	listWordtable();
	if(err==0)
	{
		printf("\n��������%d\t������%d\t�ַ�����%d\n",nword,line,nchar);
		
		printf("\n\n����PL0�﷨����\n\n");
	}
	else
	{
		printf("\n\n�ó�����ڴ��󣬲�����PL0���﷨����\n\n",err);
	}
	fileclose();
}