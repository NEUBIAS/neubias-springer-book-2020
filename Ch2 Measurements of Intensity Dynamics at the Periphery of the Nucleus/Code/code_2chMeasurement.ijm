orgtitle = getTitle();
c1title = "C1-" + orgtitle;
c2title = "C2-" + orgtitle;
run("Split Channels");
selectWindow(c2title);
run("Gaussian Blur...", "sigma=1");
run("Auto Local Threshold", "method=Mean radius=100 parameter_1=0 parameter_2=0 white");
run("Analyze Particles...", 
	"size=50-Infinity circularity=0.00-1.00 show=Nothing exclude clear include add");
count = roiManager("count");
for ( i = 0 ; i < count; i++){
	roiManager("Select", i);
	roiManager("Set Line Width", 2);
	run("Area to Line");
	run("Line to Area");
	roiManager("Update");
}
roiManager("Deselect");
roiManager("Combine");

selectWindow(c1title);
roiManager("Select", 0);
getRawStatistics(nPixels, mean, min, max, std, histogram)
print("Mean:", mean, " Min:",  min, "Max:", max, "std", std);