@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM  setup.bat - generates junction-точки in inc\<Module>\
REM  for each neighboring module for MASM to find
REM  nested include.
REM ============================================================

for %%I in ("%~dp0..") do set "LIB_ROOT=%%~fI"
set "INC=%LIB_ROOT%\inc"

if not exist "%INC%" (
    echo [ERROR] inc\ not found at %INC%
    exit /b 1
)

echo [INFO] lib = %LIB_ROOT%
echo [INFO] inc = %INC%
echo.

for /d %%F in ("%INC%\*") do (
    echo [%%~nxF]
    for /d %%G in ("%INC%\*") do (
        if /i not "%%~nxF"=="%%~nxG" (
            if not exist "%%~fF\%%~nxG" (
                mklink /J "%%~fF\%%~nxG" "%%~fG" >nul 2>&1
                if errorlevel 1 (
                    echo   [FAIL] %%~nxG
                ) else (
                    echo   [OK]   %%~nxG
                )
            )
        )
    )
)

echo.
echo Done.