#include <stdio.h>
#include <stdlib.h>
//constantes
int fila=25;//filas de la sopa de letras
int columna=25;//columnas de la sopa de letas
//variables
int i,j,letra;
//funciones
 int main()
 {
char sopa [fila][columna]; //tabla de caracteres que sera la sopa de letras
//------------------------------------------------
for (i=0;i<fila;i++){//inicializar matriz
	for (j=0;j<columna;j++)
	{
        letra=rand()%25;//25 porque es el numero de letras de la a a la z en tabla ascci
        sopa [i][j]=(letra+65);//65 porque 65 es la A en la tabla ascii

	}
}
//------------------------------------------------
for (i=0;i<fila;i++){//imprimir matriz
	for (j=0;j<columna;j++)
	{
	printf(" %c",sopa[i][j]); //imprime un espacio y luego el caracter de la matriz para que se vea cuadrado
	}
	printf("\n");
}
//------------------------------------------------------------------
printf("\n \n \n \n le falta inicializar el random para que no de siempre lo mismo\n \n \n \n ");
 }
