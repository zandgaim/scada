@echo off
REM Get the directory of the script, no matter where it is run from
set SCRIPT_DIR=%~dp0

REM Check if Python is installed
py --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Python is not installed. Please install Python first.
    exit /b 1
)

REM Check if virtualenv is installed
pip show virtualenv >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo virtualenv is not installed. Installing it now...
    pip install virtualenv
)

REM Define the location of the virtual environment (one level up from the Scripts folder)
set VENV_DIR=%SCRIPT_DIR%\..\..\venv

REM Create the virtual environment in the parent directory (project root)
echo Creating virtual environment in %VENV_DIR%...
virtualenv %VENV_DIR%

REM Activate the virtual environment
call %VENV_DIR%\Scripts\activate.bat

REM Install required dependencies
echo Installing dependencies from %SCRIPT_DIR%\requirements.txt...
pip install -r "%SCRIPT_DIR%requirements.txt"

REM Deactivate the virtual environment
echo Deactivating virtual environment...
deactivate

echo Virtual environment setup complete. You can now run the project.
pause
