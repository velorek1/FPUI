# fp-myunits

Amateur Freepascal Units and Programs.
My units use PtcGraph, PtcCrt, PtcMouse included in FreePascal 2.6 or higher for Graphics
and RTL (video and keyboard) for Text Mode.

I created this only for fun.

NOTE: FOR X11 headers in linux install: 
sudo apt-get install xorg-dev

Units:
======

Graph mode:

* gfxn.pas >> Graphic Unit to add buttons, textbox.
* gfwin.pas >> Graphic Unit to create windows.
* hex2bin.pas >> Unit to handle different operations with hexadecimals.
* gaedch.pas >> Graphic Unit that creates a dynamic list to select different options.
* gaedch2.pas >> Graphic Unit that creates a dynamic list to select different options with mouse control.

Text mode: Compatible with video unit.

* aedcho2.pas >> Unit that creates a dynamic list to select different options.
* winvideo.pas >> Unit that allows to create dynamic windows.
* vidutil.pas >> Unit with tools to expand the video functionality.

Programs:
=========
* hexeditor.pas >> demo hex editor that uses all the libraries.
* colpick.pas >> True Color(16k) palette picker.
* wintest.pas >> window test.
* asc.pas >> Text mode ASCII table with windows and multiple choice.

![Alt text](/velorek1/fp-myunits/hex1.png?raw=true "Menu bar")

EOF
