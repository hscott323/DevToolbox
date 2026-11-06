@echo off
setlocal

set "BUILD_DIR=build"
set "GENERATOR=Ninja"

cmake -S . -B "%BUILD_DIR%" -G "%GENERATOR%" -DCMAKE_CXX_COMPILER=clang++
if errorlevel 1 exit /b 1

cmake --build "%BUILD_DIR%"
if errorlevel 1 exit /b 1

for /f "delims=" %%A in ('powershell -NoProfile -Command "(Select-String -Path CMakeLists.txt -Pattern '^\s*project\s*\(\s*([^\s\)]+)' | Select-Object -First 1).Matches.Groups[1].Value"') do (
    set "PROJECT_NAME=%%A"
)

if not defined PROJECT_NAME (
    echo ERROR: Could not determine project name.
    exit /b 1
)

if not exist "%BUILD_DIR%\%PROJECT_NAME%.exe" (
    echo ERROR: Executable not found.
    exit /b 1
)

cls
"%BUILD_DIR%\%PROJECT_NAME%.exe"

endlocal