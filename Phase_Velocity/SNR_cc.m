function [ SNR ] = SNR_cc( cc, dist, t, dt )
% SNR_cc calculates the SNR for positive and negative CC in 2 periods of
% T1-10 s and 10-T2 s, respectively.
%   Detailed explanation goes here

global params

lim(1) = floor(dist / params.vmax);          % signal window
lim(2) = ceil(dist / params.vmin);           % signal window
lim(3) = params.Nwin1;                       % noise window
lim(4) = params.Nwin2;                       % noise window

% cc1 =  bandpass_n(cc, 1/10, 1/params.T1, dt,4);
% 
% snr(1) = rms(  cc1( find(t == lim(1)):find(t == lim(2)) )  );          % signal rms - positive lag
% snr(2) = rms(  cc1( find(t == lim(3)):find(t == lim(4)) )  );          % noise  rms - positive lag
% snr(3) = rms(  cc1( find(t == -lim(2)):find(t == -lim(1)) )  );        % signal rms - negative lag
% snr(4) = rms(  cc1( find(t == -lim(4)):find(t == -lim(3)) )  );        % noise  rms - negative lag
% 
% SNR(1) = snr(1) ./ snr(2);
% SNR(2) = snr(3) ./ snr(4);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for 10-40s
% cc2 =  bandpass_n(cc, 1/params.T2, 1/10, dt,4);
% 
% snr(5) = rms(  cc2( find(t == lim(1)):find(t == lim(2)) )  );          % signal rms - positive lag
% snr(6) = rms(  cc2( find(t == lim(3)):find(t == lim(4)) )  );          % noise  rms - positive lag
% snr(7) = rms(  cc2( find(t == -lim(2)):find(t == -lim(1)) )  );        % signal rms - negative lag
% snr(8) = rms(  cc2( find(t == -lim(4)):find(t == -lim(3)) )  );        % noise  rms - negative lag
% 
% 
% SNR(3) = snr(5) ./ snr(6);
% SNR(4) = snr(7) ./ snr(8);
% 
% % figure; subplot(2,1,1);plot(t,cc1); subplot(2,1,2); plot(t,cc2);
% 
% %------------------------------------
% m1= max(abs(cc1( find(t == lim(1)):find(t == lim(2)) )));
% m2= max(abs(cc1( find(t == -lim(2)):find(t == -lim(1)) )));
% m3= max(abs(cc2( find(t == lim(1)):find(t == lim(2)) )));
% m4= max(abs(cc2( find(t == -lim(2)):find(t == -lim(1)) )));
% 
% SNR(5)= m1/snr(2);
% SNR(6)=m2/snr(4);
% SNR(7)=m3/snr(6);
% SNR(8)=m4/snr(8);

%------------------------------------
m5= max(abs(cc( find(t == lim(1)):find(t == lim(2)) )));
m6= max(abs(cc( find(t == -lim(2)):find(t == -lim(1)) )));
snr(11) = rms(  cc( find(t == lim(3)):find(t == lim(4)) )  );          % noise  rms - positive lag
snr(12) = rms(  cc( find(t == -lim(4)):find(t == -lim(3)) )  );        % noise  rms - negative lag

SNR(9)= m5/snr(11);
SNR(10)= m6/snr(12);
end

