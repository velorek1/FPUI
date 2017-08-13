unit vidutil;
(*
Unit to add more functionality to the Video Unit.

Last Modified 22/8/2016.
Coded by Velorek.

*)

Interface

uses
  video,hex2bin;

Procedure TextOut(X,Y : Word;Const S : String);
Procedure Esc(X,Y : Word;Const S : String;bcolor,fcolor:integer;update:boolean);

Function VideoReadChar(x,y,z:integer):char;
{ Coordinates are 1 based, z=0 gets the character, z=1 gets the attribute.}
property screen[x,y,z:integer]:char read videoreadchar;

Implementation

Procedure TextOut(X,Y : Word;Const S : String);
{Write string to buffer without attributes in the specified positions}
Var
    P,I,M : Word;

begin
  P:=((X-1)+(Y-1)*ScreenWidth);
  M:=Length(S);
  If P+M>ScreenWidth*ScreenHeight then
  M:=ScreenWidth*ScreenHeight-P;
  For I:=1 to M do
  VideoBuf^[P+I-1]:=Ord(S[i])+($07 shl 8);
  updatescreen(true);
end;
Procedure Esc(X,Y : Word;Const S : String;bcolor,fcolor:integer;update:boolean);
{Write string to buffer with attributes}
{Update is conditional if true might be very slow to display items}

Var
    P,I,M : Word;
    fc,bc, bit2: string;
begin
  P:=((X-1)+(Y-1)*ScreenWidth);
  M:=Length(S);
  If P+M>ScreenWidth*ScreenHeight then
  M:=ScreenWidth*ScreenHeight-P;
  fc:=dec2hex(fcolor,false); {turn the bit value to hex}
  bc:=dec2hex(bcolor,false);
  bit2 := bc+fc;
  For I:=1 to M do
  VideoBuf^[P+I-1]:=Ord(S[i])+(hex2dec(bit2) shl 8);
  if update=true then  updatescreen(true);
end;


Function videoreadchar(x,y,z:integer):char;
{Read char and attributes from screen at the specified position}
{Coordinates are 1 based, z=0 gets the character, z=1 gets the attribute.}

Var
  P: Integer;
begin
  P:=((X-1)+(Y-1)*ScreenWidth);
  videoreadchar:=pchar(@VideoBuf^[P])[z];
End;

end.
