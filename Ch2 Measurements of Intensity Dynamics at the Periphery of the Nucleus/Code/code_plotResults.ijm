// store normalized total intensity values in an array
intA = newArray( nResults ); 
for ( i = 0 ; i < nResults ; i++ )
	intA[i] = getResult("RawIntDen", i) / getResult("IntDen", 0);

//prepare x-axis values
t = Array.getSequence( intA.length );

// get the statistics of the total intensity array. 
Array.getStatistics(intA, amin, amax, amean, astdDev); 

// Create the plot
Plot.create( "Total Intensity at Nuclear Membrane", "Time" , "Intensity" );
Plot.setLimits( 0, intA.length , amin * 0.9 , amax * 1.1 );
Plot.setColor( "red", "red" );
Plot.setLineWidth( 3 );
Plot.add( "circle" , t, intA );
Plot.setFontSize(14);
Plot.addLegend("Normalized Total Intensity");

  

