rem - remove all program files in current directory 
del *.prg
rem - remove .tap file
del *.tap
rem - remove config.a in order to create a fresh new _config.a
del _config.a

@echo off

rem Allow block checksum to configure 
echo EnableBlockChecksum = 1 >>_config.a

rem Allow set turbo tape speed to configure
echo TapeTurboSpeed = $80 >>_config.a

rem Using any of the additional loaders, echo the chosen loader 
rem REM the rest out. We cannot use all options. 
rem Without small loader, novaishload or MartyLoad, the default 
rem loader will be set. (White text with loading effect)

echo SmallLoader = 1 >> _config.a
rem echo NovaishLoad = 1 >>_config.a
rem echo Martyload = 1 >>_config.a

echo Assembling with ACME
acme.exe --lib  ../ --lib ../../  -v3 --msvc Loaders.a
rem INCLUDING MUSIC FILE
acme.exe setmusic.a
rem INCLUDING PICTURE FILE
acme.exe makepic.a
rem INCLUDING GAME FILE
acme.exe linker.a
rem ASSEMBLING IRQTAPE1.A 
acme.exe irqtape1.a
rem COMPACTING AND MAKING BASIC RUN for master
c:\exomizer\win32\exomizer.exe sfx $c000 irqtape1.a -o irqtape1.prg
echo Writing data
rem Tiny header auto-boot loaders are used so use this...

TapeTool.exe wn "test.tap" m "Loaders.map" ocb1 Loaders.bin c
TapeTool.exe w "test.tap" a m "Loaders.map" otl$c0 otft "Loaders.bin" .RealCodeStart .RealCodeEnd c
TapeTool.exe w "test.tap" a m "Loaders.map" otl$c0 otfb "Loaders.bin" 0 .SpriteDataStart .SpriteDataEnd $200 c
TapeTool.exe w "test.tap" a m "Loaders.map" otl$c0 otfb "music.prg" 1 c
TapeTool.exe w "test.tap" a m "Loaders.map" otl$c0 otfb "loaderpic.prg" 2 c
TapeTool.exe w "test.tap" a m "Loaders.map" otl$c0 otfb "linkedgame.prg" 3 c

rem generate tape tool master 
acme -v3 irqtape1.a

c:\exomizer\win32\exomizer.exe sfx $c000 irqtape1.prg -o irqtape1.prg -x3 -q

echo run test.tap

test.tap
