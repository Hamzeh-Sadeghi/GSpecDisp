function [ wv, env ] = An_ZZ2( t, T, d, vp, amp )
%An_ZZ calculate the analytical integral for ZZ component
%   It returns the constructted correlation and its envelope
%   Inputs:
%           t       time axis
%           T       Period axis
%           d       distance
%           vp      pahse velocity
%
% version 2: I added amp of different frequency to the calculation and use
% the basic formula cross-correlation calculation
%
% 7 dec 2016    -- version 1
% 13 dec 2016   -- version 2
% Hamzeh Sadeghisorkhani

% % angular freq
v= 2*pi./T;
up= 1./vp;

for j=1:length(v)
    om= v(j);
    for i=1:length(t)
        tt=t(i);    
        y(j,i)= amp(j)*besselj(0, d.*om.*up(j)) * cos(om*tt);
    end
end

wv= sum(y,1);
env= abs(hilbert(wv));
    
end

