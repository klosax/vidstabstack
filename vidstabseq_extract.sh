#!/bin/bash

if [ $# != 5 ]; then
	echo "Extract image sequence from video file to vidstabinput/ folder"
	echo "vidstab_extract [ <inputvideo> <starttime> <endtime> <scaling> <deinterlace> ]"
	echo "<inputvideo> filename of input video"
	echo "<starttime> image sequence start hh:mm:ss"
	echo "<endtime> image sequence start hh:mm:ss"
	echo "<scaling> scaling factor ( 1, 2, 4, 8 .. )"
	echo "<deinterlace> 0 input video is progressive, 1 input video is interlaced (scaling should be set to 1)"
else

	mkdir vidstabinput
	rm vidstabinput/*

	echo "Extract video frames.."

	vfopt="format=rgb24,scale=iw*$4:ih*$4"

	ffmpeg -ss $2 -to $3 -i $1 -an -vf $vfopt vidstabinput/frame%04d_input.png

	if [ $5 -gt 0 ]; then

		echo "Deinterlacing frames.."

		for x in vidstabinput/frame*_input.png; do

			convert "$x" -sample 100%x50% -sample 100%x200% "${x%_input.png}_field1_input.png"
			convert "$x" -roll +0+1 -sample 100%x50% -roll +0-1 -sample 100%x200% "${x%_input.png}_field2_input.png"
			rm "$x"

		done
	fi

	echo "Extract done. Delete unwanted frames from vidstabinput/ and run vidstab_stack.sh"
fi


