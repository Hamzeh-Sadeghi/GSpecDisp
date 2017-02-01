function [ q ] = syn_cc_4(v1, v2, ug, up, t, dx, m00)
% This function creates synthethic cross-correlation based on calculation
% of the intergal.
%   Inputs:     v1:     lower corner of frequency in Hz
%               v2:     upper corner of frequency in Hz
%               ug:     group slowness of that frequencies
%               up:     phase slowness of that frequencies
%               dx:     the interstation distance (Km)
%              m00:     azimuthal source distribution (360 deg vector)
%                t:     time axis
%
% Hamzeh Sadeghisorkhani
% Uppsala University
% 24 apr 2015
% last modification: 16 oct 2015 - ver 3

D= pi/180;  %conversion constant of degree to radian

v1= 2*pi*v1;
v2= 2*pi*v2;

om0= (v1+v2)/2;
dom= (v2-v1)/2;
%dx= sing/ug;

% integrate
F2=zeros(1,length(t));
for k=1:length(t)
    tt=t(k);
    F=zeros(1,360);
    for i=1:360                         
        
        % in ver 3 change the sinc function
%         F(i)= m00(i,1) .* cos(om0*dx*up.*cos(i*D)-om0*tt) .* sinc( (dom*dx*ug.*cos(i*D)-dom*tt)/pi ) ;
        
        if (dom*dx*ug.*cos(i*D)-dom*tt)==0
            F(i)= m00(i,1) .* cos(om0*dx*up.*cos(i*D)-om0*tt);
        else
            F(i)= m00(i,1) .* cos(om0*dx*up.*cos(i*D)-om0*tt) .*(sin(dom*dx*ug.*cos(i*D)-dom*tt)/(dom*dx*ug.*cos(i*D)-dom*tt));
        end
        
%         F(i)= m00(i,1) .* cos(om0*dx*up.*cos(i*D)-om0*tt) .* exp(-(dom*dx*ug.*cos(i*D)-dom*tt)^2);      %<----- ver 3
    end
        F2(k)= sum(F);          
end
q= (2*dom/pi * D).*F2;




end

