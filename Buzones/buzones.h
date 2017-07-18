#include <unistd.h> 
#include <mysql/mysql.h>

//Creacion de variables-------------------------------------------------
struct sockaddr_in serv_addr, cli_addr; //referncia la dirr del servidor y referencia la dirr del cliente //Se guarda la direccion el puert, la familia, toda la config del serv
//Fin Creacion de variables---------------------------------------------

//---------------------------------------------------------------------- 
void error(char* msg){
	perror(msg);
	exit(1);
}
//---------------------------------------------------------------------- 
void Parametros(int argc){
	if (argc < 2) {
		fprintf(stderr, "No port\n");
		exit(1);
	}
}
//---------------------------------------------------------------------- 
MYSQL *BaseDeDatos (char *server, char *user,char *database, char *password){
	MYSQL *conn;
	conn = mysql_init(NULL);
	if (!mysql_real_connect(conn, server,user, password, database, 0, NULL, 0)) {
		fprintf(stderr, "%s\n", mysql_error(conn));
		exit(1);
	}
  return(conn);
 }
//---------------------------------------------------------------------- 
void mostrartablas(MYSQL *conn){
	MYSQL_RES *res;
	MYSQL_ROW row;
	if (mysql_query(conn, "show tables")) {
		fprintf(stderr, "%s\n", mysql_error(conn));
		exit(1);
	}
	res = mysql_use_result(conn);
	printf("Las tablas en Mysql son:\n");
	while ((row = mysql_fetch_row(res)) != NULL)
		printf("%s \n", row[0]);
	mysql_free_result(res);
}
//---------------------------------------------------------------------- 
void MostrarResultado(MYSQL *conn){
	MYSQL_RES *sql_result;
	MYSQL_ROW row;
	if ( ( conn == NULL ) || mysql_query( conn, "SHOW WARNINGS" ) )
	{
		printf( "Conexion Invalida\n" );
		return;
	}
	sql_result = mysql_store_result( conn );
	if ( ( sql_result == NULL ) || ( sql_result->row_count == 0 ) )
	{
		printf( "Resultados en el SQL son NULL\n" );
		if ( sql_result )
			mysql_free_result( sql_result );
			return;
	}
	row = mysql_fetch_row( sql_result );
	if ( row == NULL )
	{
		printf( "Row vacio \n" );
		mysql_free_result( sql_result );
		return;
	}
	do
	{
		printf( "%s [%s: %s]\n", row[2], row[0], row[1] );
		row = mysql_fetch_row( sql_result );
	} while ( row );
	mysql_free_result( sql_result );
}
//----------------------------------------------------------------------
void EliminarSaltoDeLinea(char *statement,char *Resultante){
	int i=0,j=0;
while (statement[i] != '\0'){
			if ('\n' != statement[i]){
			  Resultante[j] = statement[i];
			  j++;}
		i++;}
		statement=Resultante;
}
//---------------------------------------------------------------------- 
void CrearBuzon(MYSQL *conn, char *Nombre, char *Tipo, char *Topico){
	char statement[255];
	snprintf(statement, 255, "INSERT INTO Buzon (Nombre,Tipo,Topico) VALUES('%s','%s','%s');",Nombre,Tipo,Topico);
	
	mysql_query(conn, statement);
	MostrarResultado(conn);
}
//---------------------------------------------------------------------- 
void CrearCola(MYSQL *conn, char *Nombre){
	char statement[255];
	snprintf(statement, 255,"INSERT INTO Cola (Nombre) VALUES('%s');",Nombre);

	mysql_query(conn, statement);		
	MostrarResultado(conn);
}
//---------------------------------------------------------------------- 
void EnlazarCola(MYSQL *conn, char *Buzon, char *Cola){
	char statement[255];
	snprintf(statement, 255, "INSERT INTO Buzon_Cola (ID_Buzon,ID_Cola) VALUES('%s','%s');",Buzon,Cola);
	mysql_query(conn, statement);
	MostrarResultado(conn);
}
//---------------------------------------------------------------------- 
void EscribirMsj(MYSQL *conn, char *Cola, char *Msj){
	char statement[255];

	
	snprintf(statement, 255,"INSERT INTO Mensaje (ID,ID_Cola,Msj) VALUES(NULL,'%s','%s');",Cola,Msj);
	printf("\n\nDentro de EscribirMsj:\n\n%s",statement);
	mysql_query(conn,statement);
	MostrarResultado(conn);
  
}
//---------------------------------------------------------------------- 
void VaciarTabla(MYSQL *conn, char *Tabla){
	char statement[255];
	snprintf(statement, 255, "delete from %s where 1;",Tabla);
	printf("\n%s vaciada correctamente\n",Tabla);
	mysql_query(conn, statement);	
	MostrarResultado(conn);
}
//---------------------------------------------------------------------- 
void RecibirMsj(int clilen,char buffer[],int newsockfd,int sockfd,int n){
	//El cliente debe saber a que puerto le debe hablar, se lo manda mediante el sockfd
	if (newsockfd < 0){
		error("Error en el accept\n");
	}
	bzero (buffer,256);
	n = read(newsockfd, buffer,255);
	if (n < 0){
		error("Error on read\n");
	}
	printf("Msg recibido: %s\n", buffer);
}	
//---------------------------------------------------------------------- 
void EnviarMsj(int clilen,char buffer[],int newsockfd,int sockfd,int n){
	//El cliente debe saber a que puerto le debe hablar, se lo manda mediante el sockfd
	if (newsockfd < 0){
		error("Error en el accept\n");
	}
	n = write(newsockfd, buffer,255);
	if (n < 0){
		error("Error on write");
	}
}			
//---------------------------------------------------------------------- 
void CerrarConexion(MYSQL *conn){
	printf("Cerrando Conexion\n");
	mysql_close(conn);
}
//---------------------------------------------------------------------- 


