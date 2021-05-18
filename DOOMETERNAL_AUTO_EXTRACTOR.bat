@ECHO OFF

TITLE DOOM ETERNAL AUTO EXTRACTOR v1.0 (05-13-2021)
ECHO/
ECHO 	[44;96m                                        [0m 
ECHO 	[44;96m  DOOM ETERNAL AUTO EXTRACTOR v1.0      [0m 
ECHO 	[44;96m  by BEARSHARK1911                      [0m 
ECHO/	[44;96m  DATE 05-13-2021                       [0m 
ECHO 	[44;96m                                        [0m 
ECHO/	
ECHO/	DOOM ETERNAL v5.0
ECHO/	QUICKBMS v0.11
ECHO/	
ECHO/	This script is a wrapper for quickbms.exe for DOOM ETERNAL file extraction.
ECHO/	
ECHO/	Clicking on this .bat file will automatically do the following.
ECHO/
ECHO/	1.) verify each gameresources file is unmodified and the latest verion
ECHO/	2.) extract all .decl files from gameresources, gameresources_patch1, and gameresources_patch2
ECHO/	3.) create corresponding output directories for each .resources file
ECHO/	4.) set all extracted files to read only
ECHO/	
ECHO/	All 3 gameresources files takes less than 1 minute to extract.
ECHO/	
ECHO/	change DOOM_ETERNAL_FILES to include other .resource files in the campaign
ECHO/	change OUTPUT_FILE_EXT to the type of file you want to extract
ECHO/	
ECHO/	EXAMPLE: set OUTPUT_FILE_EXT=.tga if you only want to extract texture files
ECHO/	
ECHO/	DISCLAIMER: I CANNOT STRESS HOW IMPORTANT IT IS TO EXTRACT FROM VANILLA(UNMODIFIED) GAME FILES.
ECHO/	            ALWAYS CREATE MODS FROM UNTAINTED GAME FILES.
ECHO/	
ECHO/	CREDITS: 
ECHO/	
ECHO/	This script was made possible by Zwip-Zwap Zapony's EternalModInjector.bat script.
ECHO/	

:: --------------------------------------------------------------------------------------------
:: DEFAULTS
SET OUTPUT_DIRECTORY=%USERPROFILE%\Desktop\doom eternal\GAME_FILES
SET CURRENT_DIRECTORY=%~dp0
SET DOOMETERNAL_BMS_FILE=%CURRENT_DIRECTORY%doometernal.bms
SET BMS_EXE=%CURRENT_DIRECTORY%quickbms.exe

SET DOOM_ETERNAL_DIRECTORY=C:\Program Files (x86)\Steam\steamapps\common\DOOMEternal
SET CAMPAIGN_DIRECTORY=%DOOM_ETERNAL_DIRECTORY%\base\game
SET CONFIG_FILE="DoomEternalExtractor_Settings.txt"

SET DOOM_ETERNAL_FILES=gameresources gameresources_patch1 gameresources_patch2
SET INPUT_FILE_EXT=.resources
SET OUTPUT_FILE_EXT=.decl

SET PARAMS_1=-K -F
SET PARAMS_2="%DOOMETERNAL_BMS_FILE%" "%DOOM_ETERNAL_DIRECTORY%\base" "%OUTPUT_DIRECTORY%"
:: --------------------------------------------------------------------------------------------

SET FILE_DOOMEternalx64vk=%DOOM_ETERNAL_DIRECTORY%\DOOMEternalx64vk.exe
SET FILE_gameresources=%DOOM_ETERNAL_DIRECTORY%\base\gameresources.resources
SET FILE_gameresources_patch1=%DOOM_ETERNAL_DIRECTORY%\base\gameresources_patch1.resources
SET FILE_gameresources_patch2=%DOOM_ETERNAL_DIRECTORY%\base\gameresources_patch2.resources
SET FILE_meta=%DOOM_ETERNAL_DIRECTORY%\base\meta.resources

SET FILE_LIST=%FILE_DOOMEternalx64vk% %FILE_gameresources% %FILE_gameresources_patch1% %FILE_gameresources_patch2% %FILE_meta%

SET MD5_FILE_DOOMEternalx64vk=96556f8b0dfc56111090a6b663969b86
SET MD5_gameresources=4376f5c5858b433af06ddf58bc4ef5ac
SET MD5_gameresources_patch1=ec1195542dde3ab12cadb8d74d507f91
SET MD5_gameresources_patch2=88fcd86029c645eb447972f0d56c81ca
SET MD5_meta=58cc7bf26726fe0cb8cd021e2c34be99

SET MD5_LIST=%MD5_FILE_DOOMEternalx64vk% %MD5_gameresources% %MD5_gameresources_patch1% %MD5_gameresources_patch2% %MD5_meta%

SET HASHTABLE_SORTOF[0].path=%FILE_DOOMEternalx64vk%
SET HASHTABLE_SORTOF[0].hash=%MD5_FILE_DOOMEternalx64vk%

SET HASHTABLE_SORTOF[1].path=%FILE_gameresources%
SET HASHTABLE_SORTOF[1].hash=%MD5_gameresources%

SET HASHTABLE_SORTOF[2].path=%FILE_gameresources_patch1%
SET HASHTABLE_SORTOF[2].hash=%MD5_gameresources_patch1%

SET HASHTABLE_SORTOF[3].path=%FILE_gameresources_patch2%
SET HASHTABLE_SORTOF[3].hash=%MD5_gameresources_patch2%

SET HASHTABLE_SORTOF[4].path=%FILE_meta%
SET HASHTABLE_SORTOF[4].hash=%MD5_meta%

:: --------------------------------------------------------------------------------------------

:: certutil -hashfile ".\%~1" MD5

:: extracts md5 string
:: CertUtil -hashfile FILE_DOOMEternalx64vk.exe md5 | grep -vP '(?<=MD5|CertUtil)'
REM certutil -hashfile "%FILE_DOOMEternalx64vk%" MD5

IF NOT EXIST "%DOOMETERNAL_BMS_FILE%" (
	ECHO\	
	ECHO	FILE NOT FOUND "%DOOMETERNAL_BMS_FILE%"
	ECHO\	
	
 PAUSE
 GOTO exit
)

ECHO\	
CALL :VERIFY_GAME_FILES
ECHO\	
ECHO DOOMETERNAL BMS FILE  = %DOOMETERNAL_BMS_FILE%
ECHO\	
ECHO OUTPUT DIRECTORY      = %OUTPUT_DIRECTORY%
ECHO\	
ECHO INPUT FILES
ECHO\	

ECHO %DOOM_ETERNAL_DIRECTORY%\base\gameresources.resources
ECHO %DOOM_ETERNAL_DIRECTORY%\base\gameresources_patch1.resources
ECHO %DOOM_ETERNAL_DIRECTORY%\base\gameresources_patch2.resources

ECHO\	
ECHO OUTPUT DIRECTORY
ECHO\	
CALL :CREATE_OUTPUT_DIRECTORIES
ECHO\	
CALL :EXTRACT_FILES
ECHO\	
ECHO\	SETTING ALL EXTRACTED FILES TO READ ONLY(TRUST ME, THIS IS A GOOD IDEA)
ECHO\	
CALL :SET_READ_ONLY
ECHO\	
PAUSE

EXIT /B 0

:VERIFY_GAME_FILES
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO\
ECHO VERIFYING GAME FILES
ECHO\

FOR /L %%i IN (0 1 4) DO (
	CALL :MD5_HASH "%%HASHTABLE_SORTOF[%%i].path%%" "%%HASHTABLE_SORTOF[%%i].hash%%"
)

EXIT /B 0

:MD5_HASH
SETLOCAL ENABLEDELAYEDEXPANSION
SET _HASHSTR=:
FOR /F "delims=:\s" %%A IN ('certutil -hashfile "%~1" MD5') DO SET _HASHSTR=!_HASHSTR! %%A

:: ugly solution for an ugly language
SET _nospaces=%_HASHSTR: =%
SET _hashonly=%_nospaces:CertUtil=%
SET _result=%_hashonly::MD5ha=%

CALL ECHO PATH          = %~1
CALL ECHO EXPECTED HASH = %~2
CALL ECHO CURRENT  HASH = %_result%

ECHO %~2
ECHO !_result!

IF "%~2" == "!_result!" (
	echo PASSED
	echo\	
) ELSE (

	ECHO\	
	ECHO\	MD5 FAILURE FOR GAME FILE -- "%~1"
	ECHO\	
	
	ECHO\	[1;41;93m                                                             [0m
	ECHO\	[1;41;93m ERROR: MD5 HASH DOESN'T MATCH                               [0m
	ECHO\	[1;41;93m                                                             [0m
	ECHO\	[1;41;93m UNINSTALL ALL MODS AND VERIFY GAME FILES THROUGH STEAM      [0m
	ECHO\	[1;41;93m                                                             [0m
	ECHO\	
	PAUSE
	EXIT
)

EXIT /B 0

:CREATE_OUTPUT_DIRECTORIES
SETLOCAL ENABLEDELAYEDEXPANSION
(for %%a in (%DOOM_ETERNAL_FILES%) do (
	CALL :MKDIR "%OUTPUT_DIRECTORY%\%%a"
))
EXIT /B 0

:: create output folder
:MKDIR
:: md %~1
IF NOT EXIST "%~1" (
	echo CREATING OUTPUT DIRECTORY "%~1"
	md "%~1"
) ELSE (
	echo VERIFIED OUTPUT DIRECTORY %~1
)
EXIT /B 0

:EXTRACT_SINGLEFILE
SETLOCAL ENABLEDELAYEDEXPANSION
quickbms.exe -l -K -f "*.decl" "doometernal.bms" "C:\Program Files (x86)\Steam\steamapps\common\DOOMEternal\base" "C:\Users\18144\Desktop\doom eternal\GAME_FILES"
EXIT /B 0

:EXTRACT_FILES
SETLOCAL ENABLEDELAYEDEXPANSION
(for %%F in (%DOOM_ETERNAL_FILES%) do (
		echo ".\%BMS_EXE%" !PARAMS_1! "*%%F%INPUT_FILE_EXT%" -f "%OUTPUT_FILE_EXT%" !PARAMS_2!\%%F
		START "DOOM ETERNAL EXTRACT" /WAIT /B "%BMS_EXE%" %PARAMS_1% "*%%F%INPUT_FILE_EXT%" -f "*%OUTPUT_FILE_EXT%" %PARAMS_2%\%%F
))
PAUSE
GOTO :eof

:SET_READ_ONLY
SETLOCAL ENABLEDELAYEDEXPANSION

attrib +R "%OUTPUT_DIRECTORY%\*" /S /D
GOTO :eof

:: FOR LATER
:FunctionWriteConfiguration
>".\%___CONFIGURATION_FILE%" ECHO :ASSET_VERSION=%___ASSET_VERSION%
IF DEFINED DOOMETERNAL_BMS_FILE (
	>>".\%CONFIG_FILE%" ECHO :DOOMETERNAL_BMS_FILE=1
) ELSE (
	>>".\%CONFIG_FILE%" ECHO :DOOMETERNAL_BMS_FILE=0
)
IF DEFINED REGEX (
	>>".\%CONFIG_FILE%" ECHO :REGEX=1
) ELSE (
	>>".\%CONFIG_FILE%" ECHO :REGEX=0
)
IF DEFINED DOOM_ETERNAL_DIRECTORY (
	>>".\%CONFIG_FILE%" ECHO :DOOM_ETERNAL_DIRECTORY=1
) ELSE (
	>>".\%CONFIG_FILE%" ECHO :DOOM_ETERNAL_DIRECTORY=0
)
IF DEFINED OUTPUT_DIRECTORY (
	>>".\%CONFIG_FILE%" ECHO :OUTPUT_DIRECTORY=1
) ELSE (
	>>".\%CONFIG_FILE%" ECHO :OUTPUT_DIRECTORY=0
)
EXIT /B 0
