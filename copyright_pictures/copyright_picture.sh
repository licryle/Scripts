#!/bin/bash
width=$(identify -format "%w" $1)
height=$(identify -format "%w" $1)

# Parse and format date
date=$(identify -format "%[EXIF:DateTime]" $1)
date=${date:0:10}
date=${date//:/\/}

# Parse Orientation
orientation=$(identify -format "%[EXIF:Orientation]" $1)

legend=$3

# get maxSize if set, default to 800px
if [ -z $4 ]; then
  maxSize='800'
else
  maxSize=$4
fi

# look for longer side to set format in desired output maxSize
if [ "$orientation" -le 4 ]; then
  size="${maxSize}x"
else
  size="x${maxSize}"
fi

convert $1[0] -auto-orient -resize $size xc:transparent -flatten -fill "#FFFFFF" -undercolor "rgba(0, 0, 0, 0.4)" -font ./Verdana_Italic.ttf -pointsize 13 -gravity SouthEast -draw @copyright -draw "text 376,0 ' $legend'" -undercolor "rgba(0, 0, 0, 0)" -draw "text 170,0 '$date'" $2

echo "File $1 >>>> copyrighted into >>>> $2 at size $size"
