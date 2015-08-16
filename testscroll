Uses gaedch2,gfxn,ptcgraph,ptccrt;
(*

*)

var st,sa:array[0..100] of string[125];
i,posy,a,b:integer;
aa:string;
men:tmnodo;
teclap:char;
lista:array[0..49] of string;
PROCEDURE Fill;
VAR
   X,Y: Integer;
   Ch : Integer;
BEGIN
     randomize;
     CH:=65;
     FOR Y:=0 TO 49 DO BEGIN
         FOR X:=1 TO 20 DO
             BEGIN
             lista[y] := lista[y]+chr(ch);
             END;
        CH:=CH+1;
     END;
END;

Begin
    Fullscreengraph:=false;
    a:=detect;
    initgraph(a,b,'');
    fondo(dgreyc);
    cleardevice;
    //showmouse;
    boton(20,40,getmaxx-20,getmaxy-60,1,$bdf7,true,0);
    boton(0,0,getmaxx,20,1,$ffff,false,0);
    esc(10,8,' - File Editor ::LinX:: Graph',$0000);
    posy:=60;
  //  setlength(lista,50);
    fill;
    vscroll(men,620,200,lista,20,dgreyc,whitec,whitec,0,true);
    firsttime:=false;

    for i:=1 to 3 do begin
      gtextbox(20,posy,getmaxx-20,st[i],'',$5471,$0000,$0000,121,true);
      esc(22,posy,st[i]+':'+men^.nchoice,$ffff);
      if teclap=#27 then break;
      posy:=posy+20;
    end;

    closegraph;
clrscr;
End.
