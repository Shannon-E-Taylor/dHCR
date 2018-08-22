//if you open an image file and select the germarium as an ROI
//this macro will output the no. of dots in each stack
//ignore the dapi channel, it will be meaningless. 
//and make sure you are NOT working with a z-stack!

//initialize names
name=getTitle;
id="test_21.8.18/Workers/";
dir="/home/shannon/Documents/dHCR/data/"; 
path=dir+id;
sample = "queen.csv" //CHANGE ME

//convert vasa channel to mask
run("Duplicate...", "duplicate channels=3");
rename("mask")
selectWindow("mask");
run("Gaussian Blur...", "sigma=6 scaled");
setAutoThreshold("RenyiEntropy dark no-reset");
//RoiManagerAddParticles
run("Analyze Particles...", "minimum=1 maximum=10E20 bins=20 show=Nothing clear record");
  for (i=0; i<nResults; i++) {
      x = getResult('XStart', i);
      y = getResult('YStart', i);
      doWand(x,y);
      roiManager("add");
  }

//select only the largest ROI
if (roiManager("count")>1);{
        Area=newArray(roiManager("count"));
        for (i=0; i<roiManager("count");i++){
                roiManager("select", i);
                getStatistics(Area[i], mean, min, max, std, histogram);
        }
        AreaLarge = 0;
        for (i=0; i<(roiManager("count"));i++){
                if (Area[i]>AreaLarge){
                        AreaLarge=Area[i];
                        large = i;
                }
        }
}
selectWindow("mask"); 
run("Close"); 

//crop original images
selectWindow(name);
roiManager("Select", large); 
run("Crop");

//Measure and save lengths
run("Measure");
selectWindow("Results"); 
saveAs("Measurements", path + "Areas" + name + ".csv" ); 
run("Close");

//Count dots in cropped images
selectWindow(name); 
run("Gaussian Blur...", "sigma=0.13 scaled stack");
run("Subtract Background...", "rolling=5 stack");
setAutoThreshold("Default dark");
//run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark calculate");
run("Watershed", "stack");
run("Analyze Particles...", "size=0-5 show=[Bare Outlines] summarize stack");
selectWindow("Summary of "+name);
saveAs("Measurements", path + name +".csv");
run("Close"); 
selectWindow(name); 
saveAs("Tiff", path+name+".tiff");

roiManager("reset"); 


