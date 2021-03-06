//if you open an image file and select the germarium as an ROI
//this macro will output the no. of dots in each stack
//ignore the dapi channel, it will be meaningless. 
//and make sure you are NOT working with a z-stack!
name=getTitle;
id="test_10.07.18/"
dir="/home/shannon/Documents/dHCR/data/"; 
path=dir+id;
run("Measure");
run("Gaussian Blur...", "sigma=0.13 scaled stack");
run("Subtract Background...", "rolling=5 stack");
setAutoThreshold("Default dark");
//run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark calculate");
run("Watershed", "stack");
run("Analyze Particles...", "size=0-5 show=[Bare Outlines] summarize display stack");
selectWindow("Summary of "+name);
saveAs("Measurements", path + name +".csv");
selectWindow(name); 
saveAs("Tiff", path+name+".tiff");