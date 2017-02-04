% Tutorial values of parameters
%
% Dec 2016
% Hamzeh Sadeghisorkhani

global params

%------- General Setting
params.lat1= 55;
params.lon1= 5;
params.lat2= 70;
params.lon2= 25;

params.map='./Projects/mat_border.mat';

params.data= './Projects/SNSN_north/data/ZZ';
params.save= './Projects/SNSN_north/Phase_vel/ZZ';

params.outputformat='.mat';


%------- Cross correlation
params.component= 'ZZ';

params.tmin= -2000;
params.tmax= 2000;
params.dt= 0.5;

params.vtaper= 'yes';
params.vt_inter= 0.2;
params.white= 'yes';


%------- Average Velocity
params.ref= 'yes';
params.format= '.mat';
params.delim= 1;

params.Rayleigh_ave= './Projects/SNSN_north/Average_vel/Rayleigh_wave_north.mat';
params.Love_ave= './Projects/SNSN_north/Average_vel/Love_wave_north.mat';

params.component2= 'ZZ';

params.Cmin= 3;
params.Cmax= 4.6;
params.dC= 0.01;
params.norm= 2;

params.vtaper2= 'no';
params.vt_inter2= 0.2;
params.periods= [3;4;5;6;7;8;9;10;12;14;16;18;20;22;24;26;28;30;33];


%------- Phase Velocity
params.vmin= 2.5;
params.vmax= 5;
params.T1= 3;
params.T2= 30;

params.scale= 'Log';

params.rlambda= 1.2;
params.measureperiods= [2;3;4;5;6;7;8;9;10;12;14;16;18;20;22;24;26;28;30;33;36;39;42;46;50;55;60];

params.SNRflag='yes';
params.SNR= 10;
params.Nwin1= 600;
params.Nwin2= 1200;

params.colorful='yes';


%------- Automatic Selection
params.automatic= 'yes';
params.maxdev= 0.1;
params.cycle= 1.5;
params.energy= 0.25;

params.slope{1}= 52;
params.slope{2}= -1.75;
params.slope{3}= 52;

params.anchor= 'no';
params.pr1= 5;
params.pr2= 15;

params.slope{4}= 52;
params.slope{5}= 26;
params.slope{6}= 9;
params.slope{7}= 9;
params.slope{8}= 18;






% zero crossings of the Bessel's function
load Bessel_zeros.mat
params.zz= zz;




save('./defaults/user_values.mat','params')
