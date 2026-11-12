@echo off
setlocal
set "APP_HOME=%~dp0"
set "GRADLE_VERSION=8.7"
set "GRADLE_HOME=%USERPROFILE%\.gradle\wrapper\dists\manual-gradle-%GRADLE_VERSION%"
set "GRADLE_EXE=%GRADLE_HOME%\gradle-%GRADLE_VERSION%\bin\gradle.bat"
if not exist "%GRADLE_EXE%" (
  echo Downloading Gradle %GRADLE_VERSION%...
  if not exist "%GRADLE_HOME%" mkdir "%GRADLE_HOME%"
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%GRADLE_HOME%\gradle.zip'; Expand-Archive -Force '%GRADLE_HOME%\gradle.zip' '%GRADLE_HOME%'"
  if errorlevel 1 (
    echo Gradle download failed. Install Gradle 8.7 manually and add gradle to PATH.
    exit /b 1
  )
)
call "%GRADLE_EXE%" -p "%APP_HOME%" %*
exit /b %ERRORLEVEL%
