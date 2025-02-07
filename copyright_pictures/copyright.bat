@ECHO OFF
FOR /F %%i in ('dir /B %1\*.jpg') do copyright_picture %1\%%i %2\%%i %3
@ECHO ON
pause