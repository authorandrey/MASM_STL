@echo off
setlocal

set "MASM_HOME=C:\masm32"
set "ML_EXE=%MASM_HOME%\bin\ml.exe"
set "LINK_EXE=%MASM_HOME%\bin\link.exe"

set "SRC=src"
set "OBJ=obj"
set "LIBS=libs"

if not exist "%ML_EXE%" (
    echo [ERROR] ml.exe not found: %ML_EXE%
    exit /b 1
)
if not exist "%LINK_EXE%" (
    echo [ERROR] link.exe not found: %LINK_EXE%
    exit /b 1
)

if not exist "%OBJ%"  mkdir "%OBJ%"
if not exist "%LIBS%" mkdir "%LIBS%"

if "%~1"=="" goto usage
if /i "%~1"=="ALL" goto build_all

:loop
if "%~1"=="" goto done
call :find_and_build "%~1"
if errorlevel 1 goto fail
shift
goto loop

:usage
echo Usage:
echo   build.bat Vector
echo   build.bat Vector List Map
echo   build.bat ALL
exit /b 1

:build_all
for /f "delims=" %%F in ('dir /s /b "%SRC%\*.asm"') do call :build_one "%%F"
goto done

:find_and_build
set "NAME=%~1"
set "FOUND="
for /f "delims=" %%F in ('dir /s /b "%SRC%\%NAME%.asm" 2^>nul') do set "FOUND=%%F"
if not defined FOUND (
    echo [ERROR] %NAME%.asm not found under %SRC%\
    exit /b 1
)
call :build_one "%FOUND%"
exit /b 0

:build_one
set "FULL=%~1"
for %%F in ("%FULL%") do set "NAME=%%~nF"
echo [%NAME%] %FULL%
"%ML_EXE%" /c /coff /nologo /Fo"%OBJ%\%NAME%.obj" "%FULL%"
if errorlevel 1 (
    echo [ERROR] ml %NAME%
    exit /b 1
)
"%LINK_EXE%" -lib /nologo /out:"%LIBS%\%NAME%.lib" "%OBJ%\%NAME%.obj" < nul
if errorlevel 1 (
    echo [ERROR] link %NAME%
    del /q "%OBJ%\%NAME%.obj"
    exit /b 1
)
del /q "%OBJ%\%NAME%.obj"
echo [%NAME%] OK
exit /b 0

:fail
:done
exit /b 0