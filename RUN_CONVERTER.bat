@echo off
setlocal enabledelayedexpansion
title YT to MP3

REM === Base Paths ===
set "BASE=C:\Users\andre\OneDrive\Desktop\YT_MP3"
set "VENV=%BASE%\.venv\Scripts"
set "OUTDIR=%BASE%\YT_MP3_Downloads"

REM Ensure output directory exists
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

REM Ensure yt-dlp exists
if not exist "%VENV%\yt-dlp.exe" (
  echo.
  echo =========================================
  echo               ERROR
  echo =========================================
  echo yt-dlp not found in virtual environment.
  echo Expected location:
  echo %VENV%\yt-dlp.exe
  echo.
  echo Activate the venv and run:
  echo     pip install yt-dlp
  echo.
  pause
  exit /b 1
)

REM === Header Banner ===
echo =========================================
echo                YT to MP3
echo =========================================
echo.
echo Paste a YouTube URL and press ENTER
echo.

set /p "URL=> "

REM Validate input
if "%URL%"=="" (
  echo.
  echo ERROR: No URL provided.
  echo.
  pause
  exit /b 1
)

echo.
echo Downloading and converting...
echo -----------------------------------------

"%VENV%\yt-dlp.exe" ^
  --js-runtimes node ^
  -x ^
  --audio-format mp3 ^
  --audio-quality 0 ^
  --embed-metadata ^
  --embed-thumbnail ^
  -o "%OUTDIR%\%%(title)s.%%(ext)s" ^
  "%URL%"

REM Capture exit code
set "RESULT=%ERRORLEVEL%"

if not "%RESULT%"=="0" (
  echo.
  echo =========================================
  echo               ERROR
  echo =========================================
  echo yt-dlp failed with exit code %RESULT%
  echo.
  pause
  exit /b %RESULT%
)

REM === Completion Banner ===
echo.
echo.
echo.
echo =========================================
echo            CONVERSION COMPLETE
echo =========================================
echo.
echo.
echo.
echo Output folder:
echo %OUTDIR%
echo.

REM Short delay so completion is visible
timeout /t 2 /nobreak >nul

explorer "C:\Users\andre\OneDrive\Desktop\YT_MP3\YT_MP3_Downloads"

exit /b 0
