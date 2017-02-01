function [ z_non, first_non, amp ] = z_cross3( CC, dt, freq1, freq2 )
% This function finds zero cross of real part of cross-correlation to be
% used in dispersion curve by Aki and Ekstrom method.
%
%       CC:     is cross-correlation in fourier domain
%       dt:     is time interval
%    freq1:     is lower frequency 
%    freq2:     is upper frequency
%
%  ----->   Notice: Nyquest frequency is 1 in this function.   <-----
%
% 16 sep 2015
% 18 nov 2015   ver2
%  6 mar 2016   ver3
% Hamzeh Sadeghisorkhani

CC= real(CC);

NFFT = length(CC);
f = linspace(0,1/dt,NFFT);

[~,l11]= min(abs(f- (freq1-.1*freq1) ));    % finding nearest index
% [~,l11]= min(abs(f- (freq1) ));           % finding nearest index
[~,l22]= min(abs(f-freq2));

si_non = diff(sign(CC(1:NFFT/2)));                          % find changes of sign of real part
indx_non = sort( [find(si_non>0)  find(si_non<0)] );        % combine and sort them

indx_non2= indx_non( (indx_non>l11 & indx_non<l22) );       % find indecies between freq limit
first_non= CC(indx_non2(1))>0;                              % find the upgoing or downgoing of the first zero crossing
val_non1= CC(indx_non2);                                    % the value before zero-crossing
val_non2= CC(indx_non2+1);                                  % the value after zero-crossing
f_non1= f(indx_non2);                                       % the freq before zero-crossing
f_non2= f(indx_non2+1);                                     % the freq after zero-crossing

z_non= zeros(1,length(indx_non2));                          % interpolation to find zero-crossing
for i=1:length(f_non1)
    z_non(i)= interp1([val_non1(i) val_non2(i)],[f_non1(i) f_non2(i)],0);
end

% -------------------------- added in version 3
% finding maximum amplitude between two zero-crossings
a1= find(indx_non==indx_non2(1));
a2= find(indx_non==indx_non2(end));
if a1 ==1
    ind3= indx_non( 1:a2+1);
else
    ind3= indx_non( a1-1:a2+1);
end

for i=1:length(ind3)-1
    amp(i)= max( abs( CC(ind3(i):ind3(i+1)) ) );
end


end

