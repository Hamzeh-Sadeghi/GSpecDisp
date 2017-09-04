% Copyright (c) 2016, Hamzeh Sadeghisorkhani
% All rights reserved.
%
% 
% 1) TERMS OF USE
%   If you use GSpecDisp or any function(s) of it, you need to acknowledge 
%   GSpecDisp by citing the following article:
% 
%    Sadeghisorkhani, H., Gudmundsson, O., Tryggvason, A., 2017. GSpecDisp: a 
%    Matlab GUI package for phase-velocity dispersion measurements from 
%    ambient-noise correlations, Computers and Geosciences, under review.   
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



%%
% function main
% Main window of the package, for configuring the parameters and options
%
% June 2016
% Hamzeh Sadeghisorkhani


%% Declaration
clc;clear;close all
addpath(genpath(['.', filesep, 'defaults']))
addpath(genpath(['.', filesep, 'func']))
addpath(genpath(['.', filesep, 'Doc']))
addpath(genpath(['.', filesep, 'predefind_mats']))
addpath(genpath(['.', filesep, 'main_fig']))
addpath(genpath(['.', filesep, 'Phase_Velocity']))
addpath(genpath(['.', filesep, 'Average_Velocity']))
addpath(genpath(['.', filesep, 'Viewers']))

global params h2

params.version= 'GSpecDisp1.4';

if exist('user_values.mat','file')==2
    load user_values.mat
else
    load default_values.mat    
end


%% Main figure

mainfig=figure('name',[params.version, ' - Main Window'],...
        'Menubar','none', 'NumberTitle','off','units','normalized');
    
config_main;
config_general;
config_cross_correlation;
config_average;
config_phase;
config_automatic;
                

%% Side panel
h.menu_main = uibuttongroup(mainfig,'visible','on','units','normalized','Position',[.015 .15 .2 .82],...
    'BackgroundColor','w','HighlightColor',[1 1 1]*.3,'BorderWidth',1,'BorderType','beveledin');


h.menu(1) = uicontrol( h.menu_main, 'Style','Radio','String','General Setting',...
    'BackgroundColor','w', 'units','normalized','position',[.06 .8 .9 .2],...
    'HandleVisibility','off','Userdata',h.panel(1));

h.menu(2) = uicontrol( h.menu_main, 'Style','Radio','String','Cross Correlation',...
    'BackgroundColor','w', 'units','normalized','position',[.06 .65 .9 .2],...
    'HandleVisibility','off', 'Userdata',h.panel(2));

h.menu(4) = uicontrol( h.menu_main, 'Style','Radio','String','Average Velocity',...
    'BackgroundColor','w', 'units','normalized','position',[.06 .5 .9 .2],'HandleVisibility','off',...
    'Userdata',h.panel(4));

h.menu(5) = uicontrol( h.menu_main, 'Style','Radio','String','Phase Velocity',...
    'BackgroundColor','w', 'units','normalized','position',[.06 .35 .9 .2],'HandleVisibility','off',...
    'Userdata',h.panel(5));

h.menu(3) = uicontrol( h.menu_main, 'Style','Radio','String','Automatic Selection',...
    'BackgroundColor','w', 'units','normalized','position',[.06 .2 .9 .2],'HandleVisibility','off',...
    'Userdata',h.panel(3));



set(h.menu_main,'selectedobject',h.menu(1));

set(h.menu_main,'SelectionChangeFcn',@menu_cbk);


%% Help and Doc buttons

uicontrol(mainfig,'style','pushbutton', 'string','Help','units','normalized',...
    'BackgroundColor','w','position',[.045 .26 .14 .07], 'callback',@hlp);
                
uicontrol(mainfig,'style','pushbutton', 'string','Tutorial','units','normalized',...
    'BackgroundColor','w','position',[.045 .18 .14 .07], 'callback',@doc);                




