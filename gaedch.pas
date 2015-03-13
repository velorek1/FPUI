(* Coded by Freyr, Norse God of Rain *)
Unit gAEDCh;
INTERFACE
Uses PTcCrt,Gfxn;
Type
        tmNodo = ^tmenulist;
        tMenulist = record
                        nChoice :string; {New choice}
                        nListCount :integer; {# elements}
                        mForeColor : longword; {Foreground color}
                        mBackColor : longword; {Background color}
                        mSBackColor : longword; {BC when selected}
                        mSForeColor : longword; {FC when selected}
                        soSub : boolean; {pressed?}
                        xWhere : integer;
                        yWhere : integer;
                        mNext : tmNodo; {Move forward}
                        mBack : tmNodo; {move backward}

                    end;
Var
        ErrorCode : integer;
        mfirst,mback:tmNodo;
        sub:boolean;
        disp:char;
        return:boolean;
        left:boolean;
        b2,bs2,f2,fs2:word;
Procedure CMenu(var mHandler:tmNodo;f1,b1,fs1,bs1:word;subx:boolean);
Procedure Add_item(var mHandler:tmNodo;nItem:string;x,y:integer);
Procedure Start_Menu(var mHandler:tmNodo);
Procedure Start_upMenu(var mHandler:tmNodo);
Procedure mDisplay2(mHandler:tmNodo;b1:byte);
Procedure mDisplay;
IMPLEMENTATION
Procedure mDisplay2(mHandler:tmNodo;b1:byte);
var aux:tmNodo;
i:integer; rest:string;
Begin
        aux:=mFirst;
        rest:='';
        while aux <> mFirst^.mback do begin
              esc(aux^.xwhere,aux^.ywhere,aux^.nChoice[1],aux^.mForecolor);

        for i:=2 to length(aux^.nchoice) do begin
            rest:=rest+aux^.nchoice[i];
        end;
              esc(aux^.xwhere+8,aux^.ywhere,rest,aux^.mForecolor);
              rest:='';
              aux:=aux^.mNext;

        end;
              esc(aux^.xwhere,aux^.ywhere,aux^.nChoice[1],aux^.mForecolor);

        for i:=2 to length(aux^.nchoice) do begin
            rest:=rest+aux^.nchoice[i];
        end;
              esc(aux^.xwhere+8,aux^.ywhere,rest,aux^.mForecolor);
              rest:='';

End;

Procedure mDisplay;
var aux:tmNodo;
i:integer; rest:string;
p:tmNodo;
Begin
        aux:=mFirst;
        rest:='';
        while aux <> mFirst^.mback do begin
        p:=aux;
rectangl(p^.xwhere-4,p^.ywhere-4,p^.xwhere+(length(p^.nChoice)*8)+2,p^.ywhere+10,b2,1,b2);

              esc(aux^.xwhere,aux^.ywhere,aux^.nChoice[1],aux^.mForecolor);

        for i:=2 to length(aux^.nchoice) do begin
            rest:=rest+aux^.nchoice[i];
        end;
              esc(aux^.xwhere+8,aux^.ywhere,rest,aux^.mForecolor);
              rest:='';
              aux:=aux^.mNext;
              p:=aux;

        end;
rectangl(p^.xwhere-4,p^.ywhere-4,p^.xwhere+(length(p^.nChoice)*8)+2,p^.ywhere+10,b2,1,b2);
              esc(aux^.xwhere,aux^.ywhere,aux^.nChoice[1],aux^.mForecolor);

        for i:=2 to length(aux^.nchoice) do begin
            rest:=rest+aux^.nchoice[i];
        end;
              esc(aux^.xwhere+8,aux^.ywhere,rest,aux^.mForecolor);
              rest:='';

End;
Procedure CMenu(var mHandler:tmNodo;f1,b1,fs1,bs1:word;subx:boolean);
(* Creates the group associated to the menu array
mHandler => Dyanamic List.
MID => Group's name identifier.
b1 => fore ground color ; fs1 => color when selected
*)
Begin
        mFirst := nil;
        mHandler := nil; {initiate the dynamic list}
        f2:=f1; {fore when not selected}
        b2:=b1; {background when not selected}
        bs2:=bs1; {when selected backg color}
        fs2:=fs1; {foreground when selected}
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
                        nListCount := 1;
                        nChoice := nItem;
                        mForeColor := f2;
                        mBackColor := b2;
                        mSBackColor := bs2;
                        mSForeColor := fs2;
                        soSub := sub;
                        xWhere := x;
                        yWhere := y;
                        mFirst := mHandler; {Always points to #1 item }
                        Former:=mFirst;
                        current:=former;
                        mBack:=nil;
                  end;

        End
        Else Begin
                Former:=Current;
                new(other);
                former^.mNext := other;
                other^.mBack := former;
                mBack := other; {Always points to latest item}
                mFirst^.mBack := mBack; {we close the circular list}
                with other^ do Begin
                        nListCount := nListCount + 1;
                        nChoice := nItem;
                        mForeColor := f2;
                        mBackColor := b2;
                        mSBackColor := bs2;
                        mSForeColor := fs2;
                        soSub := sub;
                        xWhere := x;
                        yWhere := y;
                end;
                Current := other;
                mhandler^.nlistCount := other^.nListCount;
                mBack^.mNext := mFirst;
        End;
End;
Procedure Move_down(var auxx:tmNodo);
var
i:integer; rest:string;
g,p:tmNodo;
Begin
        {former item}
        p:=auxx;
        rest:='';
rectangl(p^.xwhere-4,p^.ywhere-4,p^.xwhere+(length(p^.nChoice)*8)+2,p^.ywhere+10,b2,1,b2);
        esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice[1],auxx^.mForecolor);
        for i:=2 to length(auxx^.nchoice) do begin
            rest:=rest+auxx^.nchoice[i];
        end;
              esc(auxx^.xwhere+8,auxx^.ywhere,rest,auxx^.mForecolor);
              rest:='';

        {next item}
         g:=auxx^.mNext;

if g^.sosub=false then
Boton(g^.xwhere-4,g^.ywhere-4,g^.xwhere+(length(g^.nChoice)*8)+2,g^.ywhere+10,1,g^.mSBackcolor,true,0)
else
Boton(g^.xwhere-4,g^.ywhere-4,g^.xwhere+(length(g^.nChoice)*8)+2,g^.ywhere+10,1,g^.mBackcolor,false,0);

esc(g^.xwhere,g^.ywhere,g^.nChoice,g^.mSForecolor);

        auxx:=auxx^.mNext;

End;
Procedure Move_up(var auxx:tmNodo);
var
i:integer; rest:string;
g,p:tmNodo;
Begin
        {former item}
        p:=auxx;
        rest:='';
rectangl(p^.xwhere-4,p^.ywhere-4,p^.xwhere+(length(p^.nChoice)*8)+2,p^.ywhere+10,b2,1,b2);
        esc(auxx^.xwhere,auxx^.ywhere,auxx^.nChoice[1],auxx^.mForecolor);
        for i:=2 to length(auxx^.nchoice) do begin
            rest:=rest+auxx^.nchoice[i];
        end;
              esc(auxx^.xwhere+8,auxx^.ywhere,rest,auxx^.mForecolor);
              rest:='';

        {next item}
         g:=auxx^.mBack;
if g^.sosub=false then
Boton(g^.xwhere-4,g^.ywhere-4,g^.xwhere+(length(g^.nChoice)*8)+2,g^.ywhere+10,1,g^.mSBackcolor,true,0)
else
Boton(g^.xwhere-4,g^.ywhere-4,g^.xwhere+(length(g^.nChoice)*8)+2,g^.ywhere+10,1,g^.mBackcolor,false,0);

esc(g^.xwhere,g^.ywhere,g^.nChoice,g^.mSForecolor);

        auxx:=auxx^.mBack;
End;

Procedure Start_Menu(var mHandler:tmNodo);
var aux:tmNodo;
ch:char;
Begin
        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1; {no items found}
        end
        Else Begin
               aux:=mFirst;
if aux^.sosub=false then
Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
else
Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mBackcolor,false,0);

               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);

                Repeat
                        ch:=readkey;
               if mBack <> nil then begin
                        Case ch of
                                #80:move_down(aux);
                                #72:move_up(aux);
                        End;
                end
                else
                until ((ch=#27) or (ch=#13) or (ch=#75) or (ch=#77));
                if ch=#27 then begin
                   mdisplay;
                   return:=false;
                end;
                if ch=#13 then return:=true;
                if ch=#77 then left:=true;
                if ch=#75 then left:=false;
                disp := ch;
                mHandler:=aux;
        End;
   End;

Procedure Start_upMenu(var mHandler:tmNodo);
var aux:tmNodo;
ch:char;
Begin
        mDisplay;
        if mFirst = nil then Begin
                ErrorCode:=1; {no items found}
        end
        Else Begin
               aux:=mFirst;
if aux^.sosub=false then
Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mSBackcolor,true,0)
else
Boton(aux^.xwhere-4,aux^.ywhere-4,aux^.xwhere+(length(aux^.nChoice)*8)+2,aux^.ywhere+10,1,aux^.mBackcolor,false,0);

               esc(aux^.xwhere,aux^.ywhere,aux^.nChoice,aux^.mSForecolor);

                Repeat
                        ch:=readkey;
               if mBack <> nil then begin
                        Case ch of
                                #77:move_down(aux);
                                #75:move_up(aux);
                        End;
                end
                else
                until ((ch=#27) or (ch=#13));
                if ch=#27 then Begin
                   mdisplay;
                   return:=false;
                end;
                if ch=#13 then return:=true;
                disp:=ch;
                mHandler:=aux;
        End;
   End;
End.
