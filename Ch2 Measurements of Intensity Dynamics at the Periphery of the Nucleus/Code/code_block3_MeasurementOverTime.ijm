orgName = getTitle();
run("Split Channels");
c1name = "C1-" + orgName;
c2name = "C2-" + orgName;
selectWindow(c1name);
c1id = getImageID();
selectWindow(c2name);
c2id = getImageID();
opt = "area mean centroid perimeter shape integrated limit display redirect=None decimal=3";
run("Set Measurements...", opt);
for (i =0; i < nSlices; i++){
    selectImage( c1id );
    setSlice( i + 1 );
    run("Create Selection");
    run("Make Inverse");
    selectImage( c2id );
    setSlice( i + 1 );
    run("Restore Selection");
    run("Measure");
}
