(*
Unit to handle selection menus with dynamic variables.
Compatible to be used with Unit VIDE
Last Modified: 22/08/2016.
Coded by Velorek.
*)
Unit AEDCho2;
INTERFACE
Uses Video,Vidutil,Keyboard;
Type
        tmNodo = ^tmenulist;
        tMenulist = record
                        nChoice :string; {New choice}
                        nListCount :integer; {# elements}
                        mBackColor : integer; {Background color}
                        mForeColor : integer; {Foreground color}
                        mSBackColor : integer; {BC when selected}
                        mSForeColor : integer; {FC when selected}
                        xWhere : integer;
                        yWhere : integer;
                        mNext : tmNodo; {Move forward}
                        mBack : tmNodo; {move backward}

                    end;
Var
        ErrorCode     : integer; { errorcode standard Int}
    kglobal	      : char;  {monitors key strokes }
        mfirst,mLast,mCurrent  : tmNodo; {Shorcut pointers to list}
        b2,f2,bs2,fs2 : integer;
   daIndex	      : integer; { List's Cardinal}
   firsttime      :  Boolean; { To control whether an opt. was selected for the first time}
Procedure cMenu(var mHandler: tmNodo;b1,f1,bs1,fs1:integer);
Procedure Add_item(var mHandler	: tmNodo;nItem:string;x,y:integer);
Procedure Update(var mHandler	: tmNodo;nItem:string;num:integer);
Procedure Start_vMenu(mHandler:tmNodo);
Procedure Start_hMenu(mHandler: tmNodo);
procedure vscroll(var menu1:tmnodo;x1,y1:integer;list1:array of string;show_index,b1,f1,bs1,fs1:integer);
Procedure Fondo(num : integer);
Procedure Fondo2(b1,c1 : integer;fillch:char);
Procedure ChartoInt(ch:char;var i:byte);
Procedure Start_Table(mHandler: tmNodo;var mdata:string; cols : integer; vertical:boolean);
Procedure gotoP(var mHandler:tmNodo;po:integer);
Procedure Crumble(mHandler : tmNodo);
Procedure lSquare(x1,y1,x2,y2,bcolor,fcolor : integer;single:boolean);
Procedure dline(x1,y1,x2,bcolor,fcolor : integer);

Procedure mDisplay;

IMPLEMENTATION

Procedure ChartoInt(ch:char;var i:byte);
{Alternatively use ORD}
var j:byte;
begin
    for j:=0 to 255 do
             begin
                  if chr(j) = ch then i:=j;
             end;
End;

Procedure dline(x1,y1,x2,bcolor,fcolor : integer);
(* Draws a HLine *)
var i : integer;
Begin
   for i:=x1 to x2 do
      esc(i,y1,chr(196),bcolor,fcolor,false);
updatescreen(true);

End;

Procedure lSquare(x1,y1,x2,y2,bcolor,fcolor : integer;single:boolean);
(* Draws a square *)
var i,j : integer;
Begin
  if single then begin
  {sides}
   for i:=x1 to x2 do begin
        esc(i,y1,chr(196),bcolor,fcolor,false);
        esc(i,y2,chr(196),bcolor,fcolor,false);
   end;
   for j:=y1 to y2 do begin
        esc(x1,j,chr(179),bcolor,fcolor,false);
        esc(x2,j,chr(179),bcolor,fcolor,false);
   end;
  {corners}
  esc(x1,y1,chr(218),bcolor,fcolor,false);
  esc(x2,y1,chr(191),bcolor,fcolor,false);
  esc(x1,y2,chr(192),bcolor,fcolor,false);
  esc(x2,y2,chr(217),bcolor,fcolor,false);
  end
  else begin
  {sides}
   for i:=x1 to x2 do begin
        esc(i,y1,chr(205),bcolor,fcolor,false);
        esc(i,y2,chr(205),bcolor,fcolor,false);
   end;
   for j:=y1 to y2 do begin
        esc(x1,j,chr(186),bcolor,fcolor,false);
        esc(x2,j,chr(186),bcolor,fcolor,false);
   end;
  {corners}
  esc(x1,y1,chr(201),bcolor,fcolor,false);
  esc(x2,y1,chr(187),bcolor,fcolor,false);
  esc(x1,y2,chr(200),bcolor,fcolor,false);
  esc(x2,y2,chr(188),bcolor,fcolor,false);
  end;
updatescreen(true);
end;

Procedure Fondo(num :  integer);
var i,j : integer;
Begin
 for j:=1 to screenheight do
    for i:=1 to screenwidth do
      esc(i,j,chr(32),num,num,false);
updatescreen(true);
end;
Procedure Fondo2(b1,c1 : integer;fillch:char);
var i,j : integer;
Begin
 for j:=1 to screenheight do
    for i:=1 to screenwidth do
      esc(i,j,fillch,b1,c1,false);
updatescreen(true);
end;

Procedure Crumble(mHandler : tmNodo);
{ Disposes the memory}
var aux,aux2	: tmNodo;
Begin
   aux:=mLast;
{   if aux=mFirst then dispose(aux);}
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
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mBackcolor,aux^.mForecolor,false);
               aux:=aux^.mNext;
     end;
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mBackcolor,aux^.mForecolor,false);
               aux:=aux^.mNext;


end;
Procedure cMenu(var mHandler:tmNodo;b1,f1,bs1,fs1:integer);
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
//        firsttime:=true;
        mHandler := nil; {initiate the dynamic list}
        b2:=b1;
        f2:=f1;
        bs2:=bs1;
        fs2:=fs1;
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
        esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mBackcolor,auxx^.mForecolor,false);
        auxx:=auxx^.mNext;
        {next item}
        esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mSBackcolor,auxx^.mSForecolor,false);
End;
Procedure Move_up(var auxx:tmNodo);
Begin
        {former item}
        esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mBackcolor,auxx^.mForecolor,false);
        {next item}
        esc(auxx^.mBack^.xwhere,auxx^.mBack^.ywhere,auxx^.mBack^.nChoice,auxx^.mBack^.mSBackcolor,auxx^.mBack^.mSForecolor,false);
        auxx:=auxx^.mBack;
End;
Procedure move_tleft(var auxx : tmNodo;cols:integer);
var fcol : integer;
Begin
   {former item}
   esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mBackcolor,auxx^.mForecolor,false);

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
  esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mSBackcolor,auxx^.mSForecolor,false);
End; { move_tleft }
Procedure move_tright(var auxx : tmNodo;cols:integer);
var fcol : integer;
Begin
   {former item}
   esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mBackcolor,auxx^.mForecolor,false);
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
  esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice,auxx^.mSBackcolor,auxx^.mSForecolor,false);
End;
Procedure Start_vMenu(mHandler : tmNodo);
var aux:tmNodo;
ch:tkeyevent;
Begin

        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1;
               { Writeln('Error ',ErrorCode,': no items found');}
        end
        Else Begin
               aux:=mFirst;
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSBackcolor,aux^.mSForecolor,true);
               InitKeyboard;
                Repeat
                        updatescreen(true);
                        ch:=TranslateKeyEvent(GetKeyEvent);
                        Case GetKeyEventCode(ch) of
                                kbdDown : move_down(aux);
                                kbdUp : move_up(aux);
			End;
		   kglobal:=GetKeyEventChar(ch);

		until (kglobal=chr(27))  or (kglobal=chr(13));
        mCurrent:=aux;
        mCurrent^.nChoice := Aux^.nChoice;
        mCurrent^.nListCount := Aux^.nListCount;
        mHandler:=mFirst;
        firsttime:=false;
	kglobal:=GetKeyEventChar(ch);
        End;
   End;
Procedure Start_hMenu(mHandler : tmNodo);
var aux:tmNodo;
ch:tkeyevent;
Begin

        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1;
               { Writeln('Error ',ErrorCode,': no items found');}
        end
        Else Begin
               aux:=mFirst;
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSBackcolor,aux^.mSForecolor,true);
               InitKeyboard;
                Repeat
                     updatescreen(true);
                     ch:=TranslateKeyEvent(GetKeyEvent);
                        Case GetKeyEventCode(ch) of
                                kbdright : move_down(aux);
                                kbdleft : move_up(aux);
			End;
		   kglobal:=GetKeyEventChar(ch);
         	until (kglobal=chr(27))  or (kglobal=chr(13));
        mCurrent:=aux;
        mCurrent^.nChoice := Aux^.nChoice;
        mCurrent^.nListCount := Aux^.nListCount;
        mHandler:=mFirst;
        firsttime:=false;
        kglobal:=GetKeyEventChar(ch);
        End;
   End;

Procedure gotoP(var mHandler:tmNodo; po : integer);
{go to selected item}
var aux:tmNodo;
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
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mBackcolor,aux^.mForecolor,false);
               b:=b-1;
               aux:=aux^.mBack;
     end;
   esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSBackColor,aux^.mSForecolor,false);
   mhandler:=aux;
  End;
End;
Procedure Update(var mHandler: tmNodo;nItem:string;num:integer);
   var aux:tmnodo;
Begin

     mHandler:=mCurrent;
   { textcolor(mHandler^.mForecolor);
    textbackground(mHandler^.mBackcolor);}
    mhandler^.nListcount:=aux^.nListcount;
    mhandler^.nChoice:=nItem;
End;
Procedure Start_Table(mHandler:tmnodo;var mdata:string; cols : integer; vertical:boolean);
var aux	: tmNodo;
   ch	: tkeyevent;
Begin
   mdisplay;
   if firsttime=true then
   begin
   aux:=mFirst;
   esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSBackColor,aux^.mSForecolor,true);
   end
  else
   begin
   gotoP(aux,mCurrent^.nlistcount);
   SetCursorPos(mCurrent^.xwhere,mCurrent^.ywhere);
   end;
   move_down(aux);
   move_up(aux);
   Initkeyboard;
   Repeat
     updatescreen(true);
    ch:=TranslateKeyEvent(GetKeyEvent);
      kglobal:=GetKeyEventChar(ch);
 if vertical=false then begin
     Case GetKeyEventCode(ch) of
        kbddown : move_down(aux);
	kbdup : move_up(aux);
	kbdright : move_tleft(aux,cols);
	kbdleft : move_tright(aux,cols);
       {else }
            //kglobal:=chr(0);
      end; { case }
 end
 else begin
     Case GetKeyEventCode(ch) of
        kbdleft : move_down(aux);
	kbdright : move_up(aux);
	kbddown : move_tleft(aux,cols);
	kbdup : move_tright(aux,cols);
     end;
 end;
    until (KGLOBAL=chr(27)) or (KGLOBAL=chr(13)) or (kglobal='q');
     kglobal:=GetKeyEventChar(ch);
  mCurrent:=aux;
  mCurrent^.nChoice := Aux^.nChoice;
  mCurrent^.nListCount := Aux^.nListCount;
  {mCurrent^.xwhere := wherex;
  mCurrent^.ywhere := wherey; }
  mdata:=aux^.nChoice;
  firsttime:=false;
End;
procedure vscroll(var menu1:tmnodo;x1,y1:integer;list1:array of string;show_index,b1,f1,bs1,fs1:integer);
var
  aux:tmNodo;
  inumber,factor:integer;
  pointer,pointix:integer;
  dir,endx:boolean;
Procedure Start_vList(var mHandler:tmNodo;displaynum:integer);
var ch:tkeyevent;
Begin

        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1;
               { Writeln('Error ',ErrorCode,': no items found');}
        end
        Else Begin
{               aux:=mFirst;  }
               gotop(aux,displaynum);
               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSBackcolor,aux^.mSForecolor,true);
               InitKeyboard;
                Repeat
                        ch:=TranslateKeyEvent(GetKeyEvent);
           if aux^.nlistcount=1 then begin dir:=false; endx:=false; end;
          if aux^.nlistcount>1 then dir:=true;
          if aux^.nlistcount+pointer=inumber then endx:=true; {Samll correction for last items}

               if (GetKeyEventCode(ch)=kbddown) and (aux=mlast) then  break;
               if (GetKeyEventCode(ch)=kbdup) and (aux=mfirst) then break;
                        Case GetKeyEventCode(ch) of
                                kbddown : begin  move_down(aux);  end;
                                kbdup : begin  move_up(aux); end;
			End;
                kglobal:=GetKeyEventChar(ch);
           until (KGLOBAL=chr(27)) or (KGLOBAL=chr(13));

        mCurrent:=aux;
        mCurrent^.nChoice := Aux^.nChoice;
        mCurrent^.nListCount := Aux^.nListCount;
        mHandler:=aux;
        firsttime:=false;
                kglobal:=GetKeyEventChar(ch);

        End;
   End;

procedure loadlist(pointer:integer);
var
  y,line:integer;
begin
 line:=1;
 inumber:=length(list1);
 if inumber>=show_index then begin
   factor:=inumber - (show_index-1); {Last item in which all items can be displayed without scroll}
   if pointer<inumber then begin
     for y:=pointer to pointer+show_index-1 do begin
       add_item(menu1,list1[y],x1,y1+line);
       line:=line+1;
     end;
   end;
 end;
end;

BEGIN
 inumber:=length(list1); {Total number of elements in array}
 if inumber>=show_index then begin
   cMenu(menu1,b1,f1,bs1,fs1);
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
       cMenu(menu1,b1,f1,bs1,fs1);
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

End.
