Unit gfwin;
(* Unit to handle windows and mouse *)
INTERFACE
Uses ptcgraph,gfxn,ptcmouse,ptccrt;
type

             tmWin = ^tmWinData;
             tmWinData = RECORD
                          wX1,wY1 : longint; {record position}
                          wX2,wY2 : longint; {record position}
                          WinCol : word; { window color display}
                          WinBuffer : array[0..1024,0..768] of longint; { window image buffer}
                         END;

PROCEDURE gWindow(var winID:tmWin;x1,y1,x2,y2:longint;WcOL:word);
procedure alertw(var winID:tmWin;x1,y1,x2,y2:longint;WBackc,WInsidec,wTitlec,WFontTitc,WFontTextc:word;title,text:string);
function yesnow(var winID:tmWin;x1,y1,x2,y2:longint;WBackc,WInsidec,wTitlec,WFontTitc,WFontTextc:word;title,text:string):boolean;
procedure inputw(var winID:tmWin;x1,y1,x2,y2:longint;WBackc,WInsidec,wTitlec,WFontTitc,WFontTextc:word;title,text:string;var itext:string;caption:string;ilength:integer);
PROCEDURE gCloseWin(var winID:tmWin);
FUNCTION  mRange(x1,y1,x2,y2:longint):boolean;

IMPLEMENTATION

function mRange(x1,y1,x2,y2:longint):boolean; {check whether the mouse coordinates collide with the color pallette}
var
    x,y,state:longint;
begin
  getmousestate(x,y,state);
  if (x>=x1) and (x<=x2) and (y>=y1) and (y<=y2) then begin
    mrange:=true;
  end
  else
    mrange:=false;
end;

procedure gWindow(var winID:tmWin;x1,y1,x2,y2:longint;WcOL:word);
var
  i,j:longint;
begin
    new(WinId); {new object}
    for i:=x1 to x2 do
       for j:=y1 to y2 do begin
           if (i<=getmaxx) and (j<=getmaxy) and (i>=0) and (j>=0) then  { failsafe to be in bound of the array}
             WinId^.Winbuffer[i,j]:=getpixel(i,j); {record pixels from area before drawing}
       end;
      With WinId^ do Begin
            wX1 := X1;
            wY1 := Y1;
            wX2 := X2;
            wY2 := Y2;
      end;

    boton(x1+1,y1+1,x2,y2,1,wcol,true,1);
end;
PROCEDURE gCloseWin(var winID:tmWin);
var
  i,j:longint;
  x1,y1,x2,y2:longint;
Begin

    With WinId^ do Begin {retrieve position data from pointer}
          X1 := wX1;
          Y1 := wY1;
          X2 := wX2;
          Y2 := wY2;
    end;

    for i:=x1 to x2 do
     for j:=y1 to y2 do begin
         if (i<=getmaxx) and (j<=getmaxy) and (i>=0) and (j>=0) then { failsafe to be in bound of the array}
         putpixel(i,j,winId^.Winbuffer[i,j]); {redraw previous image}
     end;

     dispose(winId); {free memory}
     winid:=nil;
end;
Procedure alertw(var winID:tmWin;x1,y1,x2,y2:longint;WBackc,WInsidec,wTitlec,WFontTitc,wFontTextc:word;title,text:string);
{Alert window}
const
        trail_max = 2; {number of windows to create a trail when the window is moved}
var ch:char;
xmid,mx,my,state,xsize,ysize:longint;
oldmx,oldmy:longint; {keep track of old mouse values}
trail:array[0..trail_max] of tmwin;
wincount,i:integer;
posx,posy:longint;
begin
    {draw window}
    gwindow(winid,x1,y1,x2,y2,wbackc);
    Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,true,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
    posx:=x1+20;  //values for text
    posy:=y1+50;
    for i:=1 to length(text) do begin
    {to deal with Crlf, Writeln}
      if text[i]<>chr(10) then begin
          Esc(posx,posy,text[i],wFontTextc);
          posx:=posx+8;
     end
      else begin
        posy:=posy+10;
        posx:=x1+20;
      end;
    end;
   { Esc(x1+20,y1+50,text,wFontTextc);}
    xmid:=(((x2-x1) div 2)+x1)-40;
    Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
    escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);

  repeat
    {loop window
    break if ok button clicked or pressed with enter
    move algorithm}
    showmouse;
    getmousestate(mx,my,state);
    if keypressed then ch:=readkey;
    if ch=#13 then begin
      {close window when ok button is pressed with enter}
      Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,false,0);
      escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
      delay(100);
      Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
      escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
      break;
    end;
    if (mrange(xmid+10,y2-40,xmid+80,y2-20)) and (state=1) then begin
      {close window when ok is pressed with mouse right button}
      Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,false,0);
      escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
      delay(100);
      Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
      escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
      break;
    end;

    if (mrange(x1+5,y1+5,x2-5,y1+25)) and (state=1) then begin
    (* Move window algorithm *)
      {change title to pressed to indicate that window is being moved}
      Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,false,0);
      EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
      xsize:=x2-x1; { window size must remain constant}
      ysize:=y2-y1; { window size must remain constant}
      wincount:=0;
      repeat
        oldmx:=mx; {old mouse value}
        oldmy:=my; {old mouse value}
        getmousestate(mx,my,state); { get new values}

        if (mx<>oldmx) and (my<>oldmy) then begin
            {if there is a change in the values}
            if (winid<>nil) and (wincount = 0) then gclosewin(winid); {close main window to create trail}
            x1:=x1+(mx-oldmx);
            y1:=y1+(my-oldmy);
            if x1<=0 then x1:=0; {prevents values from being negative }
            if y1<=0 then y1:=0; {prevents values from being negative (0,0)}
            x2:=x1+xsize;
            y2:=y1+ysize;
            if x1+xsize>=getmaxx then begin
            {prevents values from going over maxwidth}
                x1:=getmaxx-xsize;
                x2:=getmaxx;
            end;
            if y1+ysize>=getmaxy then begin
            {prevents values from going over maxheight}
              y1:=getmaxy-ysize;
              y2:=getmaxy;
            end;
            {draw new window}
            if wincount=trail_max+1 then begin
             { Close trail windows when you reach the maximum}
              for i:=trail_max downto 0 do gclosewin(trail[i]); {close previous window}
              wincount:=0;
            end;
            if (x2>x1) and (y2>y1) and (wincount<=trail_max) then begin
              gwindow(trail[wincount],x1,y1,x2,y2,wbackc);
              posx:=x1+20;  {values for text}
              posy:=y1+50;
              Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
              Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,false,0);
              EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
              for i:=1 to length(text) do begin
              {to deal with Crlf, Writeln}
                if text[i]<>chr(10) then begin
                  Esc(posx,posy,text[i],wFontTextc);
                  posx:=posx+8;
                end
                else begin
                  posy:=posy+10;
                  posx:=x1+20;
                end;
              end;

              xmid:=(((x2-x1) div 2)+x1)-40;
              Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
              escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
            end;
            wincount:=wincount+1;
        end;

      until (state<>1); {until left button is released}
    {window title is unpressed again
    we delete the trail and show the main window a again}
    if (mx=oldmx) and (my=oldmy) and (wincount=0) and (winid<>nil) then gclosewin(winid); {close main window to create trail}
    wincount:=wincount-1;
    for i:=wincount downto 0 do gclosewin(trail[i]);
    gwindow(winid,x1,y1,x2,y2,wbackc);
    posx:=x1+20;  {values for text}
    posy:=y1+50;
    Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,false,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
    for i:=1 to length(text) do begin
    {to deal with Crlf, Writeln}
      if text[i]<>chr(10) then begin
          Esc(posx,posy,text[i],wFontTextc);
          posx:=posx+8;
     end
      else begin
        posy:=posy+10;
        posx:=x1+20;
      end;
    end;
    xmid:=(((x2-x1) div 2)+x1)-40;
    Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
    escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,true,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);

 end;
  until (ch=#27);
 gclosewin(winid);
End;
Function yesnow(var winID:tmWin;x1,y1,x2,y2:longint;WBackc,WInsidec,wTitlec,WFontTitc,wFontTextc:word;title,text:string):boolean;
{Yes/No window}
const
        trail_max = 2; { number of windows to create a trail when the window is moved}
var ch:char;
mx,my,state,xsize,ysize:longint;
oldmx,oldmy:longint; {keep track of old mouse values }
trail:array[0..trail_max] of tmwin;
wincount,i:integer;
posx,posy:longint;
begin
    {draw window}
    gwindow(winid,x1,y1,x2,y2,wbackc);
    Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,true,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
    posx:=x1+20;  {values for text}
    posy:=y1+50;
    for i:=1 to length(text) do begin
    {to deal with Crlf, Writeln}
      if text[i]<>chr(10) then begin
          Esc(posx,posy,text[i],wFontTextc);
          posx:=posx+8;
     end
      else begin
        posy:=posy+10;
        posx:=x1+20;
      end;
    end;
    Boton(x1+20,y2-40,x1+100,y2-20,1,winsidec,true,1);
    escc(x1+20,y2-40,x1+100,y2-20,'Yes',wFontTextc);
    Boton(x1+220,y2-40,x1+300,y2-20,1,winsidec,true,1);
    escc(x1+220,y2-40,x1+300,y2-20,'No',wFontTextc);
  repeat
    {loop window
    break if ok button clicked or pressed with enter
    move algorithm}
    showmouse;
    getmousestate(mx,my,state);
    if keypressed then ch:=readkey;
    if (mrange(x1+220,y2-40,x1+300,y2-20)) and (state=1) then begin
      {close window when ok is pressed with mouse right button}
      Boton(x1+220,y2-40,x1+300,y2-20,1,winsidec,false,0);
      escc(x1+220,y2-40,x1+300,y2-20,'No',wFontTextc);
      delay(100);
      Boton(x1+220,y2-40,x1+300,y2-20,1,winsidec,true,1);
      escc(x1+220,y2-40,x1+300,y2-20,'No',wFontTextc);
      yesnow:=false;
      break;
    end;
    if (mrange(x1+20,y2-40,x1+100,y2-20)) and (state=1) then begin
      {close window when ok is pressed with mouse right button}
      Boton(x1+20,y2-40,x1+100,y2-20,1,winsidec,false,0);
      escc(x1+20,y2-40,x1+100,y2-20,'Yes',wFontTextc);
      delay(100);
      Boton(x1+20,y2-40,x1+100,y2-20,1,winsidec,true,1);
      escc(x1+20,y2-40,x1+100,y2-20,'Yes',wFontTextc);
      yesnow:=true;
      break;
    end;

    if (mrange(x1+5,y1+5,x2-5,y1+25)) and (state=1) then begin
    (* Move window algorithm *)
      {change title to pressed to indicate that window is being moved}
      Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,false,0);
      EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
      xsize:=x2-x1; { window size must remain constant}
      ysize:=y2-y1; { window size must remain constant}
      wincount:=0;
      repeat
        oldmx:=mx; {old mouse value}
        oldmy:=my; {old mouse value}
        getmousestate(mx,my,state); { get new values}

        if (mx<>oldmx) and (my<>oldmy) then begin
            {if there is a change in the values}
            if (winid<>nil) and (wincount = 0) then gclosewin(winid); {close main window to create trail}
            x1:=x1+(mx-oldmx);
            y1:=y1+(my-oldmy);
            if x1<=0 then x1:=0; {prevents values from being negative}
            if y1<=0 then y1:=0; {prevents values from being negative (0,0)}
            x2:=x1+xsize;
            y2:=y1+ysize;
            if x1+xsize>=getmaxx then begin
            {prevents values from going over maxwidth}
                x1:=getmaxx-xsize;
                x2:=getmaxx;
            end;
            if y1+ysize>=getmaxy then begin
            {prevents values from going over maxheight}
              y1:=getmaxy-ysize;
              y2:=getmaxy;
            end;
            {draw new window}
            if wincount=trail_max+1 then begin
             { Close trail windows when you reach the maximum}
              for i:=trail_max downto 0 do gclosewin(trail[i]); {close previous window}
              wincount:=0;
            end;
            if (x2>x1) and (y2>y1) and (wincount<=trail_max) then begin
              gwindow(trail[wincount],x1,y1,x2,y2,wbackc);
              posx:=x1+20;  {values for text}
              posy:=y1+50;
              Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
              Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,false,0);
              EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
              for i:=1 to length(text) do begin
              {to deal with Crlf, Writeln}
                if text[i]<>chr(10) then begin
                  Esc(posx,posy,text[i],wFontTextc);
                  posx:=posx+8;
                end
                else begin
                  posy:=posy+10;
                  posx:=x1+20;
                end;
              end;
            Boton(x1+20,y2-40,x1+100,y2-20,1,winsidec,true,1);
            escc(x1+20,y2-40,x1+100,y2-20,'Yes',wFontTextc);
            Boton(x1+220,y2-40,x1+300,y2-20,1,winsidec,true,1);
            escc(x1+220,y2-40,x1+300,y2-20,'No',wFontTextc);
            end;
            wincount:=wincount+1;
        end;
      until (state<>1); {until left button is released}
    {window title is unpressed again
    we delete the trail and show the main window a again}
    if (mx=oldmx) and (my=oldmy) and (wincount=0) and (winid<>nil) then gclosewin(winid); {close main window to create trail}
    wincount:=wincount-1;
    for i:=wincount downto 0 do gclosewin(trail[i]);
    gwindow(winid,x1,y1,x2,y2,wbackc);
    posx:=x1+20;  {values for text}
    posy:=y1+50;
    Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,false,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
    for i:=1 to length(text) do begin
      if text[i]<>chr(10) then begin
          Esc(posx,posy,text[i],wFontTextc);
          posx:=posx+8;
     end
      else begin
        posy:=posy+10;
        posx:=x1+20;
      end;
    end;
    Boton(x1+20,y2-40,x1+100,y2-20,1,winsidec,true,1);
    escc(x1+20,y2-40,x1+100,y2-20,'Yes',wFontTextc);
    Boton(x1+220,y2-40,x1+300,y2-20,1,winsidec,true,1);
    escc(x1+220,y2-40,x1+300,y2-20,'No',wFontTextc);
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,true,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
 end;
  until (ch=#27);
 gclosewin(winid);

End;
Procedure inputw(var winID:tmWin;x1,y1,x2,y2:longint;WBackc,WInsidec,wTitlec,WFontTitc,wFontTextc:word;title,text:string;var itext:string;caption:string;ilength:integer);
{Alert window}
var 
i:integer;
posx,posy:longint;
begin
    {draw window}
    gwindow(winid,x1,y1,x2,y2,wbackc);
    Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,true,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
    posx:=x1+20;  {values for text}
    posy:=y1+50;
    for i:=1 to length(text) do begin
    {to deal with Crlf, Writeln}
      if text[i]<>chr(10) then begin
          Esc(posx,posy,text[i],wFontTextc);
          posx:=posx+8;
     end
      else begin
        posy:=posy+10;
        posx:=x1+20;
      end;
    end;
    gTextbox(x1+20,y2-65,x1+ilength*10,itext,caption,wtitlec,wFontTitc,wFontTextc,ilength,true);
   gclosewin(winid);
End;
end.
