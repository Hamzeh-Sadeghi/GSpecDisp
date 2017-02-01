function [xy_data, sxy_data, sta, CC, prds, maxp, z_non, c_non]= dispersion(cc, head, zz, ref_disp, filename, dist, text1, C_ave)
% Calculating phase velocity dispersion curve
%
% June 2016
% changed: Aug 2016
% Hamzeh Sadeghisorkhani

%% Parameters

global params

T1= params.T1;
T2= params.T2;

freq1  = 1/T2;          % lower corner frequency (Hz)
freq2  = 1/T1;          % upper corner frequency (Hz)

% time axis
dt= params.dt;
t= params.tmin:dt:params.tmax;

% maximum measurable period
maxp= round( dist/(params.rlambda*C_ave) );



%% Main body

% whitening and filtering between freq1 and freq2
if strcmp(params.white, 'yes')
    cc = cc_white( cc, T1, T2, dt );
end

% calculating SNR (signal to noise ratio)
SNR= SNR_cc( cc, dist, t, dt );

if strcmp(params.SNRflag,'no')==1
    condition= 1; 
else
    if SNR(9)>params.SNR || SNR(10)>params.SNR
        condition= 1;
    else
        condition= 0;
    end
end


if condition    % check SNR condition
    
    %first velocity tapering
    if strcmp(params.vtaper, 'yes')
        w= vel_taper2(t, dt, dist, params.vmin, params.vmax, params.vt_inter);
    else
        w=1;
    end
    cc= w.*cc;
    

    % Fourier transform
    taper= tukeywin(length(cc),0.1);    % if w=1, it is useful
    cc_b= taper'.*cc;
    CC= sym_fft(cc_b,1);
    
    % finding the real part zero-crossings
    [ z_non, first_non, amp ] = z_cross3( CC, dt, freq1, freq2 );
    
    % find irregularities of zero-crossings
    [ dz ] = crossing_detect( z_non );

    % calculate all phase velocities
    [ c_non ] = ph_vel( z_non, zz, first_non, dist, params.vmin, params.vmax);
    
    % automatic selection
    if strcmp(params.automatic, 'yes') && strcmp(params.ref, 'yes')
%         [sxy_data, ~]= disp_select9( c_non, z_non, ref_disp, dz, dist/(1.2*3.5), 'n', filename, dist, amp );
        [sxy_data, ~]= disp_select10( c_non, z_non, ref_disp, dz, maxp, 'n', filename, dist, amp );
    else
        sxy_data= [];
    end
    
%     figure
%     plot(z_non,c_non,'.')
%     figure
%     plot(linspace(0,1/dt,length(CC)),real(CC));xlim([0 .35])

    % prepare the result to return to main function
    % manual selection
    if iscolumn(z_non)==0
        prds= 1./z_non';
    else
        prds= 1./z_non;
    end

    % a vector of all measured phase velocity
    [~,sz]= size(c_non);
    a=[];b=[];
    for i=1:sz
        a=[a;prds];
        b=[b;c_non(:,i)];
    end
    xy_data(:,1)=a;
    xy_data(:,2)=b;

    sta=[head(32), head(33), head(36), head(37)];
    
    
    
else
    sta=[head(32), head(33), head(36), head(37)];
    CC= []; xy_data=[]; sxy_data=[]; prds=[]; z_non=[]; c_non=[];
    
    fprintf('\n\n')
    disp('Warning: This pair does not have sufficient energy to be measured.')
    textLabel = sprintf('Warning: This pair does not have sufficient energy to be measured.');
    set(text1, 'String', textLabel);

end
end