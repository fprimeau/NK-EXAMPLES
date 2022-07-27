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
3. Finally the script reruns the model for three years but this time uses the output from the Newton-Krylov solver to initialize the model. The resulting solution does not drift, inidicating that it is a cyclo-stationry state.<p

![NK_drift_Linfinity_norm](https://user-images.githubusercontent.com/7294603/181362571-4163aa5e-a837-4058-a817-5d00e7afdfbc.png)
![drift_before_and_after](https://user-images.githubusercontent.com/7294603/181362632-6ae98b63-1a84-4c72-a852-60d74aa02536.png)
<p>
  <strong>Figures 1</strong>  The left (or upper) panel shows the L-$\infty$ norm of the 1-year drift in the ideal age during for each call to $\boldsymbol{G}(\boldsymbol{x})$ by the <TT>nsoli.m</TT> solver. The curves in the right (or lower) panel show the ideal age as a function of time obtained by time-stepping the equations forward in time. The black curve corresponds to the random vector initialization and the red curve corresponds to the initialization using the output from the NK solver. 
<p>
# Bibliography
<p>  
Xingwen Li, François W. Primeau, A fast Newton–Krylov solver for seasonally varying global ocean biogeochemistry models,
Ocean Modelling, Volume 23, Issues 1–2 2008, Pages 13-20, ISSN 1463-5003,
https://doi.org/10.1016/j.ocemod.2008.03.001.
(https://www.sciencedirect.com/science/article/pii/S1463500308000371)
<p>
Ann Bardin, François Primeau, Keith Lindsay, An offline implicit solver for simulating prebomb radiocarbon,
Ocean Modelling, Volume 73, 2014, Pages 45-58, ISSN 1463-5003,
https://doi.org/10.1016/j.ocemod.2013.09.008.
(https://www.sciencedirect.com/science/article/pii/S1463500313001820)
<p> 
Ann Bardin, François Primeau, Keith Lindsay, Andrew Bradley, Evaluation of the accuracy of an offline seasonally-varying matrix transport model for simulating ideal age, Ocean Modelling,
Volume 105, 2016, Pages 25-33, ISSN 1463-5003,
https://doi.org/10.1016/j.ocemod.2016.07.003.
(https://www.sciencedirect.com/science/article/pii/S1463500316300750)
<p>
Weiwei Fu, François Primeau, Application of a fast Newton–Krylov solver for equilibrium simulations of phosphorus and oxygen,
Ocean Modelling, Volume 119, 2017, Pages 35-44, ISSN 1463-5003,
https://doi.org/10.1016/j.ocemod.2017.09.005.
(https://www.sciencedirect.com/science/article/pii/S1463500317301336)
