function mapviewer()
% Viewing of different pairs in a single period on a regional map.
%
% July 2016
% Hamzeh Sadeghisorkhani
clc
%% Parameters
global params

icons= rddata();

Tmin= min(params.periods);
Tmax= max(params.periods);
Cmin= params.Cmin;
Cmax= params.Cmax;
T= params.periods;

% S = shaperead('landareas.shp');
S= load('world_boundary.mat');

% declaration
np=[];
data= [];
slidval= [];
cb= [];
cm= [];


%% Figure
fig_color= [.94 .94 .94];
panel_color= [.97 .97 .97];


Fig1= figure('Name', 'Map Viewer', 'position',get(0,'screensize'), ...
    'NumberTitle','off','units','normalized', 'color', fig_color,...
    'WindowScrollWheelFcn',@figScroll);



%% Axeses
% Dispersion axes
axes1= axes('position',[.05 .12 .7 .8]);
hold(axes1,'on')

pan1= uipanel(Fig1,'visible','on','Position',[.81 .03 .185 .94],...
    'BackgroundColor', panel_color);
uipanel(pan1,'visible','on','Position',[.01 .3 .98 .01],...
    'BackgroundColor', fig_color);


% silder to see phase velocity at different period
h.slid= uicontrol('Style', 'slider','units','normalized',... 
    'Value',10,'Min',5,'Max',10,...
    'Position', [.78 .11 .01 .36], 'Callback', @slid); 



%% Buttons and text boxes inside the panel
%--------------------------------
% static texts
uicontrol(pan1,'Style','text', 'String','Map File',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .82 .2 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Left Bottom Corner and Right Top Corner',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .74 .9 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Lat 1',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.1 .7 .15 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Long 1',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.55 .7 .15 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Lat 2',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.1 .66 .15 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Long 2',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.55 .66 .15 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Projection',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .585 .2 .05],...
    'BackgroundColor',panel_color);


uicontrol(pan1,'Style','text', 'String','Color Template',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .495 .2 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Color Order',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.54 .495 .2 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Cmin',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.4 .445 .2 .02],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Cmax',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.7 .445 .2 .02],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Station Size',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .355 .2 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Station Color',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.54 .355 .2 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Line Width',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .325 .2 .02],...
    'BackgroundColor',panel_color);



% uicontrols
% Create open files button
uicontrol('style','pushbutton', 'string','Open files','units','normalized',...
    'position',[.815 .9 .08 .0494], 'callback',@openfnc);


% Create open folder button
uicontrol('style','pushbutton', 'string','Open folder','units','normalized',...
    'position',[.91 .9 .08 .0494], 'callback',@openfolder);


h.map= uicontrol(pan1,'Style','edit', 'String',params.map,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.26 .85 .6 .025],...
    'BackgroundColor','w');

h.iconmap= uicontrol(pan1,'Style','pushbutton', 'String','',...
    'Cdata',icons.file,'Tag','',...
    'Units','normalized','Position',[.88 .85 .07 .025],...
    'callback',@mapfile);



h.lat1= uicontrol(pan1,'Style','edit', 'String',params.lat1,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.24 .73 .2 .025],...
    'BackgroundColor','w','callback',@redraw);

h.lon1= uicontrol(pan1,'Style','edit', 'String',params.lon1,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.71 .73 .2 .025],...
    'BackgroundColor','w','callback',@redraw);

h.lat2= uicontrol(pan1,'Style','edit', 'String',params.lat2,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.24 .69 .2 .025],...
    'BackgroundColor','w','callback',@redraw);

h.lon2= uicontrol(pan1,'Style','edit', 'String',params.lon2,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.71 .69 .2 .025],...
    'BackgroundColor','w','callback',@redraw);



% ,'Orthographic','Stereographic'
h.proj= uicontrol(pan1,'Style','popup', ...
    'String',{'Equal-Area Cylindrical','Mercator',...
    'Plate Carree ','Robinson','Hammer'},'Value',3,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.3 .6 .55 .04],...
    'BackgroundColor','w','callback',@redraw);    



h.colormap= uicontrol(pan1,'Style','popup', 'String',...
    {'parula','jet','hsv','cool','spring','summer','autumn','winter'},'Value',2,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.25 .5 .2 .04],...
    'BackgroundColor','w','callback',@redraw);    

h.order= uicontrol(pan1,'Style','popup', 'String',...
    {'Ascending','Descending'},'Value',1,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.7 .5 .25 .04],...
    'BackgroundColor','w','callback',@redraw);    


h.fixed= uicontrol(pan1,'Style','checkbox','BackgroundColor', panel_color,...
    'String','Fixed Colorbar','units','normalized',...
    'Value',0,'Position',[.05 .445 .35 .025],'callback',@redraw);

h.colormin= uicontrol(pan1,'Style','edit', 'String','',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.5 .445 .15 .025],...
    'BackgroundColor','w');

h.colormax= uicontrol(pan1,'Style','edit', 'String','',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.81 .445 .15 .025],...
    'BackgroundColor','w','callback',@redraw);

h.size= uicontrol(pan1,'Style','edit', 'String',5,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.25 .375 .2 .025],...
    'BackgroundColor','w','callback',@redraw);

h.color= uicontrol(pan1,'Style','popup', 'String',...
    {'blue','green','red','cyan','magenta','yellow','black','white'},'Value',5,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.7 .36 .25 .04],...
    'BackgroundColor','w','callback',@redraw);    

h.grid= uicontrol(pan1,'Style','checkbox','BackgroundColor', panel_color,...
    'String','Grid','units','normalized',...
    'Value',1,'Position',[.55 .325 .25 .025],'callback',@redraw);

h.width= uicontrol(pan1,'Style','edit', 'String',2,...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.25 .325 .2 .025],...
    'BackgroundColor','w','callback',@redraw);





%%
%-------------------------------- Print
% static texts
uicontrol(pan1,'Style','text', 'String','Print to File',...
    'HorizontalAlignment','left','Fontweight','bold',...
    'Units','normalized','Position',[.03 .24 .4 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Plot Title',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .19 .2 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Format',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.1 .12 .2 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','Resolution',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.52 .12 .2 .05],...
    'BackgroundColor',panel_color);

uicontrol(pan1,'Style','text', 'String','File Name',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .05 .2 .05],...
    'BackgroundColor',panel_color);



% uicontrols
h.title= uicontrol(pan1,'Style','edit', 'String','',...
    'HorizontalAlignment','left','Tag','',...
    'Units','normalized','Position',[.26 .22 .6 .025],...
    'BackgroundColor','w','callback',@pltitle);


h.format= uicontrol(pan1,'Style','popup', ...
    'String',{'png','jpeg','tiff','bmp','pdf','eps','ps'},'Value',1,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.26 .15 .2 .025],...
    'BackgroundColor','w');    

h.res= uicontrol(pan1,'Style','popup', ...
    'String',{'100','200','300','400','500','600'},'Value',3,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.74 .15 .2 .025],...
    'BackgroundColor','w');    

h.savename= uicontrol(pan1,'Style','edit', 'String','',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.26 .08 .6 .025],...
    'BackgroundColor','w');

h.icon= uicontrol(pan1,'Style','pushbutton', 'String','',...
    'Cdata',icons.file,'Tag','',...
    'Units','normalized','Position',[.88 .08 .07 .025],...
    'callback',@file_cbk);
                
h.pr= uicontrol(pan1,'Style','pushbutton', 'String','',...
    'Cdata',icons.print,'Tag','',...
    'Units','normalized','Position',[.78 .01 .2 .05],...
    'callback',@pr);






%%
%================================
% end of main function
% Other functions (nested)
%================================
function openfnc(~,~)
    np= [];    
    data=[];
    [fname, pathname] = uigetfile({'*.mat';'*.*'},'File Selector',...
        params.save,'MultiSelect','on');
    
    [~,nnn]= size(fname);
    if nnn==1 && fname==0
        disp('No file selection made!')
        
    else
        if iscell(fname)
            [~,np]= size(fname);
            for ii=1:np
                ff{ii,:}= [pathname,fname{ii}];            
            end
        else
            [np,~]= size(fname);
            ff{1,:}= [pathname,fname];
        end    
        
        readdata(ff)
        
    end
end


%================================
function openfolder(~,~)
    np= [];
    data=[];
    tmp= uigetdir(params.save);
    
    % get all files in the directory and subdirectories
    if tmp~=0
        ff= getAllFiles(tmp);
        [np,~]= size(ff);
    
        readdata(ff)
    end
end

%================================
function readdata(ff)
    
    % importing data from file    
    data= nan(np, 4+length(T));
    for i=1:np
        tmp= importdata(ff{i,:});
        sta{i}= tmp.sta;
        d2{i}= tmp.Intdisp;

        data(i,1:4)= sta{i};
        for j=1:length(T)
            ind= find(d2{1,i}(:,1)==T(j));
            if ~isempty(ind)
                data(i,j+4)= d2{1,i}(ind,2);
            end
            
        end
    end
    
    if np==1
        indx= find(isnan(data)==1);
    else
        indx= find(all(isnan(data))==1);
    end    
    data(:,indx)=[];
    T(indx-4)= [];
    
    slidval= length(T)+4;    
    
    set(h.slid, 'Max', slidval)
    set(h.slid, 'Value', slidval)
    set(h.slid, 'SliderStep',[1/(slidval-5) , 1/(slidval-5) ]);
    
    ploting(slidval);
        
end

%================================
function ploting(ii)
    cla(axes1)
    
    latlim = [str2double(get(h.lat1,'String')) str2double(get(h.lat2,'String'))];
    lonlim = [str2double(get(h.lon1,'String')) str2double(get(h.lon2,'String'))];
    
    switch get(h.proj,'Value')
        case 1
            proj= 'eqacylin';
        case 2
            proj= 'mercator';
        case 3
            proj= 'pcarree';
        case 4
            proj= 'robinson';
        case 5
            proj= 'hammer';        
    end
    
    switch get(h.grid,'Value')
        case 1
            gr= 'on';
        case 0
            gr= 'off';
    end
    
    latinterv= (latlim(2)-latlim(1))/5;
    loninterv= (lonlim(2)-lonlim(1))/5;
    
    if latinterv<1 || loninterv<1
        units= 'dm';
    else
        units= 'degree';
    end
    

    axesm (proj, 'Frame', 'on', 'Grid', gr, 'GColor', [.8 .8 .8], 'MapLatLimit',latlim,'MapLonLimit',lonlim,...
        'FFaceColor',[1 1 1],'MLabelParallel','South',...
        'ParallelLabel','on','PLabelLocation',latinterv,'PLineLocation',latinterv,...
        'MeridianLabel','on','mlabellocation',loninterv,'MLineLocation',loninterv,...        
        'LabelUnits',units);
    axis off
    
    if isempty(get(h.map,'String'))
        geoshow(axes1,S.boundaries(:,1),S.boundaries(:,2),'Color',[.7 .7 .7])        
    else
         [pathstr,name,ext] = fileparts(get(h.map,'String'));
         if strcmp(ext,'.txt')
             mapfl =importdata([pathstr,filesep,name,ext], '\t', 0);
         elseif strcmp(ext,'.mat')
             mapfl =importdata([pathstr,filesep,name,ext]);
         end
         
        geoshow(axes1,mapfl(:,1), mapfl(:,2),'Color',[.7 .7 .7])
    end
    
    

    % plot colored lines    
    if get(h.order,'Value')==1
        col= ii;
    elseif get(h.order,'Value')==2
        col= -ii;
    end
    data_sorted= sortrows(data,col) ;
    
     switch get(h.colormap,'Value') 
        case 1
             cm=colormap(parula);
        case 2
            cm=colormap(jet);
        case 3
            cm=colormap(hsv);
        case 4
            cm=colormap(cool);
        case 5
            cm=colormap(spring);
        case 6
            cm=colormap(summer);     
        case 7
            cm=colormap(autumn);
        case 8
            cm=colormap(winter);
     end
    
    if get(h.fixed,'Value')
        if isempty(get(h.colormin,'string'))==1 || isempty(get(h.colormax,'string'))==1
            mind= min(min(data_sorted(:,5:end)));
            maxd= max(max(data_sorted(:,5:end)));
        else
            mind= str2double(get(h.colormin,'string'));
            maxd= str2double(get(h.colormax,'string'));            
        end
    else
        mind= min(data_sorted(:,ii));
        maxd= max(data_sorted(:,ii));
    end
    interv= linspace(mind,maxd,length(cm));
    for i=np:-1:1
        if isnan(data_sorted(i,ii))==0
            aa=find(interv>=data_sorted(i,ii));
            if isempty(aa)
                aa= 64;
            end            
            geoshow([data_sorted(i,1) data_sorted(i,3)],[data_sorted(i,2) data_sorted(i,4)], 'DisplayType', 'line',...
                'Color', cm(aa(1),:),'LineWidth',str2double(get(h.width,'String')));
        end
    end
    title(axes1, ['T= ',num2str(T(ii-4)),' s'])
        
    

    cb= colorbar;
    title(cb,'km/s')
    if mind==maxd
        caxis([mind-.05*mind maxd+.05*maxd])
    else
        caxis([mind maxd])
    end
    
    
    % plot stations
    cc= get(h.color,'String');    
    geoshow(data(:,1), data(:,2), 'DisplayType', 'multipoint','Marker', 'v','MarkerFaceColor',...
        cc{get(h.color,'value')},'MarkerEdgeColor',cc{get(h.color,'value')},'Color',cc{get(h.color,'value')},...
        'MarkerSize', str2double(get(h.size,'String')));
    geoshow(data(:,3), data(:,4), 'DisplayType', 'multipoint','Marker', 'v','MarkerFaceColor', ...
        cc{get(h.color,'value')},'MarkerEdgeColor',cc{get(h.color,'value')},'Color',cc{get(h.color,'value')},...
        'MarkerSize', str2double(get(h.size,'String')));
    
    tightmap
    
    
    
end

%================================
function redraw(~,~)     
    ploting(slidval)
    
end

%================================
function slid(~,~)
   slidval= round( get(h.slid, 'Value') );
   ploting(slidval);
        
end

%================================
function figScroll(~,callbackdata)    

    if ~isempty(data)
        indTmax= length(T)+4;
        indTmin= 5;
    
        slidval= slidval - callbackdata.VerticalScrollCount;
    
        if  slidval>= indTmax
            slidval= indTmax;
        end
        if  slidval<= indTmin
            slidval= indTmin;
        end
    
        if slidval>= indTmin && slidval<= indTmax
            set(h.slid, 'Value', slidval)
            ploting(slidval);
        end
        
    
    end

end 

%================================
function mapfile(~,~)
   [filename, pathname] = uigetfile( ...
        {'*.mat;*.txt','Map Files (*.mat, *.txt (tab delimited) )';...
        '*.*',  'All Files (*.*)'}, 'Map file name',params.data);

    if filename~=0
        set(h.map,'String',[pathname,filename])
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
    ax= copyobj([axes1,cb], Fig2);  
    set(ax(1,1),'Position',[0.100 0.1100 0.82 0.8150])

    switch get(h.colormap,'Value') 
        case 1
             cm=colormap(parula);
        case 2
            cm=colormap(jet);
        case 3
            cm=colormap(hsv);
        case 4
            cm=colormap(cool);
        case 5
            cm=colormap(spring);
        case 6
            cm=colormap(summer);     
        case 7
            cm=colormap(autumn);
        case 8
            cm=colormap(winter);
    end

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




end


%% 
%======================================
% Subfunctions
%======================================
function [icons]= rddata()
    load('icons.mat')

end


%================================
function mapfile(~,~)


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

