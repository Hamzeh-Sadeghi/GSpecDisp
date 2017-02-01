function save_cbk(hobj,~)

global params h2

switch get(hobj,'Tag')
case 'save1'  
    params.lat1= str2num( get(h2.lat1,'string'));
    params.lon1= str2num( get(h2.lon1,'string'));
    params.lat2= str2num( get(h2.lat2,'string'));
    params.lon2= str2num( get(h2.lon2,'string'));
    
    params.map= get(h2.map,'string');
    

    params.data= get(h2.data,'string');
    params.save= get(h2.save,'string');
    
    tmp= get(h2.radiobutton(5),'selectedobject');    
    params.outputformat= tmp.String;    

    save('./defaults/user_values.mat','params');
    
    
    
    
    
    
    
case 'save2'  
    tmp= get(h2.radiobutton(2),'selectedobject');    
    params.component= tmp.String;

    params.tmin= str2num( get(h2.tmin,'string'));
    params.tmax= str2num( get(h2.tmax,'string'));
    params.dt= str2num( get(h2.dt,'string'));
    
    if get(h2.vtaper,'Value')==1
        params.vtaper= 'yes';
    elseif get(h2.vtaper,'Value')==0
        params.vtaper= 'no';
    end        
    params.vt_inter= str2num( get(h2.vt_inter,'string') );
    if get(h2.white,'Value')==1
        params.white= 'yes';
    elseif get(h2.white,'Value')==0
        params.white= 'no';
    end            

    save('./defaults/user_values.mat','params');
    
    
    
    
    
    
    
case 'save3'  
    if get(h2.automatic,'Value')==1
        params.automatic= 'yes';
    elseif get(h2.automatic,'Value')==0
        params.automatic= 'no';
    end
    params.maxdev= str2num( get(h2.maxdev,'string'));
    params.cycle= str2num( get(h2.cycle,'string'));
    params.energy= str2num( get(h2.energy,'string'));

    if get(h2.anchor,'Value')==1
        params.anchor= 'yes';
    elseif get(h2.anchor,'Value')==0
        params.anchor= 'no';
    end
    params.pr1= str2num( get(h2.pr1,'string') );
    params.pr2= str2num( get(h2.pr2,'string') );

    tmp={str2num( get(h2.slope(1),'string')); str2num( get(h2.slope(2),'string')); str2num( get(h2.slope(3),'string'));...
        str2num( get(h2.slope(4),'string')); str2num( get(h2.slope(5),'string')); str2num( get(h2.slope(6),'string')); ...
        str2num( get(h2.slope(7),'string')); str2num( get(h2.slope(8),'string'))}';
    
    params.slope= tmp;

    
    save('./defaults/user_values.mat','params');
    
    
    
    
    
    
    
case 'save4'  
    if get(h2.ref,'Value')==1
        params.ref= 'yes';
    elseif get(h2.ref,'Value')==0
        params.ref= 'no';
    end
    tmp= get(h2.radiobutton(3),'selectedobject');    
    params.format= tmp.String;    
    params.delim= get(h2.delim,'Value');

    params.Rayleigh_ave= get(h2.Rayleigh_ave,'string');
    params.Love_ave=     get(h2.Love_ave,'string');

    tmp= get(h2.radiobutton(4),'selectedobject');    
    params.component2= tmp.String;    

    params.Cmin= str2num( get(h2.Cmin,'string') );
    params.Cmax= str2num( get(h2.Cmax,'string') );
    params.dC= str2num( get(h2.dC,'string') );
    params.norm= str2num( get(h2.norm,'string') );

    if get(h2.vtaper2,'Value')==1
        params.vtaper2= 'yes';
    elseif get(h2.vtaper2,'Value')==0
        params.vtaper2= 'no';
    end            
    params.vt_inter2= str2num( get(h2.vt_inter2,'string') );
    params.periods= str2num( get(h2.periods,'string') );


    save('./defaults/user_values.mat','params');
    
    
    
    
    
    
case 'save5'  
    params.vmin= str2num( get(h2.vmin,'string'));
    params.vmax= str2num( get(h2.vmax,'string'));
    params.T1= str2num( get(h2.T1,'string'));
    params.T2= str2num( get(h2.T2,'string'));

    tmp= get(h2.radiobutton(1),'selectedobject');
    params.scale= tmp.String;
    
    params.rlambda= str2num( get(h2.rlambda,'string'));

   params.measureperiods= str2num( get(h2.measureperiods,'string') );

    
    if get(h2.SNRflag,'Value')==1
        params.SNRflag= 'yes';
    elseif get(h2.SNRflag,'Value')==0
        params.SNRflag= 'no';
    end          
    params.SNR= str2num( get(h2.SNR,'string'));
    params.Nwin1= str2num( get(h2.Nwin1,'string'));
    params.Nwin2= str2num( get(h2.Nwin2,'string'));


    if get(h2.colorful,'Value')==1
        params.colorful= 'yes';
    elseif get(h2.colorful,'Value')==0
        params.colorful= 'no';
    end          
    

    
    save('./defaults/user_values.mat','params');

    
    
    
    
end


end