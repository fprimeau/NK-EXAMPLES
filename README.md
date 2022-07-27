# NK-EXAMPLES
To run these Matlab examples execute <TT>driver.m</TT> at the Matlab prompt. <p>
  
The examples require a time-dependent Tracer Transport Matrix (TTM) that is discretized in time using 12 equally spaced time-points.

A TMM is available in the file <TT> x3POP_MTM_SPRING2022.mat</TT>, which will be downloaded automatically from <l>https://figshare.com/articles/dataset/x3POP_MTM_SPRING2022_mat/20364726</l> if the file does not already exist. The file is big and takes a long time to download so if you aleady have the needed variables on your local disk, you can create it and avoid the slow automatic download. <p><p>

<TT>x3POP_MTM_SPRING2022.mat</TT> contains the following variables: <p>
<TT> MTM</TT>: a structure with the 12 monthly tracer transport matrices <p>
<TT> grd</TT>: a structure with the mesh size definition <p>
  <TT>M3d</TT>: a three dimensional wet-dry mask with wet points <TT> M3d(i,j,k) = 1</TT> and dry points <TT> M3d(i,j,k) = 0</TT> <p> <p>
  
The first example solves for the cyclo-stationary ideal age field using the Newton-Krylov method with a preconditioner. <p>
