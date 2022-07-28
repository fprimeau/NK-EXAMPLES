fname = 'x3POP_MTM_SPRING2022.mat';
if ( isfile('x3POP_MTM_SPRING2022.mat') )
    load( fname, 'MTM', 'grd', 'M3d');
else
    %
    % The code requires the three variables MTM, grd, and M3d
    % If you don't have them on your computer you can download them from 
    % https://figshare.com/articles/dataset/x3POP_MTM_SPRING2022_mat/20364726
    % using your web browser, OR you can let this script download it for you.
    % 
    fprintf('Tracer Transport Matrix %s does not exist.\n',fname);
    fprintf('Fethcing it from the web. Please be patient, it is a big file.\n');
    !wget --no-check-certificate https://figshare.com/ndownloader/files/36403485
    movefile('36403485',fname);
    fprintf('\n')
    fprintf('Loading MTM, grd, and M3d from %s',fname);
    %
end
% 
num_step_per_month = 245; % chosen so that dt < 3 hours
T = 365.25*24*60*60; 
dt= T/(12*num_step_per_month);
mynorm = @(x) max(abs(x)./T);

% make a structure to bundle up function arguments
sim.dt                 = dt;
sim.num_step_per_month = num_step_per_month;
sim.M3d                = M3d;
sim.iwet               = find(M3d(:));
sim.T                  = T;
sim.mynorm             = mynorm;                  

%
% initialize the one-year integrator
%
fprintf('Initializing the age solver...\n');
sim = phi_age( sim, MTM);
%
% Time step forward for 3 years to illustrate the drift
%
name = 'cold_start';
fprintf( '%s:\n', name );
iwet = sim.iwet;
%x    = sim.x0(iwet);  % steady state solution obtained using the annual average of the TTM 
x0 = 2000*T+20*randn(length(iwet),1); % init with iid x0 ~ N(2000 yrs, (20 yrs)^2)
tic;
x = x0;
% run for three years
[x,Y1,t1] = phi_age( x, sim, MTM );    
[x,Y2,t2] = phi_age( x, sim, MTM );    
[x,Y3,t3] = phi_age( x, sim, MTM );    
toc; 
fprintf('\n');

% make a plot of age near the surface (where there is a strong seasonal cycle) 
% as a function of time
figure(1)
peek = 370018;
plot( [ t1(1:end-1), t1(end) + t2(1:end-1), t1(end) + t2(end) + t3 ] / T, ...
      [ Y1(peek,1:end-1), Y2(peek,1:end-1), Y3(peek,:) ] / T, '-k', 'LineWidth', 2 );
xlabel('time (years)');
ylabel('age (years)')
grid on
hold on
drawnow

%
% Try nsoli spin-up first
%
% nsoli parameters
lmeth  = 2;             % method 2 = GMRES(m)
atol   = 5e-2;
rtol   = 1e-6;          % stop when norm is less than atol+rtol*norm of init_resid as seen by nsoli
tol    = [atol,rtol];   % [absolute error, relative tol]
etamax = 0.9;           % maximum error tol for residual in inner iteration, default = 0.9
maxit  = 10;            % maximum number of nonlinear iterations (Newton steps) default = 40
maxitl = 15;            % maximum number of inner iterations before restart in GMRES(m), default = 40;
                        % also number of directional derivative calls, also num of gmres calls
restart_limit = 10;     % max number of restarts for GMRES if lmeth = 2, default = 20;
parms  = [maxit,maxitl,etamax,lmeth,restart_limit];
 
[sol,it_hist,ierr,x_hist] = nsoli(x0, @(x) G_age(x,sim,MTM), tol, parms);
%
fname = sprintf('%s.txt',name);
movefile('tmp.txt',fname);
%
fname = sprintf('%s.mat',name);
save(fname, 'sol', 'it_hist', 'ierr', 'x_hist','T');

figure(2)
load('cold_start.mat');
semilogy(it_hist(:,2),it_hist(:,1)/T,'-or','LineWidth',2); grid on; set(gca,'FontSize',16);
xlabel('Iteration no.')
ylabel('L2 norm of drift in years/year')
print -depsc L2_norm.eps

figure(3)
load cold_start.txt
semilogy(cold_start,'-dr','LineWidth',2); grid on; set(gca,'FontSize',16);
xlabel('Iteration no.');
ylabel('L_\infty norm of drift in years/year');
print -depsc Linfty_norm.eps


tic;
% run for three years
[x,Y1,t1] = phi_age( sol, sim, MTM );    
[x,Y2,t2] = phi_age( x, sim, MTM );    
[x,Y3,t3] = phi_age( x, sim, MTM );    
toc; 
fprintf('\n');

% make a plot of age near the surface (where there is a strong seasonal cycle) 
% as a function of time
figure(1)
plot( [ t1(1:end-1), t1(end) + t2(1:end-1), t1(end) + t2(end) + t3 ] / T, ...
      [ Y1(peek,1:end-1), Y2(peek,1:end-1), Y3(peek,:) ] / T, '-r', 'LineWidth', 2 );
grid on
drawnow
