
load transport.mat MTM grd M3d
% 
num_step_per_month = 265; % chosen so that dt < 3 hours
T = 365.25*24*60*60; 
dt= T/(12*num_step_per_month);
mynorm = @(x) max(abs(x)./T);

% make a structure to bundle up for easy io
sim.dt = dt;
sim.num_step_per_month = num_step_per_month;
sim.M3d = M3d;
sim.iwet = find(M3d(:));
sim.T = T;
sim.mynorm = mynorm;                  

%{
% nsoli parameters
lmeth  = 2;             % method 2 = GMRES(m)
atol = 1e-1;
rtol = 1e-4;            % stop when norm is less than atol+rtol*norm of init_resid as seen by nsoli
tol    = [atol,rtol];   % [absolute error, relative tol]
etamax = 0.9;           % maximum error tol for residual in inner iteration, default = 0.9
maxit  = 10;            % maximum number of nonlinear iterations (Newton steps) default = 40
maxitl = 15;            % maximum number of inner iterations before restart in GMRES(m), default = 40;
                        % also number of directional derivative calls, also num of gmres calls
restart_limit = 10;     % max number of restarts for GMRES if lmeth = 2, default = 20;
parms  = [maxit,maxitl,etamax,lmeth,restart_limit];

%
%}
sim = phi_age( sim, MTM);
iwet = sim.iwet;
%{
if isfile('tmp.txt')
  delete('tmp.txt');
end

names = {'cold_start', 'hot_start'};
for i = 1:length(names)
  name = names{i};
  fprintf('%s:\n',name);
  if strcmp('cold_start',name)
    x0 = sim.T + 0*sim.x0;
  else
    x0 = sim.x0;
  end
  [sol,it_hist,ierr,x_hist] = nsoli(x0(iwet),@(x) G_age(x,sim,MTM),tol,parms);
  fname = sprintf('%s.txt',name);
  movefile('tmp.txt',fname);
  fname = sprintf('%s.mat',name);
  save(fname, 'sol', 'it_hist', 'ierr', 'x_hist','T');
end

%}

figure(1)
load('cold_start.mat');
semilogy(it_hist(:,2),it_hist(:,1)/T,'-db','LineWidth',2); grid on; set(gca,'FontSize',16);
hold on
load('hot_start.mat');
semilogy(it_hist(:,2),it_hist(:,1)/T,'-or','LineWidth',2); grid on; set(gca,'FontSize',16);
xlabel('Iteration no.')
ylabel('L2 norm of drift in years/year')
print -depsc L2_norm.eps

figure(2)
load cold_start.txt
semilogy(cold_start,'-db','LineWidth',2); grid on; set(gca,'FontSize',16);
hold on
load hot_start.txt
semilogy(hot_start,'-dr','LineWidth',2); grid on; set(gca,'FontSize',16);
xlabel('Iteration no.');
ylabel('L_\infty norm of drift in years/year');
print -depsc Linfty_norm.eps

figure(3)
load hot_start.mat
% run starting from hot start initial condition
x0 = sim.x0;
x1 = x0; x2 = x0; x3 = x0;
[x1(iwet),X1] = phi_age( x0(iwet), sim, MTM );
[x2(iwet),X2] = phi_age( x1(iwet), sim, MTM );
[x3(iwet),X3] = phi_age( x2(iwet), sim, MTM );

t = 0:36*sim.num_step_per_month;
t = 3*t/t(end);

subplot(2,1,1);
pnt = 5300;
plot(t, [ X1(pnt,1:end), X2(pnt,2:end), X3(pnt,2:end) ],'-o');
set(gca,'XTick',(0:4:36)/12);
grid on
% run starting from nsoli output
x0 = sim.x0;
x1 = x0; x2 = x0; x3 = x0;
x0(iwet) = sol;
x1 = x0;
[x1(iwet),Y1] = phi_age( x0(iwet), sim, MTM );
[x2(iwet),Y2] = phi_age( x1(iwet), sim, MTM );
[x3(iwet),Y3] = phi_age( x2(iwet), sim, MTM );

subplot(2,1,1);
plot(t,[ Y1(pnt,1:end), Y2(pnt,2:end), Y3(pnt,2:end) ],'-o');
set(gca,'XTick',(0:4:36)/12);
grid on;
