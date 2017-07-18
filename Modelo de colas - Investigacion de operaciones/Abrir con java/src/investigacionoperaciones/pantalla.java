/*REPÚBLICA DE VENEZUELA UNIVERSIDAD CATÓLICA “ANDRÉS BELLO”
ESCUELA DE INFORMÁTICA
8VO SEMETRE
INVESTIGACION DE OPERACIONES
PROFESORA: LUZ MEDINA
CIUDAD GUAYANA 
8 DE ENERO 2017

AUTORES
ADOLFO NEGRIN 21249293
PAULO PULEO   24701286

*/
package investigacionoperaciones;

import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JPanel;
import javax.swing.SwingConstants;
import javax.swing.BorderFactory;
import javax.swing.border.Border;
import java.awt.Color;
import java.awt.Rectangle; 
import java.io.FileOutputStream;
import java.io.PrintStream;

import java.text.DecimalFormat;
import java.util.Random;
import java.util.Scanner;
import javax.swing.JFrame;

/**
 *
 * @author AdolfoManuel
 */

public class pantalla extends javax.swing.JFrame {
/*int intd=2;
int Nen=1;
int Nes=1;
*/
/*
float h=0;//Costo de Inventario
float K=0;//Costo de Ordenar
float se=0;//Escazes con espera
float s=0;// Escazes sin espera
int   inventario=0;//Inventario Iinicial
float q=0;//Pedido Optimo
float PR=0;//Punto de reorden*/


    //----- Declaracion de variables -----------------------------------------------
        Scanner entrada = new Scanner(System.in); //lee entradas
        Random  rnd = new Random(); //genera un numero aleatorio
        static String[] wax = new String[21];
        static String [][] demandaZ =new String [40][3];
        static String [][] TentregaZ =new String [40][3];
        static String [][] TesperaZ =new String [40][3];
        static String[] auxivar =new String[5];
        static int Ne,Nen,Nes,intd,mayor,aux,auxiliar;
        int i,j,Ientrega=0,Iespera=0,CostoInventario,Nentregas,Nesperas,inventario,Nentrega=0,Nespera=0,pedidohecho=0,DiasEntrega=0,DiasEspera=0;
        float qactual,PRactual,K,Costofaltante=0,AleatorioEs,AleatorioEn,h=0, s=0, se=0,demandadia=0, faltante=0,invF; 
//------ Fin Declaracion de variables ------------------------------------------
float [][] demanda =new float [intd][3];
float [][] Tentrega =new float [Nen][3];
float [][] Tespera =new float [Nes][3];
float [] q = new float[intd];
float [] PR = new float[intd];


 JPanel jpanel = (JPanel) this.getContentPane();
 
 JLabel[] label = new JLabel[mayor]; //Declaración del array de etiquetas
 JTextField[][] text = new JTextField[mayor][6]; //Declaración del array de cajas de texto
 JLabel[] titulo = new JLabel[15];
 JTextField[] variables = new JTextField[8];
 Border border = BorderFactory.createLineBorder(Color.black, 1); 
    /**
     * Creates new form pantalla
     */
    public pantalla() {    
        initComponents();
        

        this.setExtendedState(JFrame.MAXIMIZED_BOTH);
        
        boton.setBounds(new Rectangle(1000, (11)*40, 100, 30));
        jpanel.setLayout(null);
        jpanel.setBackground(Color.lightGray);

titulo[1] = new JLabel();
        titulo[1].setBounds(new Rectangle(100, (1)*40, 100, 25));
        titulo[1].setText("Demanda diaria ");
        titulo[1].setBorder(border);
        titulo[1].setHorizontalAlignment(SwingConstants.CENTER);
titulo[2] = new JLabel();
        titulo[2].setBounds(new Rectangle(215, (1)*40, 125, 25));
        titulo[2].setText("Probabilidad");
        titulo[2].setBorder(border);
        titulo[2].setHorizontalAlignment(SwingConstants.CENTER);
titulo[3] = new JLabel();
        titulo[3].setBounds(new Rectangle(355, (1)*40, 125, 25));
        titulo[3].setText("Tiempo de Entrega");
        titulo[3].setBorder(border);
        titulo[3].setHorizontalAlignment(SwingConstants.CENTER);
titulo[4] = new JLabel();
        titulo[4].setBounds(new Rectangle(500, (1)*40, 125, 25));
        titulo[4].setText("Probabilidad");
        titulo[4].setBorder(border);
        titulo[4].setHorizontalAlignment(SwingConstants.CENTER);
titulo[5] = new JLabel();
        titulo[5].setBounds(new Rectangle(640, (1)*40, 150, 25));
        titulo[5].setText("Tiempo Espera Cliente");
        titulo[5].setBorder(border);
        titulo[5].setHorizontalAlignment(SwingConstants.CENTER);
titulo[6] = new JLabel();
        titulo[6].setBounds(new Rectangle(800, (1)*40, 125, 25));
        titulo[6].setText("Probabilidad");
        titulo[6].setBorder(border);
        titulo[6].setHorizontalAlignment(SwingConstants.CENTER);        
titulo[7] = new JLabel();
        titulo[7].setBounds(new Rectangle(945, (3)*40, 125, 25));
        titulo[7].setText("Costo de Inventario");
        titulo[7].setBorder(border);
        titulo[7].setHorizontalAlignment(SwingConstants.CENTER);
titulo[8] = new JLabel();
        titulo[8].setBounds(new Rectangle(945, (4)*40, 125, 25));
        titulo[8].setText("Costo de Ordenar");
        titulo[8].setBorder(border);
        titulo[8].setHorizontalAlignment(SwingConstants.CENTER); 
titulo[9] = new JLabel();
        titulo[9].setBounds(new Rectangle(945, (5)*40, 125, 25));
        titulo[9].setText("Escasez con espera");
        titulo[9].setBorder(border);
        titulo[9].setHorizontalAlignment(SwingConstants.CENTER); 
titulo[10] = new JLabel();
        titulo[10].setBounds(new Rectangle(945, (6)*40, 125, 25));
        titulo[10].setText("Escasez sin espera");
        titulo[10].setBorder(border);
        titulo[10].setHorizontalAlignment(SwingConstants.CENTER); 
titulo[11] = new JLabel();
        titulo[11].setBounds(new Rectangle(945, (7)*40, 125, 25));
        titulo[11].setText("Inventario Inicial");
        titulo[11].setBorder(border);
        titulo[11].setHorizontalAlignment(SwingConstants.CENTER); 

        
for(i=0;i<=4;i++){
variables[i] = new JTextField();
variables[i].setBounds(new Rectangle(1100, (i+3)*40, 60, 25));
variables[i].setText(auxivar[i]);
jpanel.add(variables[i], null);
}

for(i=1;i<=11;i++)        
jpanel.add(titulo[i], null);

 for(i = 0; i < mayor; i++) {
 label[i] = new JLabel(); //Llenamos el array de etiquetas    
 label[i].setBounds(new Rectangle(15, (i+2)*40, 60, 25));
 label[i].setText("Dato "+(i+1));
 label[i].setBorder(border);
 label[i].setHorizontalAlignment(SwingConstants.CENTER); 
 jpanel.add(label[i], null);
 }
 for(i = 0; i < intd; i++) {
 
 text[i][0] = new JTextField(); //Llemanos el array de cajas de texto
 text[i][1] = new JTextField(); //Llemanos el array de cajas de texto

text[i][0].setText(demandaZ[i][0]);
 text[i][1].setText(demandaZ[i][1]);


 text[i][0].setBounds(new Rectangle(115, (i+2)*40, 60, 25));
 text[i][1].setBounds(new Rectangle(240, (i+2)*40, 60, 25));
 
 //(7) ADICION DE LOS CONTROLES AL CONTENEDOR
 
 jpanel.add(text[i][0], null);
 jpanel.add(text[i][1], null);
 }
 for(i = 0; i < Nen; i++) {
 text[i][2] = new JTextField(); //Llemanos el array de cajas de texto
 text[i][3] = new JTextField(); //Llemanos el array de cajas de texto    
 
 text[i][2].setText(TentregaZ[i][0]);
 text[i][3].setText(TentregaZ[i][1]);
 
 text[i][2].setBounds(new Rectangle(385, (i+2)*40, 60, 25));
 text[i][3].setBounds(new Rectangle(530, (i+2)*40, 60, 25)); 
     
 jpanel.add(text[i][2], null);
 jpanel.add(text[i][3], null);
 }
 
 for(i = 0; i < Nes; i++) {
     
 text[i][4] = new JTextField(); //Llemanos el array de cajas de texto
 text[i][5] = new JTextField(); //Llemanos el array de cajas de texto
 
 text[i][4].setText(TesperaZ[i][0]);
 text[i][5].setText(TesperaZ[i][1]);
 
 text[i][4].setBounds(new Rectangle(680, (i+2)*40, 60, 25));
 text[i][5].setBounds(new Rectangle(825, (i+2)*40, 60, 25));    
  
  jpanel.add(text[i][4], null);
 jpanel.add(text[i][5], null);    
 }
 

 //(8) PROPIEDADES DEL FORMULARIO
 setSize(200,330);
 setTitle("Form1");
 setVisible(true); 
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        boton = new javax.swing.JButton();
        Advertencia = new javax.swing.JLabel();
        Mostrar = new javax.swing.JCheckBox();
        Archivotexto = new javax.swing.JCheckBox();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        boton.setText("Ingresar");
        boton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                botonActionPerformed(evt);
            }
        });

        Mostrar.setText("Mostrar la simulacion");
        Mostrar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                MostrarActionPerformed(evt);
            }
        });

        Archivotexto.setText("Archivo de texto");
        Archivotexto.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ArchivotextoActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(161, 161, 161)
                .addComponent(Advertencia, javax.swing.GroupLayout.PREFERRED_SIZE, 157, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 127, Short.MAX_VALUE)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(Archivotexto)
                    .addComponent(Mostrar)
                    .addComponent(boton))
                .addGap(44, 44, 44))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(174, Short.MAX_VALUE)
                .addComponent(Archivotexto)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(Mostrar)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(boton)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(Advertencia, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(11, 11, 11))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

        @SuppressWarnings("empty-statement")
    private void botonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_botonActionPerformed
   
  try {
            
                
        for (int i=0;i<intd;i++){
         demanda[i][0]=Float.parseFloat(text[i][0].getText());
         demanda[i][1]=Float.parseFloat(text[i][1].getText());
         demanda[i][2]=Float.parseFloat(text[i][1].getText());
        } 
        
        for (int i=0;i<Nen;i++){
         Tentrega[i][0]=Float.parseFloat(text[i][2].getText());
         Tentrega[i][1]=Float.parseFloat(text[i][3].getText());
         Tentrega[i][2]=Float.parseFloat(text[i][3].getText());
        }
        
        for (int i=0;i<Nes;i++){
         Tespera[i][0]=Float.parseFloat(text[i][4].getText());
         Tespera[i][1]=Float.parseFloat(text[i][5].getText());
         Tespera[i][2]=Float.parseFloat(text[i][5].getText());
        }  
        
     h=Float.parseFloat(variables[0].getText());//Costo de Inventario
     K=Float.parseFloat(variables[1].getText());//Costo de Ordenar
     se=Float.parseFloat(variables[2].getText());//Escazes con espera
     s=Float.parseFloat(variables[3].getText());// Escazes sin espera
     inventario=Integer.parseInt(variables[4].getText());//Inventario Iinicial

//----- Declaracion de variables 2----------------------------------------------
        int[] NaleatorioD =new int [Ne]; //Numeros aleatorios demanda
        int[] NaleatorioEn =new int [Nen]; //Numeros aleatorios demanda
        int[] NaleatorioEs =new int [Nes]; //Numeros aleatorios demanda
        float[][] Enespera = new float[Ne][2];//Arreglo de cliente en espera 
//------ Fin Declaracion de variables 2-----------------------------------------
//------ Llenar arreglos--------------------------------------------------------
        
        for (i=0;i<Ne;i++){//demanda
              NaleatorioD[i]=(int) (Math.random() * 100);
        }
        
        for (i=0;i<Nen;i++){//entregas
            NaleatorioEn[i]=(int) (Math.random() * 100);       
        }
        
        for (i=0;i<Nes;i++){//esperas
            NaleatorioEs[i]=(int) (Math.random() * 100);    
        }
           
        //Ordenando la tabla demanda
            for(i=0;i<intd;i++){
                int min=i;
                    for(int j=i+1;j<intd;j++){
                       if(demanda[j][0]<demanda[min][0]){
                       min=j;
                       }
                    }
                    if(i!=min){
                       float aux0 =demanda[i][0];
                       float aux1 =demanda[i][1];
                       float aux2 =demanda[i][2];
                       demanda[i][0]=demanda[min][0];
                       demanda[i][1]=demanda[min][1];
                       demanda[i][2]=demanda[min][2];
                       demanda[min][0] = aux0;
                       demanda[min][1] = aux1;
                       demanda[min][2] = aux2;
                    }
            }
        //fin Ordenando la tabla demanda
            //Ordenando la tabla entrega
            for(i=0;i<intd;i++){
                int min=i;
                    for(int j=i+1;j<Nen;j++){
                       if (Tentrega[j][0]<Tentrega[min][0]){
                       min=j;
                       }
                    }
                    if(i!=min){
                       float aux0 =Tentrega[i][0];
                       float aux1 =Tentrega[i][1];
                       float aux2 =Tentrega[i][2];
                       Tentrega[i][0]=Tentrega[min][0];
                       Tentrega[i][1]=Tentrega[min][1];
                       Tentrega[i][2]=Tentrega[min][2];
                       Tentrega[min][0] = aux0;
                       Tentrega[min][1] = aux1;
                       Tentrega[min][2] = aux2;
                    }
            }
        //fin Ordenando la tabla entrega
                //Ordenando la tabla espera
            for(i=0;i<intd;i++){
                int min=i;
                    for(int j=i+1;j<Nes;j++){
                       if (Tespera[j][0]<Tespera[min][0]){
                       min=j;
                       }
                    }
                    if(i!=min){
                       float aux0 =Tespera[i][0];
                       float aux1 =Tespera[i][1];
                       float aux2 =Tespera[i][2];
                       Tespera[i][0]=Tespera[min][0];
                       Tespera[i][1]=Tespera[min][1];
                       Tespera[i][2]=Tespera[min][2];
                       Tespera[min][0] = aux0;
                       Tespera[min][1] = aux1;
                       Tespera[min][2] = aux2;
                    }
            }
        //fin Ordenando la tabla espera
         
            FileOutputStream os = new FileOutputStream("Simulacion.txt");
            PrintStream ps = new PrintStream(os);
           
           
        //llenando las probabilidad aumentada de tabla demanda      
        for(i=0; i<intd; i=i+1)    
            for(j=0; j<i; j=i+1)
                demanda[i][2]+=demanda[i-1][2];
        
        //llenando las probabilidad aumentada de tabla tiempo entregas     
        for(i=0; i<Nen; i=i+1) 
            for(j=0; j<i; j=i+1)
                Tentrega[i][2]+=Tentrega[i-1][2];    
          
        //llenando las probabilidad aumentada de tabla tiempo esperas    
        for(i=0; i<Nes; i=i+1) 
            for(j=0; j<i; j=i+1)
                Tespera[i][2]+=Tespera[i-1][2];
        
        if((demanda[intd-1][2]!=100)|| Tentrega[Nen-1][2]!=100 || Tespera[Nes-1][2]!=100 ){
           if(auxiliar==0)
            System.out.print("\nError en la introduccion de datos por favor revise\n 1- Que no haya numeros negativos \n 2- Que la suma de las probabilidades en las distintas tablas sea 100%\n\n");
           else
            ps.print("\nError en la introduccion de datos por favor revise\n 1- Que no haya numeros negativos \n 2- Que la suma de las probabilidades en las distintas tablas sea 100%\n\n");

        }
        //Esta es la forma en que los numeros seran escritos al momento de imprimir decimales     
        DecimalFormat decimales = new DecimalFormat("0.0");
//------ Imprimir arreglo demanda-----------------------------------------------
        if(auxiliar==0)
            System.out.print("Al momento de los calculos se usan todos los decimales\nDemanda Diaria        \t");
        else
            ps.print("Al momento de los calculos se usan todos los decimales\nDemanda Diaria        \t");

        for(i=0;i<intd; i=i+1)
            if(auxiliar==0)
            System.out.print(demanda[i][0]+"\t");
            else
            ps.print(demanda[i][0]+"\t\t");

        if(auxiliar==0)
            System.out.print("\nProbabilidad          \t");
        else
            ps.print("\nProbabilidad          \t");
        
        if(auxiliar==0){
                for(i=0; i<intd; i=i+1)
                System.out.print((decimales.format(demanda[i][1]))+"%\t"); 
            System.out.print("\nProbabilidad acumulada\t");
        }
        else{
            for(i=0; i<intd; i=i+1)
            ps.print((decimales.format(demanda[i][1]))+"%\t"); 
            ps.print("\nProbabilidad acumulada\t");
        }
        
        if(auxiliar==0){
            for(i=0; i<intd; i=i+1)
            System.out.print((decimales.format(demanda[i][2]))+"%\t"); 
            System.out.print("\n\n"); 
        }
        else{
            for(i=0; i<intd; i=i+1)
            ps.print((decimales.format(demanda[i][2]))+"%\t"); 
            ps.print("\n\n"); 
        }
//------ Fin Imprimir arreglo demanda-------------------------------------------
//------ Imprimir arreglo Tespera-----------------------------------------------
        if(auxiliar==0)
            System.out.print("Tiempo de entrega    \t");
        else
            ps.print("Tiempo de entrega    \t");

        
        if(auxiliar==0){
            for(i=0;i<Nen; i=i+1)
                System.out.print(Tentrega[i][0]+"\t");
            System.out.print("\nProbabilidad          \t");
        }
        else {
            for(i=0;i<Nen; i=i+1)
                ps.print(Tentrega[i][0]+"\t\t");
            ps.print("\nProbabilidad          \t");
        }


        if(auxiliar==0){
            for(i=0; i<Nen; i=i+1)
                System.out.print((decimales.format(Tentrega[i][1]))+"%\t"); 
            System.out.print("\nProbabilidad acumulada\t");
        }else{
            for(i=0; i<Nen; i=i+1)
                ps.print((decimales.format(Tentrega[i][1]))+"%\t"); 
            ps.print("\nProbabilidad acumulada\t");
        }
        
        if(auxiliar==0){
            for(i=0; i<Nen; i=i+1)
                System.out.print((decimales.format(Tentrega[i][2]))+"%\t"); 
            System.out.print("\n\n"); 
        }else{
            for(i=0; i<Nen; i=i+1)
                ps.print((decimales.format(Tentrega[i][2]))+"%\t"); 
            ps.print("\n\n");
        }
//------ Fin Imprimir arreglo demando-------------------------------------------     
//------ Imprimir arreglo Tiempo espera-----------------------------------------
        if(auxiliar==0)
            System.out.print("Tiempo de espera     \t");
        else
            ps.print("Tiempo de espera     \t");

        
            if(auxiliar==0){
                for(i=0;i<Nes; i=i+1)
                    System.out.print(Tespera[i][0]+"\t");
                System.out.print("\nProbabilidad          \t");
            }else{
                for(i=0;i<Nes; i=i+1)
                    ps.print(Tespera[i][0]+"\t\t");
                ps.print("\nProbabilidad          \t");
            }
        
            if(auxiliar==0){
                for(i=0; i<Nes; i=i+1)
                    System.out.print((decimales.format(Tespera[i][1]))+"%\t"); 
                System.out.print("\nProbabilidad acumulada\t");
            }else{
                for(i=0; i<Nes; i=i+1)
                    ps.print((decimales.format(Tespera[i][1]))+"%\t"); 
                ps.print("\nProbabilidad acumulada\t");
            }
        
            if(auxiliar==0){
                for(i=0; i<Nes; i=i+1)
                    System.out.print((decimales.format(Tespera[i][2]))+"%\t"); 
                System.out.print("\n\n"); //Estetica
            }else{
                for(i=0; i<Nes; i=i+1)
                    ps.print((decimales.format(Tespera[i][2]))+"%\t"); 
                ps.print("\n\n"); //Estetica
            }
//------ Fin Imprimir arreglo Tiempo Espera-------------------------------------

        for(i=0; i<intd; i++){
            q[i]=(float) Math.sqrt((2*K*demanda[i][0]*12*(h+s))/(h*s));
            
            float L=0,Le=0,t0;
            int n;
            t0=q[i]/(demanda[i][0]/365);
            L=(Tentrega[0][0]*Tentrega[Nen-1][0])/2;
            n=(int) (L/t0);
            Le=(L)-(n*t0);    
            PR[i]=Le*demanda[i][0];
        
               
            //fin calcular el punto de reorden
  
        }
          
        int ii,jj;
        if (auxiliar==0)
            System.out.print("\nQ=\t");
        else
            ps.print("\nQ=\t");   
        
        if (auxiliar==0){
            for(i=0; i<intd; i++)
                System.out.print(decimales.format(q[i])+"|\t\t");
            System.out.print("\nPR=\t");
        }
        else{
            for(i=0; i<intd; i++)
                ps.print(decimales.format(q[i])+"|\t\t");
            ps.print("\nPR=\t");
        }
       for(i=0; i<intd; i++)
            if (auxiliar==0)   
                System.out.print(decimales.format(PR[i])+"|\t\t");
            else
                ps.print(decimales.format(PR[i])+"|\t\t");

        float qoptimo=q[0],PRoptimo=PR[0],costototal=10000000;
        
    for(jj=0; jj<intd; jj++)
        for(ii=0; ii<intd; ii++){
            Nentrega=0;
            Costofaltante=0;
            inventario=Integer.parseInt(variables[4].getText());//Inventario Iinicial
            PRactual=PR[jj];
            qactual=q[ii];
         if (auxiliar==0)      
            System.out.print("\nPara Q="+decimales.format(qactual)+" y PR="+PRactual+"\n"); 
         else 
            ps.print("\nPara Q="+decimales.format(qactual)+" y PR="+PRactual+"\n"); 

        
         
          
      
 
        if(aux==1){
            if (auxiliar==0){   
            System.out.print("\n   \t|  \t|No.aleatorio\t|       |      \t|    \t|        \t|       \t|                  \t|         \t|                  \t|            \n");
            System.out.print("Dia\t|Inv.\t|    para    \t|Demanda|Inv.  \t|Inv.\t|Faltante\t|  No.  \t|No. aleatorio para\t|Tiempo de\t|No. aleatorio para\t|   Tiempo   \n");
            System.out.print("   \t|Inc.\t| demanda    \t|       |Final.\t|Prom\t|        \t| Orden \t|tiempo de entrega \t| entrega \t| tiempo de espera \t| de espera  \n");
            System.out.print("---------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
            }
            else{
                ps.print("\n   \t|  \t\t|No.aleatorio\t|       |      \t|    \t|        \t|       \t|                  \t|         \t|                  \t|            \n");
                ps.print("Dia\t|Inv.\t|    para    \t|Demanda|Inv.  \t|Inv.\t|Faltante\t|  No.  \t|No. aleatorio para\t|Tiempo de\t|No. aleatorio para\t|   Tiempo   \n");
                ps.print("   \t|Inc.\t| demanda    \t|       |Final.\t|Prom\t|        \t| Orden \t|tiempo de entrega \t| entrega \t| tiempo de espera \t| de espera  \n");
                ps.print("---------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
            }
        }
            for(i=0; i<Ne; i++){
            //    System.out.print("---"+i+"----");
                //calcula la demanda del dia a partir de los numeros aleatorios en el arreglo NaleatorioD[i]
                for(j=0;NaleatorioD[i]>demanda[j][2]; j=j+1);
                demandadia=demanda[j][0];
                invF=inventario-demandadia;
                AleatorioEn=0;
                
                if (invF <=PRactual && pedidohecho==0){ //si el inventario esta debajo o igual al punto de reorden
                    Nentrega++;
                    pedidohecho=1;//significa que el pedido viene en camino
                    for(Ientrega=0;NaleatorioEn[(Nentrega-1)%Nen]>Tentrega[Ientrega][2];Ientrega=Ientrega+1);
                    DiasEntrega=(int) Tentrega[Ientrega][0];//dias para entregar
                    AleatorioEn=NaleatorioEn[(Nentrega-1)%Nen];
                }
                faltante=0;
                if (demandadia>inventario)
                    faltante=demandadia-inventario;
                AleatorioEs=0;
                if (faltante>0){ //significa que hay un cliente en espera
                    for(j=0;Enespera[j][0]!=0;j++);//buscando en el primer espacio vacio que encuentre
                   // System.out.print("\n"+j+"\n");
                    Enespera[j][0]=faltante;
                    Nespera++;

                    for(Iespera=0;NaleatorioEs[(Nespera-1)%Nes]>Tespera[Iespera][2];Iespera=Iespera+1);
                    Enespera[j][1]= Tespera[Iespera][0];//dias para entregar
                    DiasEspera= (int) Tespera[Iespera][0];
                    if (DiasEspera==0){
                        Costofaltante+=faltante*s;
                    }
                    else
                         Costofaltante+=faltante*se;
                    AleatorioEs=NaleatorioEs[(Nespera-1)%Nes];
                }
                if (invF<0)//en caso de que el invatario es negativo se convierte en 0
                    invF=0;      
                if (Iespera==0){
                    Iespera=1;
                }
                if (Ientrega==0){
                    Ientrega=1;
                }
                if (inventario<0)//en caso de que el inventario es ne se convierte en 0
                   inventario=0;
                if(aux==1){
                    if(auxiliar==0){
                    System.out.print((i+1)+"\t|"+inventario+"\t|"+NaleatorioD[i]+"\t\t|"+demandadia+"\t|"+invF+"\t|"+(inventario+invF)/2+"\t|"+faltante+"\t\t|"+Nentrega+"\t\t|"+AleatorioEn+"\t\t\t|"+DiasEntrega+"\t\t|"+AleatorioEs+"\t\t\t|"+DiasEspera+"\n");
                    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
                    }
                    else{
                    ps.print((i+1)+"\t|"+inventario+"\t\t|"+NaleatorioD[i]+"\t\t\t\t|"+demandadia+"\t|"+invF+"\t|"+(inventario+invF)/2+"\t|"+faltante+"\t\t|"+Nentrega+"\t\t\t|"+AleatorioEn+"\t\t\t\t|"+DiasEntrega+"\t\t\t|"+AleatorioEs+"\t\t\t\t|"+DiasEspera+"\n");
                    ps.print("---------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
                    }
                }
                CostoInventario+=(inventario+invF)/2;
                inventario-=demandadia; 
                // faltante=0;
                if (inventario<0)//en caso de que el inventario es ne se convierte en 0
                    inventario=0;

                if (DiasEntrega==0 && pedidohecho==1){
                    inventario+=qactual;
                    pedidohecho=0;
                }
                if (pedidohecho==1 && DiasEntrega!=0)//significa que el pedido esta en camino pero aun no ha llegado
                    DiasEntrega--;

                for(j=0;j<Ne;j++){
                    if (Enespera[j][1]!=0){ //verifica que si hay pedido
                        Enespera[j][1]--;//le resta 1 a los dias que tiene que esperar
                        if (Enespera[j][1]==0){//si los dias es igual a 0;
                            inventario-= Enespera[j][0];
                            Enespera[j][0]=Enespera[j][1]=0;//vacia el arreglo
                        }
                    }
                    else
                    Enespera[j][0]=Enespera[j][1]=0;//vacia el arreglo
                }
            }
        
//------ Fin Imprimir Tabla Final-----------------------------------------------
    if(auxiliar==0){
        System.out.print("\n");//estetica
        System.out.println("Costo Faltante \t\t"+ Costofaltante);
        System.out.println("Costo Orden \t\t"+ (Nentrega*K));
        System.out.println("Costo inventario \t"+ CostoInventario*(h/365));
        System.out.println("Costo total \t\t"+ (CostoInventario*(h/365)+(Nentrega*K)+Costofaltante));
        System.out.print("\n\n");//estetica
    }else{
        ps.print("\n");//estetica
        ps.println("Costo Faltante \t\t"+ Costofaltante);
        ps.println("Costo Orden \t\t"+ (Nentrega*K));
        ps.println("Costo inventario \t"+ CostoInventario*(h/365));
        ps.println("Costo total \t\t"+ (CostoInventario*(h/365)+(Nentrega*K)+Costofaltante));
        ps.print("\n\n");//estetica
    }
        
        if (costototal>(CostoInventario*(h/365)+(Nentrega*K)+Costofaltante)){
            qoptimo=(int)qactual;
            PRoptimo=PRactual;
            costototal=(CostoInventario*(h/365)+(Nentrega*K)+Costofaltante);
           // System.out.print("\nCostoInventario*(h/365)= "+CostoInventario*(h/365)+"\nNentrega*K= "+Nentrega*K+"\nCostofaltante= "+Costofaltante);
        }
        
    }
    if(auxiliar==0)
        System.out.println("\n El Pedido optimo es "+qoptimo+"\n con un punto de reorden igual a "+PRoptimo+"\ncon un costo total de "+decimales.format(costototal));
    else
        ps.print("\n El Pedido optimo es "+qoptimo+"\n con un punto de reorden igual a "+PRoptimo+"\ncon un costo total de "+decimales.format(costototal));

    }
        catch (Exception e) {
            Advertencia.setText("No pueden Haber Campos vacios");
        }  
    }//GEN-LAST:event_botonActionPerformed

    private void MostrarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MostrarActionPerformed
        if (Mostrar.isSelected()) 
            aux=1;
        else
            aux=0;// TODO add your handling code here:
    }//GEN-LAST:event_MostrarActionPerformed

    private void ArchivotextoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ArchivotextoActionPerformed
        if (Archivotexto.isSelected()) 
            auxiliar=1;
        else
            auxiliar=0;// TODO add your handling code here:
    }//GEN-LAST:event_ArchivotextoActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(pantalla.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(pantalla.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(pantalla.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(pantalla.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

                    if(intd > Nen)
                        if(intd>Nes) 
                            mayor=intd;
                        else
                            mayor=Nes;
                    else if(Nen>Nes)
                        mayor=Nen;
                        else
                            mayor=Nes;
                //
        
        java.awt.EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
                
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel Advertencia;
    private javax.swing.JCheckBox Archivotexto;
    private javax.swing.JCheckBox Mostrar;
    private javax.swing.JButton boton;
    // End of variables declaration//GEN-END:variables
}
