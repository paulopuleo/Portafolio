program batallanaval;

USES crt; 

CONST
n=16;{<----TAMAÑO DE LAS MATRICES}
limitex1=5;{<----COMIENZO DE LA PRIMERA MATRIZ}
limitex2=42;{<----COMIENZO DE LA SEGUNDA MATRIZ}
limitey=5;{<-----COMIENZO EN "Y" DE LAS DOS MATRICES}
colormapa=9;{<----el color del mapa}
cdisparov=12;
cdisparof=15;
cbarreminas=2;
cfragata=14;
ccrucero=3;
cdestructor=4;
cmisil=10;
misill='##';
celdas='[]';
mira='<>';
ruta='J:\Batalla Naval Final\0el propio\battleship.ite';
rutacpu='J:\Batalla Naval Final\0el propio\battleshipcpu.itw';
TYPE
CELDA = record{<----ESTE TIPO DE DATO ESTRUCTURADO CONTIENE LA INFORMACION QUE RECIBIRAN LOS MAPAS}
             coordx:byte;{<----COORDENADA X}
             coordy:byte;{<----COODENADA Y}
             barco:boolean;{<----SI TIENE UN BARCO ENCIMA}
             disparo:boolean;{<----SI HAN DISPARADO EN ESTA COODENADA}
             celdita:string[2]; {LO QUE SE DIBUJA EN LA CELDA}
             numbarco:byte;
       end;
MAPA = array [1..n,1..n] of celda;  //Este es el arreglo para el mapa

MATRIZMAPA= array[1..4]of mapa;     //En este arreglo se guarda los 4 mapas

PARTIDA = record                       //esta son los datos necesarios para guardar en el archivo
          mapas:matrizmapa;
          vida1:byte;
          vida2:byte;
          end;

ARCH = file of partida;

{------------------------------------------------------------------------------}
PROCEDURE INIMAPA (var map:mapa;x,y:integer); {PROCEDIMIENTO PARA INICIALIZAR LOS VALORES DEL MAPA}
var
i,j,aux:integer;
begin
aux:=y;
for i:=1 to n do
    begin
    for j:=1 to n do
        begin
        map[i,j].coordx:=x;
        map[i,j].coordy:=y;
        map[i,j].barco:=false; //donde false significa que no hay barco
        map[i,j].disparo:=false;  //donde false significa que no se Ha disparado
        map[i,j].celdita:='[]';   //celda con la que se pintara el mapa cuando no cumple ninguna condicion anterior que sera modificada
        map[i,j].numbarco:=0;     //indica que tipo de barco se encuetra en la casilla, donde 0 indica que no hay
        y:=y+1;  //para darle valores a y en coordy
        end;
        y:=aux;//para que y vuelva a su valor original y pinte correctamente el mapa
        x:=x+2;  //para darle valores a x en coordx
    end;
end;
{------------------------------------------------------------------------------}
PROCEDURE coordenadas; //COORDENADAS E INSTRUCCIONES;
var
j,i,x,y:byte;
begin                                                  //PARA QUE PINTE LAS COORDENADAS EN AMBOS MAPAS
textcolor(4);
i:=64; //coordenadas del mapa de los barcos
j:=0;
x:=3;
y:=4;
     repeat
     begin
          x:=x+2;
          i:=i+1;
          Gotoxy(x,y);
          writeln (char(i));
     end;
     until x=35;
     x:=3;
     repeat
     begin
         y:=y+1;
         j:=j+1;
         Gotoxy(x,y);
         writeln (j);
     end;
     until (y=20)or(y=41);
     i:=64; //coordenadas del mapa de ataque
	 j:=0;
	 x:=40;
	 y:=4;
     repeat
     begin
          x:=x+2;
          i:=i+1;
          Gotoxy(x,y);
          writeln (char(i));
     end;
     until x=72;
     x:=40;
     repeat
     begin
         y:=y+1;
         j:=j+1;
         Gotoxy(x,y);
         writeln (j);
     end;
     until (y=20)or(y=41);
textcolor(6);
gotoxy(36,23);
writeln('Presione I para ver Informacion'); //instrucciones

end;
{------------------------------------------------------------------------------}
PROCEDURE DIBUJARMAPA (map:mapa;color:integer);  {ESTE ES UN PROCEDIMIENTO PARA DIBUJAR EL MAPA}
var i,j:integer;
begin
  for i:=1 to n do    {AQUI ME MUEVO POR LAS FILAS DE LA MATRIZ}
      for j:=1 to n do    {AQUI ME MUEVO POR LAS COLUMNAS DE LA MATRIZ}
          begin
             if (map[i,j].disparo=false) then 
               begin
                    textcolor (color);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);
               end;
                if (map[i,j].disparo=true) then
                  if (map[i,j].barco=true) then
                  begin
                    textcolor (cdisparov);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);
                  end
                  else
                  begin
                    textcolor (color);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);
                  end;
                if map[i,j].celdita='--'then  //para que las fallas sean de color
               begin
                textcolor (cdisparof);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);  
               end;
               if map[i,j].celdita='XX'then  //para que los aciertos sean de color
               begin
                textcolor (cdisparov);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);  
               end;
               if map[i,j].celdita='BB'then  //para que las barreminas sean de color 
               begin
                textcolor (cbarreminas);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);   
               end;
               if map[i,j].celdita='FF'then  //para que las fragatas sean de color 
               begin
                textcolor (cfragata);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);   
               end;
               if map[i,j].celdita='CC'then  //para que los cruceros sean de color 
               begin
                textcolor (ccrucero);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);   
               end;
               if map[i,j].celdita='DD'then  //para que las destructor sean de color 
               begin
                textcolor (cdestructor);
                    gotoxy (map[i,j].coordx,map[i,j].coordy);{<----AQUI USO LAS LAS COORDENADAS QUE LES ASIGNE EN LA INICIALIZACION}
                    writeln (map[i,j].celdita);   
               end;            

           end;
end;
{------------------------------------------------------------------------------}
PROCEDURE DESBARC (var mpa,mpb:mapa;i,j:byte;var vida,turno:byte);  //PROCEDIMIENTO PARA VERIFICAR LA MUERTE DE UN BARCO
var                                                        //RECIBE COMO PARAMETROS LOS DOS MAPA,LAS COORDENADAS ACTUALES DEL CURSOR
tam,cont,imp,aux:byte;//TAM ES EL TAMAÑO DEL BARCO               Y LAS LATRAS QUE POSEE EL BARCO COMO DECIR EL TIPO
msj:string[30];
begin
begin
textcolor (0);
gotoxy(5,2);
writeln ('                                    ' );
end;           //CONT ES UN AUXILIAR PARA LOS FOR
imp:=1;           //IMP ES UN CONTADOR PARA VER SI MATO AL BARCO
cont:=1;
msj:=mpb[i,j].celdita;
aux:=mpb[i,j].numbarco;
if (mpb[i,j].celdita='BB') then
   begin
        tam:=2;
          msj:='As destruido un BARREMINAS!!!';
   end;
if (mpb[i,j].celdita='FF') then
   begin
        tam:=3;
        msj:='As destruido una FRAGATA!!!';
   end;
if (mpb[i,j].celdita='CC') then
          begin
               tam:=4;
               msj:='As destruido un CRUCERO!!!';
          end;
if (mpb[i,j].celdita='DD') then
          begin
               tam:=5;
               msj:='As destruido el DESTRUCTOR!!!';
          end;
while ((mpb[i+cont,j].numbarco=aux) and (i+cont<17) and (mpa[i+cont,j].disparo=true)) do
      begin    
         imp:=imp+1;
         cont:=cont+1;
      end;
cont:=1;
while ((mpb[i-cont,j].numbarco=aux) and (i-cont>0)  and (mpa[i-cont,j].disparo=true)) do
      begin
         imp:=imp+1;
         cont:=cont+1;
      end;           
cont:=1;
while ((mpb[i,j+cont].numbarco=aux) and (j+cont<17) and (mpa[i,j+cont].disparo=true)) do
      
      begin
        imp:=imp+1;
        cont:=cont+1;
      end;
cont:=1;
while ((mpb[i,j-cont].numbarco=aux) and (j-cont>0)  and (mpa[i,j-cont].disparo=true)) do
      begin
        imp:=imp+1;
        cont:=cont+1;
      end;
if (imp=tam) then
   begin

	gotoxy(5,23);
    textcolor (4);
	writeln (msj);
	vida:=vida-1;
	textcolor (4);
	gotoxy(36,22);;
	writeln ('le quedan ', vida , ' embarcaciones' );
    if vida<>0 then
    begin
	turno:=0;
    end;
   end;
end;
{------------------------------------------------------------------------------}
//                      AQUI COMIENZAN LOS PROCEDIMIENTOS DE GUARDADO
{------------------------------------------------------------------------------}
PROCEDURE CARGARINF (var inf:partida; mapa1,mapa2,mapab1,mapab2:mapa;vid1,vid2:byte);

begin
     inf.mapas[1]:=mapa1;
     inf.mapas[2]:=mapa2;
     inf.mapas[3]:=mapab1;
     inf.mapas[4]:=mapab2;
     inf.vida1:=vid1;
inf.vida2:=vid2;
end;
{------------------------------------------------------------------------------}
procedure LLENARARCHIVO (JUEGO: partida; path: string);
var
   archivop:arch;
   nError:integer;
begin
     {$I-}
          assign(archivop, path);
          nError:=IOResult;
     {$I+}
     if (nError=0) then
     begin
       {$I-}
         rewrite(archivop);
         nError:=IOResult;
       {$I+}
       if (nError=0) then
       begin
            write(archivop, juego);
            close(archivop);
       end
       else
          writeln('Error en el rewrite. Error N#', nError);
          readkey;
     end
     else
         writeln('Error en el assign. Error N#', nError);
         readkey;

end;

{------------------------------------------------------------------------------}
PROCEDURE TRAERPARTIDA (var juego:partida; path: string);
var
   archivop:arch;
   nError:integer;
begin
     {$I-}
          assign(archivop, path);
          nError:=IOResult;
     {$I+}
     if (nError=0) then
     begin
       {$I-}
         reset(archivop);
         nError:=IOResult;
       {$I+}
       if (nError=0) then
       begin
            read(archivop, juego);
            close(archivop);
       end
       else
          writeln('No existe partida creada precione una tcla para salir');
          readkey;
     end
     else
         writeln('Error en el assign. Error N#', nError);
         readkey;
end;
{------------------------------------------------------------------------------}
PROCEDURE CARGARPARTIDA (var inf:partida;var mapab1,mapa1,mapab2,mapa2:mapa;var vid1,vid2:byte);

begin
     mapa1:=inf.mapas[1];
     mapa2:=inf.mapas[2];
     mapab1:=inf.mapas[3];
     mapab2:=inf.mapas[4];
     vid1:=inf.vida1;
     vid2:=inf.vida2;
end;

{------------------------------------------------------------------------------}
PROCEDURE MISIL(var x,y:byte;ataqu:mapa);
var
a,b:byte;
begin
 a:=74;
 b:=21;
 repeat
 if a>x then
 begin
  a:=a-2;
 end;
 if b>y then
 begin
  b:=b-1;
 end;
 delay(20);

 dibujarmapa(ataqu,colormapa);
  gotoxy(a,b);
 textcolor(cmisil);
 writeln(misill);
 until (a=x) and (b=y);
end;
{------------------------------------------------------------------------------}
PROCEDURE cursor(var ataque,barcos,barcos1:mapa;x,y:byte;var vid:byte);
var
   movimiento,coord1:char;
   a,b,i,coord2:byte;
   condicion:boolean; //para que si dispara ramdon no salga el misil;
   
begin
     a:=1;
     b:=1;
     i:=0;
     condicion:=true;
     gotoxy(2,2);
     writeln('                                           ');
     gotoxy(2,3);
     writeln('                                           ');
     repeat
            repeat
                movimiento:=upcase(readkey);
                if movimiento='H'then
                begin
	               movimiento:='W';
	            end;                          //para que se mueva en las direccionales
                if movimiento='P'then
	            begin
                    movimiento:='S';
                end;
                if movimiento='M'then
                begin
	                movimiento:='D';
                end;
                if movimiento='K'then
                begin
	                movimiento:='A';
	            end;
                 dibujarmapa(ataque,9);
                 case movimiento of
                      'W':
                      begin
                           dibujarmapa (ataque,9);
                           y:=y-1;
                           b:=b-1;
                           if (y=4)then
                           begin
                                y:=y+1;
                                b:=b+1;
                           end;
                           gotoxy(x,y);
                           textcolor(14);
                           write(mira);
                           textcolor(colormapa);
                      end;
                      'S':
                      begin
                           dibujarmapa (ataque,9);
                           y:=y+1;
                           b:=b+1;
                           if (y=21)then
                           begin
                              y:=y-1;
                              b:=b-1;
                           end;
                           gotoxy(x,y);
                           textcolor(14);
                           write(mira);
                           gotoxy(x,y-1);
                           textcolor(colormapa);
                      end;
                      'D':
                      begin
                           dibujarmapa (ataque,9);
                           x:=x+2;
                           a:=a+1;
                           if (x=74)then
                           begin
                                x:=x-2;
                                a:=a-1;
                           end;
                           gotoxy(x,y);
                           textcolor(14);
                           write(mira);
                           gotoxy(x-2,y);
                           textcolor(colormapa);
                      end;
                      'A':
                      begin
                           dibujarmapa (ataque,9);
                           x:=x-2;
                           a:=a-1;
                           if (x=limitex2-2)then
                           begin
                                x:=x+2;
                                a:=a+1;
                           end;
                           gotoxy(x,y);
                           textcolor(14);
                           write(mira);
                           gotoxy(x+2,y);
                           textcolor(colormapa);
                      end;
                      'Q':   //para que pueda meter las coordenadas manualmente
                      begin
                      condicion:=false;
                           repeat
                                 gotoxy(37,2);writeln('          ');
                                 gotoxy(2,2);write('indique la primera coordenada[a..p]');
                                 readln(coord1);
                                 a:=ord(lowercase(coord1));
                                 if a>95 then
                                 begin
                                      a:=a-96;
                                 end;
                           until (a>=1) and (a<=16);
                           repeat
                                 gotoxy(38,3); writeln('          ');
                                 gotoxy(2,3); write('indique la segunda coordenada[1..16]');
                                 readln(coord2);
                                 begin
                                      b:=coord2;
                                 end;
                                 movimiento:=#32
                           until (b>=1) and (b<=16);
                      end;
                      'R':   //para que pueda meter las coordenadas al azar
                      begin
                           condicion:=false;
                           movimiento:=#32;
                           a:=Random(17);
                           b:=Random(17);
                           if (a=0) then
                           begin
	                          a:=1;
                           end;
                           if (b=0) then
                           begin
	                          b:=1;
                           end;
                      end;
                      'I':   //para que pueda ver las instrucciones
                      begin
                           repeat
                                 clrscr;
                                 gotoxy(36,2);writeln('COMANDOS');
                                 textcolor(14);
                                 gotoxy(4,4);writeln('W: cursor arriba;');
                                 gotoxy(4,6);writeln('S: cursor abajo;');
                                 gotoxy(25,4);writeln('D: cursor derecha;');
                                 gotoxy(25,6);writeln('S: cursor izquierda;');
                                 Gotoxy(46,4);writeln('C: Cambio direccion barco;');
                                 Gotoxy(46,6);writeln('Q: coordenadas manuales;');
                                 gotoxy(4,8);writeln('ESPACIO: disparo');
                                 gotoxy(25,22);writeln('V: volver al juego');
                                 gotoxy(46,8);writeln('R: Disparar al azar');
                                 gotoxy(20,10);writeln('Tambien se puede mover en las direccionales');
                                 gotoxy(4,14);writeln('BB:barreminas');
                                 gotoxy(44,14);writeln('FF:fragatas');
                                 gotoxy(4,16);writeln('CC:Cruceros');
                                 gotoxy(44,16);writeln('DD:Destructor');
                                 movimiento:=readkey;
                           until movimiento='v';
                           clrscr;
                           dibujarmapa(ataque,9);
                           dibujarmapa(barcos1,9);
                           coordenadas;
                      end;
             
			end;//case
   until (movimiento=#32);
   if ataque[a,b].disparo=false then
   begin
        i:=1;
        if condicion=true then
        begin
        misil(x,y,ataque);
        end;
        ataque[a,b].disparo:=true; //ESTO MODIFICA LA POSICION DE DISPARO
        if (barcos[a,b].barco=true) then
        begin
           gotoxy(5,22);writeln('Le ha dado a un barco!!');
           desbarc (ataque,barcos,a,b,vid,i);
           ataque[a,b].celdita:='XX'; //ESTO MODIFICA LAS LETRAS DE LAS CELDAS
           barcos[a,b].celdita:='XX';
           readkey;
        end
        else
        begin
           textcolor(4);
           gotoxy(5,22);writeln('Misil Fallido              ');
           barcos[a,b].celdita:='--';
           ataque[a,b].celdita:='--';
        end;
   end
   else
   begin
        gotoxy (5,2);writeln('ya se disparo en esa posicion');
   end;
until i=1;
end;
{------------------------------------------------------------------------------}
PROCEDURE JUGADOR (var barcos,ataque:mapa);  {ESTE ES UN PROCEDIMIENTO PARA DIBUJAR EL MAPA DEL JUGADOR }
begin
dibujarmapa (barcos,9);
dibujarmapa (ataque,9);
textcolor(4);
coordenadas;
end;
{------------------------------------------------------------------------------}
PROCEDURE COMPUTADORA (var ataque,barcos:mapa;x,y:byte;var vid:byte);  {ESTE EL PROCEDIMIENTO PARA LOS DISPAROS DE LA COMPUATDORA}
var
i:byte;
begin
     i:=0;
     repeat
           X:=Random(17);
           Y:=Random(17);
           if (x<>0) and (y<>0) then
              begin
                   if ataque[x,y].disparo=false then
                   begin
                        i:=1;
                        ataque[x,y].disparo:=true; //ESTO MODIFICA LA POSICION DE DISPARO
                        if (barcos[x,y].barco=true) then
                        begin
                             desbarc (ataque,barcos,x,y,vid,i);
                             ataque[x,y].celdita:='XX'; //ESTO MODIFICA LAS LETRAS DE LAS CELDAS
                             barcos[x,y].celdita:='XX';
                             gotoxy(5,22); writeln('Le ha dado a un barco!!');
                        end
                        else
                        begin
                             barcos[x,y].celdita:='--';
                             ataque[x,y].celdita:='--';
                        end;
                   end
                   else
                   begin
                        gotoxy (5,2);
                        writeln('ya se disparo en esa posicion');
                   end;
              end;
     until i=1;
end;
{------------------------------------------------------------------------------}
PROCEDURE cursorbarco (var barcos,ataque:mapa;x,y,tipobarc,modjueg:byte;direc,perso:boolean); //para colocar los barcos
var
   movimiento:char;
   a,b,i,j,f,m,contador,limix,aux,limiy:integer;
   celdabarco:string;
   coord1:char;
   coord2:byte;
begin
     a:=1;   //a y b son coordenadas que de acuerdo a la matriz
     b:=1;
     repeat
           dibujarmapa(ataque,9);
           if (perso=true)or  (modjueg=3) then
           begin

           dibujarmapa(barcos,9);
           end;
           coordenadas;
           if perso=true then
           begin
                repeat
                {######################################################################}
                if tipobarc=1 then //BARREMINAS
                begin//s=y21 //d=x37
                    i:=1;//i significa la longitud del barco
                    celdabarco:='BB';
                    if direc=false then
                    begin
                         limiY:=20;
                         limix:=37;
                    end;
                    if direc=true then
                    begin
                         limiX:=35;
                         limiy:=21;
                    end;
                end;
                {######################################################################}
                if tipobarc=2 then
                begin//s=y21 //d=x37  //FRAGATA
                     i:=2;//i significa la longitud del barco
                     celdabarco:='FF';
                     if direc=false  then
                     begin
                          limiy:=19;
                          limix:=37;
                     end;
                     if direc=true then
                     begin
                          limiX:=33;
                          limiy:=21;
                     end;
                end;
                {######################################################################}
                if tipobarc=3 then
                begin//s=y21 //d=x74  //CRUCERO
                    i:=3;//i significa la longitud del barco
                    celdabarco:='CC';
                    if direc=false  then
                    begin
                         limiy:=18;
                         limix:=37;
                    end;
                    if direc=true then
                    begin
                         limiX:=31;
                         limiy:=21;
                    end;
                end;
                {######################################################################}
                if tipobarc=4 then
                begin//s=y21 //d=x74  //DESTRUCTOR
                    i:=4;//i significa la longitud del barco
                    celdabarco:='DD';
                    if direc=false  then
                    begin
                         limiy:=17;
                         limix:=37;
                    end;
                    if direc=true then
                    begin
                         limiX:=29;
                         limiy:=21;
                    end;
                end;
                if direc=false then
                begin
                     for i:=0 to i do
                     begin
                          gotoxy(x,y+i);
                          textcolor(14);
                          writeln(mira);
                     end;
                end;
                if direc=true then
                   for i:=0 to i do
                   begin
	                  gotoxy(x+(i*2),y);
	                  textcolor(14);
	                  writeln(mira);
                   end;
           j:=i+1;


movimiento:=upcase(readkey);
if movimiento='H'then
	 begin
	 movimiento:='W';
	 end;	
if movimiento='P'then
	 begin
	 movimiento:='S';
	 end;		 
if movimiento='M'then
	 begin
	 movimiento:='D';
	 end;
if movimiento='K'then
	 begin
	 movimiento:='A';
	 end;	 	
gotoxy(2,2);                
Writeln('                                               ');
gotoxy(2,3);
Writeln('                                                ');
      case movimiento of
      'W':
      begin
       dibujarmapa(barcos,9);
        y:=y-1;
		b:=b-1;
		if (y=4)then
		begin
			y:=y+1;
			b:=b+1;
		end;
		if direc=false then
		begin
		for i:=0 to i do
			begin
                j:=i+1;
				textcolor(14);
				gotoxy(x,y+i);
				writeln(mira);								
			end;	
		end;
		if direc=true then
		for i:=0 to i do
			begin
			    gotoxy(x+(i*2),y);
				textcolor(14);
				writeln(mira);
		end;	
      end;
      'S':
      begin
       dibujarmapa(barcos,9);
		y:=y+1;
		b:=b+1;
		if (y=limiy)then
		begin
			y:=y-1;
			b:=b-1;
		end;
		if direc=false then
		begin
		for i:=0 to i do
			begin
				gotoxy(x,y+i);
				textcolor(14);
				writeln(mira);
			end;	
		end;
		if direc=true then
		for i:=0 to i do
			begin
				gotoxy(x+(i*2),y);
				textcolor(14);
				writeln(mira);
			end;
	 end;
      'D':
      begin
       dibujarmapa(barcos,9);
		x:=x+2;
		a:=a+1;
		if (x=limix)then
		begin
			x:=x-2;
			a:=a-1;
		end;
		if direc=false then
		begin
		for i:=0 to i do
			begin
				gotoxy(x,y+i);
				textcolor(14);
				writeln(mira);
			end;	
		end;
		if direc=true then
		for i:=0 to i do
			begin
				gotoxy(x+(i*2),y);
				textcolor(14);
				writeln(mira);
			end;
      end;
      'A':
      begin
       dibujarmapa(barcos,9);
		x:=x-2;
		a:=a-1;
		if (x=3)then
		begin
			x:=x+2;
			a:=a+1;
		end;
		if direc=false then
		begin
		for i:=0 to i do
			begin
				gotoxy(x,y+i);
				textcolor(14);
				writeln(mira);
			end;	
		end;
		if direc=true then
		for i:=0 to i do
			begin
				gotoxy(x+(i*2),y);
				textcolor(14);
				writeln(mira);
			end;
      end;
      'C':
      begin
      x:=5;
        y:=5;
        a:=1;
        b:=1;
		if direc=false then
		begin
		for i:=0 to i do
			begin
			direc:=true;
				textcolor(colormapa);
				gotoxy(x,y+i);
				writeln(celdas);
				
			end;	
		end
		else
		begin
		for i:=0 to i do
			begin
				textcolor(colormapa);
				gotoxy(x+(i*2),y);
				writeln(celdas);
				direc:=false;	
			end;

        end;
         dibujarmapa(barcos,9);

      end;
      'Q':   //para que pueda meter las coordenadas manualmente
            begin
                 if direc=false then
                 begin
                 repeat
					  gotoxy(37,2);
					  writeln('                ');
                      gotoxy(2,2);
                      write('indique la primera coordenada[a..p]');
                      readln(coord1);
                      a:=ord(lowercase(coord1));
                      if a>95 then
                      begin
                           a:=a-96;
                      end;
                      
                  until (a>=1) and (a<=16);
                //######################################### 
                repeat
					  gotoxy(38,3);
					  writeln('                  ');
                      gotoxy(2,3);
                      write('indique la segunda coordenada[1..16]');
                      readln(coord2);
                      begin
                           b:=coord2;
                      end;
                      movimiento:=#32
                until (b>=1) and (b<=16-i);
                 end
                 else
                 begin
                 repeat
					  gotoxy(37,2);
					  writeln('          ');
                      gotoxy(2,2);
                      write('indique la primera coordenada[a..p]');
                      readln(coord1);
                      a:=ord(lowercase(coord1));
                      if a>95 then
                      begin
                           a:=a-96;
                      end;
                      
                  until (a>=1) and (a<=16-i);
                //######################################### 
                repeat
					  gotoxy(38,3);
					  writeln('          ');	
                      gotoxy(2,3);
                      write('indique la segunda coordenada[1..16]');
                      readln(coord2);
                      begin
                           b:=coord2;
                      end;
                      movimiento:=#32
                until (b>=1) and (b<=16);       
                 end;

			end;
			'R':   //para que las coordenadas sean al azar
               begin
               aux:=random(2);
               if aux=1 then
               begin
                    direc:=false;
               end;
               if aux=0 then
               begin
                    direc:=true;
               end;
               if direc=false then
               begin
                    movimiento:=#32;
					a:=Random(17);
					b:=Random(17-i);
					if (a=0) then
					begin
						a:=1					 
					end;
					if (b=0) then
					begin
						b:=1					 
					end;
				gotoxy(5,3);
               end
               else
               begin
                movimiento:=#32;		
					a:=Random(17-i);
					b:=Random(17);
					if (a=0) then
					begin
						a:=1					 
					end;
					if (b=0) then
					begin
						b:=1					 
					end;
				gotoxy(5,3);
               end;
				
				end; 
			'I':   //para que pueda ver las instrucciones
                 begin
                 repeat
                    clrscr;
                    gotoxy(36,2);
					writeln('COMANDOS'); 
					textcolor(14);
					gotoxy(4,4);
					writeln('W: cursor arriba;'); 
					gotoxy(4,6);
					writeln('S: cursor abajo;'); 
					gotoxy(25,4);
					writeln('D: cursor derecha;'); 
					gotoxy(25,6);
					writeln('S: cursor izquierda;'); 
					gotoxy(46,4);
					writeln('C: Cambio direccion barco;'); 
					gotoxy(46,6);
					writeln('Q: coordenadas manuales;');
					gotoxy(4,8);
					writeln('ESPACIO: colocar barco');
                    gotoxy(20,10);
					writeln('Tambien te puedes mover en las direccionales');
					gotoxy(25,23);
					writeln('V: volver al juego');  
					gotoxy(46,8);
					writeln('R: colocar al azar');
                    gotoxy(4,14);writeln('BB:barreminas');
                    gotoxy(44,14);writeln('FF:fragatas');
                    gotoxy(4,16);writeln('CC:Cruceros');
                    gotoxy(44,16);writeln('DD:Destructor');
					movimiento:=readkey;
					
				until movimiento='v';
				clrscr;	
                dibujarmapa(ataque,9);
                dibujarmapa(barcos,9);
                coordenadas;
                 end;
    end; 
 until (movimiento=#32);
end
else
begin
{######################################################################}
 if tipobarc=1 then //BARREMINAS
 begin//s=y21 //d=x37 
 i:=1;//i significa la longitud del barco
 celdabarco:='BB'; 
		if direc=false then
		 begin
			limiY:=20;
			limix:=37;
		end;	
        if direc=true then
        begin
			limiX:=35;
			limiy:=21;
		end;
 end;
 {######################################################################}
 if tipobarc=2 then
 begin//s=y21 //d=x37  //FRAGATA 
 i:=2;//i significa la longitud del barco 
  celdabarco:='FF';
   if direc=false  then
   begin
			limiy:=19;
			limix:=37;
	end;		
	if direc=true then
	begin
			limiX:=33;
			limiy:=21;
	end;				
  end;
  {######################################################################}
  if tipobarc=3 then
 begin//s=y21 //d=x74  //CRUCERO
 i:=3;//i significa la longitud del barco
  celdabarco:='CC';
   if direc=false  then
   begin
			limiy:=18;
			limix:=37;
	end;		
   if direc=true then
   begin
			limiX:=31;
			limiy:=21;
	end;
  end;
  {######################################################################}
  if tipobarc=4 then
    begin//s=y21 //d=x74  //DESTRUCTOR
  i:=4;//i significa la longitud del barco
   celdabarco:='DD';
   if direc=false  then
   begin
			limiy:=17;
			limix:=37;
	end;		
   if direc=true then
   begin
			limiX:=29;
			limiy:=21;
	end;
end;
if direc=false then
		begin
		for i:=0 to i do
			begin
				gotoxy(x,y+i);
				textcolor(14);
				writeln(mira);
			end;	
		end;
		if direc=true then
		for i:=0 to i do
			begin
				gotoxy(x+(i*2),y);
				textcolor(14);
				writeln(mira);
			end;
	m:=random(2);
	if m=0 then
	begin
		direc:=false;
	end
	else
	begin
		direc:=true;
	end;
	repeat
		if direc=false then // para poner los barcos del computador
			begin				
				a:=random(17);
				b:=random(17-i);
			end
		else
			begin
				randomize;
				a:=random(17-i);
				b:=random(17);
			end;	
	until (a<>0) and (b<>0);
end;
contador:=0;
 //validando los barcos
begin
	if direc=false then
	begin
		for j:=0 to i do
		begin
			if barcos[a,b+j].barco=true then 
			begin 
			contador:=1	
			end;
		end;		 
		if contador=1 then
		begin
			aux:=0;
			gotoxy(2,3);
			Writeln('en esta posicion ya se encuentra un barco,por favor ubiquelo de nuevo'); 
		end
		 else
		begin
		aux:=1;
			for i:=0 to i do
			begin
				barcos[a,b+i].celdita:=celdabarco;
			end;
		end;		
	end	
	else
	begin
		for j:=0 to i do
		begin
			if barcos[a+j,b].barco=true then 
			begin 
			contador:=1	
			end;
		end;		 
		if contador=1 then
		begin
			aux:=0;
			gotoxy(2,3);
			Writeln('en esta posicion ya se encuentra un barco,por favor ubiquelo de nuevo'); 
		end 
		 else
		begin
		aux:=1;
			for i:=0 to i do
			begin
				barcos[a+i,b].celdita:=celdabarco;
			end;
		end;		
	end		
end;
until aux=1;
if (perso=true)or  (modjueg=3) then
           begin
           dibujarmapa(barcos,9);
           end;
f:=f+1;
if direc=false then
begin
	for i:=0 to i do
	begin
		barcos[a,b+i].barco:=true;//esto cambia la coordenada para indicar que hay un barco en esa posicion 
		ataque[a,b+i].barco:=true;//esto cambia la coordenada para indicar que hay un barco en esa posicion 
		barcos[a,b+i].numbarco:=f;//esto cambia la coordenada para indicar que hay un barco en esa posicion  
	end;	
end
else
begin
	for i:=0 to i do
	begin
		barcos[a+i,b].barco:=true;//esto cambia la coordenada para indicar que hay un barco en esa posicion
		ataque[a+i,b].barco:=true;//esto cambia la coordenada para indicar que hay un barco en esa posicion
		barcos[a+i,b].numbarco:=f;//esto cambia la coordenada para indicar que hay un barco en esa posicion   	
	end;
end;
gotoxy(2,3);
Writeln('                                                                     '); 
end;

{------------------------------------------------------------------------------}
 procedure instruccion(x:boolean;mapab,mapat,mapab2,mapat2:mapa;var vida1,vida2:byte;rutaarch:string;var sal:boolean);
 var
 regjuego:partida;
 jugador:string;
 letra,opcion:char;
 BEGIN
 if x=true then
 begin
 jugador:=('jugador 1');
 end
 else
 begin
  jugador:=('jugador 2');
 end;
               repeat
                      clrscr;
                    gotoxy(36,1);
					writeln('COMANDOS');
                    textcolor(15);
                    gotoxy(21,14);
					writeln('turno del ',jugador);
					textcolor(14);
					gotoxy(4,4);
					writeln('W: cursor arriba;'); 
					gotoxy(4,6);
					writeln('S: cursor abajo;'); 
					gotoxy(25,4);
					writeln('D: cursor derecha;'); 
					gotoxy(25,6);
					writeln('S: cursor izquierda;'); 
					gotoxy(46,4);
					writeln('C: Cambio direccion barco;'); 
					gotoxy(46,6);
					writeln('Q: coordenadas manuales;');
					gotoxy(4,8);
					writeln('ESPACIO: colocar barco');
					gotoxy(25,20);
					writeln('G:Guardar Partida');
                    gotoxy(10,10);
					writeln('Tambien puede moverse en las direccionales');
					gotoxy(46,8);
					writeln('R: disparar al azar');
                    gotoxy(25,23);
					writeln('X: Salir');
                    gotoxy(25,21);
					writeln('T :Reiniciar');
                    gotoxy(4,14);writeln('BB:barreminas');
                                 gotoxy(44,14);writeln('FF:fragatas');
                                 gotoxy(4,16);writeln('CC:Cruceros');
                                 gotoxy(44,16);writeln('DD:Destructor');
                    letra:=lowercase(Readkey);
                    if letra='g' then
                    begin
                    clrscr;
                    repeat
                       gotoxy (20,12);
                       writeln ('Seguro que desea guardar? [S/N](si)');
                       gotoxy (20,10);
                       writeln ('Se borrara la partida antes guardada');
                       opcion:=upcase(readkey);

                    until (opcion='S')or(opcion='N');
                       begin
                       if (opcion='S') then
                            CARGARINF (regjuego,mapat,mapat2,mapab,mapab2,vida1,vida2);
                            LLENARARCHIVO (regjuego,rutaarch);
                            gotoxy (20,14);
                       writeln ('La partida a sido guardada con exito');
                       readkey;
                       end;
                    end;
                       if letra='x' then
                    begin
                        vida1:=0;
                        vida2:=0;
                        sal:=true;
                       end;
                       if letra='t' then
                    begin
                        vida1:=0;
                        vida2:=0;
                        sal:=false;
                        textcolor(15);
                        clrscr;
                        writeln('reiniciando');
                        delay(2000);
                       end;

                  until letra<>'g';
                    clrscr;

  end;
{------------------------------------------------------------------------------}
PROCEDURE COLOCARBARCO (var mapabarco,mapaataque:mapa;nbarremina,ndestructo,nfragata,ncrucero,modjuego:byte;person:boolean);
var
tipobarco,j:integer;
direccion:boolean;//true horizontal false vertical
begin
direccion:=false;
for j:=1 to nbarremina do //barreminas
begin
	tipobarco:=1;
	Cursorbarco (mapabarco,mapaataque,limitex1,limitey,tipobarco,modjuego,direccion,person);
end;
for j:=1 to nfragata do //fragata
begin
	tipobarco:=2;
	Cursorbarco (mapabarco,mapaataque,limitex1,limitey,tipobarco,modjuego,direccion,person);
end;
for j:=1 to ncrucero do //crucero
begin
	tipobarco:=3;
	Cursorbarco (mapabarco,mapaataque,limitex1,limitey,tipobarco,modjuego,direccion,person);
end;
for j:=1 to ndestructo do //destructor
begin
	tipobarco:=4;
	Cursorbarco (mapabarco,mapaataque,limitex1,limitey,tipobarco,modjuego,direccion,person);
end;


end;
{------------------------------------------------------------------------------}
procedure menu (var modojuego,nbarremina,nfragata,ncrucero,ndestructo:byte;var mapata,mapaba,mapata2,mapaba2:mapa;var vidas1,vidas2:byte;var condicional:boolean);
var
   rutajuego:string;
   tipojuego:partida;
   cargarp:byte;
begin
     repeat
     Writeln('Como desea jugar?[1/3]');
     writeln('1 jugador vs jugador');
     writeln('2 jugador vs computadora');
     writeln('3 computadora vs computadora');
     readln(modojuego);
     clrscr;
     until (modojuego>=1) and  (modojuego<=3);
     if modojuego=1 then
     begin
          rutajuego:=ruta;
          repeat
          writeln('¿Desea cargar una nueva partida?');
          writeln('[1] Nueva Partida');
          writeln('[2] Cargar Partida');
          readln(cargarp);
          clrscr;
          until (cargarp=1)or(cargarp=2);
     end;
     if modojuego=2 then
     begin
          rutajuego:=rutacpu;
          repeat
          writeln('¿Desea cargar una nueva partida?');
          writeln('[1] Nueva Partida');
          writeln('[2] Cargar Partida');
          readln(cargarp);
          clrscr;
          until (cargarp=1)or(cargarp=2);
     end;
     if modojuego=3 then
     begin
          cargarp:=1;
     end;
         if cargarp=1 then
         begin
              condicional:=false;
              //#############################determinado los barcos###########
              repeat
                    writeln('introduzca el numero de barreminas max 4');
                    readln(nbarremina);
              until (nbarremina<=4) and (nbarremina>=0);
              repeat
                    writeln('introduzca el numero de fragatas max 4');
                    readln(nfragata);
              until (nfragata<=4) and (nfragata>=0);
              repeat
                    writeln('introduzca el numero de cruceros max 2');
                    readln(ncrucero);
              until (ncrucero<=2) and (ncrucero>=0);
              repeat
                    writeln('introduzca el numero de destructor max 1');
                    readln(ndestructo);
              until (ndestructo<=1) and (ndestructo>=0);
              vidas1:=(nbarremina+nfragata+ncrucero+ndestructo);
              vidas2:=(nbarremina+nfragata+ncrucero+ndestructo);
         end
         else
         begin
              Traerpartida (tipojuego,rutajuego);
              cargarpartida (tipojuego,mapaba,mapata,mapaba2,mapata2,vidas1,vidas2);
              condicional:=true;
         end;

end;
{------------------------------------------------------------------------------}
Procedure JUVSJU (mapaba,mapata,mapaba2,mapata2:mapa;nbarremina,ndestructo,nfragata,ncrucero,vida1,vida2,modojueg:byte;condicional:boolean;var salid:boolean);
begin
     clrscr;
     if condicional=false then
     begin
          writeln('Turno de Jugador 1');
          colocarbarco(mapaba,mapata,nbarremina,ndestructo,nfragata,ncrucero,modojueg,true);//para que ambos jugadores pongan sus barcos
          readkey;
          clrscr;
          writeln('Turno de Jugador 2');
          colocarbarco(mapaba2,mapata2,nbarremina,ndestructo,nfragata,ncrucero,modojueg,true);
          readkey;
     end;
     while (vida1<>0)and(vida2<>0) do
     begin
           clrscr;
           Instruccion(true,mapaba,mapata,mapaba2,mapata2,vida1,vida2,ruta,salid);
           if (vida1<>0)and(vida2<>0) then
           begin
                jugador(mapaba,mapata);   //JUGADOR 1
                cursor(mapata,mapaba2,mapaba,limitex2,limitey,vida2);
                jugador(mapaba,mapata);
                readkey;
           end;
           if (vida1<>0)and(vida2<>0) then
           begin
                clrscr;
                Instruccion(false,mapaba,mapata,mapaba2,mapata2,vida1,vida2,ruta,salid);
                if (vida1<>0)and(vida2<>0) then
                begin
                     jugador(mapaba2,mapata2);//JUGADOR 2
                     cursor(mapata2,mapaba,mapaba2,limitex2,limitey,vida1);
                     jugador(mapaba2,mapata2);
                     readkey;
                end;
           end;
     end;
      if (vida1=vida2) and (salid=true) then
     begin
     gotoxy(22,22);
     writeln('                                         ');
     gotoxy(25,22);
     textcolor(14);
     writeln('Es empate gracias por jugar ');
     readkey;
     halt;
     end;
      if (vida1=0) and (salid=true) then
     begin
     gotoxy(22,21);writeln('                                                                ');
     gotoxy(22,23);writeln('                                                                ');
     gotoxy(22,22);writeln('                                                                ');
     gotoxy(25,22);
     textcolor(14);
     writeln('El ganador es el jugador 2');
     readkey;
     clrscr;readkey;
     clrscr;
     end;
      if (vida2=0)and (salid=true) then
     begin
     gotoxy(22,21);writeln('                                                                ');
     gotoxy(22,23);writeln('                                                                ');
     gotoxy(22,22);writeln('                                                                ');
     gotoxy(25,22);
     textcolor(14);
     writeln('El ganador es el jugador 1');
     readkey;
     clrscr;
     readkey;
     clrscr;
     end;


 end;
 {------------------------------------------------------------------------------}
 Procedure JUVSCO (var mapaba,mapata,mapaba2,mapata2:mapa;nbarremina,ndestructo,nfragata,ncrucero,vida1,vida2,modojueg:byte;condicional:boolean;var salid:boolean);
 begin
      if condicional=false then
      begin
           colocarbarco(mapaba,mapata,nbarremina,ndestructo,nfragata,ncrucero,modojueg,true);//para que el jugador y la computadora pongan sus barcos
           colocarbarco(mapaba2,mapata2,nbarremina,ndestructo,nfragata,ncrucero,modojueg,false);
      end;
      while (vida1<>0) and(vida2<>0) do
      begin
           Instruccion(true,mapaba,mapata,mapaba2,mapata2,vida1,vida2,rutacpu,salid);
           if (vida1<>0)and(vida2<>0) then
           begin
                jugador(mapaba,mapata);
                cursor(mapata,mapaba2,mapaba,limitex2,limitey,vida2);
                jugador(mapaba,mapata);
                readkey;
           end;
           if vida2<>0 then
           begin
                computadora(mapata2,mapaba,limitex2,limitey,vida1);
           end;
      end;
      if (vida1=0) and (salid=true) then
     begin
     gotoxy(22,21);writeln('                                                                ');
     gotoxy(22,23);writeln('                                                                ');
     gotoxy(22,22);writeln('                                                                ');
     gotoxy(25,22);
     textcolor(14);
     writeln('El ganador es computador');
     readkey;
     clrscr;
     end;
      if (vida2=0) and (salid=true) then
     begin
     gotoxy(22,21);writeln('                                                                ');
     gotoxy(22,23);writeln('                                                                ');
     gotoxy(22,22);writeln('                                                                ');
     gotoxy(25,22);
     textcolor(14);
     writeln('El ganador es el jugador 1');
     readkey;
     clrscr;
      readkey;
     end;
 end;
 {------------------------------------------------------------------------------}
Procedure COVSCO (var mapaba,mapata,mapaba2,mapata2:mapa;nbarremina,ndestructo,nfragata,ncrucero,vida1,vida2,modojueg:byte);
var
velocidad:integer;
opcion:byte;

begin
   colocarbarco(mapaba,mapata,nbarremina,ndestructo,nfragata,ncrucero,modojueg,false);//para que el jugador y la computadora pongan sus barcos
   colocarbarco(mapaba2,mapata,nbarremina,ndestructo,nfragata,ncrucero,modojueg,false);
   clrscr;
   repeat
         writeln('que tan rapido quiere que se vea?');
         writeln('[3]Rapido');
         writeln('[2]Medio');
         writeln('[1]Lento');
         readln(opcion);
         velocidad:=(500 div opcion)
   until (opcion>=1)and (opcion<=3);
   clrscr;
   repeat
   begin
   gotoxy(36,23);
writeln('Presione una tecla para salir                        '); //
        delay(velocidad);
        textcolor(14);
        computadora(mapata,mapaba2,limitex2,limitey,vida2);
        jugador(mapaba,mapata);

		if vida2<>0 then
		begin
  gotoxy(36,23);
writeln('Presione una tecla para salir                        '); //
              delay(velocidad);
              textcolor(14);
              computadora(mapata2,mapaba,limitex2,limitey,vida1);
              jugador(mapaba2,mapata2);

		end;
    end;
    if vida1=0 then
       begin
            gotoxy(22,21);writeln('                                                                ');
     gotoxy(22,23);writeln('                                                                ');
     gotoxy(22,22);writeln('                                                                ');
     gotoxy(25,22);
     textcolor(14);
     writeln('El ganador es el jugador 2');
     readkey;
     clrscr;
       end;
    if vida2=0 then
       begin
           gotoxy(22,21);writeln('                                                                ');
     gotoxy(22,23);writeln('                                                                ');
     gotoxy(22,22);writeln('                                                                ');
     gotoxy(25,22);
     textcolor(14);
     writeln('El ganador es el jugador 1');
     readkey;
     clrscr;
       end;
 until (vida1=0)or(vida2=0)or (keypressed)
 end;
{------------------------------------------------------------------------------}
PROCEDURE INTRO;
var 
x,y,i,j,color:byte;
begin
textcolor(7);
gotoxy (6,6);
begin
x:=25; y:=11; i:=50; j:=25; randomize; begin color:=random(15); end;
gotoxy (4,6);writeln('          /\       O/ FIRE!','                              /\      \O FIRE!');
gotoxy (4,7);writeln('         /ll\     /]       ','                             /ll\      [\      ');
gotoxy (4,8);writeln('        / ll \    /\       ','                            / ll \    /\       ');
gotoxy (4,9);writeln('       /  ll  \            ','                           /  ll  \            ');
gotoxy (4,10);writeln('      /___ll___\           ','                          /___ll___\           ');
gotoxy (4,11);writeln('  ________ll______p=>_     ','                    <=q_______ll________     ');
gotoxy (4,12);writeln(' [(O)==(O)==(O)==(O)=]    ','                     [(O)==(O)==(O)==(O)=]    ');
gotoxy (4,13);writeln(' \__________________/     ','                      \__________________/     ');

end;

textcolor(1);
gotoxy (4,14);writeln('^^^^^^^^^^^^^^^^^^^^^^^^^^^','^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ');

begin
color:=random(15);
textcolor(color);
gotoxy (15,17);writeln('         [][][][][][][][][][][][][][][][]');
gotoxy (15,18);writeln('               B A T T L E S H I P       ');
gotoxy (15,19);writeln('         [][][][][][][][][][][][][][][][]');
gotoxy (15,20);writeln('         PRESIONA UNA TECLA PARA CONTINUAR');
gotoxy (15,21);writeln('         [][][][][][][][][][][][][][][][]');
end;
for x:=25 to i do
   begin

       delay (50);
       textcolor(2);

       gotoxy(x+1,y);
       writeln ('O');
       textcolor(0);
       gotoxy(x,y);
       writeln ('O');
       gotoxy(x-5,y+1);
       textcolor(0);
       writeln('BOOOOM');
   end;

        if x=i then
        begin
        gotoxy(x-5,y+1);
        textcolor(4);
        writeln('BOOOOOM');

        end;
    
 for x:=i downto j do
   begin

       delay (50);
       textcolor(2);

       gotoxy(x-1,y);
        writeln ('O');
        textcolor(0);
        gotoxy(x,y);
        writeln ('O');
        gotoxy(x+1,y+1);
        textcolor(0);
        writeln('BOOM')
    end;
     if x=j then
        begin
        gotoxy (x+1,y+1);
        textcolor(4);
        writeln ('BOOM')
        end;

readkey;
clrscr;
END;
{------------------------------------------------------------------------------}
  Procedure PRINCIPAL;
   VAR
mapatac,mapabar,mapatac2,mapabar2:mapa;
modojuego,vidas1,vidas2,nbarreminas,ndestructor,nfragatas,ncruceros:byte;
condicion,salida:boolean;
BEGIN
INTRO;
textcolor(15);
repeat
 salida:=true;
     inimapa (mapabar,limitex1,limitey);
     inimapa (mapatac,limitex2,limitey);
     inimapa (mapabar2,limitex1,limitey);
     inimapa (mapatac2,limitex2,limitey);
     menu (modojuego,nbarreminas,nfragatas,ncruceros,ndestructor,mapatac,mapabar,mapatac2,mapabar2,vidas1,vidas2,condicion);

//mostrarvalores (mapatac);
//mostrarvalores (mapabar);
clrscr;
if modojuego=1 then //JUGADOR VS JUGADOR
begin
readkey;
juvsju (mapabar,mapatac,mapabar2,mapatac2,nbarreminas,ndestructor,nfragatas,ncruceros,vidas1,vidas2,modojuego,condicion,salida);
end;
if modojuego=2 then//JUGADOR VS COMPUTADOR
begin 
juvsco(mapabar,mapatac,mapabar2,mapatac2,nbarreminas,ndestructor,nfragatas,ncruceros,vidas1,vidas2,modojuego,condicion,salida);
end;

if modojuego=3 then//COMPUTADOR VS COMPUTADOR
begin 
covsco(mapabar,mapatac,mapabar2,mapatac2,nbarreminas,ndestructor,nfragatas,ncruceros,vidas1,vidas2,modojuego);

end;
 readkey;
until salida=true;
 end;
 {------------------------------------------------------------------------------}
//######################################################################################
BEGIN
PRINCIPAL;
END.
