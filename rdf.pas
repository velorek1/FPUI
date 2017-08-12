Uses video,vidutil,winvideo,aedcho2,sysutils,keyboard;
var menuh:tmNodo;
leave:boolean;
filbuf: array of string;
Procedure screen;
var i:integer;
begin
  setcursortype(crhidden);
   fondo(1);
  for i:=1 to screenwidth do
   esc(i,1,chr(32),7,7,false);
  for i:=1 to screenwidth do
   esc(i,screenheight,chr(32),7,7,false);
   esc(3,screenheight,'F2 > Menus | ESC twice > Exit',7,0,true);
  // lsquare(1,2,screenwidth,screenheight-1,1,15,true);
end;
procedure loadmenus(indx:integer);
begin
case indx of
      1: begin
            cmenu(menuh,7,0,0,15);
            add_item(menuh,'File', 3,1);
            add_item(menuh,'Edit', 9,1);
            add_item(menuh,'Options', 15,1);
            add_item(menuh,'Help', 23,1);
         end;
      -1: begin
            cmenu(menuh,7,0,0,15);
            add_item(menuh,'New', 4,3);
            add_item(menuh,'Open', 4,4);
            add_item(menuh,'Save', 4,5);
            add_item(menuh,'Save as', 4,6);
            add_item(menuh,'Exit', 4,8);
         end;
      -2: begin
            cmenu(menuh,7,0,0,15);
            add_item(menuh,'Copy', 10,3);
            add_item(menuh,'Paste', 10,4);
            add_item(menuh,'Select', 10,5);
            add_item(menuh,'Search', 10,6);
         end;
      -3: begin
            cmenu(menuh,7,0,0,15);
            add_item(menuh,'Hex Editor', 16,3);
            add_item(menuh,'Calculator', 16,4);
            add_item(menuh,'Settings...', 16,5);
         end;
      -4: begin
            cmenu(menuh,7,0,0,15);
            add_item(menuh,'Help', 24,3);
            add_item(menuh,'About', 24,4);
         end;

end;
end;
procedure vmenu(option:string);
var win1:tmwin;
begin
    case option of
      'File': begin
                 loadmenus(1);
                 mdisplay;
                 gotop(menuh,1);
                 loadmenus(-1);
                 opwindow(win1,3,2,11,9,7);
                 lsquare(3,2,11,9,7,0,true);
                 dline(4,7,10,7,0);
                 esc(3,7,chr(195),7,0,true);
                 esc(11,7,chr(180),7,0,true);
                 start_vmenu(menuh);
                 closewin(win1);
                 case menuh^.nchoice of
                        'Exit' : leave:=true;
                 end;
                 if kglobal=#77 then vmenu('Edit');
                 if kglobal=#75 then vmenu('Help');
                 loadmenus(1);
                 mdisplay;
              end;
      'Edit': begin
                 loadmenus(1);
                 mdisplay;
                 gotop(menuh,2);
                 loadmenus(-2);
                 opwindow(win1,9,2,18,7,7);
                 lsquare(9,2,18,7,7,0,true);
                 start_vmenu(menuh);
                 closewin(win1);
                 case menuh^.nchoice of
                        'Exit' : leave:=true;
                 end;
                 if kglobal=#77 then vmenu('Options');
                 if kglobal=#75 then vmenu('File');
                 loadmenus(1);
                 mdisplay;
              end;
      'Options': begin
                 loadmenus(1);
                 mdisplay;
                 gotop(menuh,3);
                 loadmenus(-3);
                 opwindow(win1,15,2,27,6,7);
                 lsquare(15,2,27,6,7,0,true);
                 start_vmenu(menuh);
                 closewin(win1);
                 case menuh^.nchoice of
                        'Exit' : leave:=true;
                 end;
                 if kglobal=#77 then vmenu('Help');
                 if kglobal=#75 then vmenu('Edit');
                 loadmenus(1);
                 mdisplay;
              end;
      'Help': begin
                 loadmenus(1);
                 mdisplay;
                 gotop(menuh,4);
                 loadmenus(-4);
                 opwindow(win1,23,2,29,5,7);
                 lsquare(23,2,29,5,7,0,true);
                 start_vmenu(menuh);
                 closewin(win1);
                 case menuh^.nchoice of
                        'Exit' : leave:=true;
                 end;
                 if kglobal=#77 then vmenu('File');
                 if kglobal=#75 then vmenu('Options');
                 loadmenus(1);
                 mdisplay;
              end;

    end;
end;
procedure hmenu;
begin
        loadmenus(1);
        start_hMenu(menuh);
        if kglobal=chr(13) then vmenu(menuh^.nchoice);
end;
procedure buffer;
var
wherx,whery,olwherx,olwhery,tick,posy,posx,maxwid,maxline,i:integer;
olposx,olposy:integer;
head,adds,tail,temp:string;
win1:tmwin;
ch:tKeyEvent;
kglobal,oldchar:char;
begin
  {Init variables}
  wherx:=3; {Display X}
  whery:=2; {Display Y}
  tick:=0; {Timer variable}
  kglobal:=chr(0); {Char to be read and written to screen}
  posy:=1;  {Current line}
  maxwid:=1;{Maximum width of line}
  posx:=1;  {Horizontal position in the line}
  oldchar:=#0; {Previous char}
  maxline:=1;  {Maximum height of lines}
  esc(1,whery,inttostr(posy),1,11,true);
  loadmenus(1); {Menus}
  mdisplay;
  setlength(filbuf,screenheight-3); {Buffer of lines according to screenheight}
  esc(screenwidth-20,screenheight,chr(179) + ' Col: '+ inttostr(posx) + ' Row: ' + inttostr(posy),7,0,true); {Status}
  {Buffer main loop}
  repeat
      if keypressed then begin
        olposx:=posx;  {Old positions}
        olposy:=posy;
        if (kglobal <> chr(0)) and (kglobal>chr(19)) and (kglobal < chr(176)) then esc(wherx-1,whery,kglobal,1,7,true);
        ch:=TranslateKeyEvent(GetKeyEvent);
        if GetKeyEventCode(ch)=kbdf2 then hmenu;
        kglobal:=GetKeyEventChar(ch);
        //kglob:=translatekeyevent(ch);
      {Keyboard management}
      if (kglobal>chr(19)) and (kglobal < chr(176)) and (kglobal<>chr(8)) then begin
        if posx=maxwid then
          filbuf[posy]:=filbuf[posy] + kglobal;
        if posx>maxwid then Begin
        {Add character when cursor is far from the end of the line}
          temp:='';
          for i:=maxwid to posx-1 do begin
            temp:=temp + ' ';
          end;
          filbuf[posy]:= filbuf[posy] + temp + kglobal;
          maxwid:=length(filbuf[posy])-1;
          //posx:=posx+1;
        end;
        if (posx<maxwid) and (kglobal<>chr(8)) then begin
        {Add character in the middle of the line - Edit}
           head:='';
           tail:='';
           adds:='';
           for i:=1 to posx-1 do head:=head + filbuf[posy][i];
           for i:=posx to maxwid do tail:=tail + filbuf[posy][i];
           adds:=adds+kglobal;
           filbuf[posy] :=head+adds+tail;
           esc(3,whery,filbuf[posy],1,7,true);
        end;
        esc(wherx,whery,kglobal,1,15,true);
        wherx:=wherx+1;
        maxwid:=maxwid+1;
        posx:=posx+1;
      end;
       if GetKeyEventCode(ch)=3849 then begin
       {Tab Key}
         temp:='';
         for i:=1 to 8 do begin
            temp:=temp + ' ';
         end;
         filbuf[posy]:= filbuf[posy] + temp;
         esc(3,whery,filbuf[posy],1,7,true);
         maxwid:=length(filbuf[posy]);
         posx:=maxwid;
         wherx:=wherx+8;
       end;
       if kglobal=chr(8) then begin
       {Backspace}
          esc(wherx,whery,' ',1,1,true);
         if wherx>3 then begin
           adds:='';
           wherx:=wherx-1;
           if posx>maxwid then Begin
             {Add character when cursor is far from the end of the line}
             temp:='';
             for i:=maxwid to posx-1 do begin
               temp:=temp + ' ';
             end;
             filbuf[posy]:= filbuf[posy] + temp;
             maxwid:=length(filbuf[posy])-1;
          end;
           if posx=maxwid then begin
             {When the cursor is at the end of the line}
             for i:=1 to length(filbuf[posy]) -1 do adds:=adds + filbuf[posy][i];
             posx:=posx-1;
             maxwid:=maxwid-1;
           end
           else begin
             {When the cursor is in the middle of the line}
             head:='';
             tail:='';
             adds:='';
             for i:=1 to posx-2 do head:=head + filbuf[posy][i];
             for i:=posx to maxwid do tail:=tail + filbuf[posy][i];
             adds:=head+tail;
             posx:=posx-1;
             maxwid:=maxwid-1;
           end;
             filbuf[posy] := adds;
             temp:='';
             for i:=3 to screenwidth-3 do temp:=temp + ' '; {Fill up string to clear line}
             esc(3,whery,temp,1,7,true); {Clear line}
             esc(3,whery,filbuf[posy],1,7,true);
         end;
       end;
       if  GetKeyEventCode(ch) = kbdup then begin
         if whery>2 then begin
           esc(wherx,whery,oldchar,1,7,true);
           oldchar:=VideoReadChar(wherx,whery-1,0);
           posy:=posy-1;
           whery:=whery-1;
           maxwid:=length(filbuf[posy]);
         end;
       end;
       if  GetKeyEventCode(ch) = kbdf3 then begin
           opwindow(win1,3,2,screenwidth-2,screenheight-3,3);
           for i:=0 to maxline do begin
              esc(5,2+i,filbuf[i],3,0,true);
           end;
          ch:=TranslateKeyEvent(GetKeyEvent);
           closewin(win1);
       end;

       if  GetKeyEventCode(ch) = kbddown then begin
         if (whery<screenheight-2) and (whery<=maxline) then begin
           esc(wherx,whery,oldchar,1,7,true);
           oldchar:=VideoReadChar(wherx,whery+1,0);
           posy:=posy+1;
           whery:=whery+1;
           maxwid:=length(filbuf[posy]);
         end;
       end;
       if  GetKeyEventCode(ch) = kbdleft then begin
         if wherx>3 then begin
           //if oldchar<>#0 then esc(wherx+1,whery,oldchar,1,1,true);
          esc(wherx,whery,oldchar,1,7,true);
           oldchar:=VideoReadChar(wherx-1,whery,0);
          wherx:=wherx-1;
          posx:=posx-1;
         end;
       end;
       if  GetKeyEventCode(ch) = kbdright then begin
         if wherx<screenwidth-2 then begin
           esc(wherx,whery,oldchar,1,7,true);
           oldchar:=VideoReadChar(wherx+1,whery,0);
           wherx:=wherx+1;
           posx:=posx+1;
         end;
       end;
       if Kglobal=chr(13) then begin
          esc(wherx,whery,' ',1,1,true);
          posy:=posy+1;
          posx:=1;
          maxwid:=1;
          maxline:=maxline+1;
          whery:=whery+1;
          if posy<9 then wherx:=3
          else
          wherx:=4;
          esc(1,whery,inttostr(posy),1,11,true);
          end;
      end;

    if (tick=0) or (tick=1) then esc(wherx,whery,chr(179),1,15,true);
     {Animation}
     sleep(10);
      if tick=60 then begin
        {Timer}
        if  (kglobal <> chr(0)) and (kglobal>chr(19)) and (kglobal < chr(176)) then esc(wherx-1,whery,kglobal,1,7,true);
        esc(wherx,whery,oldchar,1,14,true);
        tick:=0;
        sleep(100);
        if (olposx<>posx) or (olposy<>posy) then begin
          esc(screenwidth-20,screenheight,chr(179) + '                                                   ',7,0,true);
          esc(screenwidth-20,screenheight,chr(179) + ' Col: '+ inttostr(posx) + ' Row: ' + inttostr(posy),7,0,true);
          esc(screenwidth-20,1,chr(179) + '                   ',7,0,true);
          esc(screenwidth-20,1,chr(179) + 'Len:' + inttostr(length(filbuf[posy])) + '/' + inttostr(maxwid),7,0,true);
          end;
      end;
      tick:=tick+1;
  until (kglobal=chr(27)) or (leave=true);
end;
procedure credits;
begin
  write(chr(27) + '[2J');
  writeln('Bis bald!');
end;
Begin
  leave:=false;
  initvideo;
  initkeyboard;
  screen;
  buffer;
  fondo(0);
  setcursortype(crunderline);
  donevideo;
  donekeyboard;
  credits;
End.
