#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <signal.h>
#include <netinet/in.h>
#include <unistd.h> 
#include "buzones.h"

int main(int argc, char** argv){
	int sockfd, newsockfd, portno, n,clilen,index=0,tipo=0; //Identificador de socket,Variable para albergar el nuevo socket TCP,Num de puerto,Cant de bytes que hay en el string,longitud del cliente
	char buffer[256],a[4][255],*pch;//Escribiremos lo que vaya y venga, Separa el msj del cliente, caracter que separara el string
	char statement[255],Resultante[255]; 
//Revision de los parametros introducidos-------------------------------
	Parametros(argc);
	sockfd = socket(AF_INET,SOCK_STREAM, 0);//familia,TipoDeSocket,TipoDeProtocolo (El 0 del dice al SO que elija el mejor procolo)
	if (sockfd < 0){
		error("Error opening socket\n");
	}
//Fin Revision de los parametros introducidos---------------------------

	//Inicializar
	bzero((char*) &serv_addr, sizeof(serv_addr));  //Direccion //Tama;o de la estrutura
	portno = atoi(argv[1]);							//Puerto del servidor
	serv_addr.sin_family = AF_INET;						//Asigne familia al servidor
	serv_addr.sin_port = htons(portno); 	//Pasa lo que le pases a big endian
	serv_addr.sin_addr.s_addr = INADDR_ANY;	//aceptar solicitudes de cualquier IP disponible, de localhost o relaciones remotas

	if(bind(sockfd,(struct sockaddr*)&serv_addr,sizeof(serv_addr)) < 0)	{ 	//HAce que mi sistema de diga al so que quiere pegarse al socket
		error("Error on binding\n");
	}	

//ciclo infinito para oir a los clientes--------------------------------	
	int pid[30],i=0; //para verificar quien es el padre y el hijo
	int PuertoCliente=sockfd+1;
	/*revisar*/char Finalizar[256]="salida\n"; //palabra que debe mandar el cliente para finalizar el servidor
	//Base de datos---------------------------------------------------------
	MYSQL *conn;
	conn=BaseDeDatos ("localhost", "root","buzones","357159paulo");
	int j;
	printf("\nEsperando Cliente\n");
	while(1){
	//Esperar cliente---------------------------------------------------
	listen (sockfd,1);clilen = sizeof(cli_addr); //Tama;o del cli_addr tama;o del cliente
	newsockfd = accept(sockfd, (struct sockaddr*)&cli_addr, &clilen); //Crea el nuevo  socket
	printf("\nCliente recibido\n");
	//Fin Esperar cliente-----------------------------------------------
	pid[i]= fork();		
	if (pid[i]!=0) // Este es el proceso padre
		{
			printf("\n\t\tPADRE\n");
		}
		else // Proceso hijo
		{  
			printf("\n\t\thijo numero %d\n",i);
			RecibirMsj(clilen,buffer,newsockfd,sockfd,n);
			strcat(buffer,"_");
			printf("\nMensaje recibido del cliente: %s\n",buffer);
			EliminarSaltoDeLinea(buffer,Resultante);
			index=0;
			pch = strtok (Resultante,"_");
			while (pch != NULL)
			{
				strcpy(a[index],pch);
				pch = strtok (NULL, "_");
				index++;
			}
			//a[1] = Nombre || a[2] = tipo || a[3] = topico
			switch(tolower(*a[0])){
				case 'a':{
			    //Crear Buzones-----------------------------------------
				//CrearBuzon(conn,"Nombre","Tipo","Topico");
					switch(tolower(*a[2])){		
						case 'd':{
							CrearBuzon(conn,a[1],a[2],NULL);
							snprintf(statement, 255, "\nBuzon %s creado correctamente\n",a[1]);
							EnviarMsj(clilen,statement,newsockfd,sockfd,n);
						}
						break;
						case 'f':{
							CrearBuzon(conn,a[1],a[2],NULL);
							snprintf(statement, 255, "\nBuzon %s creado correctamente\n",a[1]);
							EnviarMsj(clilen,statement,newsockfd,sockfd,n);
						}
						break;
						case 't':{
							CrearBuzon(conn,a[1],a[2],a[3]);
							snprintf(statement, 255, "\nBuzon %s creado correctamente\n",a[1]);
							EnviarMsj(clilen,statement,newsockfd,sockfd,n);
							
						}
						break;
						
					}
				//Fin Crear Buzones-------------------------------------	
			     }
				break;

				case 'b':{
				//Crear Colas-------------------------------------------
				//CrearCola(conn,"Nombre");
				  CrearCola(conn,a[1]);
				  snprintf(statement, 255, "\nCola %s creada correctamente\n",a[1]);
				  EnviarMsj(clilen,statement,newsockfd,sockfd,n);
				  
				//Fin Crear Colas---------------------------------------
			     }
				break;
				
				case 'c':{
			    //Enlazar Colas a Buzon---------------------------------
				//EnlazarCola(MYSQL *conn, char *Buzon, char *Cola)
				  EnlazarCola(conn,a[1],a[2]);
				  snprintf(statement, 255, "\nCola %s enlazada correctamente al buzon %s\n",a[2],a[1]);
				  EnviarMsj(clilen,statement,newsockfd,sockfd,n);
				//Enlazar Colas-----------------------------------------
			     }
				break;
				case 'd':{
			     //Solicitar enlazarce a una cola
			     char *Cola=a[1];
			     
			     //Escuchar Msj -----------------------------------------
				MYSQL_RES *res;
				MYSQL_ROW row;
				bzero(statement,255);				
				snprintf(statement, 255, "SELECT ID,Msj FROM Mensaje WHERE ID_Cola='%s';",a[1]);
				mysql_query(conn, statement);		
				res = mysql_use_result(conn);
				conn=BaseDeDatos ("localhost", "root","buzones","357159paulo");
				row = mysql_fetch_row(res);
					if(row[0]!=NULL){
						printf("\n Msj: %s   %s  \n\n",row[0],row[1]);
						EnviarMsj(clilen,row[1],newsockfd,sockfd,n);
						
						snprintf(statement, 255, "Delete from Mensaje Where ID =%s;",row[0]);
						printf("statement:%s",statement);
						mysql_query(conn, statement);
					}
					else{
						snprintf(statement, 255,"\n No tiene ningun msj en cola\n");
						EnviarMsj(clilen,statement,newsockfd,sockfd,n);
						
					}
				mysql_free_result(res);
				
				//Enlazar Colas-----------------------------------------
			     }
			     break;
			     case 'e':{
						 //Escribir un msj ,a[1]=Buzon,a[2]=Msj
						printf("\nEntrando a la opcion e\n");
						MYSQL_RES *res;
						MYSQL_ROW row;
						snprintf(statement, 255, "SELECT Tipo,Topico FROM Buzon WHERE Nombre='%s';",a[1]);
						mysql_query(conn, statement);
						row = mysql_fetch_row(mysql_use_result(conn));
						if(row[0]!=NULL){//Verificamos si es topico o no
								if(strcmp(row[0],"t") || strcmp(row[0],"T")){
								tipo=1;printf("\nTiene topico\n");}
								else{tipo=0;
								}
						}
						else{
							snprintf(statement, 255,"\n El buzon no existe\n");
							EnviarMsj(clilen,statement,newsockfd,sockfd,n);	
						}
						conn=BaseDeDatos ("localhost", "root","buzones","357159paulo");
						bzero(statement,255);				
						if(tipo==1){//tiene topico
							snprintf(statement, 255, "SELECT Nombre FROM Cola WHERE Nombre LIKE '%s%';",row[1]);
							printf("\nQuery:%s\n", statement);
						}
						else{//no tiene topico
							snprintf(statement, 255, "SELECT ID_Cola FROM Buzon_Cola WHERE ID_Buzon='%s';",a[1]);
							printf("\nQuery:%s\n", statement);
						
						}							
						mysql_query(conn, statement);		
						res = mysql_use_result(conn);
						conn=BaseDeDatos ("localhost", "root","buzones","357159paulo");
						
						while ((row = mysql_fetch_row(res)) != NULL){
							printf("\nCola:%s\n", row[0]);
							EscribirMsj(conn,row[0],a[2]);
							
						}					
						mysql_free_result(res);
						snprintf(statement, 255, "\nMensaje enviado correctamente\n");
						 EnviarMsj(clilen,statement,newsockfd,sockfd,n);
					}			     
					break;
				}
			printf("\nCerrando hijo: %s\n", buffer);	
			printf("\nEsperando Cliente\n");
			exit(0);	
		} 
	 i++;
	 }	//while*/
/*
mostrartablas(conn);
VaciarTabla(conn,"Mensaje");
VaciarTabla(conn,"Buzon_Cola");
VaciarTabla(conn,"Cola");
VaciarTabla(conn,"Buzon");	*/

CerrarConexion(conn);
//fin ciclo infinito para oir a los clientes----------------------------
	return 0;
}
//gcc ServidorTCP.c -o Servidor `mysql_config --cflags --libs` 
