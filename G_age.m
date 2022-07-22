function [r,G] = G_age(x0,sim,MTM)
% r = G_age(x0,sim,MTM)
% r is the preconditionned value of G
%    
% evaluate G
    G  = phi_age( x0, sim, MTM ) - x0;
    % apply the preconditioner to G
    fprintf('||G(x)|| = %e years \n',max(abs(G))/sim.T);
    r = mfactor(sim.FQ, G) - G;    
    fprintf('  ||G(x)|| = %e years \n',max(abs(r))/sim.T);
    
    fid = fopen('tmp.txt','a');
    fprintf(fid,'%f \n',sim.mynorm(r));
    fclose(fid);
end

