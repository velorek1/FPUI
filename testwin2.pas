Program testwin2;
Uses ptcmouse,gfxn,ptcgraph,ptccrt,gfwin,gaedch2;
var ch:char;
men: array [1..10] of tmnodo;
man: array [1..10] of tmwin;
st:string;
xpos:integer;
procedure display;
begin
  inicia(false);
  fondo(dcyanc);
  cleardevice;
  rectangl(0,0,getmaxx,getmaxy,dbluec,11,lbluec);
  boton(-10,0,getmaxx,20,1,lgreyc,true,0);
  boton(10,210,600,getmaxy-210,1,dbluec,true,0);
  boton(15,215,595,getmaxy-215,1,lgreyc,false,0);
  boton(0,getmaxy-20,getmaxx,getmaxy,1,lgreyc,true,0);
end;
procedure credits;
begin
  closegraph;
end;

procedure loadmenu;
var posy,i:word;
a:string;
begin
    esc(10,8,' - File Editor ::LinX:: Graph',dredc);
    posy:=230;
   // men[1]^ = nil;
    CMenu(men[1],lgreyc,blackc,dbluec,whitec,false);
    a:='';
    xpos:=30;
   for i:=1 to 10 do begin
      a:=a+'Menu option #' + chr(i+47) +' >>';
      if i>5 then begin xpos:=260; posy:=130; end;
      Add_item(men[1],a,xpos,posy+(i*20));
      a:='';
    end;
    Start_table_mouse(men[1],st,5,false,0,0,getmaxx,getmaxy);
    gwindow(man[1],100,men[1]^.ywhere,300,men[1]^.ywhere+300,lgreyc);
    CMenu(men[2],lgreyc,blackc,dredc,whitec,false);
    a:='';
    posy:=men[1]^.ywhere+20;
    for i:=1 to 10 do begin
      a:=a+'Menu option #' + chr(i+47) +' >>';
      Add_item(men[2],a,120,posy+(i*20));
      a:='';
    end;
    Start_vmenu_mouse(men[2],0,0,getmaxx,getmaxy);
   // posy:=men[2]^.ywhere;
    alertw(man[2],400,100,800,400,dcyanc,lgreyc,dbluec,whitec,blackc,men[2]^.nchoice,'Showing the different windows');
end;
Begin
    display;
    repeat
      loadmenu;
      ch:=readkey;
      gclosewin(man[1]);
    until (ch=#27);
    credits;
End.

