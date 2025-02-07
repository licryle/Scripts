@ECHO OFF
	For /F "tokens=* delims=" %%A in ('identify -format "%%w" %1') Do ( Set Width=%%A )
	For /F "tokens=* delims=" %%A in ('identify -format "%%h" %1') Do ( Set Height=%%A )
	For /F "tokens=* delims=" %%A in ('identify -format "%%[EXIF:DateTime]" %1') Do ( Set Date=%%A )

	set Date=%Date:~0,10%
	set Date=%Date::=/%
	set Legend=%3
	set Legend=%Legend:"=%
	
	if %Width% GTR %Height% ( set Size="800x" ) else ( set Size="x800" )
	convert %1[0] -resize %Size% xc:transparent -flatten -fill "#FFFFFF" -undercolor "rgba(0, 0, 0, 0.4)" -font Verdana-Italic -pointsize 13 -gravity SouthEast -draw @copyright -draw "text 376,0 '%Legend%'" -undercolor "rgba(0, 0, 0, 0)" -draw "text 170,0 '%Date%'" %2
@ECHO ON
echo "File %1 >>>> copyrighted into >>>> %2"