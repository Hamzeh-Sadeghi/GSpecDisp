% To generate a synthetic cross correlation based on the noise source 
% distribution, and using Sadeghisorkhani et al (2016) approach. Here, it
% sums the narrow band cross-correlations to have a broad band cross-correlation.
% Briefly, summation of box-car cross-correlations.
%
% Hamzeh Sadeghisorkhani
% 25 aug 2016

clc;close all;clear

%----------------------
T= 2:1:104;
T1= T-.05*T;
T2= T+.05*T;
dx= 400;
m0= ones(360,1);
tmin= -2000;
tmax= 2000;
dt= .5;

% load('CUS.mat')
% vp= downsample(syn_H(:,2),1);
% per= downsample(syn_H(:,1),1);
% 
% vg= cal_vg(vp, per,'n','rg',.2);
load('CUS_vp_vg.mat')
%----------------------

vp= interp1(per,vpp,T,'spline');
vg= interp1(per,vgg,T,'spline');

up= 1./vp;
ug= 1./vg;
t= tmin:dt:tmax;
f1= 1./T2;
f2= 1./T1;


figure;hold on
plot(per, vpp,'k.')
plot(per, vgg,'k.')
plot( T, vp)
plot( T, vg,'r')



for i=1:length(T)
    q(:,i)= syn_cc_4(f1(i), f2(i), ug(i), up(i), t, dx, m0);
end

Q= sum(q,2);

figure
plot(t,Q)


%---------------------------------------- save to sac file
load('header.mat')

h(1)= dt;
h(6)= tmin;
h(7)= tmax;
h(51)= dx;

wtSac('corr.sac',h,Q)

