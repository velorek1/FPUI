Unit opendunit;
INTERFACE
Uses gaedch2,gfxn,ptcgraph,ptccrt,sysutils,ptcmouse,gfwin;
var st,sa:array[0..100] of string[125];
i,posy,a,b:integer;
x,y,s:longint;
aa:string;
men,men2:tmnodo;
winid,int1:tmwin;
teclap,cha:char;
lista,listd:array of string;
oldachoice,filebox,filepath:string;
listfocus:boolean;
lis1,lis2,lis3:listdata;
x1,y1,x2,y2,oldx,oldy,oldmx,oldmy,marginx,marginy:longint;
(*

*)
procedure opendialog(var dirname,filename:string);

IMPLEMENTATION

Procedure loadfiles;

Var Info : TSearchRec;
    sizel,Count,i,filecount : Longint;
Begin
  Count:=0;
  filecount:=0;
  If FindFirst ('*',faAnyFile,Info)=0 then
    begin
    Repeat
      Inc(Count);
      if info.attr=32 then filecount:=filecount+1;
    Until FindNext(info)<>0;
    if filecount>0 then setlength(lista,filecount);
    FindClose(Info);
    Count:=0;
    sizel:=length(lista);
  end;
  count:=0;
  filecount:=0;

  If FindFirst ('*',faAnyFile,Info)=0 then
    begin
    Repeat
         if info.attr = 32 then
             if count<(sizel) then begin
               lista[count]:=Info.name;
               Inc(Count);
             end;
      Until FindNext(info)<>0;
    end;
  for i:=0 to length(lista)-1 do begin
         if length(lista[i])<20 then begin
           while length(lista[i]) < 20 do begin
            lista[i] := lista[i]+chr(32)
            end;
  end;
end;
End;

procedure delay(int:longint);
var j:longint;

begin
  j:=0;
  while j<>int do begin
    j:=j+1;
    rectangl(-1,-1,-10,-10,lgreyc,1,lgreyc);
  end;
end;

procedure window_display(var winid:tmwin;x1,y1,x2,y2:longint;moving:boolean);
begin
    gwindow(winid,x1,y1,x2,y2,$7c34);
    boton(x1+5,y1+5,x2-5,y2-5,1,$bdf7,true,0);
    boton(x1+5,y1+5,x2-5,y2-490,1,$2bf8,true,0);
    escc(x1+5,y1+5,x2-5,y2-490,'Open File Dialog - Hex Editor -',whitec);
    if moving=false then boton(x1+8,y1+8,x1+27,y2-492,1,lgreyc2,true,1)
    else
    boton(x1+8,y1+8,x1+27,y2-492,1,lgreyc,false,0);
    esc(x1+13,y1+10,'_',blackc);
    rectangl(x1+20,y1+40,x2-380,y2-20,blackc,1,lgreyc);
    esc(x1+35,y1+60,'Files:',blackc);
    rectangl(x1+250,y1+40,x2-15,y2-300,blackc,1,lgreyc);
    rectangl(x1+250,y1+40,x2-15,y2-460,blackc,1,whitec);
    rectangl(x1+250,y1+245,x2-15,y2-20,blackc,1,lgreyc);
    escc(x1+250,y1+40,x2-15,y2-460,'File options',black);
    boton(x1+370,y1+170,x2-120,y2-310,1,lgreyc,true,1);
    escc(x1+370,y1+170,x2-120,y2-310,'OPEN ',blackc);
    boton(x1+490,y1+460,x2-20,y2-25,1,lgreyc,true,0);
    escc(x1+490,y1+460,x2-20,y2-25,'CANCEL',blackc);
    esc(x1+260,y1+260,'Tip:',blackc);
    esc(x1+260,y1+280,'You have to take into account whether you',blackc);
    esc(x1+260,y1+290,'are running on windows or linux. The path',blackc);
    esc(x1+260,y1+300,'format is different. By default this app',blackc);
    esc(x1+260,y1+310,'will use the linux path format.',blackc);
    esc(x1+260,y1+320,'Examples:',blackc);
    esc(x1+260,y1+350,'/home/username/file.bin on Linux',blackc);
    esc(x1+260,y1+370,'\users\username\Documents\file.exe on Win',blackc);
    if not moving then
      //vscroll_mouse(men,x1+40,y1+80,listd,4,dgreyc,whitec,whitec,dredc,false,listfocus,lis1);
      vscroll_mouse(men,x1+40,y1+80,lista,27,$352,whitec,whitec,dredc,false,listfocus,lis2)
    else
      rectangl(x1+32,y1+72,x1+220,y2-35,$352,1,$352);
    gtextbox(x1+260,y1+80,x2-60,filebox,'File:',$352,whitec,blackc,30,false);
    esc(x1+260,y1+120,'Full Path:',blackc);
    gtextbox(x1+260,y1+140,x2-20,filepath,'',$7c34,whitec,blackc,30,false);

end;

procedure opendialog(var dirname,filename:string);

Begin
    listfocus:=false;
    lis1.indx:=0;
    lis2.indx:=0;
    loadfiles;
    showmouse;
    x1:=180;
    y1:=80;
    x2:=800;
    y2:=600;
    kglobal:=#0;
    window_display(winid,x1,y1,x2,y2,false);
   oldchoice:=0;
   filename:='';
    repeat
     oldachoice:=men^.nchoice;
      getmousestate(x,y,s);
      delay(100);
      {focus on list 1}
      if (x>x1+40) and (x<x1+40+(23*8)) and (y>y1+80) and (y<y1+80+(27*15)) then
        begin
         // rectangl(-1,-1,-10,-10,lgreyc,1,lgreyc);
          listfocus:=true;
          if listfocus=true then vscroll_mouse(men,x1+40,y1+80,lista,27,$352,whitec,whitec,dredc,false,listfocus,lis2);
        end;
     {focus on list 2}
    { if (x>x1+40) and (x<x1+40+(23*8)) and (y>y1+80) and (y<y1+80+(4*15)) then
        begin
          rectangl(x1+10,y2-485,x2-10,y2-485,lgreyc,1,lgreyc);
          listfocus:=true;
          if listfocus=true then vscroll_mouse(men,x1+40,y1+80,listd,4,$352,whitec,whitec,dredc,false,listfocus,lis1);
        end;  }
    if not ((x>x1+40) and (x<x1+40+(23*8)) and (y>y1+80) and (y<y1+180+(27*15))) then
      begin
         //rectangl(-1,-1,-10,-10,lgreyc,1,lgreyc);
         listfocus:=false;
      end;
    {input file}
    if (x>x1+260) and (x<x2-60) and (y>y1+80) and (y<y1+100) and (s=1) then begin
      inputw(int1,x1+260,y1+80,x1+600,y1+200,$7c34,lgreyc2,$2b98,whitec,blackc,'- Hex Editor -','',filebox,'File: ',27);
      //gtextbox(x1+260,y1+80,x2-60,filebox,'File:',whitec,blackc,blackc,30,true);

      filename:=filebox;
      esc(x1+305,y1+80,filebox,whitec);
    end;
    {cancel button}
    if (x>x1+490) and (x<x2-20) and (y>y1+460) and (y<y2-25) and (s=1) then
    begin
      boton(x1+490,y1+460,x2-20,y2-25,1,lgreyc,false,0);
      escc(x1+490,y1+460,x2-20,y2-25,'CANCEL',blackc);
      delay(100000);
      boton(x1+490,y1+460,x2-20,y2-25,1,lgreyc,true,0);
      escc(x1+490,y1+460,x2-20,y2-25,'CANCEL',blackc);
      filename:='';
      break;
    end;
    {open button}
    if (x>x1+370) and (x<x2-120) and (y>y1+170) and (y<y2-310) and (s=1) then
    begin
      boton(x1+370,y1+170,x2-120,y2-310,1,lgreyc,false,1);
      escc(x1+370,y1+170,x2-120,y2-310,'OPEN ',blackc);
      delay(100000);
      boton(x1+370,y1+170,x2-120,y2-310,1,lgreyc,true,1);
      escc(x1+370,y1+170,x2-120,y2-310,'OPEN ',blackc);
      dirname:=trim(lis1.choice);
      if filename='' then filename:=trim(lis2.choice);
      break;
    end;
     if keypressed then cha:=readkey;
    {if item is selected}
     if men^.nchoice<>oldachoice then begin
        filebox:=trim(lis2.choice);
        //gtextbox(x1+260,y1+80,x2-60,filebox,'File:',$352,whitec,blackc,30,false);
        esc(x1+260,y1+120,'Full Path:',blackc);
        gtextbox(x1+260,y1+140,x2-20,filepath,'',$7c34,whitec,blackc,30,false);
        esc(x1+263,y1+140,trim(getcurrentdir) +'/'+ trim(lis2.choice),whitec);
     end;
    {move window}
    if (x>x1+8) and (x<x1+27) and (y>y1+8) and (y<y2-492) and (s=1) then
    begin
     boton(x1+8,y1+8,x1+27,y2-492,1,lgreyc2,false,0);
     esc(x1+13,y1+10,'_',blackc);
     oldx:=x2-x1;
     oldy:=y2-y1;
     marginx:=x1;
     marginy:=y1;
     while s=1 do begin
        oldmx:=x;
        oldmy:=y;
        getmousestate(x,y,s);
        if (oldmx<>x) and (oldmy<>y) then begin
          //rectangl(x1+(x-x1),y1+(y-y1),x2-(x1-x),y2-(y1-y),dredc,1,random(6555));
          gclosewin(winid);
          //delay(10);
          window_display(winid,x1+(x-x1),y1+(y-y1),x2-(x1-x),y2-(y1-y),true);
        end;
      end;
      x1:=x1-(marginx-x);
      y1:=y1-(marginy-y);
      x2:=x1+oldx;
      y2:=y1+oldy;
    gclosewin(winid);
    window_display(winid,x1,y1,x2,y2,false);
    end;
   until (kglobal=#27) or (cha=#27);
 if kglobal=#27 then filename:='';
 kglobal:=#0;
 cha:=#0;
 gclosewin(winid);

End;
begin
end.

