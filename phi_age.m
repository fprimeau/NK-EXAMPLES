function [varargout] = phi_age(varargin)
    if (nargin == 3)  % time step forward for 1 year
        % c1 = phi_age(c0,sim,MTM);
        c = varargin{1};
        sim = varargin{2};
        MTM = varargin{3};
        dt = sim.dt;
        S = sim.S;
        C = zeros(length(c),3);
        C(:,1) = c;
        i1 = 1; i2 = 2; i3 = 3;    
        rate = @(a,b,month) ( MTM(month).A * a + MTM(month).H * b + S);
        if (nargout == 2) % save the time-series
            X = zeros( length(c), 12*sim.num_step_per_month + 1 );
            j = 1;
            X(:,j) = c; j = j+1;
        end
        for month = 1:12
            for k = 1:sim.num_step_per_month
                switch(k)
                  case 1
                    rhs  = C(:,i1) + dt * rate( C(:,i1), C(:,i1), month ); 
                    C(:,i2) = mfactor(sim.FD(month),rhs);
                    if (nargout == 2)
                        X(:,j) = C(:,i2); j = j+1;
                    end
                  case 2
                    w = (1/2) * ( 3 * C(:,i2) - C(:,i1) );
                    rhs = C(:,i2) + dt * rate( w, C(:,i1), month );
                    C(:,i3) = mfactor(sim.FD(month),rhs);
                    if (nargout == 2)
                        X(:,j) = C(:,i3); j = j+1;
                    end
                  otherwise
                    w = (1/12) * ( 23 * C(:,i3) - 16 * C(:,i2) + 5 * C(:,i1) );
                    rhs = C(:,i3) + dt * rate( w, C(:,i2), month );
                    C(:,i1) = mfactor(sim.FD(month),rhs);
                    if (nargout == 2)
                        X(:,j) = C(:,i1); j = j+1;
                    end
                    i = i1; i1 = i2; i2 = i3; i3 = i;
                end
            end
            varargout{1} = C(:,i1);
            if (nargout == 2)
                varargout{2} = X;
            end
        end
    else % initialize the age equation
         % sim = phi_age(sim,MTM);
        sim = varargin{1};
        MTM = varargin{2};
        dt = sim.dt;
        num_step_per_month = sim.num_step_per_month;
        mynorm = sim.mynorm;
        
        % d0 converts a vector to a sparse diagonal matrix
        d0 = @(x) spdiags(x(:),0,length(x(:)),length(x(:)));
        
        % make a sparse operator that restores the surface to zero with a time scale of tau
        msk = sim.M3d;     % wet == 1, dry == 0
        iwet = sim.iwet;
        msk(:,:,2:end) = 0;
        tau = 24*60^2;           % (sec)
        R =  d0(msk(iwet)/tau);   % (1/sec)
        sim.R = R;

        % make an age source term 1 sec per sec
        sim.S = sim.M3d(iwet);  % (sec/sec)
        
        %
        % prefactor the implicitly treaded part of the equation
        %
        for month = 1:12
            FD(month) = mfactor( d0( 1 + dt * MTM(month).dxidt ) - dt * MTM(month).D + dt * R );
        end
        sim.FD = FD;    

        %
        % make a preconditioner for the ideal age
        %
        Q =  MTM(1).A + MTM(1).H + MTM(1).D - R;
        for k = 2:12;
            Q = Q + MTM(k).A + MTM(k).H + MTM(k).D - R;
        end
        T = 12*num_step_per_month*dt;
        Q = Q/12;
        fprintf('factoring the preconditioner...'); tic
        FQ = mfactor(T*Q);
        sim.FQ = FQ;
        toc
        %
        % make an initial iterate for the ideal age
        %
        x0 = sim.M3d + nan;
        x0(iwet) = -mfactor(FQ,0*iwet+sim.T);
        sim.x0 = x0;
        varargout{1} = sim;
    end    
end