function [varargout] = phi_age(varargin)
% sim      = phi_age(sim,MTM);         % Initialize
% c1       = phi_age(c0,sim,MTM);       % Run for 1 year and return the last time-step
% [c1,X,t] = phi_age(c0,sim,MTM); % Run for 1 year and return the time-series of the model state vector
    
    if (nargin == 3) 
        % time step forward for 1 year
        c   = varargin{1};
        sim = varargin{2};
        MTM = varargin{3};

        dt = sim.dt;
        C  = zeros(length(c),3);
        %
        i1 = 1; i2 = 2; i3 = 3;    
        C(:,i1) = c;
        % ------------------ advection -----+--horiz diffu-----+--source---+
        %                                   |                  |           |
        %                                   v                  v           v
        rate = @(a, b, month ) ( MTM(month).A * a + MTM(month).H * b + sim.S);

        if (nargout > 1)
            % save the time-series
            X = zeros( length(c), 12*sim.num_step_per_month + 1 );
            j = 1;

            X(:,j) = c; % initial condition
            t(j)   = 0; % initial time

            j      = j+1;
        end
        for month = 1:12
            for k = 1:sim.num_step_per_month
                switch(k)
                  case 1
                    % first pump-priming step: 1st-order Adams Bashforth advection, Euler Fordward horizontal diffusion
                    rhs  = C(:,i1) + dt * rate( C(:,i1), C(:,i1), month ); 
                    pntr = i2;
                  case 2
                    % second pump-priming step: 2nd-order Adams Bashforth advection, Euler Forward horizontal diffrusion
                    w = (1/2) * ( 3 * C(:,i2) - C(:,i1) );
                    rhs = C(:,i2) + dt * rate( w, C(:,i1), month );
                    pntr = i3;
                  otherwise
                    % 3rd-order Adams Bashforth advection, Euler Forward horizontal diffusion
                    w = (1/12) * ( 23 * C(:,i3) - 16 * C(:,i2) + 5 * C(:,i1) );
                    rhs = C(:,i3) + dt * rate( w, C(:,i2), month );
                    pntr = i1;
                    i1 = i2; i2 = i3; i3 = pntr;
                end
                C(:,pntr) = mfactor( sim.FD(month), rhs ); % Euler Backward vertical diffusion and surface restoring
                if (nargout > 1)
                    X(:,j) = C(:,pntr); 
                    t(j)   = dt + t(j-1);
                    j = j+1;
                end
            end
            varargout{1} = C(:,i1);
            if (nargout > 1)
                % output the state time series
                varargout{2} = X(:,2:end);  % remove the first fence post b.c. user past it in as input
            end
            if (nargout == 3)
                % output the time variable
                varargout{3} = t(:,2:end);  % remove the first fence post b.c. user is responsible for keeping track of time
            end
        end
    else 
        %
        % initialize the age equation
        %
        sim = varargin{1};
        MTM = varargin{2};
        %
        dt                 = sim.dt;
        num_step_per_month = sim.num_step_per_month;
        mynorm             = sim.mynorm;
        
        % d0 converts a vector to a sparse diagonal matrix
        d0 = @(x) spdiags(x(:),0,length(x(:)),length(x(:)));
        
        % make a sparse operator that restores the surface to zero with a time scale of tau
        msk  = sim.M3d;     % wet == 1, dry == 0
        iwet = sim.iwet;

        msk(:,:,2:end) = 0;
        tau = 24 * 60^2;                % (sec)
        R   =  d0( msk(iwet) / tau );   % (1/sec)

        sim.R = R;

        % make an age source term 1 sec per sec
        sim.S = sim.M3d(iwet);  % (sec/sec)
        
        %
        % prefactor the implicitly treated part of thetime-stepping equation
        %
        fprintf('  Factoring the implicit time-stepping matrices..'); tic
        for month = 1:12
            %--------top layer thickness tendency---------+----vertical diffusion--+-birth--+
            %                                             |                        |        |
            %                                             v                        v        v
            FD(month) = mfactor( d0( 1 + dt * MTM(month).dxidt ) - dt * MTM(month).D + dt * R );
        end
        sim.FD = FD;    
        toc

        %
        % make a preconditioner for the ideal age
        %
        Q =  MTM(1).A + MTM(1).H + MTM(1).D - R;
        for k = 2:12;
            Q = Q + MTM(k).A + MTM(k).H + MTM(k).D - R;
        end
        T = 12*num_step_per_month*dt;
        Q = Q/12; % annually averaged transport and surface restoring (aka birth)
        fprintf('  Factoring the preconditioner...'); tic
        FQ = mfactor(T*Q);
        sim.FQ = FQ;
        toc
        %
        % used the annually averaged equation to obtain an initial iterate for the ideal age
        %
        x0 = sim.M3d + nan;
        x0(iwet) = -mfactor(FQ,0*iwet+sim.T);
        sim.x0 = x0;
        varargout{1} = sim;
    end    
end