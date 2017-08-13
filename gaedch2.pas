(* Coded by Freyr, Norse God of Rain *)
(* Adapted for LiNuX *)
Unit gAEDCh2;
INTERFACE
Uses PtcCrt,Gfxn,Ptcmouse,Ptcgraph,sysutils;
Type
        tmNodo = ^tmenulist;
        tMenulist = record
                        nChoice :string; {New choice}
                        nListCount :word; {# elements}
                        mBackColor : word; {Background color}
                        mForeColor : word; {Foreground color}
                        mSBackColor : word; {BC when selected}
                        mSForeColor : word; {FC when selected}
                        soSub : boolean; {pressed?}
                        xWhere : integer;
                        yWhere : integer;
                        mNext : tmNodo; {Move forward}
                        mBack : tmNodo; {move backward}

                    end;
        listdata = record  {progress}
                        pointer : longint;
                        dir: boolean;
                        indx:longint;
                        choice: string;
                        inumber:longint;
                end;

Var
        ErrorCode     : integer; { errorcode standard Int}
    kglobal	      : char;  {monitors key strokes }
        mfirst,mLast,mCurrent  : tmNodo; {Shorcut pointers to list}
        b2,f2,bs2,fs2 : word;
   daIndex,oldchoice,lastpointer,lastinumber : integer; { List's Cardinal}
   firsttime,sub      :  Boolean; { To control whether an opt. was selected for the first time}
Procedure cMenu(var mHandler: tmNodo;b1,f1,bs1,fs1:word;subx:boolean);
Procedure Add_item(var mHandler	: tmNodo;nItem:string;x,y:integer);
Procedure Update(var mHandler	: tmNodo;nItem:string;num:integer);
Procedure Start_vMenu(var mHandler:tmNodo);
Procedure Start_vMenu_mouse(var mHandler:tmNodo;rgx1,rgy1,rgx2,rgy2:integer);
Procedure Start_hMenu(var mHandler: tmNodo);
Procedure Start_hMenu_mouse(var mHandler: tmNodo;rgx1,rgy1,rgx2,rgy2:integer);
Procedure ChartoInt(ch:char;var i:byte);
Procedure Start_Table(mHandler: tmNodo;var mdata:string; cols : integer; vertical:boolean);
Procedure Start_Table_mouse(var mHandler: tmNodo;var mdata:string; cols : integer; vertical:boolean;rgx1,rgy1,rgx2,rgy2:integer);
Procedure gotoP(var mHandler:tmNodo;po:integer);
procedure vscroll(var menu1:tmnodo;x1,y1:integer;list1:array of string;show_index,b1,f1,bs1,fs1:word;pressed:boolean);
procedure vscroll_mouse(var menu1:tmnodo;x1,y1:integer;list1:array of string;show_index,b1,f1,bs1,fs1:word;pressed:boolean;var listafocus:boolean;var listdt:listdata);
Procedure Crumble(var mHandler : tmNodo);
Procedure mDisplay;

IMPLEMENTATION
Procedure ChartoInt(ch:char;var i:byte);
var j:byte;
begin
    for j:=0 to 255 do
             begin
                  if chr(j) = ch then i:=j;
             end;
End;

Procedure Crumble(var mHandler : tmNodo);
{ Disposes the memory}
var aux,aux2	: tmNodo;
Begin
   aux:=mLast;
   while aux <> mFirst do
   Begin
      aux2:=aux;
      dispose(aux2);
      aux:=aux^.mback;
   End;
End;
Procedure mDisplay;
var
aux:tmNodo;
Begin
      aux:=mFirst;
      while aux <> mFirst^.mBack do begin

               rectangl(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,b2,1,b2);
               esc(aux^.xwhere,aux^.ywhere,aux^.nchoice,aux^.mForecolor);

               aux:=aux^.mNext;
     end;
     //draw last item
              rectangl(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,b2,1,b2);
              esc(aux^.xwhere,aux^.ywhere,aux^.nchoice,aux^.mForecolor);
              aux:=aux^.mNext;

end;
Procedure cMenu(var mHandler:tmNodo;b1,f1,bs1,fs1:word;subx:boolean);
(* Creates the group associated to the menu array
mHandler => Dyanamic List.
MID => Group's name identifier.
b1,f1 => back & fore ground colors ; bs1,fs1 => colors when selected
*)
Begin
        daIndex:=1;
        mFirst := nil;
        mCurrent := nil;
        {mcurrent^.nlistcount:=0;}
        firsttime:=true;
        mHandler := nil; {initiate the dynamic list}
        b2:=b1;
        f2:=f1;
        bs2:=bs1;
        fs2:=fs1;
        sub:=subx;
End;
Procedure Add_item(var mHandler:tmNodo;nItem:string;x,y:integer);
(**)
var current,other,former:tmNodo;
Begin
        If ((mHandler=nil) and (mFirst = nil)) then begin
                new(mHandler);
                  with mHandler^  do begin
                        mback := nil;
                        nListCount := daIndex;
                        nChoice := nItem;
                        mBackColor := b2;
                        mForeColor := f2;
                        mSBackColor := bs2;
                        mSForeColor := fs2;
                        xWhere := x;
                        yWhere := y;
                        soSub := sub;
                        mFirst := mHandler; {Always points to #1 item }
                        Former:=mFirst;
                        current:=former;
                        mBack:=nil;
		     mFirst^.mNext := mFirst;
		     mFirst^.mBack := mFirst;
		     mLast:=mFirst;
		  end;

        End
        Else Begin
                Former:=Current;
                new(other);
                former^.mNext := other;
                other^.mBack := former;
   	        mLast := other; {Always points to latest item}
                mFirst^.mBack := mLast; {we close the circular list}
	       other^.mNext :=  mFirst;
	      daIndex := daIndex +1;
   	          with other^ do Begin
        		nListCount := daIndex;
                        nChoice := nItem;
                        mBackColor := b2;
                        mForeColor := f2;
                        mSBackColor := bs2;
                        mSForeColor := fs2;
                        soSub := sub;
                        xWhere := x;
                        yWhere := y;
                        mLast^.mNext := mFirst;
		  end;
                Current := other;
                {mhandler^.nlistCount := other^.nListCount;
	        mhandler^.nchoice := other^.nchoice;}

	End;
End;
Procedure Move_down(var auxx:tmNodo);
Begin
        {former item}
        rectangl(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,b2,1,b2);
        esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mForecolor);
        auxx:=auxx^.mNext;

        {next item}
        if auxx^.sosub=false then
          Boton(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,1,auxx^.mSBackcolor,true,0)
        else
          Boton(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,1,auxx^.mSBackcolor,false,0);
        esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mSForecolor);


End;
Procedure Move_up(var auxx:tmNodo);
var g:tmnodo;
Begin
        {former item}
        rectangl(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,b2,1,b2);
        esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mForecolor);
        {next item}
        g:=auxx^.mback;
        if g^.sosub=false then
         Boton(g^.xwhere-4,g^.ywhere-4,g^.xwhere+(length(g^.nChoice)*8)+2,g^.ywhere+10,1,g^.mSBackcolor,true,0)
        else
         Boton(g^.xwhere-4,g^.ywhere-4,g^.xwhere+(length(g^.nChoice)*8)+2,g^.ywhere+10,1,g^.mSBackcolor,false,0);

        esc(g^.xwhere,g^.ywhere,g^.nChoice,g^.mSForecolor);
        auxx:=auxx^.mBack;

End;
Procedure move_tleft(var auxx : tmNodo;cols:integer);
var fcol : integer;
Begin
   {former item}
   rectangl(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,b2,1,b2);
   esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mForecolor);
   {locate item}
   fCol:=auxx^.nListCount;
   while auxx^.nListCount < (cols + fcol) do begin
      if (cols + fCol) <= daIndex then
	 auxx:=auxx^.mNext
      else
	 Begin
	    {If overflow in search is produced}
	    auxx:=mLast;
	    break;
	 end;
   end;
   {next item}
   if auxx^.sosub=false then
     Boton(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,1,auxx^.mSBackcolor,true,0)
   else
     Boton(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,1,auxx^.mSBackcolor,false,0);
   esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mSForecolor);

End; { move_tleft }
Procedure move_tright(var auxx : tmNodo;cols:integer);
var fcol : integer;
Begin
   {former item}
   rectangl(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,b2,1,b2);
   esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mForecolor);
   {locate item}
   fCol:=auxx^.nListCount;
   while auxx^.nListCount > (fcol-cols) do begin
      if (fcol-cols) > 1 then
	 auxx:=auxx^.mBack
      else
	 Begin
	    {If overflow in search is produced}
	    auxx:=mFirst;
	    break;
	 end;
   end;
   {next item}
   if auxx^.sosub=false then
     Boton(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,1,auxx^.mSBackcolor,true,0)
   else
     Boton(auxx^.xwhere-4,auxx^.ywhere-4,auxx^.xwhere+(length(auxx^.nChoice)*8)+2,auxx^.ywhere+10,1,auxx^.mSBackcolor,false,0);
   esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mSForecolor);
End;
Procedure Start_vMenu(var mHandler : tmNodo);
var aux:tmNodo;
ch:char;
Begin

        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1;
           //     Writeln('Error ',ErrorCode,': no items found');
        end
        Else Begin
               aux:=mFirst;
               if aux^.sosub=false then
                 Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
               else
                 Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,false,0);
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);

                 Repeat
                        ch:=readkey;
                        Case ch of
                                #80 : move_down(aux);
                                #72 : move_up(aux);
			End;
		   kglobal:=ch;
		until ((ch=#27) or (ch=#13));
        mHandler:=aux;
        mHandler^.nChoice := Aux^.nChoice;
        mHandler^.nListCount := Aux^.nListCount;
        firsttime:=false;

	   kGlobal:=ch;
	End;
   End;
Procedure Start_vMenu_Mouse(var mHandler : tmNodo;rgx1,rgy1,rgx2,rgy2:integer);
var aux:tmNodo;
ch:char;
x,y,s,lastx,lasty:longint;
t:integer;
inrange,locked:boolean;
function collision(mhandler:tmnodo;x,y:integer;var t:integer):boolean;
//check whether the mouse coordinates collide with the list items
var
 px,px2,py,py2:integer;
 aux:tmNodo;
 upperbound,b:integer;
Begin
     aux:=mLast;
//     mHandler:=aux;
     upperbound:=aux^.nlistcount;
     b:=upperbound+1;
      while b <> 0 do begin
        rectangl(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,b2,1,b2);
        esc(aux^.xwhere,aux^.ywhere,aux^.nchoice,aux^.mForecolor);
        b:=b-1;
        px:=aux^.xwhere-4;
        px2:=aux^.xwhere+(length(aux^.nChoice)*8)+2;
        py:=aux^.ywhere-4;
        py2:=aux^.ywhere+10;
        if (x>=px) and (x<=px2) and (y>=py) and (y<=py2) then  begin
          collision:=true;
          t:=b;
          break;
        end
        else
        collision:=false;
        aux:=aux^.mBack;
       end;
End;
Begin

        mDisplay;
        t:=0;
        inrange:=false;
        if mFirst = nil then Begin
                ErrorCode:=1;
           //     Writeln('Error ',ErrorCode,': no items found');
        end
        Else Begin
               aux:=mFirst;
               if aux^.sosub=false then
                 Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
               else
                 Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,false,0);
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);
               s:=0;
               x:=0;
               y:=0;
                 Repeat
                    {mouse operations}
                    showmouse;
                    lastx:=x;
                    lasty:=y;
                    getmousestate(x,y,s);
                   if (x>=rgx1) and (x<=rgx2) and (y>=rgy1) and (y<=rgy2) then locked:=true
                   else
                   locked:=false;

                    if (not keypressed) and ((x<>lastx) or (y<>lasty)) then begin
                       inrange:=false;
                       if collision(aux,x,y,t) then begin
                        gotop(aux,t);
                        inrange:=true;
                       end;
                    end;
                    if (inrange=true) and (s=1) then break;
                    if keypressed then begin
                      if t<>0 then begin gotop(aux,t); t:=0; end;
                      ch:=readkey;
                    end;

                    {End mouse}
                        Case ch of
                                #80 : move_down(aux);
                                #72 : move_up(aux);
                                #13: break;
                                #27: break;
			End;
		   kglobal:=ch;
                   ch:=#0;
		until ((ch=#27) or (ch=#13)) or (locked=false);
        mHandler:=aux;
        mHandler^.nChoice := Aux^.nChoice;
        mHandler^.nListCount := Aux^.nListCount;
        firsttime:=false;
        kglobal:=ch;
	if (ch=#0) and (s=1) then kGlobal:=#1; //mouse clicked
	End;
   End;

Procedure Start_hMenu(var mHandler : tmNodo);
var aux:tmNodo;
ch:char;
Begin

        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1;
             //   Writeln('Error ',ErrorCode,': no items found');
        end
        Else Begin
               aux:=mFirst;
               if aux^.sosub=false then
                 Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
               else
                 Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,false,0);
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);
                Repeat
                ch:=readkey;
                        Case ch of
                                #77 : move_down(aux);
                                #75 : move_up(aux);
			End;
		   kglobal:=ch;
		until ((ch=#27) or (ch=#13));
        mHandler:=aux;
        mHandler^.nChoice := Aux^.nChoice;
        mHandler^.nListCount := Aux^.nListCount;
        firsttime:=false;

	   kGlobal:=ch;
	End;
   End;
Procedure Start_hMenu_mouse(var mHandler : tmNodo;rgx1,rgy1,rgx2,rgy2:integer);
var aux:tmNodo;
ch:char;
x,y,s,lastx,lasty:longint;
t:integer;
inrange,locked:boolean;
function collision(mhandler:tmnodo;x,y:integer;var t:integer):boolean;
//check whether the mouse coordinates collide with the list items
var
 px,px2,py,py2:integer;
 aux:tmNodo;
 upperbound,b:integer;
Begin
     aux:=mLast;
//     mHandler:=aux;
     upperbound:=aux^.nlistcount;
     b:=upperbound+1;
      while b <> 0 do begin
        rectangl(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,b2,1,b2);
        esc(aux^.xwhere,aux^.ywhere,aux^.nchoice,aux^.mForecolor);
        b:=b-1;
        px:=aux^.xwhere-4;
        px2:=aux^.xwhere+(length(aux^.nChoice)*8)+2;
        py:=aux^.ywhere-4;
        py2:=aux^.ywhere+10;
        if (x>=px) and (x<=px2) and (y>=py) and (y<=py2) then  begin
          collision:=true;
          t:=b;
          break;
        end
        else
        collision:=false;
        aux:=aux^.mBack;
       end;
End;
Begin

        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1;
             //   Writeln('Error ',ErrorCode,': no items found');
        end
        Else Begin
               aux:=mFirst;
               if aux^.sosub=false then
                 Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
               else
                 Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,false,0);
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);
               s:=0;
               inrange:=false;
               x:=0;
               y:=0;
               Repeat
                    {mouse operations}
                    showmouse;
                    lastx:=x;
                    lasty:=y;
                    getmousestate(x,y,s);
                    if (not keypressed) and ((x<>lastx) or (y<>lasty)) then begin
                       inrange:=false;
                       if collision(aux,x,y,t) then begin
                        gotop(aux,t);
                        inrange:=true;
                       end;
                    end;
                    if (inrange=true) and (s=1) then break;
                   if (x>=rgx1) and (x<=rgx2) and (y>=rgy1) and (y<=rgy2) then locked:=true
                   else
                   locked:=false;
                    if keypressed then begin
                      if t<>0 then begin gotop(aux,t); t:=0; end;
                      ch:=readkey;
                    end;
                    {End mouse}

                        Case ch of
                                #77 : move_down(aux);
                                #75 : move_up(aux);
                                #13 : break;
                                #27:  break;
			End;
		   kglobal:=ch;

                ch:=#0;
	until ((ch=#27) or (ch=#13)) or (locked=false);
        mHandler:=aux;
        mHandler^.nChoice := Aux^.nChoice;
        mHandler^.nListCount := Aux^.nListCount;
        firsttime:=false;

	   kGlobal:=ch;
	if (ch=#0) and (s=1) then kGlobal:=#1; //mouse clicked
	End;
   End;

Procedure gotoP(var mHandler:tmNodo; po : integer);
{go to selected item}
var aux:tmnodo;
upperbound,b:integer;
Begin
     aux:=mLast;
     mHandler:=aux;
     upperbound:=aux^.nlistcount;
     b:=0;
     if upperbound >= po then
     Begin
      b:=upperbound;
      while b <> po do begin
        rectangl(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,b2,1,b2);
        esc(aux^.xwhere,aux^.ywhere,aux^.nchoice,aux^.mForecolor);
        b:=b-1;
        aux:=aux^.mBack;
     end;
   if aux^.sosub=false then
     Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
   else
     Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,false,0);
   esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);

   mhandler:=aux;
  End;
End;
Procedure Update(var mHandler: tmNodo;nItem:string;num:integer);
Begin

    mHandler:=mCurrent;
//    rectangl(mhandler^.xwhere-4,mhandler^.ywhere-4,mhandler^.xwhere+(length(mhandler^.nChoice)*8)+2,mhandler^.ywhere+10,b2,1,b2);
//    esc(mhandler^.xwhere,mhandler^.ywhere,mhandler^.nchoice,mhandler^.mForecolor);

//    textcolor(mHandler^.mForecolor);
//    textbackground(mHandler^.mBackcolor);
    {mhandler^.nListcount:=aux^.nListcount;}
    mhandler^.nChoice:=nItem;
End;
Procedure Start_Table(mHandler:tmnodo;var mdata:string; cols : integer; vertical:boolean);
var aux	: tmNodo;
   ch	: char;
Begin
   mdisplay;
   if firsttime=true then
   begin
   aux:=mFirst;
   if aux^.sosub=false then
     Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
   else
     Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,false,0);
   esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);
   end
  else
   begin
   gotoP(aux,mCurrent^.nlistcount);
   gotoxy(mCurrent^.xwhere,mCurrent^.ywhere);
   end;
   move_down(aux);
   move_up(aux);
   Repeat
      ch:=readkey;
      kglobal:=ch;
      if vertical = false then
      begin
      case ch of
	#80 : move_down(aux);
	#72 : move_up(aux);
	#77 : move_tleft(aux,cols);
	#75 : move_tright(aux,cols);
        else
            ch:=chr(0);
      end;
    end
    else
    begin
    case ch of
        #77 : move_down(aux);
	#75 : move_up(aux);
	#80 : move_tleft(aux,cols);
	#72 : move_tright(aux,cols);
        else
            ch:=chr(0);
      end;

    end;

    until ((KGLOBAL=#27) or (KGLOBAL=#13));
  mCurrent:=aux;
  mCurrent^.nChoice := Aux^.nChoice;
  mCurrent^.nListCount := Aux^.nListCount;
  {mCurrent^.xwhere := wherex;
  mCurrent^.ywhere := wherey; }
  mdata:=aux^.nChoice;
  firsttime:=false;
End;
Procedure Start_Table_mouse(var mHandler:tmnodo;var mdata:string; cols : integer; vertical:boolean;rgx1,rgy1,rgx2,rgy2:integer);
var aux	: tmNodo;
   ch	: char;
x,y,s,lastx,lasty:longint;
t:integer;
inrange,locked:boolean;
function collision(var mhandler:tmnodo;x,y:integer;var t:integer):boolean;
//check whether the mouse coordinates collide with the list items
var
 px,px2,py,py2:integer;
 aux:tmNodo;
 upperbound,b:integer;
Begin
     aux:=mLast;
     mHandler:=aux;
     upperbound:=aux^.nlistcount;
     b:=upperbound+1;
      while b <> 0 do begin
        rectangl(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,b2,1,b2);
        esc(aux^.xwhere,aux^.ywhere,aux^.nchoice,aux^.mForecolor);
        b:=b-1;
        px:=aux^.xwhere+2;
        px2:=aux^.xwhere+(length(aux^.nChoice)*8)+2;
        py:=aux^.ywhere-4;
        py2:=aux^.ywhere+10;
        if (x>=px) and (x<=px2) and (y>=py) and (y<=py2) then  begin
          collision:=true;
          t:=b;
          mcurrent:=aux;
          mCurrent^.nChoice := Aux^.nChoice;
          mCurrent^.nListCount := Aux^.nListCount;
          mdata:=aux^.nChoice;
          break;
        end
        else
        collision:=false;
        aux:=aux^.mBack;
       end;
End;

Begin
   mdisplay;
   aux:=mfirst;
 //  gotoP(aux,mCurrent^.nlistcount);
   inrange:=false;
   x:=0;
   y:=0;
   Repeat
        {mouse operations}
        showmouse;
        lastx:=x;
        lasty:=y;
        getmousestate(x,y,s);
        if (not keypressed) and ((x<>lastx) or (y<>lasty)) then begin
        inrange:=false;
          if collision(aux,x,y,t) then begin
            gotop(aux,t);
            inrange:=true;
          end;
        end;
        if (x>=rgx1) and (x<=rgx2) and (y>=rgy1) and (y<=rgy2) then begin
          if t<>0 then begin gotop(aux,t); t:=0; end;
          locked:=true;
        end
        else
            locked:=false;
        if keypressed then begin
          if t<>0 then begin gotop(aux,t); t:=0; end;
            ch:=readkey;
        end;
        {End mouse}

      kglobal:=ch;
      if vertical = false then
      begin
      case ch of
	#80 : move_down(aux);
	#72 : move_up(aux);
	#77 : move_tleft(aux,cols);
	#75 : move_tright(aux,cols);
        #27 : break;
        #13 : break;
        else
            ch:=chr(0);
      end;
    end
    else
    begin
    case ch of
        #77 : move_down(aux);
	#75 : move_up(aux);
	#80 : move_tleft(aux,cols);
	#72 : move_tright(aux,cols);
        #27 : break;
        #13 : break;
        else
            ch:=chr(0);
      end;

    end;
    ch:=#0;
    if (inrange=true) and (s=1) then break;
    until ((KGLOBAL=#27) or (KGLOBAL=#13)) or (locked=false);
  mHandler:=aux;
  mHandler^.nChoice := Aux^.nChoice;
  mHandler^.nListCount := Aux^.nListCount;
  {mCurrent^.xwhere := wherex;
  mCurrent^.ywhere := wherey; }
  mdata:=aux^.nChoice;
  if (ch=#0) and (s=1) then kGlobal:=#1; //mouse clicked
end;
procedure vscroll(var menu1:tmnodo;x1,y1:integer;list1:array of string;show_index,b1,f1,bs1,fs1:word;pressed:boolean);
var
  aux:tmNodo;
  inumber,factor:integer;
  pointer,pointix:integer;
  dir,endx:boolean;
Procedure Start_vList(var mHandler:tmNodo;displaynum:integer);
var ch:char;
Begin
       mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1;
                Writeln('Error ',ErrorCode,': no items found');
        end
        Else Begin
               aux:=mFirst;
               gotop(aux,displaynum);
if aux^.sosub=false then
Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
else
Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,false,0);

               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);

         Repeat
        ch:=readkey;

          if aux^.nlistcount=1 then begin dir:=false; endx:=false; end;
          if aux^.nlistcount>1 then dir:=true;
          if aux^.nlistcount+pointer=inumber then endx:=true;

               if (ch=#80) and (aux=mlast) then  break;
               if (ch=#72) and (aux=mfirst) then break;
                        Case ch of
                                #80 : begin  move_down(aux);  end;
                                #72 : begin  move_up(aux); end;
			End;
	   kglobal:=ch;

               until ((ch=#27) or (ch=#13));
        mCurrent:=aux;
        mCurrent^.nChoice := Aux^.nChoice;
        mCurrent^.nListCount := Aux^.nListCount;
        mHandler:=aux;
        firsttime:=false;

	   kGlobal:=ch;
	End;
   End;

procedure loadlist(pointer:integer);
var
  y,line:integer;
begin
 line:=1;
 inumber:=length(list1);
 if inumber>=show_index then begin
   factor:=inumber - (show_index-1);
   if pointer<inumber then begin
     for y:=pointer to pointer+show_index-1 do begin
       add_item(menu1,list1[y],x1,y1+line);
       line:=line+15;
     end;
   end;
 end;
end;

BEGIN
 inumber:=length(list1); {Total number of elements in array}
 if inumber>=show_index then begin
   cMenu(menu1,b1,f1,bs1,fs1,pressed);
   pointer:=0;  {Counter of items}
   pointix:=1;  {Pointer to the item in the list}
   loadlist(0);
   endx:=false;
   repeat

       if pointer < inumber then begin
          if (pointer<factor-1) and (pointer>=0) then begin
            start_vlist(menu1,pointix);

            if kglobal=#80 then begin
              pointer:=pointer+1;
              pointix:=show_index;
            end;
          end;

          if (pointer>0) and (kglobal=#72) then begin
            pointer:=pointer-1;
            pointix:=1;
          end;
       end;

     if pointer < inumber then begin
       crumble(menu1);
       cMenu(menu1,b1,f1,bs1,fs1,pressed);
       loadlist(pointer);
     end;

     if pointer=factor-1 then begin
      start_vlist(menu1,pointix);
     end;

     until (kglobal=#27) or (kglobal=#13);
    if dir=true then gotop(menu1,aux^.nlistcount+1);
    if (dir=false) or (endx=true) then gotop(menu1,aux^.nlistcount);
end
else
    { writeln('List is shorter than display');}
END;
procedure vscroll_mouse(var menu1:tmnodo;x1,y1:integer;list1:array of string;show_index,b1,f1,bs1,fs1:word;pressed:boolean;var listafocus:boolean;var listdt:listdata);
var
  aux:tmNodo; {dummy pointer}
  boxx,boxy:longint; {upper x and upper y}
  inumber,factor:integer;  {scroll}
  pointer,pointix:integer;  {scroll}
  dir,endx:boolean;   {fix the choice}
  x,y,s:longint;  {mouse coordinates}
  laststate,lastchoice:integer;   {check whether mouse state changes}
  t:integer; {current choice}
  inrange,selected:boolean;  {inrange: toggle/untoggle mouse; selected: item is selected}
  notscroll:boolean; {if not scroll is needed}

function collision(mhandler:tmnodo;x,y:integer;var t:integer;var inrange:boolean):boolean;
//check whether the mouse coordinates collide with the list items
var
 px,px2,py,py2:integer;
 aux:tmNodo;
 upperbound,b:integer;
Begin
if inrange then begin
{only when the mouse is in range and the button is pressed}
     aux:=mLast;
     upperbound:=aux^.nlistcount;
     b:=upperbound+1;
      while b <> 0 do begin
        rectangl(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,b2,1,b2);
        esc(aux^.xwhere,aux^.ywhere,aux^.nchoice,aux^.mForecolor);
        b:=b-1;
        px:=aux^.xwhere-4;
        px2:=aux^.xwhere+(length(aux^.nChoice)*8)+2;
        py:=aux^.ywhere-4;
        py2:=aux^.ywhere+10;
        if (x>=px) and (x<=px2) and (y>=py) and (y<=py2) then  begin
          collision:=true;
          t:=b;
          break;
        end
        else
        collision:=false;
        aux:=aux^.mBack;
       end;
end;
End;


Procedure Start_vList(var mHandler:tmNodo;displaynum:integer);
var ch:char;
Begin

        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1;
                Writeln('Error ',ErrorCode,': no items found');
        end
        Else Begin
               aux:=mFirst;
        if notscroll then gotop(aux,lastchoice); {start the item on the last item selected when notscroll}
        if notscroll=false then begin
           if endx=false then gotop(aux,displaynum)
            else
              begin
                 //fix a minor bug
                if listdt.pointer=0 then gotop(aux,displaynum+1)
                else
                 gotop(aux,displaynum);
              end;
         end;
if aux^.sosub=false then
Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
else
Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,false,0);

               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);
        //Design

         Repeat
        showmouse;
        getmousestate(x,y,s);
     {check whether scroll buttons are pressed}
     if notscroll then begin
     {buttons appear inactive}
      boton(boxx,y1-6,boxx+20,y1+16,1,dgreyc,true,0);   {up}
      escc(boxx,y1-6,boxx+17,y1+16,':',0);
      boton(boxx,boxy-20,boxx+20,boxy,1,dgreyc,true,0); {down}
      escc(boxx,boxy-20,boxx+17,boxy,':',0);
     end
     else begin
     {buttons appear active}
      boton(boxx,y1-6,boxx+20,y1+16,1,lgreyc,true,0);   {up}
      escc(boxx,y1-6,boxx+17,y1+16,':',0);
      boton(boxx,boxy-20,boxx+20,boxy,1,lgreyc,true,0); {down}
      escc(boxx,boxy-20,boxx+17,boxy,':',0);
     end;
     if (x>=boxx) and (x<=boxx+20) and (y>=y1-6) and (y<=y1+16) and (s=1) and (notscroll =false) then begin
      ch:=#0;
      boton(boxx,y1-6,boxx+20,y1+16,1,lgreyc,false,0);   {up}
      escc(boxx,y1-6,boxx+17,y1+16,':',0);
      gotop(aux,1);
      ch:=#72;
      inrange:=false;
      selected:=false;
     end;
     if (x>=boxx) and (x<=boxx+20) and (y>=boxy-20) and (y<=boxy) and (s=1) and (notscroll=false) then begin
      ch:=#0;
      boton(boxx,boxy-20,boxx+20,boxy,1,lgreyc,false,0); {down}
      escc(boxx,boxy-20,boxx+17,boxy,':',0);
      gotop(aux,show_index);
      ch:=#80;
      inrange:=false;
      selected:=false;
     end;

     {end}
      if collision(aux,x,y,t,inrange) and (s=1)  then begin
           {inrange controls whether the mouse is in range}
            mdisplay;
            gotop(aux,t);
            selected:=true;
            laststate:=t;
          end;
           if selected then begin
             gotop(aux,laststate);
           end;
        if (x>=x1) and (x<=boxx) and (y>=y1) and (y<=boxy) and (s=1) then  begin
          inrange:=true;
        end;

        if {(s=1) and} not((x>=x1) and (x<=boxx+40) and (y>=y1) and (y<=boxy)) then begin
           // when clicked elsewhere
          // mdisplay;
           listafocus:=false;
           //if aux<>mFirst then dir:=true;
          // break;
        end;

         if keypressed then begin selected:=false; inrange:=false; ch:=readkey; end;
         {fix a minor bug of the choice}
          if aux^.nlistcount=1 then begin lastpointer:=0; dir:=false; endx:=false; end;
          if aux^.nlistcount>1 then dir:=true;
          if aux^.nlistcount+pointer=inumber then endx:=true;
          if aux^.nlistcount+listdt.pointer=inumber then endx:=true;

               if (ch=#80) and (aux=mlast) then  break;
               if (ch=#72) and (aux=mfirst) then break;
	  kglobal:=ch;
                        Case ch of
                                #80 : begin  move_down(aux); ch:=#0;  end;
                                #72 : begin  move_up(aux); ch:=#0; end;
			End;

               until ((ch=#27) or (ch=#13)) or (listafocus=false);
        mCurrent:=aux;
        mCurrent^.nChoice := Aux^.nChoice;
        mCurrent^.nListCount := Aux^.nListCount;
        if notscroll then begin
                listdt.indx:=aux^.nlistcount;  {record last selected item for not scroll}
                listdt.choice := aux^.nchoice;
        end;
        mHandler:=aux;
        firsttime:=false;

	   kGlobal:=ch;
	End;
   End;

procedure loadlist(pointer:integer);
var
  y,line:integer;
begin
 line:=1;
 inumber:=length(list1);
 if inumber>=show_index then begin
   {when we have more elements, begin scroll}
   factor:=inumber - (show_index-1);
   if pointer<inumber then begin
     for y:=pointer to pointer+show_index-1 do begin
       add_item(menu1,list1[y],x1,y1+line);
       line:=line+15;
     end;
   end;
 end;

 if inumber<show_index then begin
     {no scroll needed}
     for y:=0 to inumber-1 do begin
       add_item(menu1,list1[y],x1,y1+line);
       line:=line+15;
     end;
 end;

end;
BEGIN
 selected:=false;
 inrange:=false;
 notscroll:=false;
// listafocus:=true;
 inumber:=length(list1); {Total number of elements in array}
 boxx:=x1+(length(list1[1])*8)+4;  {max x}
 boxy:=y1+(show_index*15);
 boton(x1-6,y1-6,x1+(length(list1[1])*8)+4,y1+(show_index*15),1,b1,false,0); {frame}
 if inumber<=show_index then begin
  {without scroll}
   cMenu(menu1,b1,f1,bs1,fs1,pressed);
   loadlist(0);
   notscroll:=true;
 end;
      boton(boxx,y1+17,boxx+20,boxy-21,1,dgreyc,true,0); {bar}

     if notscroll then begin
     {buttons appear inactive}
      boton(boxx,y1-6,boxx+20,y1+16,1,dgreyc,true,0);   {up}
      escc(boxx,y1-6,boxx+17,y1+16,':',0);
      boton(boxx,boxy-20,boxx+20,boxy,1,dgreyc,true,0); {down}
      escc(boxx,boxy-20,boxx+17,boxy,':',0);
     end
     else begin
     {buttons appear active}
      boton(boxx,y1-6,boxx+20,y1+16,1,lgreyc,true,0);   {up}
      escc(boxx,y1-6,boxx+17,y1+16,':',0);
      boton(boxx,boxy-20,boxx+20,boxy,1,lgreyc,true,0); {down}
      escc(boxx,boxy-20,boxx+17,boxy,':',0);
      end;
   endx:=false;

 if inumber>show_index then begin
 {scroll management routine}
   cMenu(menu1,b1,f1,bs1,fs1,pressed);
   pointer:=0;  {Counter of items}
   if listdt.indx>0 then begin
    pointix:=listdt.indx; { record previous choice }
    if listdt.pointer=listdt.inumber-show_index then begin dir:=true; endx:=true; end;
    loadlist(listdt.pointer);
    pointer:=listdt.pointer
   end
   else begin

     pointix:=1;  {Pointer to the item in the list/first time}
     loadlist(0);
   end;
   //if aux<>nil then if (aux^.nlistcount>0) and (firsttime=false) then gotop(aux,aux^.nlistcount);
   repeat

       if pointer < inumber then begin
          if (pointer<factor-1) and (pointer>=0) then begin
            start_vlist(menu1,pointix);

            if kglobal=#80 then begin
              pointer:=pointer+1;
              pointix:=show_index;
            end;
          end;

          if (pointer>0) and (kglobal=#72) then begin
            pointer:=pointer-1;
            pointix:=1;
          end;
       end;

     if pointer < inumber then begin
       crumble(menu1);
       cMenu(menu1,b1,f1,bs1,fs1,pressed);
       loadlist(pointer);
     end;

     if pointer=factor-1 then begin
      start_vlist(menu1,pointix);
     end;


     until (kglobal=#27) or (kglobal=#13) or (listafocus=false);
      if (dir=true) then begin
        gotop(menu1,aux^.nlistcount+1);
        oldchoice:=aux^.nlistcount+1;
        lastpointer:=pointer;
        listdt.pointer:=lastpointer;
        listdt.indx:=oldchoice;
        listdt.choice := menu1^.nchoice;
        listdt.dir:=endx;
      end;
      if (dir=false) or (endx=true) then begin
        gotop(menu1,aux^.nlistcount);
        oldchoice:=aux^.nlistcount;
        lastpointer:=pointer;
        lastinumber:=inumber;
        listdt.pointer:=lastpointer;
        listdt.indx:=oldchoice;
        listdt.choice := menu1^.nchoice;
        listdt.dir:=endx;
        listdt.inumber:=lastinumber;
      end;
end
else
{start the list on the last item selected when not scroll}
 if notscroll then begin

  if listdt.indx=0 then lastchoice:=1
  else
    lastchoice:=listdt.indx;
  start_vlist(menu1,lastchoice);
    { writeln('List is shorter than display');}
 END;
end;
End.
