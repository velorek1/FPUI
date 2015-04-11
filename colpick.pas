Program colorpicker;
(* TrueColor COLOR PICKER *)
Uses gfxn,ptcgraph,ptccrt,ptcmouse,hex2bin,gfwin;

type
          cell = record
                 px:integer;
                 py:integer;
                 code:string; // decimal color number in string
                 size:integer; //size of cell
                 num:longint; //decimal color number
          end;

var
  t,p,globald:integer;
  x,y,state,lastx,lasty:longint;
  xs,ys,states:string; {String equivalents of values}
  byte_cell:array[1..196] of cell; // palette array
  byte_cell2:array[1..188] of cell; // shades array
  car:char; //keyboard input handler
  shades:boolean;
  win1:tmwin; //window handler
  inputs,inputs2:string;
function collision(x,y:integer;var t:integer):boolean;
//check whether the mouse coordinates collide with the color pallette
var
  i:integer;
begin
      for i:=1 to 196 do begin
           with byte_cell[i] do begin
                if (x>=px) and (x<=px+20) and (y>=py) and(y<=py+20) then
                  begin
                    collision:=true;
                    t:=i; // pass this value by val.
                    break;
                  end
                else
                collision:=false;
           end;
        end;
end;
function collision2(x,y:integer;var t:integer):boolean;
//check whether the mouse coordinates collide with the color pallette
var
  i:integer;
begin
      for i:=1 to 188 do begin
           with byte_cell2[i] do begin
                if (x>=px) and (x<=px+20) and (y>=py) and(y<=py+20) then
                  begin
                    collision2:=true;
                    t:=i; // pass this value by val.
                    break;
                  end
                else
                collision2:=false;
           end;
        end;
end;

Procedure generate;
{Generate color palette}
var
  ram:longint;
  i,posx,posy:integer;
Begin
    randomize;
    posy:=80;
    posx:=40;
    for i:=1 to 196 do begin
    {boton(20,posy,getmaxx-20,posy+13,1,10,false,0);}
        {str(posy,lb);}
        ram:=random(65535);
        with byte_cell[i] do begin // store values in array
                px:=posx;
                py:=posy;
                size:=20;
                num:=ram;
                //code:=dec2hex(ram);
                str(ram,code);
        end;
        boton(posx,posy,posx+20,posy+20,1,ram,true,3); // draw buttons
        posy:=posy+20;
        if posy > 340 then begin posy:=80; posx:=posx+22; end;
    end;
    posy:=40;
End;
Procedure gen_shades(col:longint);
{Generate color palette}
var
  ram:longint;
  i,posx,posy:integer;
Begin
    posy:=430;
    posx:=40;
    ram:=col;
    for i:=1 to 188 do begin
    {boton(20,posy,getmaxx-20,posy+13,1,10,false,0);}
        {str(posy,lb);}
        with byte_cell2[i] do begin // store values in array
                px:=posx;
                py:=posy;
                size:=20;
                num:=ram;
                //code:=dec2hex(ram);
                str(ram,code);
        end;
        boton(posx,posy,posx+20,posy+20,1,ram,true,1); // draw buttons
        posy:=posy+20;
        if posy > 490 then begin posy:=430; posx:=posx+20; end;
       if ram<65535 then ram:=ram+globald; //difference between colors
       if ram>=65535 then ram:=65535;
    end;
    shades:=true;
End;

procedure init_screen;
{Init graph and main program layout}
var a,b:integer;
begin
    //Fullscreengraph:=true;
    a:=detect;
    initgraph(a,b,'');
    fondo(dgreyc);
    cleardevice;
    showmouse;
    boton(20,40,getmaxx-20,getmaxy-67,1,$bdf7,true,0);
    boton(0,0,getmaxx,20,1,$ffff,false,0);
    esc(10,8,' - Color picker High Color::LinX:: 16-bit',$0000);
   // CMenu(men,$0000,$bdf7,$0000,$ffff,false);
   // Add_item(men,'hello',posx,posy);
    esc(40,60,'Color palette: ',blackc);
    linex(30,370,getmaxx-30,370);
    rectangl(650,80,950,360,blackc,1,dgreyc);
    boton(410,320,570,360,1,tilec,true,1); //generate button
    esc(425,335,'Generate palette',whitec);
    esc(650,60,'Color area:',blackc);
    esc(40,400,'Shades of selected color:',blackc);
    boton(900,650,980,680,1,dbluec,true,0); //exit button
    esc(926,661,'EXIT',whitec);
    rectangl(45,610,310,680,blackc,1,blackc);
    rectangl(35,600,300,670,blackc,1,lgreyc);
    gTextbox(40,620,120,inputs,'Color code (Hex): ',tilec,blackc,blackc,4,false);
    gnumbox(40,640,80,inputs2,'Shades rate:      ',tilec,blackc,blackc,2,false);
end;

Begin
  init_screen; {Init graph and draw main screen}
  generate; {generate color palette}
  shades:=false;
  x:=0;
  y:=0;
  globald:=1;
  repeat
    {main loop}
      lastx:=x;     //last mousex position
      lasty:=y;
      getmousestate(x,y,state);
      str(x,xs);
      str(y,ys);
      str(state,states);
      if (collision(x,y,t)) and (state=1) then begin
      {When you press one of the cells, generate shades}
        boton(byte_cell[t].px,byte_cell[t].py,byte_cell[t].px+20,byte_cell[t].py+20,1,byte_cell[t].num,false,3);
        delay(100);
        boton(byte_cell[t].px,byte_cell[t].py,byte_cell[t].px+20,byte_cell[t].py+20,1,byte_cell[t].num,true,3);
        gen_shades(byte_cell[t].num);
      end;
      if (collision(x,y,t)) and (state=4) then begin
      {When you press one of the cells, change color of the label; right button}
        boton(byte_cell[t].px,byte_cell[t].py,byte_cell[t].px+20,byte_cell[t].py+20,1,byte_cell[t].num,false,3);
        delay(100);
        boton(byte_cell[t].px,byte_cell[t].py,byte_cell[t].px+20,byte_cell[t].py+20,1,byte_cell[t].num,true,3);
        esc(670,90,'Code: ' + byte_cell[t].code+ ':'+dec2hex(byte_cell[t].num),whitec);

      end;

      if (x>=410) and (x<=570) and (y>=320) and (y<=360) and (state=1) then begin
         //generate button
         boton(410,320,570,360,1,tilec,false,1); //generate button
         esc(425,335,'Generate palette',whitec);
         delay(100);
         boton(410,320,570,360,1,tilec,true,1); //generate button
         esc(425,335,'Generate palette',whitec);
         generate;
      end;
      if (x>=40) and (x<=267) and (y>=620) and (y<=640) and (state=1) then begin
      //textbox1
        gTextbox(40,620,120,inputs,'Color code (Hex): ',tilec,blackc,blackc,4,true);
        if inputs<>'' then gen_shades(hex2dec(inputs));
      end;
      if (x>=40) and (x<=223) and (y>=640) and (y<=660) and (state=1) then begin
      //textbox2
      //inputs:='';
        gnumbox(40,640,80,inputs2,'Shades rate:      ',tilec,blackc,blackc,2,true);
        val(inputs2,globald);
      end;

      if (x>=900) and (x<=980) and (y>=650) and (y<=680) and (state=1) then begin
        //exit button
        boton(900,650,980,680,1,dbluec,false,0); //exit button
        esc(926,661,'EXIT',whitec);
        delay(100);
        boton(900,650,980,680,1,dbluec,true,0); //exit button
        esc(926,661,'EXIT',whitec);
        delay(100);
        closegraph;
        exit;
    end;
      if (collision2(x,y,p)) and (state=1) then begin
        //when you press the shades show alertbox
        alertw(win1,329,201,650,351,dgreyc,lgreyc,tilec,blackc,blackc,'- Color Information -','> Hex Code: '+ dec2hex(byte_cell2[p].num));
      end;

      if (x<>lastx) or (y<>lasty) then begin
        {Detect whether there is mouse movement}
        if collision(x,y,t)=true then begin
           {Change color of rectangle when hovering}
           rectangl(650,80,950,360,blackc,1,byte_cell[t].num);
           esc(670,90,'Code: ' + byte_cell[t].code+ ':'+dec2hex(byte_cell[t].num),blackc);
        end
        else
           rectangl(650,80,950,360,blackc,1,dgreyc);

      if shades then
         {When shades are activated}
        getmousestate(x,y,state);
        if collision2(x,y,p)=true then begin
           {Change color of rectangle when hovering}
           rectangl(650,80,950,360,blackc,1,byte_cell2[p].num);
           esc(670,90,'Code: ' + byte_cell2[p].code+ ':'+dec2hex(byte_cell2[p].num),blackc);
          end;
          rectangl(820,4,1022,17,whitec,1,whitec); //clear mouse coordinates  when mouse moves
       end;
       esc(820,8,'MOUSE X:' + xs + ' ' + ' Y:'+ys,dredc);
      if keypressed then car:=readkey;
   until car=#27; //ESC key press
    closegraph;
End.

