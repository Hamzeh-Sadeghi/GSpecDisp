function [ dz ] = crossing_detect( z_non )
% crossing_detect.m predicts irrigularities of zero-crossings.
%   18 nov 2015
% Hamzeh Sadeghisorkhani

mm= mean(diff(z_non));
zp= z_non+mm;
dz=zeros(1,length(z_non));
dz(2:end)= z_non(2:end)-zp(1:end-1);
dz(abs(dz)<1*std(dz))=0;
    
end

