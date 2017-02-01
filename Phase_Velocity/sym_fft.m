function [ CC ] = sym_fft( XC2, num_zpad )
% This function calculates symmetric fft.
%   INput is a symmetric function from f[-a,a].
%   dt is time interval (sampling interval).
%   num_zpad is how many zero needs to be padded (odd number).
% Hamzeh Sadeghisorkhani
% 13 sep 2015

if iscolumn(XC2)==1
    XC2= XC2';
end

N= length(XC2);
NP= (N/2+.5):N;
NP1= NP(1)-1;
XC3= [XC2(NP) zeros(1,num_zpad) (XC2(1:NP1))];

CC= fft(XC3);

end

