function [C, T, dist_sorted, RL3, dist_max]=ave_dispersion(cc, dist, t, nn, len, comp)
% Calculating average phase velocity dispersion curve
%
% June 2016
% Hamzeh Sadeghisorkhani

%% Parameters

global params

T= params.periods;
dt= params.dt;

vmin= params.Cmin-.2*params.Cmin;   % 20% less
vmax= params.Cmax+.1*params.Cmax;   % 10% more
interval= params.vt_inter2;

dist_max= max(dist)+ .1*max(dist);
c= params.Cmin:params.dC:params.Cmax;



%% Calculation

% the frequencies for calculation
F= (1./T);

%velocity tapering
if strcmp(params.vtaper2,'yes')    
    for ii=1:len
        w= vel_taper2(t, dt, dist(ii), vmin, vmax, interval);
        cc(:,ii)= w'.*cc(:,ii);
    end    
end


% symmetric Fourier transform
CC= zeros(len,length(t)+1);
for ii=1:len
    CC(ii,:)= sym_fft(cc(:,ii),1);
end

% frequency axes
NFFT = length(t)+1;
f = linspace(0,1/dt,NFFT);


%---------------- finding real part values at specified frequencies
RL= zeros(len, length(F));
for ii=1:len    
    RL(ii,:)= interp1(f, real(CC(ii,:)), F, 'spline');        
end

% sorting based on distance
RL(:,length(F)+1)= dist;
RL2= sortrows(RL,length(F)+1);
RL3= zeros(len,length(F));
for ii=1:length(F)
    RL3(:,ii)= RL2(:,ii)./max(abs(RL2(:,ii)));
end

dist_sorted= RL2(:,length(F)+1);


%%
%---------------- calculating the average velocity based on nn norm
C= zeros(1,length(F));
x= linspace(0,dist_max,1000);
for ii=1:length(F)
    count= 0;
    res= zeros(1,length(c));
   for j=1:length(c)
       count= count +1;       
       Z= (2*pi*F(ii)*x)/c(j);
       if strcmp(comp,'ZZ')==1
           J = besselj(0,Z);           
       elseif strcmp(comp,'RR')==1 || strcmp(comp,'TT')==1
           J = besselj(0,Z)-besselj(2,Z);
       elseif strcmp(comp,'ZR')==1 || strcmp(comp,'RZ')==1
           J = besselj(1,Z);
       end       
       Jint= interp1(x, J, RL2(:,length(F)+1), 'spline');  
       res(count)= norm( (Jint-RL3(:,ii)),nn );
   end    
   C(1,ii)= c((res==min(res)));    
end





end