# NK-EXAMPLES
To run these Matlab examples execute <TT>age_driver.m</TT> at the Matlab prompt. <p>
  
The examples require a time-dependent Tracer Transport Matrix (TTM) that is discretized in time using 12 equally spaced time-points.

A TMM is available in the file <TT> x3POP_MTM_SPRING2022.mat</TT>, which will be downloaded automatically from <l>https://figshare.com/articles/dataset/x3POP_MTM_SPRING2022_mat/20364726</l> if the file does not already exist. The file is big and takes a long time to download so if you aleady have the needed variables on your local disk, you can load the needed variables and save them to a file named <TT> x3POP_MTM_SPRING2022.mat</TT> in the same directory as the <TT>age_driver.m</TT> script and avoid the slow automatic download. <p><p>

<TT>x3POP_MTM_SPRING2022.mat</TT> contains the following variables: <p>
<TT> MTM</TT>: a structure with the 12 monthly tracer transport matrices <p>
<TT> grd</TT>: a structure with the mesh size definition <p>
  <TT>M3d</TT>: a three dimensional wet-dry mask with wet points <TT> M3d(i,j,k) = 1</TT> and dry points <TT> M3d(i,j,k) = 0</TT> <p> 
<p> 
The example in <TT>age_driver.m</TT> uses the ideal age equation:
 
$$\frac{∂\boldsymbol{x}}{∂t} + \left[\mathbf{T}(t) + \mathbf{R}\right]\boldsymbol{x} = \boldsymbol{1}$$

where $\mathbf{T}(t)$ is a time-periodic tracer transport matrix with period $T$ that is discretized in time using twelve piecewise constant advective-diffusive flux divertence operators and $\mathbf{R}$ is a constant surface restoring matrix that restores the tracer in the top layer of the model to zero with a time-scale of 1 day. 
 
<p>
1. The script first initializes the age variable with a vector of independently and identically distributed random variables drawn from a normal distribution with mean 2000 years and variance (20 years)^2 and time-steps the equations forward in time for three years. The drift illustrates the slow adjustment to equilibrium. 

<p>
2. Then the script uses the same initial random vector to initialize the Newton-Krylov solver to find the cyclo-stationary state. The NK solver uses a preconditioner applied to the function $\boldsymbol{G}(\boldsymbol{x}) \equiv \boldsymbol{\phi}(\boldsymbol{x},t)-\boldsymbol{x}(t)$, where $\boldsymbol{\phi}(\boldsymbol{x},t)$ uses the ideal age equation and the initial condition, $\boldsymbol{x}$, to find the age one year later, i.e., to find $\boldsymbol{x}(t+T)$, the age at time $t+T$.  The preconditioner that allows for rapid convergence of the Krylov solver consists of applying $\left(\left[\overline{\mathbf{T}}+\mathbf{R}\right]^{-1}\!-\mathbf{I}\right)$ to $\boldsymbol{G}(\boldsymbol{x})$.

<p>  
3. Finally the script reruns the model for three years but this time uses the output from the Newton-Krylov solver to initialize the model. The resulting solution does not drift, inidicating that it is a cyclo-stationry state.<p>
  
Xingwen Li, François W. Primeau, A fast Newton–Krylov solver for seasonally varying global ocean biogeochemistry models,
Ocean Modelling, Volume 23, Issues 1–2 2008, Pages 13-20, ISSN 1463-5003,
https://doi.org/10.1016/j.ocemod.2008.03.001.
(https://www.sciencedirect.com/science/article/pii/S1463500308000371)
