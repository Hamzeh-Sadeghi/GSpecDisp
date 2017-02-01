function default_cbk(hobj,~)

global h2

tmp= load('default_values.mat','params');

switch get(hobj,'Tag')
case 'default1'
    set(h2.lat1,'string',tmp.params.lat1);
    set(h2.lon1,'string',tmp.params.lon1);
    set(h2.lat2,'string',tmp.params.lat2);
    set(h2.lon2,'string',tmp.params.lon2);
    set(h2.map,'string',tmp.params.map);

    set(h2.data,'string',tmp.params.data);
    set(h2.save,'string',tmp.params.save);
        
    if strcmp(tmp.params.outputformat,'.mat')==1
        set(h2.radiobutton(5),'selectedobject',h2.radio(14));     
    elseif strcmp(tmp.params.outputformat,'txt')==1
        set(h2.radiobutton(5),'selectedobject',h2.radio(15));    
    end  
    
    
    
case 'default2'
    if strcmp(tmp.params.component,'ZZ')==1
        set(h2.radiobutton(2),'selectedobject',h2.radio(3)); 
    elseif strcmp(tmp.params.component,'ZR')==1
        set(h2.radiobutton(2),'selectedobject',h2.radio(4));
    elseif strcmp(tmp.params.component,'RR')==1
        set(h2.radiobutton(2),'selectedobject',h2.radio(5));
    elseif strcmp(tmp.params.component,'TT')==1
        set(h2.radiobutton(2),'selectedobject',h2.radio(6));
    elseif strcmp(tmp.params.component,'RZ')==1
        set(h2.radiobutton(2),'selectedobject',h2.radio(16));    
    end     

    set(h2.tmin,'string',tmp.params.tmin);
    set(h2.tmax,'string',tmp.params.tmax);
    set(h2.dt,'string',tmp.params.dt);
    
    
    if strcmp(tmp.params.vtaper,'yes')==1
        set(h2.vtaper,'Value',1);      
        set(h2.vt_inter,'Enable','on');
    elseif strcmp(tmp.params.vtaper,'no')==1
        set(h2.vtaper,'Value',0);
        set(h2.vt_inter,'Enable','off');
    end      
    set(h2.vt_inter,'string',tmp.params.vt_inter);    
    if strcmp(tmp.params.white,'yes')==1
        set(h2.white,'Value',1);        
    elseif strcmp(tmp.params.white,'no')==1
        set(h2.white,'Value',0);
    end              
    
  
    
    
    
case 'default3'
    if strcmp(tmp.params.automatic,'yes')==1
        set(h2.automatic,'Value',1);    
        set(h2.maxdev,'Enable','on');
        set(h2.cycle,'Enable','on');
        set(h2.energy,'Enable','on');
        set(h2.slope(1:3),'Enable','on');
        set(h2.anchor,'Enable','on');
        if get(h2.anchor,'Value') 
           set(h2.slope(4:8),'Enable','on');           
           set(h2.pr1,'Enable','on');
           set(h2.pr2,'Enable','on');
        end
    elseif strcmp(tmp.params.automatic,'no')==1
        set(h2.automatic,'Value',0);
        set(h2.maxdev,'Enable','off');
        set(h2.cycle,'Enable','off');
        set(h2.energy,'Enable','off');
        set(h2.slope(:),'Enable','off');
        set(h2.anchor,'Enable','off');
        set(h2.pr1,'Enable','off');
        set(h2.pr2,'Enable','off');
    end      
    set(h2.maxdev,'string',tmp.params.maxdev);
    set(h2.cycle,'string',tmp.params.cycle);
    set(h2.energy,'string',tmp.params.energy);
    

    if strcmp(tmp.params.anchor,'yes')==1
        set(h2.anchor,'Value',1);        
        set(h2.slope(4:8),'Enable','on');           
        set(h2.pr1,'Enable','on');
        set(h2.pr2,'Enable','on');
    elseif strcmp(tmp.params.anchor,'no')==1
        set(h2.anchor,'Value',0);
        set(h2.slope(4:8),'Enable','off');           
        set(h2.pr1,'Enable','off');
        set(h2.pr2,'Enable','off');
    end
    
    set(h2.pr1,'string',tmp.params.pr1);
    set(h2.pr2,'string',tmp.params.pr2);


    set(h2.slope(1),'string',tmp.params.slope{1});
    set(h2.slope(2),'string',tmp.params.slope{2});
    set(h2.slope(3),'string',tmp.params.slope{3});
    set(h2.slope(4),'string',tmp.params.slope{4});
    set(h2.slope(5),'string',tmp.params.slope{5});
    set(h2.slope(6),'string',tmp.params.slope{6});
    set(h2.slope(7),'string',tmp.params.slope{7});
    set(h2.slope(8),'string',tmp.params.slope{8});
    


    
case 'default4'
    if strcmp(tmp.params.ref,'yes')==1
        set(h2.ref,'Value',1);        
        set(h2.radio(7:9),'Enable','on');
        set(h2.Rayleigh_ave,'Enable','on');
        set(h2.Love_ave,'Enable','on');
        set(h2.icon(3:4),'Enable','on');
        set(h2.delim,'Enable','on');
    elseif strcmp(tmp.params.ref,'no')==1
        set(h2.ref,'Value',0);
        set(h2.radio(7:9),'Enable','off');
        set(h2.Rayleigh_ave,'Enable','off');
        set(h2.Love_ave,'Enable','off');
        set(h2.icon(3:4),'Enable','off');
        set(h2.delim,'Enable','off');
    end
    
    if strcmp(tmp.params.format,'.mat')==1
        set(h2.radiobutton(3),'selectedobject',h2.radio(7)); 
    elseif strcmp(tmp.params.format,'Excel')==1
        set(h2.radiobutton(3),'selectedobject',h2.radio(8));
    elseif strcmp(tmp.params.format,'txt')==1
        set(h2.radiobutton(3),'selectedobject',h2.radio(9));    
    end     
    
    set(h2.delim,'Value',tmp.params.delim);
    
    set(h2.Rayleigh_ave,'string',tmp.params.Rayleigh_ave);
    set(h2.Love_ave,'string',tmp.params.Love_ave);
    

    if strcmp(tmp.params.component2,'ZZ')==1
        set(h2.radiobutton(4),'selectedobject',h2.radio(10)); 
    elseif strcmp(tmp.params.component2,'ZR')==1
        set(h2.radiobutton(4),'selectedobject',h2.radio(11));
    elseif strcmp(tmp.params.component2,'RR')==1
        set(h2.radiobutton(4),'selectedobject',h2.radio(12));
    elseif strcmp(tmp.params.component2,'TT')==1
        set(h2.radiobutton(4),'selectedobject',h2.radio(13));
    elseif strcmp(tmp.params.component2,'RZ')==1
        set(h2.radiobutton(4),'selectedobject',h2.radio(17));
    end     
    
    set(h2.Cmin,'string',tmp.params.Cmin);
    set(h2.Cmax,'string',tmp.params.Cmax);
    set(h2.dC,'string',tmp.params.dC);
    set(h2.norm,'string',tmp.params.norm);

    
    if strcmp(tmp.params.vtaper2,'yes')==1
        set(h2.vtaper2,'Value',1);    
        set(h2.vt_inter2,'Enable','on');
    elseif strcmp(tmp.params.vtaper2,'no')==1
        set(h2.vtaper2,'Value',0);
        set(h2.vt_inter2,'Enable','off');
    end
             
    set(h2.vt_inter2,'string',tmp.params.vt_inter2);
    set(h2.periods,'string',tmp.params.periods);

       
 
    
    
case 'default5'
    set(h2.vmin,'string',tmp.params.vmin)
    set(h2.vmax,'string',tmp.params.vmax);
    set(h2.T1,'string',tmp.params.T1);
    set(h2.T2,'string',tmp.params.T2);

    if strcmp(tmp.params.scale,'Log')==1
        set(h2.radiobutton(1),'selectedobject',h2.radio(1)); 
    else
        set(h2.radiobutton(1),'selectedobject',h2.radio(2));
    end
    
    set(h2.rlambda,'string',tmp.params.rlambda);
    
    set(h2.measureperiods,'string',tmp.params.measureperiods);

    
    if strcmp(tmp.params.SNRflag,'yes')==1
        set(h2.SNRflag,'Value',1);  
        set(h2.SNR,'Enable','on');
        set(h2.Nwin1,'Enable','on');
        set(h2.Nwin2,'Enable','on');
    elseif strcmp(tmp.params.vtaper2,'no')==1
        set(h2.SNRflag,'Value',0);
        set(h2.SNR,'Enable','off');
        set(h2.Nwin1,'Enable','off');
        set(h2.Nwin2,'Enable','off');
    end
    set(h2.SNR,'string',tmp.params.SNR);
    set(h2.Nwin1,'string',tmp.params.Nwin1);
    set(h2.Nwin2,'string',tmp.params.Nwin2);
    
    
    if strcmp(tmp.params.colorful,'yes')==1
        set(h2.colorful,'Value',1);          
    elseif strcmp(tmp.params.colorful,'no')==1
        set(h2.colorful,'Value',0);        
    end
    
    
    
    
end
% params
end