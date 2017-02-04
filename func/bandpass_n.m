function [d]=bandpass_n(c,flp,fhi,delt,n) 
% 
% bandpass a time series with a nth order butterworth filter 
% 
% ----->      d= bandpass_n(c,flp,fhi,delt,n) 
% c = input time series 
% flp = lowpass corner frequency of filter 
% fhi = hipass corner frequency 
% delt = sampling interval of data 
% n= filter order
% 
% Hamzeh Sadeghisorkhani

fnq=1/(2*delt);  % Nyquist frequency 
Wn=[flp/fnq fhi/fnq];    % butterworth bandpass non-dimensional frequency 

[z,p,k] = butter(n,Wn);         % butterworth z:zeros, p:poles, k:gain
[sos,g] = zp2sos(z,p,k);        % transfer function coefficients
d = filtfilt(sos,g,c);          % zero-phase filtering

return;