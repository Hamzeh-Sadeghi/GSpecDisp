function [ output, c_non ] = disp_select10( c_non, z_non, ref_disp, dz, mp, pl, name, dist, amp )
% disp_select10 is for automatic selection of dispersion curves based on a
% reference dispersion.
%
%   In ver 10: I clean up all criteria and make them as a predefined
%   variables. I also add 2 points backward criterion rather than ver 9.
%
%   Inputs:
%         c_non:    all possible phase velocities (dispersions)
%         z_non:    zero-crossing values (freq)
%      ref_disp:    reference dispersion (2 columns matrix, 1-frequencies, 2-phase velocity)
%            dz:    irrigularity pridection of zero-crossings
%            mp:    max periods
%            pl:    ploting the selections
%          name:    the station-pair name
%          dist:    distance
%           amp:    amplitude of maximum of real part between zero-crossings, as a function of period
%
%   17 jun 2016
% last modified: 14 Feb 2017
% Hamzeh Sadeghisorkhani

global params

%############################## predefined values
cr1     = params.maxdev;        % maximum deviation from the reference model
cr2     = params.cycle;         % number of cycles that above and below it will be removed
cr3     = params.energy;        % energy (amplitude) criterion (less than 25% will not be selected )

pr2     = params.pr2;           % default is 15
pr1     = params.pr1;           % default is 5

slope1  = params.slope{1};      % 1st slope criterion
slope2  = params.slope{2};
slope3  = params.slope{3};

slope4  = params.slope{4};
slope5  = params.slope{5};
slope6  = params.slope{6};
slope7  = params.slope{7};
slope8  = params.slope{8};

%##############################

%--------------------- preparing inputs
c_non_org= c_non;

if iscolumn(z_non)==0
    periods= 1./z_non';
else
    periods= 1./z_non;
end

% choose every periods that are less than max periods
flag= (periods>mp);
periods(flag==1)=[];
c_non(flag==1,:)=[];
c_non_org(flag==1,:)=[];
dz(flag==1)= [];

% parameters related to reference model
[syn_grd, up, low, dc3, dc4, syn_val]= ref_pre(ref_disp, periods, dist, cr1);

% removing outliers
c_non= rm_out(periods,c_non, up, low, syn_val, dc3, dc4, cr2);


%--------------------------- start selection
grad= 0;
c= 0;           % counter
count2= 0;
first= 0;
second=0;
for s=1:length(periods)         % loop over periods
    if amp(s)>(cr3*max(amp)) %&& dz(s)==0 
        phv2=[];Gr1=[];        
    
        %\\\\\\\\\\\\\\\
        if grad==0      % finding the first point: closet to reference
            phv= c_non(s,:);
            [l2,l1]=  nanmin(abs(phv-syn_val(s)));               
            if isnan(l2)==0
                c= c+1;
                per(c)= periods(s);
                C(c)= phv(l1);        
                grad= 1;
            end
            
        %\\\\\\\\\\\\\\\
        elseif grad==1      % finding 2nd point: reference slope and min gradient
            phv= c_non(s,:);
            Gr1= cal_grad( phv, C(c), periods(s), per(c) );
            gradient1= cal_grad(syn_val(s), syn_val(c), periods(s), per(c)); 
            dgrad_syn= gradient1 - Gr1;
            cc=0;
            for j=1:length(phv)
%                 if abs(dgrad_syn(j)) < 2 && Gr1(j)>-.4 && Gr1(j)<3    
                if abs(dgrad_syn(j)) < slope1 && Gr1(j)>slope2 && Gr1(j)<slope3
                    cc= cc+1;
                    phv2(cc)= phv(j);
                end
            end                   
            if isempty(phv2)==0
                [gradient0, per, C, c, l1]= pselect(phv, phv2, C, periods, per, c, s);
                grad= 2;
            end        
        
        
        %\\\\\\\\\\\\\\\
        elseif grad==2      % finding other point: reference slope and min gradient, the constraint values are different for below pr2 and pr1 sec
        if strcmp(params.anchor,'yes')             
        if periods(s)>pr2                                %<--------- T > pr2
            phv= c_non(s,:);
            Gr1= cal_grad(phv, C(c), periods(s), per(c)); 
            dgrad0= gradient0 - Gr1;
          
            cc=0;
            for j=1:length(phv)
                if abs(dgrad0(j)) < slope1 && Gr1(j)>slope2 && Gr1(j)<slope3
                    cc= cc+1;
                    phv2(cc)= phv(j);                    
                end
            end
            if isempty(phv2)==0
                [gradient0, per, C, c, l1]= pselect(phv, phv2, C, periods, per, c, s);
            end    
            
            
            %-----------------
            elseif periods(s)>pr1 && periods(s)<=pr2          %<---------   pr1 < T < pr2
            if first==0 % preserve the last point values
                % selection of velocity at pr1 with comparing with reference slope
                C15= C(c);
                per15= per(c);
                temp=find(periods<pr1);
                per5= periods(periods==periods(temp(1)));
                phv= c_non((periods==periods(temp(1))),:);                   %all C around pr1
                gradientt= cal_grad(C15,phv,per15,per5); 
                Csyn15= syn_val((periods==per15));
                Csyn5= syn_val((periods==per5));
                syn_grad15_5= cal_grad(Csyn15,Csyn5,per15,per5);
                [~,l2]= nanmin(abs(gradientt-syn_grad15_5));
                gradient15_5= gradientt(l2);
                C5= phv(l2);     
                first= 1;
            end
            
            count2= count2 + 1;
            if dz(s)==0 
                phv= c_non(s,:);
                Gr1= cal_grad(phv, C(c), periods(s), per(c)); 
                Gr15= cal_grad(phv, C15, periods(s), per15); 
                Gr5= cal_grad(phv, C5, periods(s), per5); 

                dgrad0     = gradient0 - Gr1;           % compare with the 2 pervious selected points
                dgrad15_5_0= gradient15_5 - Gr1;        % compare with real 15-5 gradient
                dgrad15    = gradient15_5 - Gr15;       % compare all points from pr2 with real 15-5 gradient
                dgrad5     = gradient15_5 - Gr5;        % compare all points from pr1 with real 15-5 gradient               
                
                
                cc=0; 
                for j=1:length(phv)
                    if abs(dgrad0(j)) < slope4 && abs(dgrad15_5_0(j)) < slope5 && abs(dgrad15(j)) < slope6 && abs(dgrad5(j)) < slope7
                        cc= cc+1;
                        phv2(cc)= phv(j);
                    end
                end
                if isempty(phv2)==0
                    [gradient0, per, C, c, l1]= pselect(phv, phv2, C, periods, per, c, s);
                end
                
            end
            
        %-----------------
            else                     %<---------    T < pr1
                if dz(s:end)==0
                    phv= c_non(s,:);
                    c= c+1;
                    per(c)= periods(s);
                    C(c)= phv(l1);          
                else
                    if dz(s)==0
                        if periods(s)==per5
                            c= c+1;
                            per(c)= periods(s);
                            C(c)= C5;
                        else
                            phv= c_non(s,:);
                            Gr5= cal_grad(phv, C5, periods(s), per5);
                            Grs= cal_grad(syn_val(periods==periods(s)), Csyn5, periods(s), per5);
                            drads= Gr5 - Grs;
                            
                            cc=0;
                            for j=1:length(phv)
                                if abs(drads(j)) < slope8
                                    cc= cc+1;
                                    phv2(cc)= phv(j);
                                end
                            end
                            if isempty(phv2)==0
                                [gradient0, per, C, c, l1]= pselect(phv, phv2, C, periods, per, c, s);
                            end
                        end
                    end
        
                end     % dz(s:end)==0
            
        end     % if periods > pr2 
        
        elseif strcmp(params.anchor,'no')   % if there is no anchor selection it uses the smoothness criterion
             phv= c_non(s,:);
            %Gr1= atan( (phv-C(c))/(periods(s)-per(c))) *180/pi;   
            Gr1= cal_grad(phv, C(c), periods(s), per(c)); 
            dgrad0= gradient0 - Gr1;
          
            cc=0;
            for j=1:length(phv)
                if abs(dgrad0(j)) < slope1 && Gr1(j)>slope2 && Gr1(j)<slope3
                    cc= cc+1;
                    phv2(cc)= phv(j);                    
                end
            end
            if isempty(phv2)==0
                [gradient0, per, C, c, l1]= pselect(phv, phv2, C, periods, per, c, s);
            end    
             
        end     % anchor 
        
    
    
        end     % checking grad
    
    end     % energy (amplitude) checking
end         % loop over periods 



if pl=='y'
%     figure
%     plot(periods,dz,'.-')
    
    figure;hold on
    plot(periods,c_non,'b.')   
    title(['All dispersion points- disp select10',' - ', name],'Interpreter','none');xlabel('Periods');ylabel('Velocity (km/s)')
    if ~isempty(ref_disp)
        plot(ref_disp(:,1), ref_disp(:,2), 'r-.')
    end
    plot(periods,up,'g-.'); plot(periods,low,'g-.')
    axis([min(periods) max(periods) 2.5 5])
    plot(per,C , 'ro')        
    plot(periods, syn_val+1.5.*dc3,'m')
    plot(periods, syn_val+1.5.*dc4,'m')   
    
end

if exist('per','var')==1
    output= [per', C'];    
else
    output= [];
end


end

%==================================
%================================== other functions
function [syn_grd, up, low, dc3, dc4, syn_val]= ref_pre(ref_disp, periods, dist, cr1)

    % reference model value and gradient gradient
    syn_val= interp1(ref_disp(:,1),ref_disp(:,2),periods, 'spline');
    for i=2:length(periods)-1
        syn_grd(i)= (syn_val(i)-syn_val(i-1))/(periods(i)-periods(i-1));
    end
    syn_grd(1)= nan;
    syn_grd(end+1)= nan;

    % maximum reference model deviation 
    up= syn_val+ cr1*syn_val;
    low= syn_val- cr1*syn_val;

    % next cycle velocity value
    dc3=  (syn_val.^2 ./ ( (dist./periods) - syn_val ));
    dc4= -(syn_val.^2 ./ ( (dist./periods) + syn_val ));

end

%------------------------
function [c_non]= rm_out(periods,c_non, up, low, syn_val, dc3, dc4, cr2)
    for i=1:length(periods)
        c_non(i,c_non(i,:)>up(i))= nan;
        c_non(i,c_non(i,:)<low(i))= nan;
        c_non(i,c_non(i,:)> (syn_val(i)+cr2*dc3(i)))= nan;
        c_non(i,c_non(i,:)< (syn_val(i)+cr2*dc4(i)))= nan;
    end

    % delete empty c_non columons
    c_non1= c_non; clear c_non
    a= +isnan(c_non1);
    cn_sz=size(c_non1,2);
    count= 0;
    for i=1:cn_sz
        if a(:,i)==1
        else
            count= count+1;
            c_non(:,count)= c_non1(:,i);
        end
    end
end

%------------------------
function [gradient0, per, C, c, l1]= pselect(phv, phv2, C, periods, per, c, s)
    gr= cal_grad(phv2,C(c),periods(s),per(c)); 
    c= c+1;
    min_loc= find(min(abs(gr))==abs(gr));
    C(c)= phv2(min_loc);
    per(c)= periods(s);
    l1=find(phv==C(c));
    gradient0= gr(min_loc);                
end

%------------------------
function [gg]= cal_grad(y2,y1,x2,x1)
   
    gg= atan((y2-y1)./(x2-x1)).*1000;
end
