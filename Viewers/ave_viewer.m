function ave_viewer()
% Viewing and comparing different dispersions, and possible to create a
% dispersion from them or manually.
%
% July 2016
% Hamzeh Sadeghisorkhani
clc
%% Parameters
global params


Tmin= min(params.periods);
Tmax= max(params.periods);
Cmin= params.Cmin;
Cmax= params.Cmax;
T= params.periods;

mm= {'+','o','*','.','x','s','^','v','>','<','p','h'};
marker= repmat(mm,1,10);
mm= {[0,0.4470,0.7410],[0.8500,0.3250,0.0980],[0.9290,0.6940,0.1250],[0.4940,0.1840,0.5560],...
    [0.4660,0.6740,0.1880],[0.3010,0.7450,0.9330],[0.6350,0.0780,0.1840]};
colors= repmat(mm,1,17);

% declaration
% ff= char;
% ff2= char;
data=[];
np=[];
h.plot= [];
plot2= [];


%% Figure
fig_color= [.94 .94 .94];
panel_color= [.97 .97 .97];

avview= figure('Name', 'Average Viewer', 'position',get(0,'screensize'), ...
    'NumberTitle','off','units','normalized', 'color', fig_color);%,...
%     'WindowScrollWheelFcn',@figScroll);


%% Axeses
% Dispersion axes
axes1= axes('position',[.05 .42 .5 .50]);
hold(axes1,'on')

pan1= uipanel(avview,'visible','on','Position',[.05 .08 .5 .26],...
    'BackgroundColor', panel_color);
uipanel(pan1,'visible','on','Position',[.5 .01 .01 .98],...
    'BackgroundColor', fig_color);


tab1= uitable(avview,'units','normalized','Position',[.58 .08 .25 .84],...
    'Data', cell(100,10));

tab2= uitable(avview,'units','normalized','Position',[.86 .08 .108 .84],...
    'ColumnEditable',true,'CellEditCallback',@draw_ave,...
    'keypressfcn',@newrow,...
    'Enable','off','ColumnName',{'Per','C'},'Data',cell(100,2) );

uicontrol(avview,'Style','text', 'String','New Dispersion',...
    'HorizontalAlignment','center','FontWeight','bold',...
    'Units','normalized','Position',[.86 .93 .1 .02],...
    'BackgroundColor',fig_color);


%% Buttons and text boxes inside the panel
%-------------------------------- Dispersion Viewer
uicontrol(pan1,'Style','text', 'String','Dispersion Viewer',...
    'HorizontalAlignment','left','Fontweight','bold',...
    'Units','normalized','Position',[.01 .92 .4 .05],...
    'BackgroundColor',panel_color);

% Create open files button
uicontrol(pan1, 'style','pushbutton', 'string','Open files','units','normalized',...
    'position',[.05 .7 .1 .1], 'callback',@openfnc);


% logarithmic scale checkbox
uicontrol(pan1,'Style','checkbox','BackgroundColor', panel_color,...
    'String','Log Axis','units','normalized','Tag','logcb',...
    'Value',1,'Position',[.32 .7 .15 .07],'callback',@logscale);
            
            
% Dispersion axes min and max
uicontrol(pan1,'Style','text', 'String','Cmin',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .4 .05 .08],...
    'BackgroundColor',panel_color);
uicontrol(pan1,'Style','text', 'String','Cmax',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .25 .05 .08],...
    'BackgroundColor',panel_color);
uicontrol(pan1,'Style','text', 'String','T1',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.3 .4 .05 .08],...
    'BackgroundColor',panel_color);
uicontrol(pan1,'Style','text', 'String','T2',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.3 .25 .05 .08],...
    'BackgroundColor',panel_color);



uicontrol(pan1,'Style','edit', 'String',Cmin,...
    'HorizontalAlignment','left','Tag','Cmin',...
    'Units','normalized','Position',[.1 .42 .07 .07],...
    'BackgroundColor','w','callback',@limits);

uicontrol(pan1,'Style','edit', 'String',Cmax,...
    'HorizontalAlignment','left','Tag','Cmax',...
    'Units','normalized','Position',[.1 .27 .07 .07],...
    'BackgroundColor','w','callback',@limits);

uicontrol(pan1,'Style','edit', 'String',Tmin,...
    'HorizontalAlignment','left','Tag','Tmin',...
    'Units','normalized','Position',[.33 .42 .07 .07],...
    'BackgroundColor','w','callback',@limits);

uicontrol(pan1,'Style','edit', 'String',Tmax,...
    'HorizontalAlignment','left','Tag','Tmax',...
    'Units','normalized','Position',[.33 .27 .07 .07],...
    'BackgroundColor','w','callback',@limits);

%%
%-------------------------------- New Dispersion
uicontrol(pan1,'Style','text', 'String','New Dispersion',...
    'HorizontalAlignment','left','Fontweight','bold',...
    'Units','normalized','Position',[.53 .92 .4 .05],...
    'BackgroundColor',panel_color);


% logarithmic scale checkbox
uicontrol(pan1,'Style','checkbox','BackgroundColor', panel_color,...
    'String','New Dispersion','units','normalized','Tag','logcb',...
    'Value',0,'Position',[.56 .7 .15 .07],'callback',@newdisp);


h.ave= uicontrol(pan1, 'style','pushbutton', 'string','Interp/Average','units','normalized',...
    'Enable','off','position',[.56 .5 .12 .1], 'callback',@ave);

h.draw= uicontrol(pan1, 'style','pushbutton', 'string','Draw','units','normalized',...
    'Enable','off','position',[.56 .3 .12 .1], 'callback',@draw_ave);

h.save= uicontrol(pan1, 'style','pushbutton', 'string','Save Dispersion','units','normalized',...
    'Enable','off','position',[.56 .1 .12 .1], 'callback',@save_ave);



uicontrol(pan1,'Style','text', 'String','T (Periods)',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.75 .55 .2 .05],...
    'BackgroundColor',panel_color);

h.T= uicontrol(pan1,'Style','edit', 'String',T,...
    'HorizontalAlignment','left','Max',2,'Enable', 'off',...
    'Units','normalized','Position',[.84 .1 .1 .5],...
    'BackgroundColor','w','callback',@chT);





%%
%================================
% end of main function
% Other functions (nested)
%================================
function openfnc(~,~)
    data=[];
    np=[];
    
    [fname, pathname] = uigetfile({'*.mat';'*.*'},'File Selector',...
        'MultiSelect','on', params.save);
    
    [~,nnn]= size(fname);
    if nnn==1 && fname==0
        disp('No file selection made!')
        
    else
    if ~isempty(fname)
        if iscell(fname)
            [~,np]= size(fname);
            for ii=1:np
                ff{ii,:}= [pathname,fname{ii}];   
                ff2{ii,:}= fname{ii};
            end
        else
            [np,~]= size(fname);
            ff{1,:}= [pathname,fname];
            ff2{1,:}= fname;
        end    
    end
    
    % importing data from file and show them on the table 1    
    for i=1:np
        d{i} =importdata(ff{i,:});
        [szd(i),~]= size(d{i});
        
    end
    
    mszd= max(szd);
    data= nan(mszd, 2*np);
    for i=1:np
        for j=1:mszd
            if j<=szd(i)
                data(j,i*2-1)= d{1,i}(j,1);
                data(j,i*2)= d{1,i}(j,2);
            end
        end
    end
    
    cname= {'Per','C'};    
        
    set(tab1,'Data',data,'ColumnName',repmat(cname,1,np))
    ploting(ff2)
    end
end


%================================
function ploting(ff2)
    cla(axes1)
    plot2= [];
    
    for i=1:np
        h.plot(i)= plot(axes1, data(:,i*2-1),data(:,i*2),'Marker',marker{i},'color',colors{i}); 
    end
    set(axes1,'xscal','log', 'XTick', [.1 .2 .3 .4 .5 1 2 3 4 5 6 7 8 9 10 15 20 25 30 35 40 50 60 80 100 120]);
    set(axes1, 'box','on', 'ylim', [Cmin Cmax], 'xlim', [Tmin Tmax])
    title(axes1, ['Average Phase Velocity'])
    xlabel(axes1,'Period (sec)')
    ylabel(axes1,'Phase Velocity (km/sec)')  
    
    
    for i=1:np        
        tmp= strsplit(ff2{i,1},'.mat');
        lg{i}= tmp{1,1};
    end
    legend(lg,'Location','northwest','Interpreter','none')
        
end

%================================
function logscale(h, ~)
    if (get(h,'Value') == get(h,'Max'))
        set(axes1,'xScale','log');        
    else
        set(axes1,'xScale','linear');        
    end
end

%================================
function limits(h, ~)
    switch get(h,'Tag')
        case 'Cmin'
            Cmin= str2double(get(h,'String'));
        case 'Cmax'
            Cmax= str2double(get(h,'String'));
        case 'Tmin'
            Tmin= str2double(get(h,'String'));
        case 'Tmax'
            Tmax= str2double(get(h,'String'));
    end
    set(axes1,'ylim', [Cmin Cmax], 'xlim', [Tmin Tmax])    
end

%================================
function newdisp(handel,~)
    if (get(handel,'Value') == get(handel,'Max'))        
        set(tab2, 'Enable', 'on');
        set(h.ave, 'Enable', 'on');        
        set(h.draw, 'Enable', 'on');        
        set(h.save, 'Enable', 'on');        
        set(h.T, 'Enable', 'on');
    else        
        set(tab2, 'Enable', 'off');
        set(h.ave, 'Enable', 'off');        
        set(h.draw, 'Enable', 'off');        
        set(h.save, 'Enable', 'off');
        set(h.T, 'Enable', 'off');
    end
end


%================================
function chT(handel,~)
    T= str2num( get(handel,'String') );    
end

%================================
function ave(~,~)
    % interpolation for finding new values at specified T
    for i=1:np
        ind= ~isnan(data(:,2*i-1));
        C_int(:,i)= interp1(data(ind,2*i-1),  data(ind,2*i), T, 'spline');
    end
    
    Cm= mean(C_int,2);
    
    new_data= [T,Cm];
    
    set(tab2,'Data',new_data)
    
end

%================================
function draw_ave(~,~)  
    if ~isempty(plot2)
        set(plot2,'XData',[])
        set(plot2,'YData',[])
    end
    
    
    dd= get(tab2,'Data');
    dd= sortrows(dd,1);
    plot2= plot(axes1, dd(:,1),dd(:,2),'color','m','Marker','d','MarkerFaceColor','m'); 
    
end

%================================
function newrow(~,evt)    
    if strcmp(evt.Key,'n') || strcmp(evt.Key,'N')
         dd= get(tab2,'Data');
         dd(end+1,:)=nan; 
         set(tab2,'Data',dd)        
    end       
   
end

%================================
function save_ave(~,~)
    dd= get(tab2,'Data');
    
    dd= sortrows(dd,1);
    
    [file,path] = uiputfile('*.mat','Save As New Dispersion', params.save);
    
    tmp= strsplit(file,'.mat');
    file1= tmp{1,1};
    
     C_new(:,1)= dd(:,1);
     C_new(:,2)= dd(:,2);
     save([path,file1,'.mat'],'C_new')
    
    
end



    
end

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

