Program openfile;
Uses aedcho2,video,keyboard,vidutil,winvideo,sysutils;
var ch:char; c,i,j:integeR;
menu1:tmnodo;
win1:array[0..1] of tmwin;
lista:array of string;
filecount,dircount,endx : longint;
filearray : array of string;
path,mess1:string;
procedure listfiles(path:string);
Var Info : TSearchRec;
    Count : Longint;
    temp:string;
    indx,dirx,i:longint;
    Begin
    setlength(filearray,0);
      Count:=0;
      filecount:=0;
      dircount:=0;
        If FindFirst (path,faAnyFile and faDirectory,Info)=0 then
        begin
          Repeat
          Inc(Count);
          With Info do
            begin
              If (Attr and faDirectory) = faDirectory then
              dircount:=dircount+1
              else
              filecount:=filecount+1;
            end;
          Until FindNext(info)<>0;
          end;
          FindClose(Info);
      Count:=0;
      mess1:='Dir: ' +inttostr(dircount)+ ' ' +chr(179) +' ' + 'Files: '+ inttostr(filecount);
      esc((screenwidth-19) - length(mess1),2,mess1,3,15,true);
        setlength(filearray,filecount+dircount);
        indx:=dircount;
        temp:='';
        for i:=0 to ((screenwidth-40)-3) do temp:=temp+' ';
        filearray[0] :='<.>'+temp;
        temp:='';
        for i:=0 to ((screenwidth-40)-4) do temp:=temp+' ';
        filearray[1] :='<..>'+temp;
        dirx:=2;
        temp:='';
      if (filecount>0) or (dircount>2) then begin
        If FindFirst (path,faAnyFile and faDirectory,Info)=0 then
        begin
          Repeat
          Inc(Count);
          With Info do
            begin
              If (Attr and faDirectory) = faDirectory then begin
                if (name <> '.') and (name <>'..') then begin
                 for i:=0 to ((screenwidth-40)-length(name)-2) do temp:=temp+' ';
                 filearray[dirx] :='<'+ name +'>' +temp;
                 dirx:=dirx+1;
                 temp:='';
                end;
              end
              else begin
               if filecount>0 then begin
               for i:=0 to ((screenwidth-40)-length(name)) do temp:=temp+' ';
               filearray[indx] := name+temp;
               indx:=indx+1;
               temp:='';
               end;
              end;
            end;
          Until FindNext(info)<>0;
          end;
          FindClose(Info);
      end;
end;
procedure credits;
begin
  write(chr(27) + '[2J');
  writeln(trim(menu1^.nchoice) +': Bis bald!');

end;

Begin
  initvideo;
  initkeyboard;
  randomize;
  fondo(1);
  listfiles('*');
  opwindow(win1[0],11,3,screenwidth-19,screenheight-1,0);
  opwindow(win1[1],10,2,screenwidth-20,screenheight-2,7);

  path:='';
      esc((screenwidth-19) - length(mess1),2,mess1,3,15,true);
      esc(10,2,'Path: '+ Getcurrentdir,3,15,true);
  repeat
    vscroll(menu1,15,3,filearray,screenheight-6,7,0,1,15);
    if menu1^.nchoice[1] ='<' then begin
      for i:=0 to length(menu1^.nchoice) do if menu1^.nchoice[i]='>' then endx:=i;
      for i:=2 to endx-1 do path:=path+menu1^.nchoice[i];
      closewin(win1[1]);
//      closewin(win1[0]);
//      opwindow(win1[0],11,3,screenwidth-19,screenheight-1,0);
      opwindow(win1[1],10,2,screenwidth-20,screenheight-2,7);
      setcurrentdir(path);
      listfiles('*');
      esc(10,2,'Path: ' + Getcurrentdir,3,15,true);
      path:='';
    end;
 if (menu1^.nchoice[1] <>'<') and (kglobal=#13) then break;
  until kglobal=#27;
  updatescreen(true);
  donevideo;
  donekeyboard;
  credits;
End.
