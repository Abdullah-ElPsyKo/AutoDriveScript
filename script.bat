@echo off
setlocal EnableDelayedExpansion

:: Pas hier de volumenaam en het uit te voeren bestand aan
set VOLUME_NAME=ESD-USB
set FILE_NAME=test.txt

echo Searching for drive with volume name %VOLUME_NAME%...

for /f "tokens=1,2 delims==" %%i in ('wmic logicaldisk get name^,volumename /format:value 2^>nul') do (
    if "%%i"=="Name" (
        set "drive=%%j"
    ) else if "%%i"=="VolumeName" (
        set "volName=%%j"
        set "volName=!volName:~0,-1!"
        if "!volName!"=="%VOLUME_NAME%" (
            set "DRIVE_LETTER=!drive:~0,-1!"
        )
    )
)

if defined DRIVE_LETTER (
    echo Found %VOLUME_NAME% on drive !DRIVE_LETTER!
    echo Attempting to open %FILE_NAME% on drive !DRIVE_LETTER!
    if exist "!DRIVE_LETTER!\%FILE_NAME%" (
        start "" "!DRIVE_LETTER!\%FILE_NAME%"
    ) else (
        echo File "%FILE_NAME%" not found on drive !DRIVE_LETTER!.
    )
) else (
    echo Drive %VOLUME_NAME% not found.
)
