% Main window configuration
% June 2016
% Hamzeh Sadeghisorkhani

% colors and icons
panel_color= [.97 .97 .97];
fig_color= [.94 .94 .94];
load icons.mat

% make the main window larger    
ps= get(mainfig,'position');
%set(mainfig,'position',[ps(1)-.25*ps(1) ps(2)-.25*ps(2) 1.5*ps(3) 1.5*ps(4)]);
set(mainfig,'position',[.5-1.5*ps(3)/2 .5-1.5*ps(4)/2 1.5*ps(3) 1.5*ps(4)]);

% add a separation line
uibuttongroup(mainfig,'visible','on','BackgroundColor',panel_color,...
    'units','normalized','Position',[0 .11 1 .01]);

% add Run, Map viewer, Help and Doc buttons
uicontrol(mainfig,'style','pushbutton', 'string','Phase Velocity','units','normalized',...
                    'position',[.83 .02 .15 .07], 'callback','phase_vel');

uicontrol(mainfig,'style','pushbutton', 'string','Average Velocity','units','normalized',...
                    'position',[.66 .02 .15 .07], 'callback','average_vel');
                
                
                
uicontrol(mainfig,'style','pushbutton', 'string','Map Viewer','units','normalized',...
                    'position',[.36 .02 .15 .07], 'callback','mapviewer');                 
                
uicontrol(mainfig,'style','pushbutton', 'string','Dispersion Viewer','units','normalized',...
                    'position',[.19 .02 .15 .07], 'callback','dispviewer');                
                
uicontrol(mainfig,'style','pushbutton', 'string','Average Viewer','units','normalized',...
                    'position',[.02 .02 .15 .07], 'callback','ave_viewer');                
                
                
                                
