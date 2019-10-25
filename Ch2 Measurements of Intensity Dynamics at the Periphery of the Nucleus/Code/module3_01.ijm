// Input: 
// - Hyperstack holding the 4 channels of the FISH assay (DAPI channel first)
// Output: 
// - Split channels, no scale

// Split channels
run("Split Channels");

// Initialization
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
run("Options...", "iterations=1 count=1 edm=Overwrite");
run("Set Measurements...", "area mean centroid shape redirect=None decimal=2");