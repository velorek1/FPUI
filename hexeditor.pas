Uses gaedch2,gfxn,ptcgraph,ptccrt,ptcmouse,hex2bin,gfwin,sysutils;
const
{messages}
        aboutmsg = 'Hex Editor v0.1' + chr(10) + '2015. = Coded by Velorek =';
        textwin = 'Are you sure that you want to quit'+chr(10) + 'Hex Editor?';
        mes = 'Write path to file below.';
var
{file}
menu1,menu2:tmNodo;
menu1data:string;
texto:array[0..360] of string[2];
{hex}
intexto:string;
fileop:string;  {global file to be opened}
x,y,state,lastx,lasty:longint;
xs,ys,states:string;
car:char;
menux:array[1..3] of tmwin;
menops:array[1..3] of tmnodo;
pressed,fullsc,ver:boolean;

procedure credits;
{Exit screen}
begin
  {Dispose memory}
  if menux[1]<>nil then gclosewin(menux[1]);
  if menux[2]<>nil then gclosewin(menux[2]);
  if menux[3]<>nil then gclosewin(menux[3]);
  if menops[1]<>nil then crumble(menops[1]);
  closegraph;
  clrscr;
  TextColor(7);
  TextBackGround(0);
  writeln('');
  textcolor(10);
  write('H');
  textcolor(2);
  write('ex');
  textcolor(10);
  write('E');
  textcolor(2);
  write('dit v1.0');
  writeln('');
  textcolor(7);
  writeln('>> Thank you for using AED Software. - 2014 -');
  Writeln('');
  halt;
end;

procedure display;
{design layout}
begin
    inicia(fullsc);
    fondo($2b98);
    cleardevice;
    showmouse;
    rectangl(30,50,getmaxx-10,getmaxy-57,$884,1,$884);
    boton(20,40,getmaxx-20,getmaxy-67,1,$bdf7,true,1);
    boton(24,50,getmaxx-26,getmaxy-77,1,$bdf7,false,0);
    boton(0,0,getmaxx,23,1,whitec,false,0);
    rectangl(1,1,185,23,$2b98,11,blackc);
    boton(5,2,60,22,1,lgreyc,true,1);
    escc(5,2,60,22,'File',blackc);
    escc(3,1,58,21,'File',whitec);
    boton(65,2,120,22,1,lgreyc,true,1);
    escc(65,2,120,22,'Edit',blackc);
    escc(63,1,118,21,'Edit',whitec);
    boton(125,2,180,22,1,lgreyc,true,1);
    escc(125,2,180,22,'Help',blackc);
    escc(123,1,178,21,'Help',whitec);
    setcolor(blackc);
    line(186,1,186,23);
    line(890,1,890,23);
    esc(190,8,' Hex Editor v0.01',$0000);
    line(178,51,178,getmaxy-78);
    line(750,51,750,getmaxy-78);
    rectangl(0,getmaxy-25,getmaxx,getmaxy,$a7,1,$a7);
    esc(870,752,chr(196) + ' Coded by Velorek',lgreyc);
end;

procedure loadpage;
{Load hexadecimal values to menu}
var i,posx,posy:integer;
begin
     posx:=200;
     posy:=70;
     cMenu(Menu1,lgreyc,blackc,dbluec,whitec,true);
       i:=0;
       Repeat
        Add_Item(Menu1,texto[i],posx,posy);
        posx:=posx+30;
        if posx>=720 then begin
          posy:=posy+30;
          posx:=200;
        end;
        i:=i+1;
       until i=360;
    rectangl(900,4,1300,17,whitec,1,whitec);
    esc(900,8,'  Edit area',blackc);
  Start_Table_mouse(Menu1,menu1data,18,true,186,61,733,652);
  if (kglobal=#1) or (kglobal=#13) then alertw(win1,329,201,650,351,$7c34,lgreyc2,$2b98,whitec,blackc,'Hex Info','Parameter: ' + menu1^.nchoice);

    rectangl(900,4,1300,17,whitec,1,whitec);
end;

procedure loadtext;
{Load ascii values to menu}
var i,posx,posy:integer;
byt:integer;
prin:char;
begin
     posx:=770;
     posy:=69;
       i:=0;
     cMenu(Menu2,lgreyc,blackc,dgreenc,whitec,true);
       Repeat
        byt:=hex2dec(texto[i]);
        if (byt=32) or (byt=00) then prin:='.'
        else
        prin:=chr(byt);
        Add_Item(Menu2,prin,posx,posy);
       // esc(posx,posy,prin,dgreyc);
        posx:=posx+12;
        if posx>=980 then begin
          posy:=posy+30;
          posx:=770;
        end;
        i:=i+1;
       until i=360;
    rectangl(900,4,1300,17,whitec,1,whitec);
    esc(900,8,'  Edit area',blackc);
    Start_Table_mouse(Menu2,menu1data,18,true,762,61,981,652);
  if (kglobal=#1) or (kglobal=#13) then alertw(win1,329,201,650,351,$7c34,lgreyc2,$2b98,whitec,blackc,'Hex Info','Parameter: ' + menu2^.nchoice);
    rectangl(900,4,1300,17,whitec,1,whitec);
end;

procedure addr;
{Deal with offset address}
var i,current,posy,posx:integer;
rem:string;
begin
     current:=1;
     posx:=35;
     posy:=70;
     i:=0;
     repeat
         rem:=dec2hex(current);
         esc(posx,posy,'Offset: ',dgreyc);
         esc(posx+10*8,posy,rem,dbluec);
         posy:=posy+30;
         current:=current+19;
      i:=i+1;
     until i=20;
end;

procedure loadfile(fil:string);
{Open file to display}
var
F:file of byte;
Cp:Byte;
i:longint;
Count:integer;
filesi:string;
Begin
  for i:=1 to 360 do texto[i]:='00';

    If fil <> '' then
    Begin
         {Check if file exists}
         if not fileexists(fil) then
         Begin
           alertw(win1,329,201,650,351,$7c34,lgreyc2,$2b98,whitec,blackc,'- Hex Editor -','Parameter: ' + fil +chr(10)+'Error: File not found.');
           exit;
         end;
    end
    else
      exit; {if no file is given}
    assign(f,fil);
    reset(f);
    count:=0;
    i:=filesize(f);
    str(i,filesi);
    boton(24,getmaxy-96,getmaxx-26,getmaxy-74,1,$44da,false,0);
    esc(30,getmaxy-88,'File: '+Paramstr(1) + '  ' + '[Loading: '+filesi+' bytes]',blackc);
    count:=0;
    addr;
    while not eof(f) do Begin
      Read(f,Cp);
      Texto[count]:=dec2hex(cp);
      count:=count+1;
      if count = 360 then break;
    end;
    close(f);
    loadpage;
    loadtext;
end;

procedure loadmenus(men:integer);
{load menus to memory}
begin
 Case men of
    1: begin
         CMenu(menops[1],lgreyc,blackc,dredc,whitec,true);
         Add_item(menops[1],'New        CTRL+N',14,30);
         Add_item(menops[1],'Open           F3',14,50);
         Add_item(menops[1],'Save       CTRL+S',14,70);
         Add_item(menops[1],'Save As     ALT+S',14,90);
         Add_item(menops[1],'Exit          ESC',14,120);
      end;
    2: begin
         CMenu(menops[2],lgreyc,blackc,dredc,whitec,true);
         Add_item(menops[2],'Undo       CTRL+U',73,30);
         Add_item(menops[2],'Copy       CTRL+C',73,50);
         Add_item(menops[2],'Paste      CTRL+V',73,70);
         Add_item(menops[2],'Fullscreen CTRL+F',73,100);
       end;
    3: begin
         CMenu(menops[3],lgreyc,blackc,dredc,whitec,true);
         Add_item(menops[3],'Help          F1',133,30);
         Add_item(menops[3],'Calculator    F7',133,50);
         Add_item(menops[3],'About           ',133,80);
       end;
 end;
end;

procedure drawmenus;
begin
  rectangl(1,1,185,23,$2b98,11,blackc);
  boton(5,2,60,22,1,lgreyc,true,1);
  escc(5,2,60,22,'File',blackc);
  escc(3,1,58,21,'File',whitec);
  boton(65,2,120,22,1,lgreyc,true,1);
  escc(65,2,120,22,'Edit',blackc);
  escc(63,1,118,21,'Edit',whitec);
  boton(125,2,180,22,1,lgreyc,true,1);
  escc(125,2,180,22,'Help',blackc);
  escc(123,1,178,21,'Help',whitec);
  if menux[1]<>nil then gclosewin(menux[1]);
  if menux[2]<>nil then gclosewin(menux[2]);
  if menux[3]<>nil then gclosewin(menux[3]);
end;

procedure hovermenus(x,y,state:integer);
{deal with mouse menus}
begin
   if (mrange(1,155,1024,768)) or (mrange(321,1,1024,768)) then begin
    if menux[1]<>nil then gclosewin(menux[1]);
    if menux[2]<>nil then gclosewin(menux[2]);
    if menux[3]<>nil then gclosewin(menux[3]);
    pressed:=false;
   end;

   if not pressed then begin
    {if mouse position is not on the menus}
    drawmenus;
    {hovering}
    if mrange(5,2,60,22) then begin
      boton(5,2,60,22,1,dgreyc,true,1);
      escc(5,2,60,22,'File',blackc);
      escc(3,1,58,21,'File',whitec);
    end;
    if mrange(65,2,120,22) then begin
      boton(65,2,120,22,1,dgreyc,true,1);
      escc(65,2,120,22,'Edit',blackc);
      escc(63,1,118,21,'Edit',whitec);
    end;
    if mrange(125,2,180,22) then begin
      boton(125,2,180,22,1,dgreyc,true,1);
      escc(125,2,180,22,'Help',blackc);
      escc(123,1,178,21,'Help',whitec);
    end;
  end;
end;

procedure opendialog;
{Open file dialog}
begin
 inputw(win1,309,201,675,351,dgreyc,lgreyc2,$2b98,whitec,blackc,'Open Dialog',mes,intexto,'File:',30);
 if intexto<>'' then begin
    fileop:=intexto;
   loadfile(fileop);
 end;
end;

procedure checkmenus(x,y,state:integer);
var
ch:char;
begin
    {pressing}
    if keypressed then ch:=readkey;
    if ch=#27 then begin
    {if you press escape}
      pressed:=false;
      ch:=#0;
      drawmenus;
    end;
    if mrange(5,2,60,22) and ((state = 1) or (pressed)) then begin
     if (x<>lastx) or (y<>lasty) then begin
      boton(65,2,120,22,1,lgreyc,true,1);
      escc(65,2,120,22,'Edit',blackc);
      escc(63,1,118,21,'Edit',whitec);
      boton(125,2,180,22,1,lgreyc,true,1);
      escc(125,2,180,22,'Help',blackc);
      escc(123,1,178,21,'Help',whitec);
     end;
    if menux[2]<>nil then gclosewin(menux[2]);
     if menux[3]<>nil then gclosewin(menux[3]);
    if menux[1]=nil then begin
      boton(5,2,60,22,1,dgreyc,false,1);
      escc(5,2,60,22,'File',blackc);
      escc(3,1,58,21,'File',whitec);
      gwindow(menux[1],5,22,160,140,lgreyc);
      linex(6,110,159,110);
      loadmenus(1);
      start_vmenu_mouse(menops[1],5,22,160,150);
    end;
    pressed:=true;
    end;
    if mrange(65,2,120,22) and ((state=1) or (pressed)) then begin
     if (x<>lastx) or (y<>lasty) then begin
      boton(5,2,60,22,1,lgreyc,true,1);
      escc(5,2,60,22,'File',blackc);
      escc(3,1,58,21,'File',whitec);
      boton(125,2,180,22,1,lgreyc,true,1);
      escc(125,2,180,22,'Help',blackc);
      escc(123,1,178,21,'Help',whitec);
      end;
      if menux[3]<>nil then gclosewin(menux[3]);
     if menux[1]<>nil then gclosewin(menux[1]);
    if menux[2]=nil then begin
      boton(65,2,120,22,1,dgreyc,false,1);
      escc(65,2,120,22,'Edit',blackc);
      escc(63,1,118,21,'Edit',whitec);
      gwindow(menux[2],65,22,215,120,lgreyc);
      linex(66,90,214,90);
      loadmenus(2);
      start_vmenu_mouse(menops[2],65,22,215,120);
    end;
    pressed:=true;
    end;
    if mrange(125,2,180,22) and ((state=1) or (pressed)) then begin
     if (x<>lastx) or (y<>lasty) then begin
      boton(65,2,120,22,1,lgreyc,true,1);
      escc(65,2,120,22,'Edit',blackc);
      escc(63,1,118,21,'Edit',whitec);
      boton(5,2,60,22,1,lgreyc,true,1);
      escc(5,2,60,22,'File',blackc);
      escc(3,1,58,21,'File',whitec);
     end;
      if menux[1]<>nil then gclosewin(menux[1]);
     if menux[2]<>nil then gclosewin(menux[2]);
    if menux[3]=nil then begin
      boton(125,2,180,22,1,dgreyc,false,1);
      escc(125,2,180,22,'Help',blackc);
      escc(123,1,178,21,'Help',whitec);
      gwindow(menux[3],125,22,270,100,lgreyc);
      linex(126,70,269,70);
      loadmenus(3);
      start_vmenu_mouse(menops[3],125,22,270,100);
    end;
      pressed:=true;
    end;

{menu options}
     if mrange(5,22,160,150) and (pressed) and (menux[1]<>nil) then begin
      {File}
      start_vmenu_mouse(menops[1],5,22,160,140);
       if (kglobal=#1) or (kglobal=#27) or (kglobal =#13) then begin
         gclosewin(menux[1]);
         drawmenus;
         if kglobal<>#27 then begin
           case menops[1]^.nListcount of
                  5: credits;
           end;
           case menops[1]^.nListcount of
                  2: opendialog;
           end;
         end;
       end;
     end;
     if mrange(62,22,215,120) and (pressed) and (menux[2]<>nil) then begin
      {Edit}
      start_vmenu_mouse(menops[2],62,22,215,120);
       if (kglobal=#1) or (kglobal=#27) or (kglobal =#13) then begin
         gclosewin(menux[2]);
         drawmenus;
         if kglobal<>#27 then begin
           case menops[2]^.nListcount of
                  4: begin
                        if fullsc=false then
                          fullsc:=true
                        else
                        fullsc:=false;
                        inicia(fullsc);
                        display;
                        loadfile(fileop);
                     end;
           end;
         end;
       end;
     end;
     if mrange(122,22,270,100) and (pressed) and (menux[1]<>nil) then begin
     {Help}
       start_vmenu_mouse(menops[3],122,22,270,100);
       if (kglobal=#1) or (kglobal=#27) or (kglobal =#13) then begin
         gclosewin(menux[3]);
         drawmenus;
         if kglobal<>#27 then begin
           case menops[3]^.nListcount of
                  3: alertw(win1,329,201,650,351,dgreyc,lgreyc2,$2b98,whitec,blackc,'About',aboutmsg);
           end;
         end;
       end;
     end;

end;

Begin
    fullsc:=false;
    display;
    ver:=false;
    pressed:=false;
    if paramstr(1)<>'' then fileop:=paramstr(1);
    loadfile(fileop);
    x:=0;
    y:=0;
    repeat
    {main loop}
      lastx:=x;
      lasty:=y;
      getmousestate(x,y,state);
      str(x,xs);
      str(y,ys);
      str(state,states);
      esc(900,8,'  X:' + xs + ' Y:' + ys,blackc);
      if (keypressed) and (pressed=false) then car:=readkey;
      if (x<>lastx) or (y<>lasty) then begin
        rectangl(900,4,1300,17,whitec,1,whitec);
        if (menu1<>nil) and (pressed=false) and mrange(186,61,733,652) then loadpage;
        if (menu1<>nil) and (pressed=false) and mrange(762,61,981,652) then loadtext;
        hovermenus(x,y,state);
      end;
      checkmenus(x,y,state);
      if (car=#27) and (pressed=false) then begin
        {do you want to quit?}
        ver:=yesnow(win1,329,201,650,351,$7c34,lgreyc2,$2b98,whitec,blackc,'- Hex Editor -',textwin);
        car:=#0;
      end;
    until ver;
    credits;
End.
