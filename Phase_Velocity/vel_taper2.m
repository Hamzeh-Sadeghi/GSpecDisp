function [ w ] = vel_taper2( t, dt, dist, vmin, vmax, interval )
% vel_taper.m creates a velocity cosine taper for a given time axis between
% vmin-vmax km/s with the corresponding velocity interval.
%
%   18 nov 2015
% last modified: Jan 2017
% Hamzeh Sadeghisorkhani


t1=round(dist/vmax/dt)*dt;
t2=round(dist/vmin/dt)*dt;

% w= zeros(1,length(t));
% w(find(t==t1):find(t==t2))=1;
% w(find(t==-t2):find(t==-t1))=1;
%     
% t3=round(dist/(vmax+interval*vmax)/dt)*dt;
% sam=find(t==t1)-find(t==t3);
% %aa= sin(linspace(0,pi/2,sam));
% aa=  fliplr( .5 .* (cos(pi.*(linspace(0,1,sam)))+1) );
% w(find(t==-t2)-sam:find(t==-t2)-1)= aa;
% w(find(t==t1)-sam:find(t==t1)-1)= aa;
% w(find(t==-t1)+1:find(t==-t1)+sam)= fliplr(aa);
% w(find(t==t2)+1:find(t==t2)+sam)= fliplr(aa);


% changed to this in: Jan. 2017
tolerance = dt/8;

w= zeros(1,length(t));
w(find(abs(t-t1) < tolerance) : find(abs(t-t2) < tolerance)) =1;
w(find(abs(t+t2) < tolerance) : find(abs(t+t1) < tolerance)) =1;
   
t3=round(dist/(vmax+interval*vmax)/dt)*dt;
sam=find(abs(t-t1) < tolerance)-find(abs(t-t3) < tolerance);
aa=  fliplr( .5 .* (cos(pi.*(linspace(0,1,sam)))+1) );
w(find(abs(t+t2) < tolerance)-sam:find(abs(t+t2) < tolerance)-1)= aa;
w(find(abs(t-t1) < tolerance)-sam:find(abs(t-t1) < tolerance)-1)= aa;
w(find(abs(t+t1) < tolerance)+1:find(abs(t+t1) < tolerance)+sam)= fliplr(aa);
w(find(abs(t-t2) < tolerance)+1:find(abs(t-t2) < tolerance)+sam)= fliplr(aa);


end

