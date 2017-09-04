function average_vel()
% Calculating the average velocity based on the Bessel function curve
% fitting as a function of distance for all elements of correlation tensor.
%
% June 2016
% Hamzeh Sadeghisorkhani
clc
%% Parameters
global params


comp= params.component2;

% declaration
ff= cell(1);
C_not= [];
C_smth= [];
T= [];
h.smth= [];
h.not= [];
h.point= [];
dist_sorted=[];
RL3= [];
dist_max= [];
x= [];
J= [];
T= [];
slidval= [];


%% Figure
fig_color= [.94 .94 .94];
panel_color= [.97 .97 .97];

avfig= figure('Name', 'Average Velocity Calculation', 'position',get(0,'screensize'), ...
    'NumberTitle','off','units','normalized', 'color', fig_color,...
    'WindowScrollWheelFcn',@figScroll);


%% Axeses
% Dispersion axes
axes1= axes('position',[.05 .56 .72 .40]);
hold(axes1,'on')

pan1= uipanel(avfig,'visible','on','Position',[.81 .03 .185 .94],...
    'BackgroundColor', panel_color);

uipanel(avfig,'visible','on','Position',[.81 .45 .185 .01],...
    'BackgroundColor', fig_color);

% Curve fitting axes
axes3= axes('position',[.05 .11 .72 .36]);
hold(axes3,'on')

% Text message to user
text1= uicontrol('Style','edit','FontName','Arial','Fontsize',10,'Fontweight','bold',...
                'String','message','Max',5,'Min',0,'HorizontalAlignment','left',...
                'BackgroundColor', 'w','Enable','inactive',...
                'units','normalized','Position',[.05 .02 .72 .05]);




%% Right side panel, axes and buttons
% Create open files button
uicontrol('style','pushbutton', 'string','Open files','units','normalized',...
    'position',[.815 .9 .08 .0494], 'callback',@openfnc);


% Create open folder button
uicontrol('style','pushbutton', 'string','Open folder','units','normalized',...
    'position',[.91 .9 .08 .0494], 'callback',@openfolder);

% component selection radio buttons
uicontrol(pan1,'Style','text', 'String','Component',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .8 .4 .05],...
    'BackgroundColor',panel_color);

h.rad= uibuttongroup(pan1,'units','normalized','BackgroundColor',panel_color,...
    'bordertype','none','Position',[.08 .78 .9 .05]);

set(h.rad,'SelectionChangeFcn',@radcbk);

h.rad1 = uicontrol( h.rad, 'Style','Radio','String','ZZ',...
    'BackgroundColor',panel_color, 'units','normalized','position',[.0 0 .15 1],'HandleVisibility','off');
h.rad2 = uicontrol( h.rad, 'Style','Radio','String','ZR',...
    'BackgroundColor',panel_color, 'units','normalized','position',[.2 0 .15 1],'HandleVisibility','off');
h.rad3 = uicontrol( h.rad, 'Style','Radio','String','RR',...
    'BackgroundColor',panel_color, 'units','normalized','position',[.4 0 .15 1],'HandleVisibility','off');
h.rad4 = uicontrol( h.rad, 'Style','Radio','String','TT',...
    'BackgroundColor',panel_color, 'units','normalized','position',[.6 0 .15 1],'HandleVisibility','off');
h.rad5 = uicontrol( h.rad, 'Style','Radio','String','RZ',...
    'BackgroundColor',panel_color, 'units','normalized','position',[.8 0 .15 1],'HandleVisibility','off');

if strcmp(comp,'ZZ')
    set (h.rad1,'value',1);
    set (h.rad2,'value',0);
    set (h.rad3,'value',0);
    set (h.rad4,'value',0);
    set (h.rad5,'value',0);
elseif strcmp(comp,'ZR')
    set (h.rad1,'value',0);
    set (h.rad2,'value',1);
    set (h.rad3,'value',0);
    set (h.rad4,'value',0);
    set (h.rad5,'value',0);
elseif strcmp(comp,'RR')
    set (h.rad1,'value',0);
    set (h.rad2,'value',0);
    set (h.rad3,'value',1);
    set (h.rad4,'value',0);
    set (h.rad5,'value',0);
elseif strcmp(comp,'TT')
    set (h.rad1,'value',0);
    set (h.rad2,'value',0);
    set (h.rad3,'value',0);
    set (h.rad4,'value',1);
    set (h.rad5,'value',0);
elseif strcmp(comp,'RZ')
    set (h.rad1,'value',0);
    set (h.rad2,'value',0);
    set (h.rad3,'value',0);
    set (h.rad4,'value',0);
    set (h.rad5,'value',1);
end


% Norm text boxes
uicontrol('Style','text', 'String','Norm',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.85 .64 .06 .03],...
    'BackgroundColor',panel_color);
h.norm= uicontrol('Style','edit', 'String',params.norm,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.875 .65 .06 .03],...
    'BackgroundColor','w','callback',@normselect);

% logarithmic scale checkbox
uicontrol('Style','checkbox','BackgroundColor', panel_color,...
                'String','Log Axis','units','normalized','Tag','logcb',...
                'Value',1,'Position',[.82 .58 .1 .03],'callback',@logscale);

% Create calculation button
uicontrol('style','pushbutton', 'string','Calculation','units','normalized',...
    'position',[.865 .5 .08 .0494], 'callback',@calc);

% silder to see coherency at different period
h.slid= uicontrol('Style', 'slider','units','normalized',... 
    'Value',2,'Min',1,'Max',2,...
    'Position', [.78 .11 .01 .36], 'Callback', @cohr); 
                

% Smooth text boxes
% for help see: http://se.mathworks.com/help/curvefit/smooth.html
uicontrol('Style','text', 'String','Smoothness Coeff',...
    'HorizontalAlignment','center',...
    'Units','normalized','Position',[.82 .378 .06 .03],...
    'BackgroundColor',panel_color);
h.coeff= uicontrol('Style','edit', 'String',.3,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.875 .38 .06 .03],...
    'BackgroundColor','w','callback',@coeffselect);


% Create smooth button
uicontrol('style','pushbutton', 'string','Smooth','units','normalized',...
    'position',[.865 .28 .08 .0494], 'callback',@smth);



% Create open files button
uicontrol('style','pushbutton', 'string','Save Dispersion','units','normalized',...
    'position',[.815 .08 .08 .0494], 'callback',@savedisp);


% Create open folder button
uicontrol('style','pushbutton', 'string','Save Curve Fits','units','normalized',...
    'position',[.91 .08 .08 .0494], 'callback',@savefits);





%%
%================================
% end of main function
% Other functions (nested)
%================================
function openfnc(~,~)
    tt= 0;
    ff=cell(1);
    
    [fname, pathname] = uigetfile({'*.sac';'*.*'},'File Selector',...
        params.data,'MultiSelect','on');    
    
    [~,nnn]= size(fname);
    if nnn==1 && fname==0
        disp('No file selection made!')
        set(text1, 'String', 'No file selection made!');
        
    else
%     if iscell(fname)
%         [~,np]= size(fname);
%         for ii=1:np
%             ff(ii,:)= [pathname,fname{ii}];            
%         end        
%     else        
%         ff= [];        
%         tt= 1;
%         textLabel = sprintf('Error. Not sufficient number of files !!!');
%         set(text1, 'String', textLabel);
%     end
        
        fname= cellstr(fname);
        [~,np]= size(fname);
        if np<5
            clear ff
            tt= 1;
            textLabel = sprintf('Error. Not sufficient number of files (less than 5 pairs) !!!');
            set(text1, 'String', textLabel);
        else
            for ii=1:np
                ff{ii}= [pathname,fname{ii}];            
            end
        end            
    
    
    if ~isempty(ff) && tt==0
        textLabel = sprintf('Files are opened');
        set(text1, 'String', textLabel);
    elseif isempty(ff) && tt==0
        textLabel = sprintf('Error. No files are read !!!');
        set(text1, 'String', textLabel);
    end
    
    end
end


%================================
function openfolder(~,~)
    tmp= uigetdir(params.data);
    
    if tmp~=0
    % get all files in the directory and subdirectories
    ff= getAllFiles(tmp)';
    
    if ~isempty(ff)
        textLabel = sprintf('All files in the folder are opened');
        set(text1, 'String', textLabel); 
    else
        textLabel = sprintf('Error. No files are read !!!');
        set(text1, 'String', textLabel);
    end
    
    else
        set(text1, 'String', 'No file selection made!');
    end
end

%================================
function radcbk(~,eventdata)
    
    comp = get(eventdata.NewValue,'String');   
    
end

%================================
function calc(~,~)
    J=[];
    C_not= [];
    C_smth= [];
    T= [];
    dist_sorted= [];
    RL3= [];
    set(h.not,'XData',[])
    set(h.not,'YData',[])
    set(h.smth,'XData',[])
    set(h.smth,'YData',[])
    set(h.point, 'XData',[])
    set(h.point, 'YData',[])
   
    
    if ~isempty(ff)
        textLabel = sprintf('Calculation started. Be patient ! \n After finshing the result will be appear on the screen.');
        set(text1, 'String', textLabel); 
        drawnow
        
        % time axes
        t= params.tmin : params.dt : params.tmax;
    
        % reading sac files and get distances
        [~, len]=size (ff);
        cc=zeros(length(t),len);h_raw=zeros(158,len);
        for ii=1:len
            [cc(:,ii),h_raw(:,ii)]=rdSac(char(ff{ii}));
        end
        
        dist= h_raw(51,:);
        
        nn= str2double(get(h.norm,'string'));
        
        if strcmp(comp,'RZ')==1
           cc= -cc;
        end
        
        [C_not, T, dist_sorted, RL3, dist_max]=ave_dispersion(cc, dist, t, nn, len, comp);  
        
        coherency;
        ploting1(len);
        
        slidval= length(T);
        ploting2(slidval)        
        
        set(h.slid, 'Max', slidval)
        set(h.slid, 'Value', slidval)
        set(h.slid, 'SliderStep',[1/(slidval-1) , 1/(slidval-1) ]);
        
    else
        textLabel = sprintf('Error. No files are selected !!!');
        set(text1, 'String', textLabel);
    end
    
    
end


%================================
function ploting1(len)
    set(h.not,'XData',[])
    set(h.not,'YData',[])
    
    h.not= plot(axes1, T,C_not,'b.-'); 
    set(axes1,'xscal','log', 'XTick', [.1 .2 .3 .4 .5 1 2 3 4 5 6 7 8 9 10 15 20 25 30 35 40 50 60 80 100 120]);
    set(axes1, 'box','on', 'ylim', [params.Cmin params.Cmax], 'xlim', [T(1) T(end)])
    title(axes1, ['Average Phase Velocity (', num2str(len), ' station pairs)'])
    xlabel(axes1,'Period (sec)')
    ylabel(axes1,'Phase Velocity (km/sec)')    
    
        
end


%================================
function coherency()
        
    x= linspace(0,dist_max,1000);
    if ~isempty(C_smth)
        vel_tmp= (C_smth);
    else
        vel_tmp= (C_not);
    end
    
    for ii=1:length(T)
        Z= (2*pi*1/T(ii)*x)/vel_tmp(ii);
        if strcmp(comp,'ZZ')==1
            J(ii,:) = besselj(0,Z);
        elseif strcmp(comp,'RR')==1 || strcmp(comp,'TT')==1
            J(ii,:) = besselj(0,Z)-besselj(2,Z);
        elseif strcmp(comp,'ZR')==1 || strcmp(comp,'RZ')==1
            J(ii,:) = besselj(1,Z);
        end      
    end
    
    
end


%================================
function ploting2(ii)
    cla(axes3)   
    set(h.point, 'XData',[])
    set(h.point, 'YData',[])
    
    
    plot(axes3, dist_sorted,RL3(:,ii),'.'); 
    plot(axes3, x, J(ii,:));
    
    set(axes3, 'box','on','ylim',[-1 1])
    title(axes3, ['Observed and predicted amplitude (T= ', num2str(T(ii)), ' sec)'])
    xlabel(axes3,'Distance (km)')
    ylabel(axes3,'Normalized Amplitude')    
    
    if ~isempty(C_smth)
        h.point= plot(axes1, T(ii), C_smth(ii), 'md', 'MarkerFaceColor','m' );
    else
        h.point= plot(axes1, T(ii), C_not(ii), 'md', 'MarkerFaceColor','m' );
    end
    
        
end

%================================
function smth(~,~)
    set(h.smth,'XData',[])
    set(h.smth,'YData',[])
    
    coeff= str2double(get(h.coeff,'string'));
    C_smth= smooth(T,C_not,coeff,'rloess');
    C_smth= C_smth';
    h.smth= plot(axes1, T,C_smth,'ro-');
    
    coherency()
    ploting2(slidval)
        
end


%================================
function logscale(h, ~)
    if (get(h,'Value') == get(h,'Max'))
        display('Logarithmic axis chosen');
        set(text1, 'String', 'Logarithmic axis chosen');
        set(axes1,'xScale','log');        
    else
        display('Linear axis chosen');
        set(text1, 'String', 'Linear axis chosen');
        set(axes1,'xScale','linear');        
    end
end

%================================
function normselect(~,~)  
    display('New value for Norm is chosen');
    set(text1, 'String', 'New value for Norm is chosen');    
end

%================================
function coeffselect(~,~)  
    display('New value for Coeff is chosen');
    set(text1, 'String', 'New value for Coeff is chosen');    
end


%================================
function cohr(~,~)
   slidval= round( get(h.slid, 'Value') );
   ploting2(slidval);
        
end


%================================
function figScroll(~,callbackdata)    

    if ~isempty(J)
        chormax= get(h.slid, 'Max');
        chormin= get(h.slid, 'Min');
    
        slidval= slidval - callbackdata.VerticalScrollCount;
    
        if  slidval>= chormax
            slidval= chormax;
        end
        if  slidval<= chormin
            slidval= chormin;
        end
    
        if slidval>= chormin && slidval<= chormax
            set(h.slid, 'Value', slidval)
            ploting2(slidval);
        end
        
    else
        textLabel = sprintf('Error.   Mouse wheel not work.   No Coherency are measured !!!');
        set(text1, 'String', textLabel);
    end

end 


%================================
function savedisp(~,~)
    [file,path] = uiputfile('*.mat','Save As Dispersions',params.save);
    if ~isempty(C_not)
        if file
            tmp= strsplit(file,'.mat');
            file1= tmp{1,1};
            
            if ~isempty(C_smth)
                C_sm(:,1)= T;
                C_sm(:,2)= C_smth;
                save([path,file1,'_sm.mat'],'C_sm')
                
                C_nonsm(:,1)= T;
                C_nonsm(:,2)= C_not;
                save([path,file1,'_nonsm.mat'],'C_nonsm')
                
                set(text1, 'String', ...
                    sprintf('Original dispersion saved with extension of _nonsm. \nSmoothed dispersion saved with extension of _sm.'));
                
            else
                C_nonsm(:,1)= T;
                C_nonsm(:,2)= C_not;
                save([path,file1,'_nonsm.mat'],'C_nonsm')
                
                set(text1, 'String', 'Only original dispersion saved with extension of _nonsm.');
            end            
            
            
        else
            set(text1, 'String', 'Error. No File Name Selected !!!');
        end
        
    else
        set(text1, 'String', 'Error. No Dispersion Exist !!!');
    end
        
end

%================================
function savefits(~,~)
    [file,path] = uiputfile('*.mat','Save As Dispersions',params.save);
    if ~isempty(dist_sorted)
        if file
            RL= RL3;            
            save([path,file],'dist_sorted','RL','T','J','x');
            set(text1, 'String', sprintf('The observed and predicted coherencies are saved.'));
            
        else
            set(text1, 'String', 'Error. No File Name Selected !!!');
        end
        
    else
        set(text1, 'String', 'Error. No Dispersion Exist !!!');
    end
    
    
end
        







end     % end of main function

%%
% Copyright (c) 2016, Hamzeh Sadeghisorkhani
% All rights reserved.
%
% 
% 1) TERMS OF USE
%   If you use GSpecDisp or any function(s) of it, you need to acknowledge 
%   GSpecDisp by citing the following article:
%   Sadeghisorkhani, H., Gudmundsson, O.. GSpecDisp: a Matlab GUI 
%   package for phase-velocity dispersion measurements from ambient-noise 
%   correlations, Computers and Geosciences, ??.   
%   
% 
% 2) LICENSE:
%   This program is part of GSpecDisp
%   GSpecDisp is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%      GSpecDisp is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%       You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.



