#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
//#include "buzones.h"


int main(int argc, char** argv){
	int sockfd, portno,n;
	struct sockaddr_in serv_addr;
	struct hostent *server; 
	char buffer[256];

	if (argc < 3) { //2do ip 3ero puerto
		fprintf(stderr, "IP or Port missing\n");
		exit(1);
	}

	portno = atoi(argv[2]);			
	sockfd = socket(AF_INET,SOCK_STREAM, 0); //La familia //Tipo de socket  //Tipo de protocolo (El 0 del dice al SO que elija el mejor procolo)
	if (sockfd < 0){
		error("Error opening socket\n");
	}

	server = gethostbyname(argv[1]);
	if (server == NULL){
		fprintf(stderr, "Error Domain%s\n" );
		exit(1);
	}

	bzero((char*) &serv_addr, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;					
	serv_addr.sin_port = htons(portno); 

	bcopy( (char*)server->h_addr, (char*) &serv_addr.sin_addr.s_addr, server->h_length); //Dir del servidor //El lugar donde deberia estar la direccion //Tama;o de la dir

	if (connect (sockfd, &serv_addr, sizeof(serv_addr)) < 0){
		error ("Error on connect\n");
	}
	
	printf("\nIngrese un mensaje: \n");

	printf("Para crear un buzon \t\t\ta_Nombre_Tipo_Topico \n");
	printf("Para crear una cola \t\t\tb_Nombre\n");
	printf("Para enlazar una cola a un buzon \tc_NombreBuzon_NombreCola\n");
	printf("Para escuchar una cola \t\t\td_NombreCola\n");
	printf("Para escribir en un buzon\t\te_NombreBuzon_Msj\n");
	bzero (buffer,256);
	fgets (buffer,255,stdin);
	
	n = write(sockfd, buffer, strlen (buffer));

	if (n < 0){
		error("Error on write\n");
	}
	bzero (buffer,256);

	n = read(sockfd, buffer,255);	

	if (n < 0){
		error("Error on read\n");
	}

	printf("Msg recibido : %s\n", buffer);

	return 0;
	
	
	
	
	
	
}
