run("Subtract Background...", "rolling=50 stack");
//run("Channels Tool...");
Stack.setChannel(1);
run("Blue");
Stack.setChannel(2);
run("Green");
Stack.setChannel(3);
run("Magenta");
Stack.setDisplayMode("composite");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Enhance Contrast", "saturated=0.35");
run("Enhance Contrast", "saturated=0.35");

