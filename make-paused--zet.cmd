@echo off
@echo Cloning Psi from official repository
git clone git://git.psi-im.org/psi.git
@echo Cloning and init Iris from official repository
cd psi
git submodule init
git submodule update
cd ..
@echo Creating Psi+ Project
svn checkout http://psi-dev.googlecode.com/svn/trunk/patches
@echo Completed
@echo Updating Psi from official repository..
cd psi
git pull
@echo Completed
@echo Updating Iris from official repository..
git submodule update
@echo Completed
@echo Updating Psi+ Project..
cd ../patches
svn cleanup
svn up
@echo Completed
cd ..
pause
@echo Updating Psi to Psi+
copy patches\app.ico psi\win32\app.ico /Y
svnversion patches >> revision
copy /B set + revision setrev.cmd
del revision
cd patches
copy 270-psi-application-info.diff   270-psi-application-info.diff.backup
call ../setrev.cmd
sed "s/\(xxx\)/%rev%/" -i "270-psi-application-info.diff"
UNIX2DOS 270-psi-application-info.diff
del ..\setrev.cmd
cd ../psi
pause
SET patchdir=..\patches\
SET patchlist=1.tmp
dir /B %patchdir%*.diff |sort >%patchlist%
for /F "delims=" %%v in (%patchlist%) do patch -p1 < %patchdir%%%v && pause
cd ../patches
del 270-psi-application-info.diff
ren 270-psi-application-info.diff.backup 270-psi-application-info.diff
cd ../psi\iris
ren conf_win.pri.example conf_win.pri
cd ../../../../Program Files\Git\bin
ren sh.exe sh.ex_
cd ../../../psi\build
pause
@echo start > timestamps.log
time /T >> timestamps.log
cd psi
call qmake
call make clean
call make
cd ..
@echo finish >> timestamps.log
time /T >> timestamps.log
cd ../../Program Files\Git\bin
ren sh.ex_ sh.exe
cd ../../../psi\build
copy psi\src\release\psi.exe psi.exe
copy psi\src\release\psi.exe psi-portable.exe
pause