# NK-EXAMPLES
The examples require a time-dependent Tracer Transport Matrix (TTM) that is discretized in time using 12 equally spaced time-points.

A TMM is available in the file <b> x3POP_MTM_SPRING2022.mat</b>, which will be downloaded automatically if the file does not already exist in the directory where <b> driver.m </b> is located.

<b>x3POP_MTM_SPRING2022.mat</b> contains the following variables:
<i> MTM</i>: a structure with the 12 monthly tracer transport matrices <p>
<i> grd</i>: a structure with the mesh size definition <p>
<i>M3d</i>: a 3d wet-dry mask with wet points = 1 and dry points = 0 <p>
