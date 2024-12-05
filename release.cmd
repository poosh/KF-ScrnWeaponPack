@echo off

setlocal

set CURDIR=%~dp0
call ..\ScrnMakeEnv.cmd %CURDIR%

echo Removing previous release files...
del /S /Q %RELEASEDIR%\*

:: Sanity check
if exist %RELEASEDIR%\System\%KFPACKAGE%.u (
    echo Failed to cleanup the release directory
    set /A ERR=100
    goto :error
)

del %KFDIR%\System\%KFPACKAGE%.ucl 2>nul

echo Compiling project...
call make.cmd
set /A ERR=%ERRORLEVEL%
if %ERR% NEQ 0 goto error

echo Exporting .int file...
%KFDIR%\System\ucc dumpint %KFPACKAGE%.u

echo.
echo Copying release files...
xcopy /F /I /Y *.ini %RELEASEDIR%
xcopy /F /I /Y *.txt %RELEASEDIR%
xcopy /F /I /Y *.md  %RELEASEDIR%

mkdir %RELEASEDIR%\System 2>nul
xcopy /F /I /Y %KFDIR%\System\%KFPACKAGE%.int %RELEASEDIR%\System\
xcopy /F /I /Y %KFDIR%\System\%KFPACKAGE%.u %RELEASEDIR%\System\
xcopy /F /I /Y %KFDIR%\System\%KFPACKAGE%.ucl %RELEASEDIR%\System\

mkdir %RELEASEDIR%\Animations 2>nul
xcopy /F /I /Y %STEAMDIR%\Animations\ScrnWeaponPack_A.ukx %RELEASEDIR%\Animations\

mkdir %RELEASEDIR%\Sounds 2>nul
xcopy /F /I /Y %STEAMDIR%\Sounds\ScrnWeaponPack_SND.uax %RELEASEDIR%\Sounds\

mkdir %RELEASEDIR%\StaticMeshes 2>nul
xcopy /F /I /Y %STEAMDIR%\StaticMeshes\ScrnWeaponPack_SM.usx %RELEASEDIR%\StaticMeshes\

mkdir %RELEASEDIR%\Textures 2>nul
xcopy /F /I /Y %STEAMDIR%\Textures\ScrnWeaponPack_T.utx %RELEASEDIR%\Textures\

if not exist %RELEASEDIR%\System\%KFPACKAGE%.u (
    echo Release failed
    set /A ERR=101
    goto :error
)

echo.
echo Updating the bundle...
xcopy /F /I /Y %RELEASEDIR%\System\*                %BUNDLEDIR%\System\

echo.
echo Compressing uz2...
mkdir %RELEASEDIR%\uz2 2>nul
call :MakeUz2 System\%KFPACKAGE%.u
echo %RELEASEDIR%\uz2:
dir /B %RELEASEDIR%\uz2
xcopy /F /I /Y %RELEASEDIR%\Uz2\*.uz2               %BUNDLEUZ2%\

echo Release is ready!

goto :end

:error
color 0C

:end
endlocal & SET _EC=%ERR%
exit /b %_EC%

:MakeUz2
%KFDIR%\System\ucc compress %RELEASEDIR%\%1 && move /y %RELEASEDIR%\%1.uz2 %RELEASEDIR%\uz2\ >nul
set %~1=%~n2
exit /b 0
