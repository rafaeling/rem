# rem
Lexical analyzer generator which use minig regulars expressions to extract products opinion in pc componentes.
[Spanish Version](memoria.pdf)
# script
#### Con el comando wget descargamos la web en la que aparece el producto, si queremos
aplicarlo sobre otro producto debemos cambiar la url por la del producto.
wget -i http://www.pccomponentes.com/leotec_l_pad_meteor_dcx_9__8gb.html >> datos
#### Con la ayuda del comando cat volcamos todas las opiniones de lo usuario (que se encuentra
en los archivos pagina_opiniones_usuario.php\?idc\=*) en el archivo solucion.txt
cat pagina_opiniones_usuario.php\?idc\=* >> solucion.txt
#### Los siguientes comandos hacen ejecutable el programa en cualquier entorno Linux,
independientemente del sistema y lugar en el que situemos el programa.
DIRECTORIOANTES=$(pwd)
cd ..
DIRECTORIODESPUES=$(pwd)
cp $DIRECTORIOANTES/solucion.txt $DIRECTORIODESPUES
####Compilación de los dos programas lex que analizan los archivos correspondientes
lex practica3.l
g++ lex.yy.c -o prog -lfl./prog datos/solucion.txt >> final.txt
lex practica3a.l
g++ lex.yy.c -o prog1 -lfl
./prog1 final.txt >> final2.txt
#### Limpieza de los datos que no sirven
rm -r -f datos
rm prog
rm prog1
rm solucion.txt
rm final.txt
rm lex.yy.c
