% To generate a synthetic cross correlation based on the noise source 
% distribution, and using Sadeghisorkhani et al (2016) approach. Here, it
% sums the narrow band cross-correlations to have a broad band cross-correlation.
% Briefly, summation of box-car cross-correlations.
%
% in ver 3: I use the non-filtered formulation for cross-correlation
% calculation.
%
% Hamzeh Sadeghisorkhani
% 25 aug 2016
% ver 3: 13 dec 2016

clc;close all;clear; tic

pr= 'n';
%========================================
d= 400;                 % distance
dt= .5;                 % time interval
t= -800:dt:800;         % time

N_level= 1.5;            % noise level

% df= (1/dt)/length(t)    % frequency interval (Nyqust/N)
%freq= .009:.0001:1;
f= .008:.001:.5;
T= 1./f;

% T= 2:.02:120;           % period
amp= ones(1,length(T)); % amplitude
% amp(215:235)= 0;
% amp(260:295)= 0;

% smooth low amplitude
% x = linspace(-4,4,21); norm1 = normpdf(x,0,1);
% x = linspace(-4,4,37); norm2 = normpdf(x,0,1);
% amp(215:235)= 1-(1/max(norm1))*norm1;
% amp(260:296)= 1-(1/max(norm1))*norm2;

T2= 14;
T1= 8;
ind2= find(min(abs(T-T2))==abs(T-T2));
ind1= find(min(abs(T-T1))==abs(T-T1));

x = linspace(-4,4,ind1-ind2+1); norm1 = normpdf(x,0,1);
amp(ind2:ind1)= 1-(1/max(norm1))*norm1;
% amp(ind2:ind1)= 1-2*norm1;


figure
semilogx(T,amp); ylim([0 1])


load('CUS_vp_vg.mat')   % load dispersion
%========================================

vp= interp1(per,vpp,T,'spline');


[ Q, ~ ] = An_ZZ2( t, T, d, vp, amp );

figure
plot(t,Q)


% add noise
noise= N_level* randn(1,length(Q));
noise= tukeywin(length(noise),.05)'.* bandpass_n(noise,1/110,1/4,dt,4);

lev= rms(noise)/max(Q)*100

Q= Q+ noise;


figure
plot(t,Q)

%%  save to sac file
load('header.mat')

h(1)= dt;
h(6)= t(1);
h(7)= t(end);
h(51)= d;

if pr=='y'
    wtSac('./calculated_data/corr_sm0_noise.sac',h,Q)
end

toc