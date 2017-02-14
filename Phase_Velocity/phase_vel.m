function phase_vel()
% Calculating the phase velocity dispersion curves based on Ekstrom et.al. 
% 2009 method (http://onlinelibrary.wiley.com/doi/10.1029/2009GL039131/full) 
% and let user graphically select the suitable dispersion curves.
%
% June 2016
% changed: Aug 2016
% last modification: 14 Feb 2017
% Hamzeh Sadeghisorkhani

%% Parameters
global params

T= params.measureperiods;
comp= params.component;


[ref_disp_R, ~, ~]= rddata(params.Rayleigh_ave, params.ref, params.format, params.delim);
[ref_disp_L, zz, icons]= rddata(params.Love_ave, params.ref, params.format, params.delim); 
    

% declaration
pnum= 0;
np= [];
% ff= char;
% ff2= char;
ff= cell(1);
ff2= cell(1);
titlename= char;
xy_data=[];
sxy_data=[];
prds=[];
sta=[];
dist= [];
z_non=[];
c_non=[];
ref_disp=[];



%% Figure
fig_color= [.94 .94 .94];
panel_color= [.97 .97 .97];

f= figure('Name', 'Phase Velocity (Dispersion Curve Measurement)', 'position',get(0,'screensize'), ...
    'NumberTitle','off','units','normalized', 'color', fig_color);
% f= figure('color',[.94 .94 .94]); % full screen with Java
% drawnow
% jFig = get(f, 'JavaFrame'); 
% jFig.setMaximized(true);


%% Axeses
% Dispersion axes
axes1= axes('position',[.05 .24 .75 .7113]);


pan1= uipanel(f,'visible','on','Position',[.81 .03 .185 .94],...
    'BackgroundColor', panel_color);

% Map of stations
axes2= axes('parent', pan1, 'position',[.03 .586 .95 .3]);

if isempty(params.map)
%     S = shaperead('landareas.shp');
%     for ind1=1:25
%         plot(axes2,S(ind1).X, S(ind1).Y, 'Color',[.7 .7 .7]); hold on
%     end  
    S=load('world_boundary.mat');
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


% Plot of real part of cross correlation
axes3= axes('position',[.05 .08 .75 .1]);

% Text message to user
text1= uicontrol('Style','edit','FontName','Arial','Fontsize',10,'Fontweight','bold',...
                'String','message','Max',5,'Min',0,'HorizontalAlignment','left',...
                'BackgroundColor', 'w','Enable','inactive',...
                'units','normalized','Position',[.05 .02 .75 .05]);




%% Right side panel, axes and buttons
% Create open file button
uicontrol('style','pushbutton', 'string','Open file','units','normalized',...
                    'position',[.865 .9 .08 .0494], 'callback',@openfnc);
                
% Create referesh button
uicontrol('style','pushbutton', 'string','Referesh', 'units','normalized',...
                    'position',[.931 .54 .06 .04],'callback',@refereshfnc);
                
% Maximum measurable period (distance/(1.2*C_ave))
uicontrol('Style','text', 'String','Max Measurable Period:    ','HorizontalAlignment','left',...
                'BackgroundColor', panel_color,...
                'units','normalized','Position',[.82 .42 .1 .03]);
text2= uicontrol('Style','text','HorizontalAlignment','left',...
                'BackgroundColor', panel_color,...
                'units','normalized','Position',[.9 .42 .06 .03]);
                
% logarithmic scale checkbox
uicontrol(f,'Style','checkbox','BackgroundColor', panel_color,...
                'String','Log Axis','units','normalized','Tag','logcb',...
                'Value',1,'Position',[.82 .35 .1 .03],'callback',@logscale);

% print icon
h.pr= uicontrol(pan1,'Style','pushbutton', 'String','',...
    'Cdata',icons.print,'Tag','',...
    'Units','normalized','Position',[.68 .33 .16 .05],...
    'callback',@pr);

if strcmp(params.scale,'Log')
    set(findobj('Tag','logcb'),'Value',1);
else
    set(findobj('Tag','logcb'),'Value',0);
end
                
                               
%static text
uicontrol(f,'Style','text', 'String','Selection mode',...
                'BackgroundColor', panel_color, ...
                'Units','normalized','Position',[.84 .25 .14 .05]);             
            
% Create list box of selection mode
uicontrol('Style', 'listbox',...
           'String', {'','Add','Rectangle','Delete','Delete Rectangle'},'Value',1,...
           'Units', 'normalized','Position', [.84 .18 .14 .1],...
           'BackgroundColor', 'w', 'Callback', @setpop);   


                                
% Create next button
uicontrol('style','pushbutton','string','Next','units','normalized',...
                    'position',[.82 .05 .08 .0494], 'callback',@nextfnc);
                
% Create previous button
uicontrol('style','pushbutton','string','Previous','units','normalized',...
                    'position',[.82 .11 .08 .0494], 'callback',@prevfnc);
                
% Create done button
uicontrol('style','pushbutton', 'string','Done!','units','normalized',...
                    'position',[.91 .08 .08 .0494], 'callback',@donefnc);
                

        

% component selection radio buttons
uicontrol(pan1,'Style','text', 'String','Component',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.05 .48 .4 .05],...
    'BackgroundColor',panel_color);

h.rad= uibuttongroup(pan1,'units','normalized','BackgroundColor',panel_color,...
    'bordertype','none','Position',[.08 .465 .9 .05]);

set(h.rad,'SelectionChangeFcn',@radcbk);

h.rad1 = uicontrol( h.rad, 'Style','Radio','String','ZZ',...
    'BackgroundColor',panel_color, 'units','normalized','position',[0 0 .15 1],'HandleVisibility','off');
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



%% 
h_select=plot(axes1,0,0);



%%
%================================
% end of main function
% Other functions (nested)
%================================
% function openfnc(~,~)   
%     xy_data=[];
%     sxy_data=[];
%     textLabel = sprintf('File is opened');
%     set(text1, 'String', textLabel);
%     
%     [fname, pathname] = uigetfile({'*.sac';'*.*'},'File Selector',...
%         params.data,'MultiSelect','on');
%     
%     [~,nnn]= size(fname);
%     if nnn==1 && fname==0
%         disp('No file selection made!')
%         set(text1, 'String', 'No file selection made!');
%         
%     else
%     if iscell(fname)
%         [~,np]= size(fname);
%         for ii=1:np
%             ff(ii,:)= [pathname,fname{ii}];
%             ff2(ii,:)= fname{ii};
%         end        
%     else
%         [np,~]= size(fname);
%         ff= [pathname,fname];
%         ff2= fname;
%     end
%     
%     pnum= 0;
%     do_calc
%     end
% end

function openfnc(~,~)   
    xy_data=[];
    sxy_data=[];
    textLabel = sprintf('File is opened');
    set(text1, 'String', textLabel);
    
    [fname, pathname] = uigetfile({'*.sac';'*.*'},'File Selector',...
        params.data,'MultiSelect','on');
    
    [~,nnn]= size(fname);
    if nnn==1 && fname==0
        disp('No file selection made!')
        set(text1, 'String', 'No file selection made!');
        
    else
        
        fname= cellstr(fname);
        [~,np]= size(fname);
        for ii=1:np
            ff{ii}= [pathname,fname{ii}];
            ff2{ii}= fname{ii};
        end
        
        pnum= 0;
        do_calc
    end
end


%================================
function do_calc
   pnum= pnum+1;
   
   if pnum<=0
       disp('That was the first selected file!');
       textLabel = sprintf('That was the first selected file!');
       set(text1, 'String', textLabel);
   elseif pnum<=np
       cla(axes1) 
       cla(axes3)       
       
        % selecting correct Bessel function zero crossings
        if strcmp(comp,'ZZ')==1
            zc= zz(:,1); 
            %     disp('Selected Component:   ZZ')
        elseif strcmp(comp,'RR')==1 || strcmp(comp,'TT')==1
            zc= zz(:,4); 
            %     disp('Selected Component:   TT or RR')
        elseif strcmp(comp,'ZR')==1 || strcmp(comp,'RZ')==1
            zc= zz(:,2); 
            %     disp('Selected Component:   RZ or ZR')
        end
        
        if strcmp(comp, 'TT')
            ref_disp= ref_disp_L;
        else
            ref_disp= ref_disp_R;
        end
       
       % average velocity
       if ~isempty(ref_disp)
           ind= intersect(find(ref_disp(:,1)>params.T1),find(ref_disp(:,1)<params.T2));
           C_ave= mean(ref_disp(ind,2));    
       else
           C_ave= 3.5;
       end
       
       
       filename= ff{pnum};
       if exist('strsplit')==2
           tmp= strsplit(ff2{pnum},'.sac');
       else
            tmp= strsplit_lin(ff2{pnum},'.sac');
       end
       titlename= tmp{1,1};
       [cc, head]= rdSac(filename);cc=cc'; 
       fprintf('\n\nPair name: %s\n',titlename)
       
       
       dist= head(51);
       
       if strcmp(comp,'RZ')==1
           cc= -cc;
       end
    
       [xy_data, sxy_data, sta, CC, prds,  maxp, z_non, c_non]= dispersion(cc, head, zc, ref_disp, titlename, dist, text1, C_ave);
       
       textLabel2 = sprintf('%d %s',maxp,'sec');
       set(text2, 'String', textLabel2);
       
       ploting(sta, dist, CC)
       
   else
       disp('Working on the selected files finished!');
       textLabel = sprintf('Working on the selected files finished!');
       set(text1, 'String', textLabel);
   end
    
end

%================================
function ploting(sta, D, CC)
    hold(axes2,'on')
    plot(axes2,[sta(1,2) sta(1,4)],[sta(1,1) sta(1,3)],'m','LineWidth',2)
    plot(axes2,[sta(1,2) sta(1,4)],[sta(1,1) sta(1,3)],'vr','MarkerFaceColor','r')
    
    if isempty(xy_data)== 0
        if strcmp(params.colorful,'yes')==1
            plot(axes1,1./z_non,c_non,'.')
        else
            plot(axes1,xy_data(:,1),xy_data(:,2),'b.');
        end
    
    
    hold(axes1,'on')
    title(axes1,[titlename,' - distance: ', sprintf('%4.2f',D), ' km'],'Interpreter','none');xlabel(axes1,'Periods');ylabel(axes1,'Velocity (km/s)')
    if ~isempty(ref_disp)
        plot(axes1,ref_disp(:,1), ref_disp(:,2), 'r-.');
    end
    if strcmp(params.automatic,'yes') && strcmp(params.ref, 'yes')        
        if isempty(sxy_data)==0            
            plot(axes1,sxy_data(:,1),sxy_data(:,2) , 'ro'); 
        else
            set(text1, 'String', 'Maybe the inter-station distance is too short !!!');
        end
    end
    
    set(axes1, 'Xlim',[params.T1 params.T2],'ylim', [params.vmin params.vmax])
    axes1.XTick= [.1 .2 .3 .4 .5 .6 .7 .8 .9 1 2 3 4 5 6 7 8 9 10 15 20 25 30 35 40 50 60 80 100 120]; 
    axes1.YTick= [1 1.2 1.5 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8 4 4.2 4.4 4.6 4.8 5 5.5 6]; 
    axes1.XGrid='on'; axes1.YGrid='on'; 
    set(axes1,'xScale',params.scale);
    h_select=plot(axes1,0,0);
    

        
   
    NFFT = length(CC);
    freq = linspace(0,1/params.dt,NFFT);
    hold(axes3,'on')
    plot(axes3,1./freq,real(CC(1:length(CC))) );
%     plot(axes3,1./freq,imag(CC(1:length(CC))), 'r' );
%     plot(axes3,1./freq,abs(CC(1:length(CC))), 'g' );
    set(axes3,'xScale',params.scale);
    set(axes3,'XTick',[.1 .2 .3 .4 .5 1 2 3 4 5 6 7 8 9 10 15 20 25 30 35 40 50 60 80 100 120], 'XTickLabel',[]);
    xlim(axes3,[params.T1 params.T2]); 
    axes3.XGrid='on'; axes3.YGrid='on'; 
    end
end


%================================
function radcbk(~,eventdata)
    
    comp = get(eventdata.NewValue,'String');   
    
end

%================================
function nextfnc(~,~)   
    disp('Next pair');
    textLabel = sprintf('Next pair');
    set(text1, 'String', textLabel);
    do_calc            
end

%================================
function prevfnc(~,~)   
    pnum= pnum-2;
    disp('Previous pair');
    textLabel = sprintf('Previous pair');
    set(text1, 'String', textLabel);
    do_calc    
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
function setpop(src,~)
    if src.Value==1
        set(f,'WindowButtonDownFcn', @none);
    elseif src.Value==2
        set(f,'WindowButtonDownFcn', @add_points);
    elseif src.Value==3
        set(f,'WindowButtonDownFcn', @rect);
    elseif src.Value==4
        set(f,'WindowButtonDownFcn', @delete_points);
    elseif src.Value==5
        set(f,'WindowButtonDownFcn', @del_rect);
    end
end

%================================
function none(~,~)
    disp('No Selection Made. Change the popup menu!');
    textLabel = sprintf('No Selection Made. Change the popup menu!');
    set(text1, 'String', textLabel);
end

%================================
function add_points(~,~)
    xdata=xy_data(:,1);
    ydata=xy_data(:,2);

    axissize = axis;
    % dx, dy to scale the distance
    dx = (axissize(2) - axissize(1));
    dy = (axissize(4) - axissize(3));

    cc = get(axes1,'CurrentPoint');
    xy = cc(1,1:2);

    [~,xselect,yselect] = closestpoint(xy,xdata,ydata,dx,dy);
    disp(['You selected     X: ',num2str(xselect),'     Y: ',num2str(yselect)]);
    textLabel = sprintf('You selected     X: %2.3f     Y: %2.3f', xselect, yselect);
    set(text1, 'String', textLabel);
    plot(xselect,yselect,'ro')
end

%================================
function rect(~,~)
    cc = get(axes1,'CurrentPoint');
    rectxy1 = cc(1,1:2);
    rectxy2 = rectxy1 + eps(rectxy1);

    % update the rect polygon of the box, changing the second corner
    xv = [rectxy1(1), rectxy2(1), rectxy2(1), rectxy1(1), rectxy1(1)];
    yv = [rectxy1(2), rectxy1(2), rectxy2(2), rectxy2(2), rectxy1(2)];
    
    selecthandle = fill(xv,yv,[.953 .961 .972],'facealpha',0.5, ...
          'linestyle','--','edgecolor','b');
    
      set(f,'WindowButtonMotionFcn', {@mdown, rectxy1, selecthandle});
      set(f,'WindowButtonUpFcn',{@mup, selecthandle, rectxy1});
%       uiwait(gcf); 

end

%================================
function mdown(~, ~, rectxy1, selecthandle)
    
    mousenew = get(axes1,'CurrentPoint');
    rectxy2 = mousenew(1,1:2);
    
    % update the rect polygon of the box, changing the second corner
    xv = [rectxy1(1), rectxy2(1), rectxy2(1), rectxy1(1), rectxy1(1)];
    yv = [rectxy1(2), rectxy1(2), rectxy2(2), rectxy2(2), rectxy1(2)];
    
    set(h_select,'xdata',[],'ydata',[])    
    pl = find(inpolygon(xy_data(:,1),xy_data(:,2),xv,yv));
    h_select=plot(xy_data(pl,1),xy_data(pl,2),'bo','MarkerFaceColor','r');
      
    set(selecthandle,'xdata',xv,'ydata',yv)    
 end

%================================
function mup(~, ~, selecthandle, rectxy1)
    set(f,'WindowButtonMotionFcn',[]);
    set(f,'WindowButtonUpFcn',[]);
    
    mousenew = get(axes1,'CurrentPoint');
    rectxy2 = mousenew(1,1:2);
    
    % update the rect polygon of the box, changing the second corner
    xv = [rectxy1(1), rectxy2(1), rectxy2(1), rectxy1(1), rectxy1(1)];
    yv = [rectxy1(2), rectxy1(2), rectxy2(2), rectxy2(2), rectxy1(2)];
    
    pl = find(inpolygon(xy_data(:,1),xy_data(:,2),xv,yv));    
    if isempty(pl)~=1
        plot(xy_data(pl,1),xy_data(pl,2),'ro')
        
        dd=zeros(length(pl),2);
        aa(:,1)= xy_data(pl,1);
        aa(:,2)= xy_data(pl,2);

        cc=0;
        for i=1:length(pl)
            for j=1:2
                cc=cc+1;
                bb(cc,1)= aa(i,j);
            end
        end
        dd(:,1)= bb(1:length(pl));
        dd(:,2)= bb(length(pl)+1:2*length(pl));
        
        fprintf('You selected     X: %2.3f      Y: %2.3f\n',dd(:,1),dd(:,2));
        textLabel = sprintf('You selected     X: %2.3f     Y: %2.3f \n',dd(:,1),dd(:,2));
        set(text1, 'String', textLabel);
    end
    
    set(selecthandle,'xdata',[],'ydata',[]) 
    set(h_select,'xdata',[],'ydata',[])        
end

%================================
function delete_points(~, ~)
    handle = findobj(gcf,'Type','Line','Color','red','Marker','o');
    [sz,~]=size(get(handle));

    a=[];b=[];
    for i=1:sz
        a=[a get(handle(i),'XData')];
        b=[b get(handle(i),'YData')];
    end
    xdata= a;
    ydata= b;


    axissize = axis;
    % dx, dy to scale the distance
    dx = (axissize(2) - axissize(1));
    dy = (axissize(4) - axissize(3));

    cc = get(axes1,'CurrentPoint');
    xy = cc(1,1:2);
    [~,xselect,yselect] = closestpoint(xy,xdata,ydata,dx,dy);
    disp(['You deleted      X: ',num2str(xselect),'     Y: ',num2str(yselect)]);
    textLabel = sprintf('You delected     X: %2.3f     Y: %2.3f', xselect, yselect);
    set(text1, 'String', textLabel);
    plot(xselect,yselect,'kx','LineWidth',3,'MarkerSize',8)
end

%================================
function del_rect(~,~)
    % find objects which are red circles
    handle = findobj(gcf,'Type','Line','Color','red','Marker','o');
    [sz,~]=size(get(handle));

    a=[];b=[];
    for i=1:sz
        a=[a get(handle(i),'XData')];
        b=[b get(handle(i),'YData')];
    end
    ddata(1,:)= a;
    ddata(2,:)= b;
    
    % delete mis-selected red circles
    ddata(:,isnan(ddata(2,:)))=[];
    
    ddata= ddata';
    %-----------------------------
    
    cc = get(axes1,'CurrentPoint');
    rectxy1 = cc(1,1:2);
    rectxy2 = rectxy1 + eps(rectxy1);

    % update the rect polygon of the box, changing the second corner
    xv = [rectxy1(1), rectxy2(1), rectxy2(1), rectxy1(1), rectxy1(1)];
    yv = [rectxy1(2), rectxy1(2), rectxy2(2), rectxy2(2), rectxy1(2)];
    
    selecthandle = fill(xv,yv,[.953 .961 .972],'facealpha',0.5, ...
          'linestyle','--','edgecolor','k');
    
      set(f,'WindowButtonMotionFcn', {@dmdown, rectxy1, selecthandle, ddata});
      set(f,'WindowButtonUpFcn',{@dmup, selecthandle, rectxy1, ddata});
%       uiwait(gcf); 

end

%================================
function dmdown(~, ~, rectxy1, selecthandle, ddata)
    
    mousenew = get(axes1,'CurrentPoint');
    rectxy2 = mousenew(1,1:2);
    
    % update the rect polygon of the box, changing the second corner
    xv = [rectxy1(1), rectxy2(1), rectxy2(1), rectxy1(1), rectxy1(1)];
    yv = [rectxy1(2), rectxy1(2), rectxy2(2), rectxy2(2), rectxy1(2)];
    
    set(h_select,'xdata',[],'ydata',[])    
    pl = find(inpolygon(ddata(:,1),ddata(:,2),xv,yv));
    h_select=plot(ddata(pl,1),ddata(pl,2),'bo','MarkerFaceColor','k');
      
    set(selecthandle,'xdata',xv,'ydata',yv)    
 end

%================================
function dmup(~, ~, selecthandle, rectxy1, ddata)
    set(f,'WindowButtonMotionFcn',[]);
    set(f,'WindowButtonUpFcn',[]);
    
         
    mousenew = get(axes1,'CurrentPoint');
    rectxy2 = mousenew(1,1:2);
    
    % update the rect polygon of the box, changing the second corner
    xv = [rectxy1(1), rectxy2(1), rectxy2(1), rectxy1(1), rectxy1(1)];
    yv = [rectxy1(2), rectxy1(2), rectxy2(2), rectxy2(2), rectxy1(2)];
    
    pl = find(inpolygon(ddata(:,1),ddata(:,2),xv,yv));    
    if isempty(pl)~=1
        plot(ddata(pl,1),ddata(pl,2),'kx','LineWidth',3,'MarkerSize',8)
        
        dd=zeros(length(pl),2);
        aa(:,1)= ddata(pl,1);
        aa(:,2)= ddata(pl,2);

        cc=0;
        for i=1:length(pl)
            for j=1:2
                cc=cc+1;
                bb(cc,1)= aa(i,j);
            end
        end
        dd(:,1)= bb(1:length(pl));
        dd(:,2)= bb(length(pl)+1:2*length(pl));
        
        fprintf('You deleted     X: %2.3f      Y: %2.3f\n',dd(:,1),dd(:,2));
        textLabel = sprintf('You deleted     X: %2.3f     Y: %2.3f \n',dd(:,1),dd(:,2));
        set(text1, 'String', textLabel);
    end
    
    set(selecthandle,'xdata',[],'ydata',[]) 
    set(h_select,'xdata',[],'ydata',[])        
end


%================================
function logscale(h, ~)
    if (get(h,'Value') == get(h,'Max'))
        display('Logarithmic axis chosen');
        set(text1, 'String', 'Logarithmic axis chosen');
        set(axes1,'xScale','log');
        set(axes3,'xScale','log');
    else
        display('Linear axis chosen');
        set(text1, 'String', 'Linear axis chosen');
        set(axes1,'xScale','linear');
        set(axes3,'xScale','linear');
    end
end

%================================
function donefnc(~, ~)
    if isempty(get(axes1, 'Children'))==0    % if axes1 contains anything
        
    %------ finds all red o mark and its uniqueness
    handle = findobj(axes1,'Type','Line','Color','red','Marker','o');
    [sz1,~]=size(get(handle));
    
    
    a=[];b=[];
    for i=1:sz1
        a=[a get(handle(i),'XData')];
        b=[b get(handle(i),'YData')];
    end
    tt(1,:)= a;
    tt(2,:)= b;
    
    % delete mis-selected red circles
    tt(:,isnan(tt(2,:)))=[];
    
    % select unique values
    C = unique(tt','rows');
    temp=C';

    %------ delete points with black x mark
    handle2 = findobj(axes1,'Type','Line','Color','black','Marker','x');
    [sz2,~]=size(get(handle2));
    
    if sz2>0
        a=[];b=[];
        for i=1:sz2
            a=[a get(handle2(i),'XData')];
            b=[b get(handle2(i),'YData')];
        end
        
        sza= length(a);
        szb= length(b);
        
        for i=1:max(sza,szb)
            c1= find(a(i)==temp(1,:));
            c2= find(b(i)==temp(2,:));            
            ints= intersect(c1,c2);  
            temp(:,ints)=[];            
        end
    
    end
    
    %-------- check the uniqueness
    a= temp(1,:);
    dsa=diff(sort(a));
    repeated= a(dsa==0);
    
    if isempty(repeated)==0
        fprintf('\n\n');
        disp('There is(are) double selection(s) in period(s).')
        disp('The dispersion curve is not saved.')
        fprintf('Repetition happened at: %2.3f \n',repeated);
        
        textLabel = sprintf('Not saved. Double velocity in period(s). Repetition happened at: %2.3f\n', repeated);
        set(text1, 'String', textLabel);
        
        uiwait

    else
        Sdisp= temp';
        
        % interpolation at specified periods
        Tint= T( intersect(find(T>Sdisp(1,1)), find(T<Sdisp(end,1))) );
        Cint= interp1(Sdisp(:,1),  Sdisp(:,2), Tint, 'linear');
        Intdisp(:,1)= Tint;
        Intdisp(:,2)= Cint;
        
        nn=[params.save,filesep,titlename,'.mat'];            
        save(nn,'Sdisp','Intdisp','prds','sta','dist')    

%             nnxls=[params.save,filesep,titlename,'.xlsx'];
%             xlswrite(nnxls,Sdisp)

        if strcmp(params.outputformat,'txt')==1            
            txtresult= nan(max([length(Sdisp);length(Intdisp);length(prds)]),10);
            for i=1:length(Sdisp)
                txtresult(i,1)=  Sdisp(i,1);
                txtresult(i,2)=  Sdisp(i,2);
            end
            for i=1:length(Intdisp)
                txtresult(i,3)=  Intdisp(i,1);
                txtresult(i,4)=  Intdisp(i,2);
            end
            prds2= flipud(prds);
            for i=1:length(prds)
                txtresult(i,5)=  prds2(i,1);
            end
            txtresult(1,6)= sta(1); txtresult(1,7)= sta(2); txtresult(1,8)= sta(3); txtresult(1,9)= sta(4);
            txtresult(1,10)= dist;
            
            nn2=[params.save,filesep,titlename,'.txt'];
            dlmwrite(nn2,txtresult,'precision','%.2f','delimiter','\t');
        end


        disp('Despersion is saved')
        textLabel = sprintf('Despersion is saved');
        set(text1, 'String', textLabel);

        uiresume
    end
    
    end  % if axes1 contains anything
    
    do_calc
    
    
end     % end of done_fnc



%================================
function pr(~,~)
    h.Fig3= figure('name','Print Options','NumberTitle','off','units','normalized',...
        'menubar','non','color',panel_color);
    
% static texts
uicontrol(h.Fig3,'Style','text', 'String','Print to File',...
    'HorizontalAlignment','left','Fontweight','bold',...
    'Units','normalized','Position',[.05 .88 .4 .05],...
    'BackgroundColor',panel_color);

uicontrol(h.Fig3,'Style','text', 'String','Plot Title',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.08 .74 .2 .08],...
    'BackgroundColor',panel_color);

uicontrol(h.Fig3,'Style','text', 'String','Format',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.08 .55 .2 .08],...
    'BackgroundColor',panel_color);

uicontrol(h.Fig3,'Style','text', 'String','Resolution',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.5 .55 .2 .08],...
    'BackgroundColor',panel_color);

uicontrol(h.Fig3,'Style','text', 'String','File Name',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.08 .18 .2 .08],...
    'BackgroundColor',panel_color);



% uicontrols
h.title= uicontrol(h.Fig3,'Style','edit', 'String','',...
    'HorizontalAlignment','left','Tag','',...
    'Units','normalized','Position',[.2 .76 .5 .07],...
    'BackgroundColor','w','callback',@pltitle);


h.format= uicontrol(h.Fig3,'Style','popup', ...
    'String',{'png','jpeg','tiff','bmp','pdf','eps','ps'},'Value',1,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.2 .6 .1 .04],...
    'BackgroundColor','w');    

h.res= uicontrol(h.Fig3,'Style','popup', ...
    'String',{'100','200','300','400','500','600'},'Value',3,...
    'HorizontalAlignment','left','Enable','on',...
    'Units','normalized','Position',[.68 .6 .1 .04],...
    'BackgroundColor','w');    

h.ax2= uicontrol(h.Fig3,'Style','checkbox','BackgroundColor', panel_color,...
                'String','Include the frequency axis','units','normalized',...
                'Value',1,'Position',[.08 .4 .4 .03]);

h.savename= uicontrol(h.Fig3,'Style','edit', 'String','',...
    'HorizontalAlignment','left',...
    'Units','normalized','Position',[.2 .2 .5 .07],...
    'BackgroundColor','w');

h.icon= uicontrol(h.Fig3,'Style','pushbutton', 'String','',...
    'Cdata',icons.file,'Tag','',...
    'Units','normalized','Position',[.72 .2 .04 .07],...
    'callback',@file_cbk);
                
h.pr= uicontrol(h.Fig3,'Style','pushbutton', 'String','',...
    'Cdata',icons.print,'Tag','',...
    'Units','normalized','Position',[.84 .04 .12 .17],...
    'callback',@pr2);
    
    
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
function pr2(~,~)

    Fig2 = figure('visible','off');
    if (get(h.ax2,'Value') == get(h.ax2,'Max'))
        ax= copyobj([axes1,axes3], Fig2);  
        set(ax(1,1),'Position',[0.100 0.3700 0.82 0.5550])
        set(ax(2,1),'Position',[0.100 0.1100 0.82 0.1750])
    else
        ax= copyobj(axes1, Fig2);  
        set(ax(1,1),'Position',[0.100 0.1100 0.82 0.8150])
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
    
    close (h.Fig3)
    
end



end     % end of main function


%% 
%======================================
% Subfunctions
%======================================
function [ref_disp, zz, icons]= rddata(d, reference, format, delimval)
    load('Bessel_zeros.mat')
    load('icons.mat')

    if strcmp(reference, 'yes')    
        if ~isempty(d)
            if strcmp(format, '.mat')
                ref_disp =importdata(d);
            elseif strcmp(format, 'Excel')
                ref_disp =xlsread(d);
            elseif strcmp(format, 'txt')
                tmp= {'\t',' ',',','-',';'};
                delim= tmp(delimval);       
                ref_disp =importdata(d, char(delim), 0);            
            end
        else
            ref_disp=[];
        end
        
    else
        ref_disp= [];
    end

end



