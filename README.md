# Scripts for HCR analysis in ImageJ 

Caveat: these are my first ImageJ macros. They work for my workflow, but may not be generalisable, and are not elegantly written. In particular, the sigma values and thresholding for the Gaussian may not work for other imaging pipelines. I also use the third channel to define the region of the tissue to be imaged- and intend to change this to make the script more general. 

I do most of my imaging on our FV-1000 confocal, using a silicon oil lens (NA = ??). Thus far, I've been working on honeybee ovaries.  

## What's in here? 

#### `scripts/process-HCR.ijm` 

- a short script that subtracts the background from the image (making the dots/signal clearer), and recolours and merges the channels.

- by default: Channel 1 = blue. Channel 2 = Green. Channel 3 = Magenta. 

#### `scripts/dHCR.ijm`

- blurs the third channel, thresholds it, and uses it as a mask to define the region of the tissue to image. The largest ROI/particle is used as the mask. 

- applies a Gaussian filter (sigma = 0.13, because that's what worked for my data) to all channels, subtracts the background, then thresholds the image. Watershed segmentation is used to split 'dots'. (This should probably be done before thresholding.) 

- uses the `Analyze Particles` function to count particles. 

Input: an image. Output: three files. 

1) `[Imagename].csv`: Counts of particles in each channel. 

2) `Areas[Imagename].csv`: the area of the ROI measured

3) `[Imagename].tif`: the final thresholded image (sanity check). 

#### `scripts/dHCR-stacks.ijm` 

- basically the same as `dHCR.ijm`, but returns data for each slice of a Z-stack. 

- handy if you want to know if dot dentisties vary with depth. 


## TODO

- add R scripts for analysis 

- make it more generalisable (ie use the signal in each channel to make a mask for that channel) 

 
