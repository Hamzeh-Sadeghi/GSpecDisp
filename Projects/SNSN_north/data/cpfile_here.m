
clear
clc
close all


comp    = 'tt'


input = imdata('/media/store/data/pairs/stations_2012_matlab_north.dat','',comp);

for i=1:length(input)
    input(i,:)
    copyfile(['/media/store/data/full_tensor_correlation_1bit/yearly/',input(i,:)],...
        ['/home/Hamzeh/matlab-tr/phv_measure/measures_app1.4/Projects/SNSN_north/data/',upper(comp)])
    
end
    