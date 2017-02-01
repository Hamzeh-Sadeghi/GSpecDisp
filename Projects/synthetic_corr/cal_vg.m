function [ vg ] = cal_vg( vp, per, pr, sm_type, sm_num )
%cal_vg calculates the group velocity based on given phase velocity and
%period.
%   
% vp:       phase velocity
% per:      period
% pr:       plot 'y' or 'n'
% sm_type:  type of smoothing 'mv' or 'rg'
% 'mv':     is moving average 
% 'rg':     is Robust Local Regression, see the link below:
%           http://se.mathworks.com/help/curvefit/smoothing-data.html
% sm_num:   smoothing coefficient, for 'mv' is an integer number, for 'rg' 
%            is in percentage (between (0,1)) best value is around .2
%
% 11 jun 2016
% Hamzeh Sadeghisorkhani
% 



up=1./vp;
ug= zeros(length(per),1);
for i=2:length(per)-1
    ug(i)= up(i)- per(i)*((up(i+1)-up(i-1))/(per(i+1)-per(i-1)));
end
ug(1)= up(1)- per(1)*((up(2)-up(1))/(per(2)-per(1)));
ug(end)= up(end)-per(end)*((up(end)-up(end-1))/(per(end)-per(end-1)));

vg= 1./ug;

if nargin>3
    if sm_type=='mv'
        vg= smooth(vg,sm_num);
    elseif sm_type=='rg'
        vg= smooth(per,vg,sm_num,'rloess');
    end
end

if pr=='y'
    figure; plot(per,vp);hold on;plot(per,vg)
    legend('phase velocity', 'group velocity','location','northwest')    
end

end

