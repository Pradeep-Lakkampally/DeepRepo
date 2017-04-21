@ECHO OFF

REM #--------------------------------------------------------------------------------------------------------------------
REM #--------------------------------------------------------------------------------------------------------------------
REM # Script Name  :BIMonitor-Obfuscate.bat
REM # Author       :Pradeep Lakkampally
REM # Date         :19/04/2017
REM #--------------------------------------------------------------------------------------------------------------------

REM #--------------------------------------------------------------------------------------------------------------------
REM # This .bat script obfuscate BIMonitor-EAR.ear
REM #--------------------------------------------------------------------------------------------------------------------

set TEMP_BIMONITOR_OBFUSCATE=%temp%\BIMonitor-Obfuscate\
set TEMP_BIMONITOR_WEB=%temp%\BIMonitor\BIMonitor-Web
set BIMonitor_EAR=BIMonitor-EAR.ear
set BIMonitor_RAR=BIMonitor-EAR.rar
set BIMonitor_WAR=BIMonitor-Web.war
set BIMonitor_WAR_OBF=BIMonitor-Web_obf.war
set CURRENT_DIR=%CD%
set EAR_LOCATION=.
echo.
IF EXIST %TEMP_BIMONITOR_OBFUSCATE% (
	echo Deleting BIMONITOR-OBFUSCATE from temp directory
	DEL /f /s /q %TEMP_BIMONITOR_OBFUSCATE% 1>nul
	RMDIR /S /Q %TEMP_BIMONITOR_OBFUSCATE%
)

MKDIR %TEMP_BIMONITOR_OBFUSCATE%
IF NOT EXIST %CURRENT_DIR%\BIMonitor-Obfuscate\ (
	MKDIR %CURRENT_DIR%\BIMonitor-Obfuscate\
)

COPY %EAR_LOCATION%\%BIMonitor_EAR% %TEMP_BIMONITOR_OBFUSCATE%\%BIMonitor_EAR%
COPY %EAR_LOCATION%\yguard.jar %TEMP_BIMONITOR_OBFUSCATE%\yguard.jar
COPY %EAR_LOCATION%\build.xml %TEMP_BIMONITOR_OBFUSCATE%\build.xml
CD /D %TEMP_BIMONITOR_OBFUSCATE%
echo.
echo ==================================Extracting EAR
echo.
jar xf %BIMonitor_EAR%
DEL %BIMonitor_EAR%
echo.
echo ==================================Obfuscation Started
ANT -f build.xml|more
echo.
echo ==================================Obfuscation Completed.
DEL  %BIMonitor_WAR%
REN %BIMonitor_WAR_OBF% %BIMonitor_WAR%
DEL yguard.jar
DEL build.xml
DEL yguardlog.xml
echo.
echo ==================================Constructing EAR
jar cf %BIMonitor_EAR% .
RMDIR /S /Q APP-INF
RMDIR /S /Q META-INF
CD /D %CURRENT_DIR%\BIMonitor-Obfuscate\
IF EXIST %BIMonitor_EAR% (
	DEL %BIMonitor_EAR%
)
echo.
echo ===================================Copying %BIMonitor_EAR% from %TEMP_BIMONITOR_OBFUSCATE% to %CURRENT_DIR%\BIMonitor-Obfuscate
COPY %TEMP_BIMONITOR_OBFUSCATE%\%BIMonitor_EAR% %CURRENT_DIR%\BIMonitor-Obfuscate\%BIMonitor_EAR%
RMDIR /S /Q %TEMP_BIMONITOR_OBFUSCATE%
echo.
echo.
echo ===================================Completed Obfuscation. Location %CURRENT_DIR%\BIMonitor-Obfuscate\%BIMonitor_EAR%
pause