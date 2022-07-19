/*

Author: Sergi Caparr¢s Jurado
Correo: scaparros arroba proton.me
A¤o: 1998

Instrucciones

JUGADOR 1
Flecha Arriba : Mueve el jugador hacia arriba
Flecha Abajo : Mueve el jugador hacia abajo
Tecla / : Bola hacia arriba
Tecla * : Bola recta
Tecla - : Bola hacia abajo


JUGADOR 2
Tecla Q : Mueve el jugador hacia arriba
Tecla A : Mueve el jugador hacia abajo
Tecla R : Bola hacia arriba
Tecla T : Bola recta
Tecla V : Bola hacia abajo

La bola siempre est  en constante movimiento.
Los porteros son los £nicos jugadores que chutan la bola autom ticamente.
En este caso la trayectoria de la bola ser  recta.

El resto de los jugadores s¢lo chutar n la bola cuando est‚n tocando la bola
y adem s tengan presionado la tecla correspondiente para chutar la bola.
La direcci¢n de la bola (arriba, recto o abajo) depender  de la tecla
que se est‚ pulsando en ese momento.

*/





Program Futbolin;
GLOBAL
    madrid;  // Goles del Madrid
    barca;   // Goles del barca
    ident;   // Codigo indetificador del Process Pelota();
Begin
    load_fpg ("c:\prg\juegos\futbolin\futbol.fpg"); // Fichero donde est n los Graficos
    set_Mode (m320x200); // Inicializa el Modo de Video
    Presenta(); // Ejecuta la presentaci¢n y esta llama a los dem s procesos
end;
Process Presenta();
private
xx,yy,color;
Begin
    set_fps(200,4);
    Put_screen (0,7);
    yy=171;
    Repeat
        xx=174;
        repeat
            color=get_pixel
            (xx,yy);
            if (color>0) color= color + rand (20,255);end;
            Put_pixel (xx,yy,color);
            if (key(_esc)) xx=285;end;
            frame;
            xx=xx+1;
        Until (xx>284);
        yy=yy+1;
        if (key(_esc)) yy=181;end;
    Until (yy>180);
    Put_Screen (0,1);
    Write_int (0,300,5,4,offset madrid);
    Write_int (0,20,5,4,offset barca);
    set_fps(18,0);
    mune_barca (32,100,rand (2,3),120,80,1); // Portero barca
    mune_barca (130,100,rand (8,9),133,67,2); // defensa barca
    mune_barca (70,100,rand (8,9),133,67,2); // media barca
    mune_barca (220,100,rand (12,13),106,93,2); // delatera barca
    mune_madrid(288,100,rand (4,5),120,80,1); // Portero MAdrid
    mune_madrid(190,100,rand (10,11),133,67,2); // defensa MAdrid
    mune_madrid(250,100,rand (10,11),133,67,2); // media Madrid
    mune_madrid(100,100,rand (14,15),106,93,2); // delatera MAdrid
    ident=pelota();
end;
Process mune_barca(x,y,graph,max_y,min_y,tipo); //tipo=1 portero, tipo=0 jugador
Begin
    loop
        frame;
        if (key(_up) and (y > min_y)) y=y-3;end;
        if (key(_down) and (y < max_y)) y=y+3;end;
        if (collision (TYPE pelota))
            if (key(_c_backslash)) ident.angle=45000;
                else if (key(_c_minus)) ident.angle=315000;
                else if (key(_c_asterisk) or (tipo==1)) ident.angle=0;end;
                end;
            end;
        end;
    end;
end;
Process mune_madrid(x,y,graph,max_y,min_y,tipo); //tipo=1 portero, tipo=0 jugador
Begin
    loop
        frame;
        if (key(_q) and (y > min_y)) y=y-3;end;
        if (key(_a) and (y < max_y)) y=y+3;end;
        if (collision (TYPE pelota))
            if (key(_r)) ident.angle=135000;
                else if (key(_y)) ident.angle=225000;
                else if (key(_t) or (tipo==1)) ident.angle=180000;end;
                end;
            end;
        end;
    end;
end;
Process Pelota();
private
    angulo;
Begin
    graph=6;
    x=160;
    y=100;
    Timer[1]=0;
    repeat
        frame;
    until (timer[1]>100);
    loop
        advance (9);
        //if (angulo==0) angle=0; end;// derecha;
        //if (angulo==1) angle=45000; end;//arriba-derecha
        //if (angulo==2) angle=135000;end;//arriba-izquierda
        //if (angulo==3) angle=180000;end; //Izq
        //if (angulo==4) angle=225000;end; //abajo-izq
        //if (angulo==5) angle=315000;end; //abajo-dere
        if (x>300)
            if (angle==0) angle=180000;end;
            if (angle==45000) angle=135000;end;
            if (angle==315000) angle=225000;end;
        end;
        if (x<20)
            if (angle==180000) angle=0;end;
            if (angle==135000) angle=45000;end;
            if (angle==225000) angle=315000;end;
        end;
        if (y<20)
            if (angle==45000) angle=315000;end;
            if (angle==135000) angle=225000;end;
        end;
        if (y>180)
            if (angle==225000) angle=135000;end;
            if (angle==315000) angle=45000;end;
        end;
        if ((x<28) and (y<120) and (y>80))
            madrid=madrid+1;
            gol(2);
        end;
        if ((x>292) and (y<120) and (y>80))
            barca=barca+1;
            gol(1);
        end;
        frame;
     end;
end;
Process gol(equipo); // equipo=1 = barca, equipo=2 =MAdrid;
Begin
    signal (ident,s_kill);
    Timer=0;
    repeat
        frame;
    until (timer>100);
    ident=pelota();
    if (equipo==1) ident.angle=0;
    else ident.angle=180000;
    end;
end;
