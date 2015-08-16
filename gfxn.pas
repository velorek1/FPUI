(*
-------------------------------------------
        A Freepascal Graphic Unit v1.0
        Coded by:Freyr
-------------------------------------------

 Fill styles: (tipo : fillstyles)

  0 EmptyFill
     Uses backgroundcolor.
  1 SolidFill
     Uses filling color
  2 LineFill
     Fills with horizontal lines.
  3 ltSlashFill
     Fills with lines from left-under to top-right.
  4 SlashFill
     Idem as previous, thick lines.
  5 BkSlashFill
     Fills with thick lines from left-Top to bottom-right.
  6 LtBkSlashFill
     Idem as previous, normal lines.
  7 HatchFill
     Fills with a hatch-like pattern.
  8 XHatchFill
     Fills with a hatch pattern, rotated 45 degrees.
  9 InterLeaveFill
     Does something.
  10 WideDotFill
     Fills with dots, wide spacing.
  11 CloseDotFill
     Fills with dots, narrow spacing.
  12 UserFill
     Fills with a user-defined pattern.

*)

Unit gfxn;
Interface

Uses ptcgraph,ptccrt; { equivalents to Borland Pascal units}

Const
{list of some basic 16bit colours}
        {d/l + colour + c }

        whitec = $ffff;
        blackc = $0000;
        dgreyc = $7bef;
        lgreyc = $bdf7; {light grey}
        lgreyc2 = $C618;
        dredc = $7800;
        lredc = $f800;
        dbluec = $000F;
        lbluec = $1f;
        lbluec2 = $54b; { blueish}
        dgreenc = $03E0;
        lgreenc = $7e0;
        dcyanc = $03EF;
        lcyanc = $7ff;
        dyellowc = $ffe0;
        lyellowc = $AFE5;
        orangec = $fbe0;
        brownc = $79e0;
        tilec = $5471; { similar to tile}
        pinkc = $f81f;
        purplec = $780F;
        olivec = $7BE0;


procedure Inicia(Fullscreen:boolean);
procedure Init2(a,b:integer;Fullscreen:boolean);
procedure Fin;
procedure Rectangl(x1,y1,x2,y2:integer;cborde,tipo,cfondo:word);
procedure gTextbox(x1,y2,x2:integer;var yo:string;caden:string;colfondo,colefore,collabel,tecl:word;actley:boolean);
procedure gNumbox(x1,y2,x2:integer;var yo:string;caden:string;colfondo,colefore,collabel,tecl:word;actley:boolean);
procedure Boton(xx1,yy1,xx2,yy2:integer;tipo:word;cfondo:word;t:boolean;tyh:integer);
Procedure Bcol(xx1,yy1,xx2,yy2:integer;tipo:word;cfondo:word;arri,abaj:word;t:boolean);
procedure Linex(tra1,ra1,tra2,ra2:integer);
procedure Fondo(color:word);
procedure Esc(x,y:integer;s:string;col:word);
procedure Escc(x1,y1,x2,y2:integer;s:string;col:word); {writes text and centers it in an area}
procedure Fuente(fu,dir:word;siz:word);
Implementation
procedure Init2(a,b:integer;Fullscreen:boolean);
{ Start graphics. Fullscreen boolean}
var
  gd,gm: integer;
begin
  Fullscreengraph:=Fullscreen;
  gd :=a; {preferred,1024x768x32}
  gm:=b;
  initgraph(gd, gm, '');
end;
procedure Inicia(Fullscreen:boolean);
{ Start graphics. Full res. Fullscreen boolean}
var
  gd,gm: integer;
begin
  Fullscreengraph:=Fullscreen;
  gd := detect; {preferred,1024x768x32}
  initgraph(gd, gm, '');
end;
Procedure Fin;
{close graph}
begin
  Closegraph;
end;
Procedure bcol(xx1,yy1,xx2,yy2:integer;tipo:word;cfondo:word;arri,abaj:word;t:boolean);
{ Draws a button with color
 There are 12 Fill styles}
Begin
  setfillstyle(tipo,cfondo);
  bar(xx1,yy1,xx2,yy2); {Draws a rectangle with the current colour and fillstyle}
  if t then begin
    { Button unpressed}
    setcolor(arri);   { upper corners}
    line(xx1,yy1,xx2,yy1);
    line(xx1,yy1,xx1,yy2);
    setcolor(abaj);  {lower corners}
    line(xx2,yy1,xx2,yy2);
    line(xx1,yy2,xx2,yy2);
  end;
  if t=false then begin
    {Button pressed}
    setcolor(abaj);  {upper corners}
    line(xx1,yy1,xx2,yy1);
    line(xx1,yy1,xx1,yy2);
    setcolor(arri); {lower corners}
    line(xx2,yy1,xx2,yy2);
    line(xx1,yy2,xx2,yy2);
  end;
end;
procedure boton(xx1,yy1,xx2,yy2:integer;tipo:word;cfondo:word;t:boolean;tyh:integer);
(* Draws a button at the specified coordinates
tipo:Filling style
t:boolean that controls whether the button is drawn pressed(false) or not
tyh:type of button
    0 or > 5: Simple button   t:=true/false
    1: Black line       ; t:=true
    2: Black line x2    ; t:=true
    3: White line x2    ; t:=true
    4: rectangle black/white or when button is pressed is better; t:=true/false;
*)
begin
  setfillstyle(tipo,cfondo); { select background colour and fillstyle}
  bar(xx1,yy1,xx2,yy2); { draw a rectangle with the above-mentioned pattern}

  if t then begin
    {unpressed button}
    setcolor(whitec);
    line(xx1,yy1,xx2,yy1);
    line(xx1,yy1,xx1,yy2);
    setcolor(blackc);
    line(xx2,yy1,xx2,yy2);
    line(xx1,yy2,xx2,yy2);
  end;
  if t=false then begin
    {pressed button}
    setcolor(blackc);
    line(xx1,yy1,xx2,yy1);
    line(xx1,yy1,xx1,yy2);
    setcolor(whitec);
    line(xx2,yy1,xx2,yy2);
    line(xx1,yy2,xx2,yy2);
 end;


  if tyh=1 then begin
    {   1: Black line       ; t:=true}
    setcolor(blackc);
    line(xx1-1,yy1-1,xx2,yy1-1);
    line(xx1-1,yy1-1,xx1-1,yy2);
    setcolor(blackc);
    line(xx2,yy1-1,xx2,yy2);
    line(xx1-1,yy2-1,xx2,yy2-1);
    setcolor(blackc);
  end;

  if tyh=2 then begin
   { 2: Black line x2    ; t:=true}
    setcolor(blackc);
    line(xx1-1,yy1-1,xx2+1,yy1-1);
    line(xx1-1,yy1-1,xx1-1,yy2);
    setcolor(blackc);
    line(xx2+1,yy1-1,xx2+1,yy2);
    line(xx1-1,yy2-1,xx2+1,yy2-1);
    setcolor(blackc);
    line(xx1-2,yy1-2,xx2+1,yy1-2);
    line(xx1-2,yy1-2,xx1-2,yy2);
    setcolor(blackc);
    line(xx2+1,yy1-2,xx2+1,yy2);
    line(xx1-2,yy2-2,xx2+1,yy2-2);
    setcolor(blackc);
  end;
  if tyh=3 then begin
   {3: White line x2    ; t:=true}
    setcolor(whitec);
    line(xx1+1,yy1+1,xx2,yy1+1);
    line(xx1+1,yy1+1,xx1+1,yy2);
    setcolor(blackc);
    line(xx2,yy1+1,xx2,yy2);
    line(xx1+1,yy2,xx2,yy2);
    setcolor(blackc);
    setcolor(blackc);
    line(xx1-1,yy1-1,xx2,yy1-1);
    line(xx1-1,yy1-1,xx1-1,yy2);
    setcolor(blackc);
    line(xx2,yy1-1,xx2,yy2);
    line(xx1-1,yy2-1,xx2,yy2-1);
    setcolor(blackc);
  end;

 If tyh=4 then begin
    {rectangle or when accentuated pressed button}
    setcolor(blackc);
    line(xx1-1,yy1-1,xx2,yy1-1);
    line(xx1-1,yy1-1,xx1-1,yy2);
    setcolor(whitec);
    line(xx2-1,yy1+1,xx2-1,yy2-1);
    line(xx1+1,yy2-1,xx2-1,yy2-1);
 end;

end;
procedure rectangl(x1,y1,x2,y2:integer;cborde,tipo,cfondo:word);
(*
Draws a rectangle in the given position
with cborde: border color
tipo:fill pattern
cfondo:background color.
*)
begin
  setfillstyle(tipo,cfondo);
  bar(x1,y1,x2,y2);
  setcolor(cborde);
  line(x1,y1,x2,y1);
  line(x1,y1,x1,y2);
  setcolor(cborde);
  line(x2,y1,x2,y2);
  line(x1,y2,x2,y2);
end;
procedure fondo(color:word);
{sets background color and cleans the screen}
begin
  setbkcolor(color);
  cleardevice;
end;
procedure esc(x,y:integer;s:string;col:word);
{writes a string in the specific coordinates}
begin
  setcolor(col);
  outtextxy(x,y,s);
end;

procedure escc(x1,y1,x2,y2:integer;s:string;col:word);
{Draws and centers a text in an area}
var
  pp,ty,XEXE,tt,yeye:integer;
  LON:INTEGER;
begin
  setcolor(col);
  YEYE:=Y2-Y1-5;
  tt:=y1 + YEYE DIV 2;
  {x}
  LON:=length(s);
  LON:=LON * 4 - 10 ;
  XEXE:=x2-x1;
  ty:=xexe div 2;
  PP:=x1+ty-6-lon;
  outtextxy(PP,tt,s);
end;

procedure fuente(fu,dir:word;siz:word);
{Changes font}
begin
  settextstyle(fu, dir,siz);
end;

procedure gTextbox(x1,y2,x2:integer;var yo:string;caden:string;colfondo,colefore,collabel,tecl:word;actley:boolean);
(*
Textbox
        yo:string; byval -> stores and passes the string of characters.
        caden: string; -> label of te textbox
        colfondo: background color of the textbox
        colefore: foreground color of the textbox
        collabel: color of the label
        tecl:number of keys.
        actley: activated or false
*)
var
  cad,cad2:string;
  lon,oldx,i:integer;
  tecla:char;
begin
  lon:=length(caden);
  lon:=lon * 8; {each character in the string is separated by 8 pixels}

  esc(x1,y2,caden,collabel); {write label}

  if colfondo=whitec then
    {make it hightlight if nbackground colour is white}
    boton(x1+lon,y2-4,x2+lon,y2+12,1,colfondo,false,4)
  else
    boton(x1+lon,y2-4,x2+lon,y2+12,1,colfondo,false,0);

if actley=true then begin
{when textbox is activated}

    ESC(X1+lon+1,Y2,chr(179),colefore); {cursor}

    cad:= ''; {initialises variable}
    oldx:=x1+lon+2;
    repeat
     {Textbox input loop}

     if keypressed then begin
       tecla:=readkey;
       if (tecla>chr(31)) and (tecla<chr(126)) then begin  {range of allowed keys}
        {ignore arrow keys}
        if tecla=#75 then tecla:='K';
        if tecla=#80 then tecla:='P';
        if tecla=#72 then tecla:='H';
        if tecla=#77 then tecla:='M';
            if (length(cad)<tecl) and (oldx<x2+lon-8) then begin
             {boundaries}
              cad:=cad+tecla;
              rectangl(oldx-1,y2-2,oldx+7,y2+10,colfondo,1,colfondo);  {rectangle to delete previous characters and cursor}
              esc(oldx,y2,tecla,colefore);
              oldx:=oldx+8;
              esc(oldx,y2,chr(179),colefore);
            end;
       end;
       if tecla=#8 then begin
         {backspace key}
          if oldx>x1+lon+2 then begin
          {if we haven't reach the beginning of the textbox}
            cad2:='';
            if length(cad)>1 then
              for i:=1 to length(cad)-1 do cad2:=cad2+cad[i] {remove last character from string;}
            else
              cad2:='';
              cad:=cad2;
              rectangl(oldx-1,y2-2,oldx+7,y2+10,colfondo,1,colfondo);  {rectangle to delete previous characters and cursor}
              oldx:=oldx-8;
              rectangl(oldx-1,y2-2,oldx+7,y2+10,colfondo,1,colfondo);  {rectangle to delete previous characters and cursor}
              esc(oldx,y2,chr(179),colefore);
            end;
          end;
       end;
    until (tecla=#13) or (tecla=#27);
    rectangl(oldx-1,y2-2,oldx+7,y2+10,colfondo,1,colfondo);  {rectangle to delete previous characters and cursor}
    if tecla=#13 then yo:=cad; {saves string if enter key was pressed}
    tecla:=chr(0); {clear key buffer}
end;
end;
procedure gnumbox(x1,y2,x2:integer;var yo:string;caden:string;colfondo,colefore,collabel,tecl:word;actley:boolean);
(*
Textbox
        yo:string; byval -> stores and passes the string of characters.
        caden: string; -> label of te textbox
        colfondo: background color of the textbox
        colefore: foreground color of the textbox
        collabel: color of the label
        tecl:number of keys.
        actley: activated or false
*)
var
  cad,cad2:string;
  lon,oldx,i:integer;
  tecla:char;
begin
  lon:=length(caden);
  lon:=lon * 8; {each character in the string is separated by 8 pixels}

  esc(x1,y2,caden,collabel); {write label}

  if colfondo=whitec then
    {make it hightlight if nbackground colour is white}
    boton(x1+lon,y2-4,x2+lon,y2+12,1,colfondo,false,4)
  else
    boton(x1+lon,y2-4,x2+lon,y2+12,1,colfondo,false,0);

if actley=true then begin
{when textbox is activated}

    ESC(X1+lon+1,Y2,chr(179),colefore); {cursor}

    cad:= ''; {initialises variable}
    oldx:=x1+lon+2;

    repeat
     {Textbox input loop}

     if keypressed then begin
       tecla:=readkey;
       if (tecla>chr(47)) and (tecla<chr(58)) then begin  {range of allowed keys}
        {ignore arrow keys}
        if tecla=#75 then tecla:='K';
        if tecla=#80 then tecla:='P';
        if tecla=#72 then tecla:='H';
        if tecla=#77 then tecla:='M';
            if (length(cad)<tecl) and (oldx<x2+lon-8) then begin
             {boundaries}
              cad:=cad+tecla;
              rectangl(oldx-1,y2-2,oldx+7,y2+10,colfondo,1,colfondo);  {rectangle to delete previous characters and cursor}
              esc(oldx,y2,tecla,colefore);
              oldx:=oldx+8;
              esc(oldx,y2,chr(179),colefore);
            end;
       end;
       if tecla=#8 then begin
         {backspace key}
          if oldx>x1+lon+2 then begin
          {if we haven't reach the beginning of the textbox}
            cad2:='';
            if length(cad)>1 then
              for i:=1 to length(cad)-1 do cad2:=cad2+cad[i] {remove last character from string;}
            else
              cad2:='';
              cad:=cad2;
              rectangl(oldx-1,y2-2,oldx+7,y2+10,colfondo,1,colfondo);  {rectangle to delete previous characters and cursor}
              oldx:=oldx-8;
              rectangl(oldx-1,y2-2,oldx+7,y2+10,colfondo,1,colfondo);  {rectangle to delete previous characters and cursor}
              esc(oldx,y2,chr(179),colefore);
            end;
          end;
       end;
    until (tecla=#13) or (tecla=#27);
    rectangl(oldx-1,y2-2,oldx+7,y2+10,colfondo,1,colfondo);  {rectangle to delete previous characters and cursor}
    if tecla=#13 then yo:=cad; {saves string if enter key was pressed}
    tecla:=chr(0); {clear key buffer}
end;
end;

procedure linex(tra1,ra1,tra2,ra2:integer);
{draws a black and white line for separation}
begin
  setcolor(blackc);
  line(tra1,ra1,tra2,ra1);
  setcolor(whitec);
  line(tra1,ra1+1,tra2,ra1+1);
end;
end.
