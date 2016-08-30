Uses vidutil,video,crt,aedcho2;

Procedure screen;
begin
        fondo(9);
end.

procedure asciitable;
var i,j:integer;
asc : tmNodo;
data : string;
begin
  Cmenu(Asc,1,7,2,0);
  j:=2;
  for i:=0 to 255 do begin
             if j<12 do
               j:=j+1
             else
               j:=0;
             Additem(asc,chr(i),i+2,j);
  end;
  Start_table(asc,data,11,true);
end.
begin
      screen;
      asciitable;
end.