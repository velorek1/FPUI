unit videord;
// emulates three param screen[] array for dialedit.
// can't be in dialedit since procedural properties aren't allowed in $mode tp
interface

uses Video;


function videoreadchar(x,y,z:integer):char;
procedure clrscr;
// Coordinates are 1 based, z=0 gets the character, z=1 gets the attribute.
property screen[x,y,z:integer]:char read videoreadchar;


implementation
procedure clrscr;
begin
  initvideo;
  clearscreen;
end;

function videoreadchar(x,y,z:integer):char;

Var
  P: Integer;

begin
    initvideo;
    P:=((X-1)+(Y-1)*ScreenWidth);
      videoreadchar:=pchar(@VideoBuf^[P])[z];
      end;

end.


