echo off
rem This file is part of Notepad++ project
rem Copyright (C)2025 Don HO <don.h@free.fr>
rem
rem This program is free software: you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation, either version 3 of the License, or
rem at your option any later version.
rem
rem This program is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
rem GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License
rem along with this program.  If not, see <https://www.gnu.org/licenses/>.

echo on

if NOT EXIST ".\PowerEditor\visual.net\x64\Debug\notepad++.exe" GOTO FAILED_BUILD
setlocal
set SIGN=1

if %SIGN% == 0 goto NoSign

set signtoolWin11="C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
set signBinary=%signtoolWin11% sign /fd SHA512 /tr http://timestamp.acs.microsoft.com /td sha512 /a /f %NPP_CERT% /p %NPP_CERT_PWD% /d "Notepad++" /du https://notepad-plus-plus.org/

REM macro is used to sign NppShell.dll & NppShell.msix with hash algorithm SHA256, due to signtool.exe bug:
REM https://learn.microsoft.com/en-us/windows/msix/package/signing-known-issues 
set signBinarySha256=%signtoolWin11% sign /fd SHA256 /tr http://timestamp.acs.microsoft.com /td sha512 /a /f %NPP_CERT% /p %NPP_CERT_PWD% /d "Notepad++" /du https://notepad-plus-plus.org/


%signBinary% .\PowerEditor\visual.net\x64\Debug\notepad++.exe
If ErrorLevel 1 goto End

REM VEERU %signBinary% ..\bin64\plugins\Config\nppPluginList.dll
REM VEERU If ErrorLevel 1 goto End
REM VEERU 
REM VEERU %signBinary% ..\bin64\updater\GUP.exe
REM VEERU If ErrorLevel 1 goto End
REM VEERU 
REM VEERU %signBinary% ..\bin64\updater\libcurl.dll
REM VEERU If ErrorLevel 1 goto End

:NoSign



rem Remove old built Notepad++ 64-bit package
rmdir /S /Q .\zipped.package.debug64

rem Re-build Notepad++ 64-bit package folders
mkdir .\zipped.package.debug64
mkdir .\zipped.package.debug64\updater
mkdir .\zipped.package.debug64\localization
mkdir .\zipped.package.debug64\themes
mkdir .\zipped.package.debug64\autoCompletion
mkdir .\zipped.package.debug64\functionList
mkdir .\zipped.package.debug64\userDefineLangs
mkdir .\zipped.package.debug64\plugins
mkdir .\zipped.package.debug64\plugins\Config
mkdir .\zipped.package.debug64\plugins\doc


rem Basic Copy needed files into Notepad++ 64-bit package folders
copy /Y .\LICENSE .\zipped.package.debug64\license.txt
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\bin\readme.txt .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\bin\change.log .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\src\langs.model.xml .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\src\stylers.model.xml .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\src\contextMenu.xml .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\src\tabContextMenu_example.xml .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\src\toolbarButtonsConf_example.xml .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\src\shortcuts.xml .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\bin\doLocalConf.xml .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y .\PowerEditor\bin\nppLogNulContentCorruptionIssue.xml .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y \PowerEditor\visual.net\x64\Debug\"notepad++.exe" .\zipped.package.debug64\
If ErrorLevel 1 goto End
copy /Y \PowerEditor\visual.net\x64\Debug\*.pdb .\zipped.package.debug64\
If ErrorLevel 1 goto End


copy /Y ".\PowerEditor\installer\nativeLang\*.xml" .\zipped.package.debug64\localization\
If ErrorLevel 1 goto End

copy /Y ".\PowerEditor\installer\APIs\*.xml" .\zipped.package.debug64\autoCompletion\
If ErrorLevel 1 goto End

copy /Y ".\PowerEditor\installer\functionList\*.xml" .\zipped.package.debug64\functionList\
If ErrorLevel 1 goto End

copy /Y ".\PowerEditor\bin\userDefineLangs\markdown._preinstalled.udl.xml" .\zipped.package.debug64\userDefineLangs\
If ErrorLevel 1 goto End
copy /Y ".\PowerEditor\bin\userDefineLangs\markdown._preinstalled_DM.udl.xml" .\zipped.package.debug64\userDefineLangs\
If ErrorLevel 1 goto End

copy /Y ".\PowerEditor\installer\themes\*.xml" .\zipped.package.debug64\themes\
If ErrorLevel 1 goto End

rem For disabling auto-updater
copy /Y .\PowerEditor\src\config.4zipPackage.xml .\zipped.package.debug64\config.xml
If ErrorLevel 1 goto End
REM VEERU copy /Y ..\bin64\plugins\Config\nppPluginList.dll .\zipped.package.debug64\plugins\Config\
REM VEERU If ErrorLevel 1 goto End
REM VEERU copy /Y ..\bin64\updater\GUP.exe .\zipped.package.debug64\updater\
REM VEERU If ErrorLevel 1 goto End
REM VEERU copy /Y ..\bin64\updater\libcurl.dll .\zipped.package.debug64\updater\
REM VEERU If ErrorLevel 1 goto End
REM VEERU copy /Y ..\bin64\updater\gup.xml .\zipped.package.debug64\updater\
REM VEERU If ErrorLevel 1 goto End
REM VEERU copy /Y ..\bin64\updater\LICENSE .\zipped.package.debug64\updater\
REM VEERU If ErrorLevel 1 goto End
REM VEERU copy /Y ..\bin64\updater\README.md .\zipped.package.debug64\updater\
REM VEERU If ErrorLevel 1 goto End
REM VEERU copy /Y ..\bin64\updater\updater.ico .\zipped.package.debug64\updater\
REM VEERU If ErrorLevel 1 goto End

"C:\Program Files\7-Zip\7z.exe" a -r .\npp.portable.x64.7z .\zipped.package.debug64\*
If ErrorLevel 1 goto End

goto End

:FAILED_BUILD
echo notepad++ not found. No package generated.

:End
