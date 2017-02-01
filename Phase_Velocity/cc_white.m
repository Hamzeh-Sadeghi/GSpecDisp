function [ cc_out ] = cc_white( cc, T1, T2, dt )
%cc_white.m does the whitening and prefiltering on the given
% cross-correlation.
%   Detailed explanation goes here
%
% 12 nov 2015
% Hamzeh Sadeghisorkhai

f1= 1/T2; f2=1/T1;
if iscolumn(cc)==0
    cc=cc';
    col='n';
end
%----------------------------------
% preparation
% 1- remove mean
cc= cc-mean(cc);   

% 2- time tapering (10% cosine)
t_taper = tukeywin(length(cc),0.1);
cc_b= t_taper.*cc;

% 3- Fourier transform
CC= fft(cc_b);

amp_CC=abs(CC);                   %calculating amplitude
max_amp=max(amp_CC);              %find maximum of amplitude
% NFFT = length(cc);
% f = linspace(0,1/dt,NFFT);        % frequency axis  

%---------------------------------- 
% 4- water level correction and whitening
% CC= CC ./ amp_CC; % only whitening
CC= CC ./ (amp_CC+.05*max_amp);


%-------------------------------
% 5- inverse fourier transform and bandpass filtering
cc_out= ifft(CC);
cc_out= t_taper.*cc_out;
cc_out= bandpass_n(cc_out,f1,f2,dt,4);

if col=='n'
    cc_out=cc_out';    
end
end

