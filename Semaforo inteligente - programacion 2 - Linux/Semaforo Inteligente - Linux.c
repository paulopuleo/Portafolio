/*Universidad Catolica Andres Bello
  Proyecto 2 - SEMAFORO
  Maria Rodriguez 25081214
  Paulo Puleo 24701286	*/

#include<stdio.h>
#include<stdlib.h>
//----------------------------------
typedef struct cruce{
    char desde,hacia; //estructura para los giros no permitidos
    struct cruce *siguiente,*anterior;
}Cruce;
//---------------------------------
typedef struct nodo{ //estructura para los cruces en el semaforo
    char desde,hacia;//las dos caracteres del cruce
    int color; 	
    struct nodo *siguiente,*anterior; //apunta al siguiente o anterior cruce
    struct cruce *crucesI,*crucesF; //apunta al primer y ultimo cruce no permitido del nodo
}Nodo;
//---------------------------------
typedef struct{
    struct nodo *inicio,*fin;	//nodo principa que 
}Lista;				//apunta a la lista de cruces permitidos
//---------------------------------
Lista *NUEVALISTA (){  //funcion para crear una lista nueva
    Lista *principal;	
    principal=(Lista *)malloc(sizeof(Lista)); //pide el espacio necesario de memoria
    if (principal!=NULL)	
            principal->inicio=principal->fin=NULL; //inicializa en null ambos punteros
    else{
        printf("error al crear la lista");
        return(EXIT_SUCCESS); 
    }
}
//---------------------------------
int InsertarCalle (Lista *principal,char des,char hac){ //incerta una calle en la lista
    Nodo *nuevo,*actual;
    int comp=0;
    if (principal->inicio!=NULL){	
    	actual=principal->inicio;    //si la lista no esta vacia se ubica en el inicio
    	while (actual!=NULL){	//revisa que la calle no sea repetida
    		if (actual->desde==des && actual->hacia==hac)
    			return(1);//significa que la calle si existe
    		actual=actual->siguiente;
    	}
    }
    	nuevo=(Nodo *)malloc(sizeof(Nodo)); //crea el nodo
    	nuevo->desde=des;nuevo->hacia=hac;//llena sus campos desde y hacia
    	if (principal->inicio==NULL){		  //si la lista no tiene 
    	    nuevo->siguiente=nuevo->anterior=NULL;// nodos lo convierte en el principio y el fin
    	    principal->inicio=principal->fin=nuevo;//en el principio y el fin
    	    nuevo->crucesI=NULL;
     	    nuevo->crucesF=NULL;
    	}
   	else{//si la lista no esta vacia
        	nuevo->anterior=principal->fin; //ubica el nodo al final de la lista
        	nuevo->anterior->siguiente=principal->fin=nuevo;
        	nuevo->siguiente=NULL;
        	nuevo->crucesI=NULL;
        	nuevo->crucesF=NULL;
    	}
    	return(0);    
}
//------------------------------------------------------------------------------------
int InsertarCruce (Lista *principal,char des, char hac, char calleD, char calleH){
    Cruce *nuevo,*aux; Nodo *actual;
    if (des==hac)
    	return(0);
    nuevo=(Cruce *)malloc(sizeof(Cruce));
    nuevo->desde=des;
    nuevo->hacia=hac;
    if (principal->inicio==NULL){
        printf("Error lista vacia");
        return(1);
    } 
    else{ 
    	//////////////////////////////////////////////////////////////////////////////// 
	while(actual!=NULL && (actual->desde!=calleD || actual->hacia!=calleH))
         			actual=actual->siguiente;	   
   	while(actual!=NULL){					//revisa que el
    		aux=actual->crucesI;				//cruce que se 
    		while(aux!=NULL){				//este ingresando
    			if (aux->desde==des && aux->hacia==hac) //en la lista no
    				return(0);			//este repetido
    			aux=aux->siguiente;
    		}
    		actual=actual->siguiente;	
    	}/////////////////////////////////////////////////////////////////////////////////////
         actual=principal->inicio;	//ubica el puntero al pricipio
         	while(actual!=NULL && (actual->desde!=calleD || actual->hacia!=calleH))
	//recorre hasta encontrar el nodo indicado por parametros o llege al final de la lista
         			actual=actual->siguiente;	            
            if (actual->crucesI==NULL){	//si la lista de cruces no permitidos
            	actual->crucesI=nuevo;	// esta vacia ubica el nodo al principio
            	actual->crucesF=nuevo;	//de la lista y ubica los 2 punteros
            	nuevo->siguiente=NULL;	//del cruce al mismo y su anterior
            	nuevo->anterior=NULL;   //y siguiente del no permitido a NULL
            }
            else{    	
        	nuevo->anterior=actual->crucesF; //si la lista de cruces no 
        	nuevo->anterior->siguiente=nuevo;//permitidos es distinto de
        	actual->crucesF=nuevo; 		//NULL ubica el cruce al final
        	nuevo->siguiente=NULL;		//de lista dicha
        	}
    }
}
//--------------------------------------------------------------------------------
void leerarchivo(Lista *principal, char *archivo){//funcion para leer el archivo
	FILE *af;				//crea un puntero a archivo
	char p,p1,p2,p3,p4;			
	int q=1,cont=0,c=0, l=0;
	if ((af=fopen(archivo,"r"))==NULL){
		printf("El archivo no existe\n");        
		exit (1);
	}
	while((p=fgetc(af))!=EOF){//recorre todo el archivo
		if(p=='\n')	  //contando los \n		
		l++;		  
	}
	rewind (af);		//ubica el puntero en el principio del archivo
	for(c=0;c<l;c++){//el problema es que hay que poner el numero de lineas aqui para que funcione
		cont=0;q=1;p='a';
		while((p>='a' && p<='z') || (p>='A' && p<='Z') || p!='\n'){ //mientras no sea caracter
			p=fgetc(af); //toma un caracter del archivo
			if (p==' ')	 //si el caracter es espacio se 
				continue;//salta este llamado del ciclo
			if (q==1){		// intercala entre con el int q
				p1=toupper(p);  //p1 y p2 para guarda el contenido
				q++;		//aumenta q para que en el
			}			//proximo llamando entre en el otro 
			else {			//condicional y luego
				p2=toupper(p);	//convierte el caracter en mayuscula
				q=1;		//convierte q en 1
			}
			if ((p2>='A' && p2<='Z') && (p1>='A' && p1<='Z')){
		 		if(cont==0){
					InsertarCalle(principal,p1,p2);
					cont++;//inserta la calle usando p1 y p2
					p3=p1;p4=p2;//aumenta cont para no entrar
				} 		//mas en este condicional
				else	
					//ingresa los cruces en la calle agregada anteriormente	
					InsertarCruce(principal,p1,p2,p3,p4);	
				p1=p2=' ';
			}	
		}

	}
	fclose(af);//cierra el archivo
}
//---------------------------------
int IMPRIMIR (Lista *principal){//imprime el contenido de las listas
    Nodo *actual; Cruce *aux;
    if (principal->inicio==NULL){	//en caso de que lista sea vacia
    	printf("error la lista esta vacia no se puede imprimir\n");
    	return(1);		
    	}
    actual=principal->inicio;	//ubica el puntero al principio de la lista
    do{
    printf("\n%c%c-->",actual->desde,actual->hacia); 
    printf("[");//imprime [ por estetica
    if(actual->crucesI==NULL){
        printf("NULL]");
    }    
    else{
    	if(actual->crucesI!=NULL)
       	aux=actual->crucesI;
       do{
            if(aux==NULL)
               printf("NULL");
            printf("%c%c,",aux->desde,aux->hacia);
            aux=aux->siguiente;
       }while (aux!=NULL);
    printf("NULL]"); //imprime NULL] por estetica
    }
    actual=actual->siguiente;
    }while (actual!=NULL);
	printf("\n");    
}
//--------------------------------------------
int CREARGRUPOS (Lista *principal, Lista *grupos){//crea los grupos por colores
	Nodo *actual;
	Nodo *aux;
	char i='1';
	char b,c;	
	int a;
	c='0';
	if (principal==NULL || grupos==NULL){
		printf("salida1");
		return(0);}
	if (principal->inicio!=NULL){
		actual=principal->inicio;
		while (actual!=NULL){
			a=actual->color; //convierte a en el color de actual
			c=(char) ((a/10)+48);//convierte a en div de 10 y en caracter
			b=(char) ((a%10)+48);//convierte a en modulo de 10 y en caracter
			InsertarCalle(grupos,c,b);//incerta una grupo en la lista grupos
			actual=actual->siguiente;
		}
		actual=principal->inicio;
		while (actual!=NULL){
			a=actual->color;
			c=(char) ((a/10)+48);
			b=(char) ((a%10)+48);
			InsertarCruce(grupos,actual->desde,actual->hacia,c,b);
			//incerta un cruce en el grupo correspondiente
			actual=actual->siguiente;
		}
			
	}
}
//------------------------------------------------------------------------------
int ORDENAR (Lista *principal){//ordena los cruce que no tengan giros no 
	Nodo*actual,*aux,*aux2;//permitidos al final de la lista 
	int cont=0;
	if (principal->inicio==NULL){//si lista es vacia se sale de 
		printf("salida 1");  //la funcion
		return(0);
		}	
	actual=principal->inicio; //se ubica al principio de la lista
	while (actual!=NULL && actual!=aux2 && actual!=principal->fin){
		while (actual->crucesI!=NULL && actual!=principal->fin){
			actual=actual->siguiente; 
			if (actual==NULL || actual==principal->fin){
				printf("salida 3\n");
				return(0);}
		}
		aux2=principal->fin; //ubica aux2 al final de la lista y la
		while(aux2!=NULL && aux2->crucesI==NULL && aux2!=actual) //recorre hasta
			 aux2=aux2->anterior; //encontrar un calle que no tengo cruces no permitidos
			 if (aux2==NULL){ 
			 	printf(">>>>>>todos son nulos<<<<<<");
			 	return(0);
			 }
			 if (aux2==actual)
			 	return(0);
				if (actual->anterior!=NULL)
					aux=actual->anterior;
				else{
					aux=actual->siguiente;
					principal->inicio=aux;
				}
				if (actual->anterior!=NULL){
					actual->anterior->siguiente=actual->siguiente;
					actual->siguiente->anterior=actual->anterior;
				}
				else
					actual->siguiente->anterior==NULL;
				actual->anterior=principal->fin;
				actual->anterior->siguiente=actual;
				actual->siguiente=NULL;
				principal->fin=actual;
				actual=aux;
				actual=actual->siguiente;;	
	}//cambia los que no tenga los no permitidos al final hasta 
}	// que actual sea igual a aux2
//--------------------------------------------
int COLORACION (Lista *principal,int colores){
	Nodo *actual,*aux;
	Cruce *aux2;
	int comp=0;
	if (principal->inicio==NULL){//en caso de lista vacia
		printf("\nerror1\n");
		return(0);
	}
	actual=principal->inicio; //pone el puntero en el inicio de la lista
	while (actual!=NULL && actual->color!=0 && actual!=principal->fin) //mientras actual no sea nulo y encuentre un nodo sin grupo
		actual=actual->siguiente; //recorre la lista hasta que se cumple la condicion anterior
	if (actual==NULL)
		return(0);
	if(actual->siguiente!=NULL)
		actual->color=colores;	//convierte el actual en el color llamado en la funcion
	aux=actual->siguiente;	//convierte el aux en el siguiente
	while (aux!=NULL && aux->color!=0) //recorre la lista hasta que cumpla la condicion
			aux=aux->siguiente;
	if (aux==NULL){ 
		if (actual->crucesI==NULL && actual->color==0)
	 	actual->color=colores;
		return(0);
	}
	while(aux!=NULL){
		aux2=actual->crucesI;
		if (aux2==NULL){
			actual->color=colores;
			COLORACION(principal,colores);
		}
		if (aux2!=NULL){
			while(aux2!=NULL && comp==0){
				if (aux2->desde==aux->desde && aux2->hacia==aux->hacia)
					comp++;
					aux2=aux2->siguiente;			
			}
			if (comp==0){
				aux->color=actual->color;
			}
			else{
				aux->color=0;
				comp=0;
			}
		}
	aux=aux->siguiente;	
	}
COLORACION(principal,colores+1);//vuelve a llamar la funcion aumentando los colores	
}
//---------------------------------
main(int argc, char *argv[]){
	Lista *principal=NULL;
	Lista *grupos=NULL;
	char archivo[200];	
      	principal=NUEVALISTA();
      	grupos=NUEVALISTA();
	if (argc<2){
		printf("Introduzca el nombre del archivo ");
		scanf("%s",archivo);
		leerarchivo(principal, archivo);
	}
	else{
		leerarchivo(principal, argv[1]);
	}
	printf("\n\tarchivo recibido\n");
	IMPRIMIR(principal);
	ORDENAR(principal);
    	COLORACION(principal,1);
    	CREARGRUPOS(principal,grupos);
    	printf("\n\tgrupos creados\n");
	IMPRIMIR(grupos);
}   //archivo a entregar
