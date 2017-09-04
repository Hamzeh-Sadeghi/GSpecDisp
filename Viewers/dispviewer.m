function dispviewer()
% Viewing and comparing different pairs dispersions.
%
% July 2016
% Hamzeh Sadeghisorkhani
clc
%% Parameters
global params

icons= rddata();

Tmin= params.T1;
Tmax= params.T2;
Cmin= params.vmin;
Cmax= params.vmax;
% T= params.periods;


mm= {'+','o','*','.','x','s','^','v','>','<','p','h'};
marker= repmat(mm,1,10);
mm= {[0,0.4470,0.7410],[0.8500,0.3250,0.0980],[0.9290,0.6940,0.1250],[0.4940,0.1840,0.5560],...
    [0.4660,0.6740,0.1880],[0.3010,0.7450,0.9330],[0.6350,0.0780,0.1840]};
colors= repmat(mm,1,17);

% declaration
ff2= cell(1);
data=[];
data2=[];
dataave=[];
sta= [];
np=[];
h.plot= [];
h.plot2= [];
plotave= [];
leg= [];



%% Figure
fig_color= [.94 .94 .94];
panel_color= [.97 .97 .97];

Fig1= figure('Name', 'Dispersion Viewer', 'position',get(0,'screensize'), ...
    'NumberTitle','off','units','normalized', 'color', fig_color);


%% Axeses
% Dispersion axes
axes1= axes('position',[.05 .42 .5 .50]);
hold(axes1,'on')

pan1= uipanel(Fig1,'visible','on','Position',[.05 .08 .5 .26],...
    'BackgroundColor', panel_color);
uipanel(pan1,'visible','on','Position',[.4 .01 .01 .98],...
    'BackgroundColor', fig_color);


% Map of pairs
axes2= axes('parent', Fig1, 'position',[.6 .15 .35 .7]); hold(axes2,'on')
if isempty(params.map)
%     S = shaperead('landareas.shp');
%     for ind1=1:25
%         plot(axes2,S(ind1).X, S(ind1).Y, 'Color',[.7 .7 .7]); hold on
%     end        
    S= load('world_boundary.mat');
    plot(axes2,S.boundaries(:,2),S.boundaries(:,1), 'Color',[.7 .7 .7])
else
    [pathstr,name,ext] = fileparts(params.map);
    if strcmp(ext,'.txt')
        mapfl =importdata([pathstr,filesep,name,ext], '\t', 0);
    elseif strcmp(ext,'.mat')
        mapfl =importdata([pathstr,filesep,name,ext]);
    end         
        plot(axes2,mapfl(:,2), mapfl(:,1),'Color',[.7 .7 .7])
end
axis([params.lon1 params.lon2 params.lat1 params.lat2])
set(axes2,'XTick',[],'YTick',[],'Box','on')

% Create referesh button
uicontrol('style','pushbutton', 'string','Referesh', 'units','normalized',...
                    'position',[.89 .11 .06 .04],'callback',@refereshfnc);
                
   
%% Buttons and text boxes inside the panel
%-------------------------------- Dispersion Viewer
uicontrol(pan1,'Style','text', 'String','Dispersion Viewer',...
    'HorizontalAlignment','left','Fontweight','bold',...
    'Units','normalized','Position',[.01 .92 .2 .05],...
    'BackgroundColor',panel_color);

% Create open files button
uicontrol(pan1, 'style','pushbutton', 'string','Open files','units','normalized',...
    'position',[.05 .7 .1 .1], 'callback',@openfnc);

% Create open average button
uicontrol(pan1, 'style','pushbutton', 'string','Open Average','units','normalized',...
    'position',[.05 .5 .1 .1], 'callback',@openave);


% logarithmic scale checkbox
uicontrol(pan1,'Style','checkbox','BackgroundColor', panel_color,...
    'String','Log Axis','units','normalized','Tag','logcb',...
    'Value',1,'Position',[.21 .72 .1 .07],'callback',@logscale);

% Selected Dispersion checkbox
h.selc= uicontrol(pan1,'Style','checkbox','BackgroundColor', panel_color,...
    'String','Selected Dispersion','units','normalized','Tag','',...
    'Value',1,'Position',[.21 .55 .18 .07],'callback',@callplot);

% Interpolated Dispersion checkbox
h.intrp= uicontrol(pan1,'Style','checkbox','BackgroundColor', panel_color,...
    'String','Interpolated Dispersion','units','normalized','Tag','',...
    'Value',1,'Position',[.21 .47 .18 .07],'callback',@callplot);

            
            
% Dispersion axes min and max
uicontrol(pan1,'Style','text', 'String','Cmin',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .25 .05 .08],...
    'BackgroundColor',panel_color);
uicontrol(pan1,'Style','text', 'String','Cmax',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .1 .05 .08],...
    'BackgroundColor',panel_color);
uicontrol(pan1,'Style','text', 'String','T1',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.22 .25 .05 .08],...
    'BackgroundColor',panel_color);
uicontrol(pan1,'Style','text', 'String','T2',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.22 .1 .05 .08],...
    'BackgroundColor',panel_color);



uicontrol(pan1,'Style','edit', 'String',Cmin,...
    'HorizontalAlignment','left','Tag','Cmin',...
    'Units','normalized','Position',[.1 .27 .07 .07],...
    'BackgroundColor','w','callback',@limits);

uicontrol(pan1,'Style','edit', 'String',Cmax,...
    'HorizontalAlignment','left','Tag','Cmax',...
    'Units','normalized','Position',[.1 .12 .07 .07],...
    'BackgroundColor','w','callback',@limits);

uicontrol(pan1,'Style','edit', 'String',Tmin,...
    'HorizontalAlignment','left','Tag','Tmin',...
    'Units','normalized','Position',[.25 .27 .07 .07],...
    'BackgroundColor','w','callback',@limits);

uicontrol(pan1,'Style','edit', 'String',Tmax,...
    'HorizontalAlignment','left','Tag','Tmax',...
    'Units','normalized','Position',[.25 .12 .07 .07],...
    'BackgroundColor','w','callback',@limits);

%%
%-------------------------------- Print
% static texts
uicontrol(pan1,'Style','text', 'String','Print to File',...
    'HorizontalAlignment','left','Fontweight','bold',...
    'Units','normalized','Position',[.43 .92 .4 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Plot Title',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.45 .74 .1 .08],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Format',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.46 .55 .1 .08],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Resolution',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.72 .55 .1 .08],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','File Name',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.44 .28 .1 .08],...
    'BackgroundColor',panel_color);



% uicontrols
h.title= uicontrol(pan1,'Style','edit', 'String','',...
    'HorizontalAlignment','left','Tag','',...
    'Units','normalized','Position',[.52 .76 .35 .07],...
    'BackgroundColor','w','callback',@pltitle);


h.format= uicontrol(pan1,'Style','popup', ...
    'String',{'png','jpeg','tiff','bmp','pdf','eps','ps'},'Value',1,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.52 .6 .1 .04],...
    'BackgroundColor','w');    

h.res= uicontrol(pan1,'Style','popup', ...
    'String',{'100','200','300','400','500','600'},'Value',3,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.8 .6 .1 .04],...
    'BackgroundColor','w');    

h.savename= uicontrol(pan1,'Style','edit', 'String','',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.52 .3 .35 .07],...
    'BackgroundColor','w');

h.icon= uicontrol(pan1,'Style','pushbutton', 'String','',...
    'Cdata',icons.file,'Tag','',...
    'Units','normalized','Position',[.88 .3 .04 .07],...
    'callback',@file_cbk);
                
h.pr= uicontrol(pan1,'Style','pushbutton', 'String','',...
    'Cdata',icons.print,'Tag','',...
    'Units','normalized','Position',[.88 .04 .09 .17],...
    'callback',@pr);



%%
%================================
% end of main function
% Other functions (nested)
%================================
function openfnc(~,~)
    data=[];
    data2=[];
    np=[];
    
    [fname, pathname] = uigetfile({'*.mat';'*.*'},'File Selector',...
        params.save,'MultiSelect','on');
    
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
    
    % importing data from file
    for i=1:np
        tmp= importdata(ff{i,:});
        d{i} = tmp.Sdisp;
        sta{i}= tmp.sta;
        d2{i}= tmp.Intdisp;
        [szd(i),~]= size(d{i});
        [szd2(i),~]= size(d2{i});
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
    
    mszd2= max(szd2);
    data2= nan(mszd2, 2*np);
    for i=1:np
        for j=1:mszd2
            if j<=szd2(i)
                data2(j,i*2-1)= d2{1,i}(j,1);
                data2(j,i*2)= d2{1,i}(j,2);
            end
        end
    end

    ploting()
    end
end


%================================
function ploting()
    cla(axes1)
    cla(axes2)
    
    if (get(h.selc,'Value') == get(h.selc,'Max')) && (get(h.intrp,'Value') == get(h.intrp,'Max'))    
        for i=1:np      % selected dispersion
            h.plot(i)= plot(axes1, data(:,i*2-1),data(:,i*2),'Marker',marker{i},'color',colors{i}); 
        end
        for i=1:np       % interpolated dispersion
            h.plot2(i)= plot(axes1, data2(:,i*2-1),data2(:,i*2),'Marker','d','color',colors{i},'linestyle','none'); 
        end
    elseif (get(h.selc,'Value') == get(h.selc,'Min')) && (get(h.intrp,'Value') == get(h.intrp,'Max'))    
        for i=1:np      % interpolated dispersion
            h.plot2(i)= plot(axes1, data2(:,i*2-1),data2(:,i*2),'Marker',marker{i},'color',colors{i}); 
        end
    elseif (get(h.selc,'Value') == get(h.selc,'Max')) && (get(h.intrp,'Value') == get(h.intrp,'Min'))
        for i=1:np      % selected dispersion
            h.plot(i)= plot(axes1, data(:,i*2-1),data(:,i*2),'Marker',marker{i},'color',colors{i}); 
        end
    end
    set(axes1,'xscal','log', 'XTick', [.1 .2 .3 .4 .5 1 2 3 4 5 6 7 8 9 10 15 20 25 30 35 40 50 60 80 100 120]);
    set(axes1, 'box','on', 'ylim', [Cmin Cmax], 'xlim', [Tmin Tmax])
    xlabel(axes1,'Period (sec)')
    ylabel(axes1,'Phase Velocity (km/sec)')  
    if isempty(get(h.title,'string'))
        title(axes1, ['Phase Velocity Dispersion Curve'])
    else
         title(axes1, get(h.title,'string'))
    end
    
    
    % legend
    if (get(h.selc,'Value') == get(h.selc,'Max')) || (get(h.intrp,'Value') == get(h.intrp,'Max'))
        for i=1:np        
            tmp= strsplit(ff2{i,1},'.mat');
            lg{i}= tmp{1,1};
        end
        leg= legend(axes1,lg,'Location','northwest','Interpreter','none');
    end
    
    
      
    % ---------- plot average dispersion
    if ~isempty(dataave)
        plotave= plot(axes1, dataave(:,1),dataave(:,2),'-.k','linewidth',2); 
    end

    
    %----------- plot station pairs on the map
    if isempty(params.map)
%         for ind2=1:25
%             plot(axes2,S(ind2).X, S(ind2).Y, 'Color',[.7 .7 .7]); hold on
%         end
        plot(axes2,S.boundaries(:,2),S.boundaries(:,1), 'Color',[.7 .7 .7])
    else
        [pathstr,name,ext] = fileparts(params.map);
        if strcmp(ext,'.txt')
            mapfl =importdata([pathstr,filesep,name,ext], '\t', 0);
        elseif strcmp(ext,'.mat')
            mapfl =importdata([pathstr,filesep,name,ext]);
        end
        plot(axes2,mapfl(:,2), mapfl(:,1),'Color',[.7 .7 .7])
    end    
    
    for i=1:np        
%         plot(axes2,[sta{i}(1,2) sta{i}(1,4)],[sta{i}(1,1) sta{i}(1,3)],'m','LineWidth',2)
%         plot(axes2,[sta{i}(1,2) sta{i}(1,4)],[sta{i}(1,1) sta{i}(1,3)],'vr','MarkerFaceColor','r')
        plot(axes2,[sta{i}(1,2) sta{i}(1,4)],[sta{i}(1,1) sta{i}(1,3)],'LineWidth',2,'Marker',marker{i},'color',colors{i})

    end
    
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
function openave(~,~)   
    
     [fname, pathname] = uigetfile({'*.mat';'*.*'},'File Selector',...
        params.data,'MultiSelect','off');
    
    [~,nnn]= size(fname);
    if nnn==1 && fname==0
        disp('No file selection made!')
        
    else
    
    if ~isempty(plotave)
        set(plotave,'XData',[])
        set(plotave,'YData',[])
    end
    
    if ~isempty(fname)
        if iscell(fname)
            [~,npave]= size(fname);
            for ii=1:npave
                ff{ii,:}= [pathname,fname{ii}];   
                ff3{ii,:}= fname{ii};
            end
        else
            [npave,~]= size(fname);
            ff{1,:}= [pathname,fname];
            ff3{1,:}= fname;
        end    
    end
    
    % importing data from file
    for i=1:npave        
        d{i} = importdata(ff{i,:});        
        [szd(i),~]= size(d{i});
        
    end
    
    mszd= max(szd);
    dataave= nan(mszd, 2*npave);
    for i=1:npave
        for j=1:mszd
            if j<=szd(i)
                dataave(j,i*2-1)= d{1,i}(j,1);
                dataave(j,i*2)= d{1,i}(j,2);
            end
        end
    end
    
    plotave= plot(axes1, dataave(:,1),dataave(:,2),'-.k','linewidth',2); 
    
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
function callplot(~, ~)
    ploting()
end

%================================
function refereshfnc(~,~) 
    cla(axes2)
   if isempty(params.map)
%         for ind2=1:25
%             plot(axes2,S(ind2).X, S(ind2).Y, 'Color',[.7 .7 .7]); hold on
%         end
        plot(axes2,S.boundaries(:,2),S.boundaries(:,1), 'Color',[.7 .7 .7])
    else
        [pathstr,name,ext] = fileparts(params.map);
        if strcmp(ext,'.txt')
            mapfl =importdata([pathstr,filesep,name,ext], '\t', 0);
        elseif strcmp(ext,'.mat')
            mapfl =importdata([pathstr,filesep,name,ext]);
        end
        plot(axes2,mapfl(:,2), mapfl(:,1),'Color',[.7 .7 .7])
    end    
        
end


%================================
function pltitle(~,~) 
    title(axes1, get(h.title,'string'))
    drawnow
end



%================================
function file_cbk(~,~)
   [filename, pathname] = uiputfile( ...
        {'*.png;*.jpeg;*.tiff;*.bmp;*.pdf;*.eps;*.ps','Image Files (*.png, *.jpeg, *.tiff, *.bmp, *.dat, *.eps, *.ps)';...
        '*.*',  'All Files (*.*)'}, 'Save as file name',params.save);

    if filename~=0
        set(h.savename,'String',[pathname,filename])
    end     
    
    
end
    
    
%================================
function pr(~,~)

    Fig2 = figure('visible','off');
    ax= copyobj([axes1,leg], Fig2);  
    set(ax(1,1),'Position',[0.100 0.1100 0.82 0.8150])


    switch get(h.res,'Value')
        case 1
            rs= '100';
        case 2
            rs= '200';
        case 3
            rs= '300';
        case 4
            rs= '400';
        case 5
            rs= '500';
        case 6
            rs= '600';       
    end
    
    switch get(h.format,'Value')
        case 1
            fr= 'png';
        case 2
            fr= 'jpeg';
        case 3
            fr= 'tiff';
        case 4
            fr= 'bmp';
        case 5
            fr= 'pdf';
        case 6
            fr= 'epsc';
        case 7
            fr= 'psc';
    end
            
    if get(h.format,'Value')<=4
        print(Fig2, ['-d',fr], ['-r',rs], get(h.savename,'String'))
    else
        print(Fig2, ['-d',fr],  get(h.savename,'String'))
    end
    
end






end     % end of main function


%% 
%======================================
% Subfunctions
%======================================
function [icons]= rddata()
    load('icons.mat')

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

