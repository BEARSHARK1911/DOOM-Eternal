@ECHO OFF

TITLE DOOM ETERNAL MOD ASSEMBLER v1.0 (05-13-2021)
ECHO/
ECHO 	[44;96m                                    [0m 
ECHO 	[44;96m  DOOM ETERNAL MOD ASSEMBLER v1.0   [0m 
ECHO 	[44;96m  by BEARSHARK1911                  [0m 
ECHO/	[44;96m  DATE 02-13-2021                   [0m 
ECHO 	[44;96m                                    [0m 
ECHO/
ECHO/	AUTOMATICALLY PACK, EXPORT, AND LAUNCH MODS TO DOOM ETERNAL
ECHO/
ECHO/ 
ECHO/
ECHO/

SET DOOM_ETERNAL_PATH=C:\Program Files (x86)\Steam\steamapps\common\DOOMEternal
SET DOOM_ETERNAL_MOD_INJECTOR_PATH=%DOOM_ETERNAL_PATH%\EternalModInjector.bat
SET EXPORT_PATH=%DOOM_ETERNAL_PATH%\Mods
SET FILE_LIST=gameresources gameresources_patch1 gameresources_patch2 README.txt
SET currTime=%TIME%
SET currTime=%currTime::=%
SET currTime=%currTime: =%

SET MODPATH=%~dp0
SET ARCHIVE_DIRNAME=ARCHIVES
SET ARCHIVE_PATH=%MODPATH%ARCHIVES
SET MODNAME=

CALL :FUNCTION_FILENAME
CALL :MKDIR "%ARCHIVE_PATH%"

SET MOD_DIRECTORY_PATH=%EXPORT_PATH%\%MODNAME%.zip
SET MOD_ARCHIVE_PATH=%ARCHIVE_PATH%\%MODNAME%_%currTime%.zip

ECHO %MOD_DIRECTORY_PATH%
ECHO %MOD_ARCHIVE_PATH%

ECHO TESTING ---- %ARCHIVE_PATH%

"c:\Program Files\7-Zip\7z.exe" a "%MOD_ARCHIVE_PATH%" "*" -x!ARCHIVES  -x!*.zip

copy "%MOD_ARCHIVE_PATH%" "%MOD_DIRECTORY_PATH%"

:: CALL "%DOOM_ETERNAL_MOD_INJECTOR_PATH%"

PAUSE

:FUNCTION_FILENAME
for %%a in (.) do (
	SET MODNAME=%%~nxa
)
SET MODNAME=%MODNAME%

EXIT /B 0

:: create archive directory
:MKDIR
IF NOT EXIST "%~1" (
	echo CREATING ARCHIVE DIRECTORY
	md "%ARCHIVE_PATH%"
)
EXIT /B 0