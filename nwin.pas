UNIT nWin;
{Modified to be used with unit Video}
INTERFACE
USES Video,hex2bin;
         TYPE
         tDual = record
                   ch : char;
                   attr : byte;
                 end;
         tpantalla = record
                  pos : array[1..25,1..80] of tDual;
         end;

             tmWin = ^tmWinData;
             tmWinData = RECORD
                          wx1,wy1 : byte;
                          wx2,wy2 : byte;
                          oldy:byte;
                          oldc:array[1..2] of byte; {old color}
                          WinCol : Byte;
                          WinID : String;
                          WinType : array[1..2] of char;
                          WinPant : tPantalla;
                         END;
PROCEDURE OpWindow(var winID:tmWin;x1,y1,x2,y2:byte;WcOL,wType:bYTE);
PROCEDURE CloseWin(var winID:tmWin);
IMPLEMENTATION
PROCEDURE OpWindow(var winID:tmWin;x1,y1,x2,y2:byte;WcOL,wType:BYTE);
Var i,j:integer;
pantalla : tpantalla absolute $b800:$0000; {direcci¢n absoluta en memoria}
capt : tpantalla;
BEGIN
     New(winID);
     With WinId^ do Begin
          Oldy:=wherey;
          WinCol := wCol;
          wX1 := X1;
          wY1 := Y1;
          wX2 := X2;
          wY2 := Y2;
          WinPant := pantalla; {guardamos la pantalla entera}
     End;
     GOTOxy(x1,y1);
     FOR j:=y1 to y2 do
         for i:=x1 to x2 do
             begin
                  GOTOxy(i,j);
                  textcolor(WinID^.winCol);
                  write('Û');
             end;
END;
PROCEDURE CloseWin(var winID:tmWin);
Var i,j:byte;
ch_data:string;
BEGIN
    With WinId^ do Begin
   for j:=wy1 to wy2 do
         for i:=wx1 to wx2 do begin
              {get attributes;separate bytes for background and foreground colours}
              ch_data:=dec2hex(WinPant.pos[j,i].attr); {read byte 00 to 7F 127 dec}
              oldc[1]:=hex2dec(ch_data[1]);
              oldc[2]:=hex2dec(ch_data[2]); {Restores previous colour}
          end;
     for j:=wy1 to wy2 do
         for i:=wx1 to wx2 do begin
              {normvideo; }
              gotoxy(i,j); {invert this two}
              {get attributes;separate bytes for background and foreground colours}
              textbackground(oldc[1]);
              textcolor(oldc[2]); {Restores previous colour}
              write(WinPant.pos[j,i].ch); {Write previous char}
              {writeln(WinPant.pos[j,i].attr);}
              end;
    gotoxy(wherex,oldy);
    End;
    Dispose(winId);
END;
END.
