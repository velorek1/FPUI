Uses vidutil,video,aedcho2,sysutils,winvideo;
{globals}
var win1,win2,win3,win4: tmWin;

Procedure screen;
var i:integer;
begin
        fondo2(1,9,chr(179));
  for i:=1 to screenwidth do
   esc(i,1,chr(32),7,7,false);
   esc(3,1,'Ascii Table for Linux - Coded by Velorek -',7,0,true);
   esc(3,screenheight,'Press ESC twice or Q once to exit',7,0,true);
end;

procedure wink;
begin
  sleep(200);
 opwindow(win1,3,4,71,14,0);
  sleep(200);
 opwindow(win2,2,3,70,13,7);
  sleep(200);
 lsquare(2,3,70,13,7,0,true);
  sleep(200);
end;

procedure asciitable;
var i,j,x:integer;
asc : tmNodo;
data : string;
begin
  SetCursorType(crHidden);
  Cmenu(Asc,7,0,3,15);
  j:=4;
  x:=4;
  for i:=1 to 255 do begin
             Add_item(asc,chr(i),x,j);
             if j<11 then
               j:=j+1
             else begin
               j:=4;
               x:=x+2;
             end;
  end;
  firsttime:=true;
  repeat
  Start_table(asc,data,8,false);
  if win4 <> nil  then closewin(win4);
  if win3 <> nil  then closewin(win3);
  opwindow(win3,screenwidth-29,19,screenwidth-8,21,0);
  opwindow(win4,screenwidth-30,18,screenwidth-9,20,2);
  lsquare(screenwidth-30,18,screenwidth-9,20,2,15,true);
  esc(screenwidth-30+1,19,'Char: '+ data + ' | Code: '+ inttostr(ord(data[1])),2,15,true);
  until (kglobal=#27) or (kglobal='q');
  sleep(200);
  if (win4 <> nil) and (kglobal<>#13) then closewin(win4);
  sleep(200);
  if (win3 <> nil) and (kglobal<>#13) then closewin(win3);
  sleep(200);
  lsquare(2,3,70,13,7,7,true);
  sleep(200);
  closewin(win2);
  sleep(200);
  closewin(win1);
  sleep(200);

end;
procedure credits;
begin
   writeln(chr(27)+'[2J'); //clear screen
   Writeln('Coded by Velorek 2016 - AED -');
end;
begin
      Initvideo;
      screen;
      wink;
      asciitable;
      Donevideo;
      credits;
end.
