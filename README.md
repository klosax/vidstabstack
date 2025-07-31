# Extract frame sequence and create aligned stacked images from videofiles

## Requires
* FFMPEG with [VidStab](https://github.com/georgmartius/vid.stab) library.
* ImageMagick with convert tool.

## Scripts
* Extract image sequence from a video file: `vidstabseq_extract`
* Align and stack image sequence in chunks: `vidstabseq_stack`

Run the scripts without any arguments to show help.

## Workflow

* Extract from timestamp 06m21s to 06m46s, frames should be scaled 2x, video is not interlaced:\
`sh vidstabseq_extract myvideo.mp4 06:21 06:46 2 0`

* The extracted frames will be stored in `vidstabinput/` folder, which could be manually inspected and bad frames deleted.

* Align and stack the frames stored in `vidstabinput/` folder in chunks, using 20 images in each chunk, saving the output images in the current folder:\
`sh vidstab_stack 20`

* The output images can now be inspected. If the result is bad try using different chunk sizes and/or delete any bad frames.

* When done the `vidstabinput/` folder can be deleted.
