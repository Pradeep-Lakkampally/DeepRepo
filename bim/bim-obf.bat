@ECHO OFF

REM #--------------------------------------------------------------------------------------------------------------------
REM #--------------------------------------------------------------------------------------------------------------------
REM # Script Name  :bim-obf.bat
REM # Author       :Pradeep Lakkampally
REM # Date         :19/04/2017
REM #--------------------------------------------------------------------------------------------------------------------

REM #--------------------------------------------------------------------------------------------------------------------
REM # This .bat script obfuscate bim-EAR.ear
REM #--------------------------------------------------------------------------------------------------------------------

set TEMP_bim_OBFUSCATE=%temp%\bim-Obfuscate\
set TEMP_bim_WEB=%temp%\bim\bim-Web
set bim_EAR=bim-EAR.ear
set bim_RAR=bim-EAR.rar
set bim_WAR=bim-Web.war
set bim_WAR_OBF=bim-Web_obf.war
set CURRENT_DIR=%CD%
set EAR_LOCATION=.
echo.
IF EXIST %TEMP_bim_OBFUSCATE% (
	echo Deleting bim-OBFUSCATE from temp directory
	DEL /f /s /q %TEMP_bim_OBFUSCATE% 1>nul
	RMDIR /S /Q %TEMP_bim_OBFUSCATE%
)

MKDIR %TEMP_bim_OBFUSCATE%
IF NOT EXIST %CURRENT_DIR%\bim-Obfuscate\ (
	MKDIR %CURRENT_DIR%\bim-Obfuscate\
)

COPY %EAR_LOCATION%\%bim_EAR% %TEMP_bim_OBFUSCATE%\%bim_EAR%
COPY %EAR_LOCATION%\yguard.jar %TEMP_bim_OBFUSCATE%\yguard.jar
COPY %EAR_LOCATION%\build.xml %TEMP_bim_OBFUSCATE%\build.xml
CD /D %TEMP_bim_OBFUSCATE%
echo.
echo ==================================Extracting EAR
echo.
jar xf %bim_EAR%
DEL %bim_EAR%
echo.
echo ==================================Obfuscation Started
ANT -f build.xml|more
echo.
echo ==================================Obfuscation Completed.
DEL  %bim_WAR%
REN %bim_WAR_OBF% %bim_WAR%
DEL yguard.jar
DEL build.xml
DEL yguardlog.xml
echo.
echo ==================================Constructing EAR
jar cf %bim_EAR% .
RMDIR /S /Q APP-INF
RMDIR /S /Q META-INF
CD /D %CURRENT_DIR%\bim-Obfuscate\
IF EXIST %bim_EAR% (
	DEL %bim_EAR%
)
echo.
echo ===================================Copying %bim_EAR% from %TEMP_bim_OBFUSCATE% to %CURRENT_DIR%\bim-Obfuscate
COPY %TEMP_bim_OBFUSCATE%\%bim_EAR% %CURRENT_DIR%\bim-Obfuscate\%bim_EAR%
RMDIR /S /Q %TEMP_bim_OBFUSCATE%
echo.
echo.
echo ===================================Completed Obfuscation. Location %CURRENT_DIR%\bim-Obfuscate\%bim_EAR%
pause
