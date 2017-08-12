(*
Unit WinVideo - to be used with unit for screen management Video;

This unit creates an area to be displayed as a window an assigns it a dynamic variable.
3:x1/y1[-----------] 10:x2/y1
       [-----------]   It resizes an array of with the size of the area in question.
       [-----------]   Note that: size = [(x2-x1) +1] [(y2-y1) +1] = [(10-3) + 1] * [(10-4) + 1]
       [-----------]   To calculate size we shoudld add an extra unit as this is added when drawn on screen.
4:x1/y2              10:x2/y2

Attr bits are added with HEX2Bin library to make it more readable.
Coded By Velorek.
Last Modified: 22/08/2016.
*)

Unit winvideo;
INTERFACE
Uses Video,vidutil,sysutils,hex2bin2;
        TYPE
         tDual = record
                   ch : char;
                   attr : char;   {Each cell has a char and an attr with 2 bits}
                 end;
         tmWin = ^tmWinData;
         tmWinData = RECORD
                       wx1,wy1 : integer; {Save old coordinates}
                       wx2,wy2 : integer;
                       size: longint;   {Save size of buffer}
                       WinPant : array of tdual; {Array to be resized}
                     end;

PROCEDURE OpWindow(var winID:tmWin;x1,y1,x2,y2:byte;WcOL:integer);
PROCEDURE CloseWin(var winID:tmWin);
IMPLEMENTATION
PROCEDURE OpWindow(var winID:tmWin;x1,y1,x2,y2:byte;WcOL:integer);
Var i,j,k:integer;
newlen:integer;

BEGIN
      new(winId);
      newlen:=((x2-x1) + 1 ) * ((y2-y1) + 1);
      setlength(WinId^.WinPant,newlen); {Dynamic resize of array with new size}

      {Save previous area in memory}

      with WinId^ do begin
        size:=newlen;
        wx1:=x1;
        wx2:=x2;
        wy1:=y1;
        wy2:=y2;
        k:=0;
          for j:=y1 to y2 do begin
             for i:=x1 to x2 do begin
                   WinPant[k].ch := videoreadchar(i,j,0);
                   WinPant[k].attr := videoreadchar(i,j,1);
                   if k<newlen-1 then k:=k+1;
             end;
          end;
       end;

     {Draw window}
      for j:=y1 to y2 do
        for i:=x1 to x2 do
          esc(i,j,' ',wcol,wcol,false);

        updatescreen(true);

END;
PROCEDURE CloseWin(var winID:tmWin);
{Retrieve previous area and draw it to screen}
Var i,j,k:integer;
bit1,bit2,bitnum:integer;
temp:string;
BEGIN
        with winId^ do begin
        k:=0;
          for j:=wy1 to wy2 do
            for i:=wx1 to wx2 do begin
                bitnum:=ord(winpant[k].attr);
                temp:=dec2hex(bitnum,false);
                bit1:=hex2dec(temp[1]);
                bit2:=hex2dec(temp[2]);
                esc(i,j,Winpant[k].ch,bit1,bit2,false);
                if k<size-1 then k:=k+1;
            end;
        end;
  updatescreen(true);
END;

End.
