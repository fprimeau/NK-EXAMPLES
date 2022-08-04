function [M,varargout] = woa2018read(var,n)
% [M,X,Y,Z] = woa2018read(var,n,gg); 
%    fetch the 1∘x1∘ World Ocean Atlas 2018 objectively analyzed mean
%    from NOAA website
%    output includes a meshgrid of lat (Y) lon (X) and depths (Z)
% input:
%    var = 't': temperature                  
%    var = 's': salinity                     
%    var = 'I': density                      
%    var = 'M': mixed layer depth            
%    var = 'o' dissolved oxygen             
%    var = 'O': percent saturation           
%    var = 'A': apparent oxygen utilization  
%    var = 'i': silicate                     
%    var = 'n': nitrate
%    var = 'p': phosphate                    
%    n   = 0    annual average
%    n   = 1:12 monthly average
%    n   = 13   Winter average
%    n   = 14   Spring average
%    n   = 15   Summer average
%    n   = 16   Autumn average
%
% output:
%    M is a 180 x 360 x 102 phosphate array for n = 0 
%    M is a 180 x 360 x 37 phosphate array for n = 1:16
%
% Citation for WOA13 Data
%
%   PUBLICATIONS
%
% Temperature:
%
%  Locarnini, R. A., A. V. Mishonov, O. K. Baranova, T. P. Boyer, M. M. Zweng, 
%  H. E. Garcia, J. R. Reagan, D. Seidov, K. Weathers, C. R. Paver, 
%  and I. Smolyar, 2018. World Ocean Atlas 2018, Volume 1: Temperature. A. Mishonov 
%  Technical Ed.; NOAA Atlas NESDIS 81, 52pp.
%
% Salinity:
%
%  Zweng, M. M., J. R. Reagan, D. Seidov, T. P. Boyer, R. A. Locarnini, H. E. Garcia, 
%  A. V. Mishonov, O. K. Baranova, K. Weathers, C. R. Paver, and I. Smolyar, 2018. 
%  World Ocean Atlas 2018, Volume 2: Salinity. A. Mishonov Technical Ed.; 
%  NOAA Atlas NESDIS 82, 50pp.
%
% Oxygen:
%  Garcia, H. E., K. Weathers, C. R. Paver, I. Smolyar, T. P. Boyer, R. A. Locarnini,
%  M. M. Zweng, A. V. Mishonov, O. K. Baranova, D. Seidov, and J. R. Reagan, 2018. 
%  World Ocean Atlas 2018, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and 
%  Oxygen Saturation. A. Mishonov Technical Ed.;%   NOAA Atlas NESDIS 83, 38pp.
%
% Nutrients:
%  Garcia, H. E., K. Weathers, C. R. Paver, I. Smolyar, T. P. Boyer, R. A. Locarnini,
%  M. M. Zweng, A. V. Mishonov, O. K. Baranova, D. Seidov, and J. R. Reagan, 2018. 
%  World Ocean Atlas 2018, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate 
%  and nitrate+nitrite, silicate). A. Mishonov Technical Ed.; NOAA Atlas NESDIS 84, 35pp.
%
% Density:
%  Locarnini, R.A., T.P. Boyer, A.V. Mishonov, J.R. Reagan, M.M. Zweng, O.K. Baranova,
%  H.E. Garcia, D. Seidov, K.W. Weathers, C.R. Paver, and I.V. Smolyar (2019). 
%  World Ocean Atlas 2018, Volume 5: Density. A. Mishonov, Technical Editor. 
%  NOAA Atlas NESDIS 85, 41pp.
%
% Conductivity:
%  Reagan, J.R., M.M. Zweng, D. Seidov, T.P. Boyer, R.A. Locarnini, A.V. Mishonov, 
%  O.K. Baranova, H.E. Garcia, K.W. Weathers, C.R. Paver, I.V. Smolyar, and R.H. Tyler (2019).
%  World Ocean Atlas 2018, Volume 6: Conductivity. A. Mishonov Technical Editor, 
%  NOAA Atlas NESDIS 86, 38 pp. 
    
    switch (var)
      case 't'
        ext = 'dat';       
        fname = sprintf('woa18_decav_t%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/temperature/ascii/decav/1.00/%s.gz',fname);
        nzm = 57;
      case 's'
        ext = 'dat';
        fname = sprintf('woa18_decav_s%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/salinity/ascii/decav/1.00/%s.gz',fname);
        nzm = 57;
      case 'I'
        ext = 'dat';
        fname = sprintf('woa18_decav_I%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/density/ascii/decav/1.00/%s.gz',fname);
        nzm = 57;
      case 'M'
        ext = 'dat';
        % csv did not exist on 07/29/2022 so I used ASCII
        fname = sprintf('woa18_A5B7_M%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/mld/ascii/A5B7/1.00/%s.gz',fname);
        nzm = 1;
      case 'o'
        ext = 'dat';
        fname = sprintf('woa18_all_o%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/oxygen/ascii/all/1.00/%s.gz',fname);
        nzm = 57
      case 'O'
        ext = 'dat';
        fname = sprintf('woa18_all_O%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/o2sat/ascii/all/1.00/%s.gz',fname);
        nzm = 57;
      case 'A'
        ext = 'dat';
        fname = sprintf('woa18_all_A%02dan01.%s',n,ext)
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/AOU/ascii/all/1.00/%s.gz',fname);
        nzm = 57;
      case 'i'
        ext = 'dat';
        fname = sprintf('woa18_all_i%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/silicate/ascii/all/1.00/%s.gz',fname);
        nzm = 43;
      case 'n'
        ext = 'dat';
        fname = sprintf('woa18_all_n%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/nitrate/ascii/all/1.00/%s.gz',fname);
        nzm = 43;
      case 'p'
        ext = 'dat';
        fname = sprintf('woa18_all_p%02dan01.%s',n,ext);
        cmd = sprintf('wget https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/phosphate/ascii/all/1.00/%s.gz',fname);
        nzm = 43;
      otherwise
        fprintf('Invalid variable. %s does not exist.\n',var);
        return
    end
    system(cmd);
    cmd = sprintf('gunzip %s.gz',fname);
    system(cmd);
    fid = fopen(fname,'r');
    FORMAT = '%8.4f%8.4f%8.4f%8.4f%8.4f%8.4f%8.4f%8.4f%8.4f%8.4f';
    M = textscan(fid,FORMAT);
    Q = [M{:}];
    if (var ~='M')
        if (n==0)
            nz = 102;
        else
            nz = nzm;
        end
    else
        nz = 1;
    end
    nx = 360;
    ny = 180;
    
    if (nz == 1)
        M = permute(reshape([M{:}]',[nx,ny]),[2 1]);
    else
        M = permute(reshape([M{:}]',[nx,ny,nz]),[2 1 3]);
    end
    
    inan = find(M(:) ==-99.9999);
    M(inan) = NaN;
    cmd = sprintf('rm %s',fname);
    system(cmd);
    if (nargout>1)
        [zt,zw,dzt,dzw] = zgrid(nz);
        [xt,yt,xu,yi,dxt,dyt,dxu,dyu] = xygrid(nx,ny);
        [X,Y,Z] = meshgrid(xt(2:end),yt,zt);
        varargout{1} = X;
        varargout{2} = Y;
        varargout{3} = Z;
    end
end
%
% subfunctions
%


function [zt,zw,dzt,dzw]= zgrid(nz);
    km = nz;
    
    % vertical grid
    %  zt = [2.5;10;20;30;50;75;100;125;150;200;250;300;400;500;600;700;800;900;...
    %        1000;1100;1200;1300;1400;1500;1750;2000;2500;3000;3500;4000;4500;...
    %        5000;5500];
    
    zt = [2.5;5;10;15;20;25;30;35;40;45;50;55;60;65;70;75;80;85;90;95;100;125;150;...  
          175;200;225;250;275;300;325;350;375;400;425;450;475;500;550;600;650;700;...  
          750;800;850;900;950;1000;1050;1100;1150;1200;1250;1300;1350;1400;1450;... 
          1500;1550;1600;1650;1700;1750;1800;1850;1900;1950;2000;2100;2200;2300;... 
          2400;2500;2600;2700;2800;2900;3000;3100;3200;3300;3400;3500;3600;3700;...
          3800;3900;4000;4100;4200;4300;4400;4500;4600;4700;4800;4900;5000;5100;... 
          5200;5300;5400;5500;5600;5700;5800;5900;6000;6100;6200;6300;6400;6500;...  
          6600;6700;6800;6900;7000;7100;7200;7300;7400;7500;7600;7700;7800;7900;...
          8000;8100;8200;8300;8400;8500;8600;8700;8800;8900;9000];
    
    zt = zt(1:nz+1);
    zw = [0;5;0.5*(zt(2:end-1)+zt(3:end))];
    zw =zw(1:nz+1);
    dzt = zw(2:end)-zw(1:end-1);
    dzw = [2.5;zt(2:end)-zt(1:end-1)];
    zt = zt(1:nz);  
end

function [xt,yt,xu,yu,dxt,dyt,dxu,dyu] = xygrid(nx,ny);
% [xt,yt,xu,yu,dxt,dyt,dxu,dyu] = xygrid;
% generate the horizonal grid
% grid size
    imt = nx+1;
    jmt = ny;
    
    % dlat
    dyt = ones(1,jmt);
    
    % dlon
    dxt = ones(1,imt);
    
    % grid definition 
    stlon = -1.0;
    stlat = -90.0;
    
    % yt,yu
    yt(1) = stlat +0.5*dyt(1);
    for j=2:jmt;
        yt(j) = yt(j-1)+0.5*(dyt(j)+dyt(j-1));
    end
    yu(1) = stlat+dyt(1);
    for j=2:jmt
        yu(j) = yu(j-1)+dyt(j);
    end
    %xt,xu
    xt(1) = stlon+0.5*dxt(1);
    for j = 2:imt;
        xt(j) = xt(j-1)+0.5*(dxt(j)+dxt(j-1));
    end
    xu(1) = stlon+dxt(1);
    for j =2:imt;
        xu(j) = xu(j-1)+dxt(j);
    end
    
    % radius of the earth
    a = 6370.661745873249136e3; 
    
    da = (pi/180*dyt).*(a^2*cos(yt*pi/180)*pi/180*dxt(1));
    for j=1:jmt-1
        dyu(j) = 0.5*(dyt(j)+dyt(j+1));
    end
    dyu(jmt) = dyt(jmt);
    for i =1:imt-1
        dxu(i) = 0.5*(dxt(i)+dxt(i+1));
    end
    dxu(imt) = dxt(imt);
end
