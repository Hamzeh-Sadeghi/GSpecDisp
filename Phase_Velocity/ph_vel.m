function [ c_non ] = ph_vel( z_non, zz, first_non, dist, vmin, vmax)
% ph_vel.m calculates the phase velocity by comparing with zero-crossings
% of zero order Bessel function (Ekstrom et al 2009). The final values of
% phv velocity will be between vmin-vmax km/s.
%
%       z_non:      zero_crossings of real part of cross-correlation
%          zz:      zero_crossings of zero-order Bessel function
%   first_non:      shows the direction of first zero-crossings
%        dist:      distance
%        vmin:      minimum velocity
%        vmax:      maximum velocity
%
% 18 nov 2015
% last modified: June 2016
% Hamzeh Sadeghisorkhani


if first_non==1
    st_non=0;
elseif first_non==0
    st_non=1;
end

for i= st_non:2:length(zz)-length(z_non)
% for i=0:1:length(zz)-length(z_non)
    for j=1:length(z_non)        
        c_non1(j,i+1)= 2*pi*dist*(z_non(1,j)/zz(i+j,1));
    end
end
c_non1(c_non1<vmin)= nan;
c_non1(c_non1>vmax)= nan;
a= +isnan(c_non1);
cn_sz=size(c_non1,2);
count= 0;
for i=1:cn_sz
    if a(:,i)==1
    else
        count= count+1;
        c_non(:,count)= c_non1(:,i);
    end
end

end

