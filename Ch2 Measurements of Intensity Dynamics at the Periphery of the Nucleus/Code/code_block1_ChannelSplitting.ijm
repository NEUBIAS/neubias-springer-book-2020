orgName = getTitle();
run("Split Channels");
c1name = "C1-" + orgName;
c2name = "C2-" + orgName;
selectWindow(c1name);
c1id = getImageID();
selectWindow(c2name);
c2id = getImageID();