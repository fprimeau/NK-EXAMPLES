# NK-EXAMPLES
To run these Matlab examples execute <TT>driver.m</TT> at the Matlab prompt. <p>
  
The examples require a time-dependent Tracer Transport Matrix (TTM) that is discretized in time using 12 equally spaced time-points.

A TMM is available in the file <TT> x3POP_MTM_SPRING2022.mat</TT>, which will be downloaded automatically if the file does not already exist in the directory where <b> driver.m </b> is located.

<TT>x3POP_MTM_SPRING2022.mat</TT> contains the following variables: <p>
<TT> MTM</TT>: a structure with the 12 monthly tracer transport matrices <p>
<TT> grd</TT>: a structure with the mesh size definition <p>
<TT>M3d</TT>: a 3d wet-dry mask with wet points = 1 and dry points = 0 <p>
