	//tidy up
	// close all images
//close("*");
	// empty the ROI manager
	//roiManager("reset");
	// empty the results table
	//run("Clear Results");
	//close results table
   //	if (isOpen("Results")) {
   //    selectWindow("Results");
   //    run("Close");
   //	}



type = bitDepth()
if (type != 8){
	//--Convert to 8 bit
	run("8-bit");	
}

//-- Correct uneven illumination
run("Bandpass Filter...", "filter_large=50 filter_small=0 suppress=None tolerance=5 autoscale process");
run("Bleach Correction", "correction=[Histogram Matching]");
//- Close the log window
selectWindow("Log");
run("Close");


//-- Filter for entropy (wound is black IE low variance)
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT", "stack");
run("Variance...", "radius=3 stack");
//- Run a second round to smooth
//run("Variance...", "radius=20 stack");
run("Convert to Mask", "stack");
run("Invert LUT");
run("Analyze Particles...", "size=12000-Infinity pixel summarize stack");
//close('*');

//-- Following code for visualisations only --------------------------------------------
//-- Make edge and wound masks
run("Analyze Particles...", "size=30000-Infinity pixel show=[Masks] stack");
run("Invert LUT");
rename("Wound")
;
run("Analyze Particles...", "size=12000-Infinity pixel show=[Bare Outlines] stack");
rename("Edge");
run("Invert", "stack");
run("Dilate", "stack");
run("Dilate", "stack");

//-- Making movies
run("RGB Color", "frames keep");
run("Label...", "format=00:00 starting=0 interval=10 x=20 y=105 font=90 text=[] range=1-57");
run("Make Montage...", "columns=5 rows=3 scale=0.30 first=1 last=56 increment=4 border=5 font=12");
