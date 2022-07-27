# NK-EXAMPLES
To run these Matlab examples execute <TT>age_driver.m</TT> at the Matlab prompt. <p>
  
The examples require a time-dependent Tracer Transport Matrix (TTM) that is discretized in time using 12 equally spaced time-points.

A TMM is available in the file <TT> x3POP_MTM_SPRING2022.mat</TT>, which will be downloaded automatically from <l>https://figshare.com/articles/dataset/x3POP_MTM_SPRING2022_mat/20364726</l> if the file does not already exist. The file is big and takes a long time to download so if you aleady have the needed variables on your local disk, you can load the needed variables and save them to a file named <TT> x3POP_MTM_SPRING2022.mat</TT> in the same directory as the <TT>age_driver.m</TT> script and avoid the slow automatic download. <p><p>

<TT>x3POP_MTM_SPRING2022.mat</TT> contains the following variables: <p>
<TT> MTM</TT>: a structure with the 12 monthly tracer transport matrices <p>
<TT> grd</TT>: a structure with the mesh size definition <p>
  <TT>M3d</TT>: a three dimensional wet-dry mask with wet points <TT> M3d(i,j,k) = 1</TT> and dry points <TT> M3d(i,j,k) = 0</TT> <p> 
<p>
The example in <TT>age_driver.m</TT> solves for the cyclo-stationary ideal age equation. 
<p>The script first initializes the age variable with a vector of independently and identically distributed random variables drawn from a normal distribution with mean 2000 years and variance (20 years)^2 and time-steps the equations forward in time for three years. This illustrates the model drift. 
<p>Then the script uses the same initial random vector to initialize the Newton-Krylov solver to find the cyclo-stationary state. 
<p>
Finally the script reruns the model for three years but this time uses the output from the Newton-Krylov solver to initialize the model. The resulting solution does not drift, inidicating that it is a cyclo-stationry state.<p>
