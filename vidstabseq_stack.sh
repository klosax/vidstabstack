#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Align image sequence in vidstabinput/ folder in chunks and output the stacked average of each chunk."
	echo "vidstab_stack <chunk size> [gamma]"
	echo "<chunk size> the number of frames to be aligned and stacked in each chunk"
	echo "[gamma] set to change the gamma of the output images
else

	mkdir vidstabtemp
	rm vistabtemp/*

	mkdir vidstabtemp/rest
	rm vidstabtemp/rest/*
	cp vidstabinput/frame*_input.png vidstabtemp/rest

	filecount="$(find vidstabtemp/rest -type f | wc -l)"

	chunksize=$1

	echo "$filecount images found"

	while [ $filecount -gt 0 ]
	do

		echo "Stacking chunk $filecount.."

		chunkcount=0

		for x in vidstabtemp/rest/frame*_input.png; do

			mv -- "$x" "vidstabtemp/"

			chunkcount=$((chunkcount+1))

			if [ $chunkcount -gt $((chunksize-1)) ]; then
				break
			fi

		done

		filelist=$(echo $(ls vidstabtemp/*.png | sort -n -t _ -k 2) | sed -e "s/ /|/g")

		ffmpeg -i "concat:$filelist" -vf format=yuv444p,vidstabdetect=shakiness=1:mincontrast=0.1:stepsize=1:result="vidstabtemp/transforms.trf" -f null -
		ffmpeg -i "concat:$filelist" -vf format=yuv444p,vidstabtransform=smoothing=0:zoom=0:optzoom=0:crop=black:interpol=no:input="vidstabtemp/transforms.trf",unsharp=5:5:0.8:3:3:0.4 vidstabtemp/frame%04d_stab.png

		rm vidstabtemp/frame*_input.png


		if [ -z "$2" ]; then
			convert vidstabtemp/frame*_stab.png -evaluate-sequence Mean -auto-level -auto-gamma vidstab_chunk_$filecount.png 
		else
			convert vidstabtemp/frame*_stab.png -evaluate-sequence Mean -gamma $2 vidstab_chunk_$filecount.png 
		fi

		rm vidstabtemp/frame*_stab.png

		echo "$chunkcount images stacked"

		filecount=$((filecount-chunkcount))

	done
	
	rmdir vidstabtemp/rest

	rm vidstabtemp/*
	rmdir vidstabtemp

fi

echo "Stacking done. You can now inspect the result. You can now delete the vidstabinput/ folder or run vidstab_stack again using other settings."

