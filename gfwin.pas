Unit gfwin;
(* Unit to handle windows and mouse *)
INTERFACE
Uses ptcgraph,gfxn,ptcmouse,ptccrt;
type

             tmWin = ^tmWinData;
             tmWinData = RECORD
                          wX1,wY1 : longint; //record position
                          wX2,wY2 : longint; //record position
                          WinCol : word; // window color display
                          //WinID : String;
                         // WinType : array[1..2] of integer; //allows for different window styles
                          WinBuffer : array[0..1024,0..768] of longint; // window image buffer
                         END;

PROCEDURE gWindow(var winID:tmWin;x1,y1,x2,y2:longint;WcOL:word);
procedure alertw(var winID:tmWin;x1,y1,x2,y2:longint;WBackc,WInsidec,wTitlec,WFontTitc,WFontTextc:word;title,text:string);
PROCEDURE gCloseWin(var winID:tmWin);
FUNCTION  mRange(x1,y1,x2,y2:longint):boolean;

IMPLEMENTATION

function mRange(x1,y1,x2,y2:longint):boolean;//check whether the mouse coordinates collide with the color pallette
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
//  d:array[1..1024,1..768] of longint;
  i,j:longint;
begin
    new(WinId); //new object
    for i:=x1 to x2 do
       for j:=y1 to y2 do begin
           if (i<=getmaxx) and (j<=getmaxy) and (i>=0) and (j>=0) then  // failsafe to be in bound of the array
             WinId^.Winbuffer[i,j]:=getpixel(i,j); //record pixels from area before drawing
       end;
      With WinId^ do Begin
           // WinCol := wCol;
            wX1 := X1;
            wY1 := Y1;
            wX2 := X2;
            wY2 := Y2;
      end;

 // if (x1>x2) and (y1>y2) then begin
    //only draw when values make sense
    boton(x1+1,y1+1,x2,y2,1,wcol,true,1);
 // end;
end;
PROCEDURE gCloseWin(var winID:tmWin);
var
  i,j:longint;
  x1,y1,x2,y2:longint;
Begin

    With WinId^ do Begin //retrieve position data from pointer
          X1 := wX1;
          Y1 := wY1;
          X2 := wX2;
          Y2 := wY2;
    end;

    for i:=x1 to x2 do
     for j:=y1 to y2 do begin
         if (i<=getmaxx) and (j<=getmaxy) and (i>=0) and (j>=0) then // failsafe to be in bound of the array
         putpixel(i,j,winId^.Winbuffer[i,j]); // redraw previous image
     end;

     dispose(winId); //free memory
end;
Procedure alertw(var winID:tmWin;x1,y1,x2,y2:longint;WBackc,WInsidec,wTitlec,WFontTitc,wFontTextc:word;title,text:string);
var ch:char;
xmid,ymid,mx,my,state,xsize,ysize:longint;
oldmx,oldmy:longint; //keep track of old mouse values
begin
    //draw window
    gwindow(winid,x1,y1,x2,y2,wbackc);
    Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,true,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
    Esc(x1+20,y1+50,text,wFontTextc);
    xmid:=(((x2-x1) div 2)+x1)-40;
    Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
    escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
 repeat
    //loop window
    //break if ok button clicked or pressed with enter
    //move algorithm
    showmouse;
    getmousestate(mx,my,state);
    if keypressed then ch:=readkey;
    if ch=#13 then begin
      //close window when ok button is pressed with enter
      Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,false,0);
      escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
      delay(100);
      Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
      escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
      break;
    end;
    if (mrange(xmid+10,y2-40,xmid+80,y2-20)) and (state=1) then begin
      //close window when ok is pressed with mouse right button
      Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,false,0);
      escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
      delay(100);
      Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
      escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
      break;
    end;

    if (mrange(x1+5,y1+5,x2-5,y1+25)) and (state=1) then begin
    (* Move window algorithm *)
      //change title to pressed to indicate that window is being moved
      Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,false,0);
      EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
      xsize:=x2-x1; // window size must remain constant
      ysize:=y2-y1; // window size must remain constant
      repeat
        oldmx:=mx; //old mouse value
        oldmy:=my; //old mouse value
        getmousestate(mx,my,state); // get new values

        if (mx<>oldmx) and (my<>oldmy) then begin
            //if there is a change in the values
            x1:=x1+(mx-oldmx);
            y1:=y1+(my-oldmy);
            if x1<=0 then x1:=0; //prevents values from being negative
            if y1<=0 then y1:=0; //prevents values from being negative (0,0)
            x2:=x1+xsize;
            y2:=y1+ysize;
            if x1+xsize>=getmaxx then begin
            //prevents values from going over maxwidth
                x1:=getmaxx-xsize;
                x2:=getmaxx;
            end;
            if y1+ysize>=getmaxy then begin
            //prevents values from going over maxheight
              y1:=getmaxy-ysize;
              y2:=getmaxy;
            end;
            //draw new window
            gclosewin(winid); //close previous window
            gwindow(winid,x1,y1,x2,y2,wbackc);
            Boton(x1+5,y1+5,x2-5,y2-5,1,winsidec,true,0);
            Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,false,0);
            EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
            Esc(x1+20,y1+50,text,wFontTextc);
            xmid:=(((x2-x1) div 2)+x1)-40;
            Boton(xmid+10,y2-40,xmid+80,y2-20,1,winsidec,true,1);
            escc(xmid+10,y2-40,xmid+80,y2-20,'OK',wFontTextc);
        end;
      until (state<>1); //until left button is released
    //window title is unpressed again
    Boton(x1+5,y1+5,x2-5,y1+25,1,wtitlec,true,0);
    EscC(x1+5,y1+5,x2-5,y1+25,title,wFontTitc);
    end;
  until (ch=#27);
 gclosewin(winid);
End;

end.
