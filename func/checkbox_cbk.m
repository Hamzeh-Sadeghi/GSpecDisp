function checkbox_cbk(hobj,~)

global h2

switch get(hobj,'Tag')
case 'vtaper'
   if get(h2.vtaper,'Value') 
       set(h2.vt_inter,'Enable','on');
   else
       set(h2.vt_inter,'Enable','off');
   end
   
   
   
%----------
case 'automatic'
    if get(h2.automatic,'Value') 
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
   else
       set(h2.maxdev,'Enable','off');
       set(h2.cycle,'Enable','off');
       set(h2.energy,'Enable','off');
       set(h2.slope(:),'Enable','off');
       set(h2.anchor,'Enable','off');
       set(h2.pr1,'Enable','off');
       set(h2.pr2,'Enable','off');
   end
    
    
    
%----------
case 'anchor'
    if get(h2.anchor,'Value') 
       set(h2.slope(4:8),'Enable','on');
       set(h2.pr1,'Enable','on');
       set(h2.pr2,'Enable','on');
    else       
       set(h2.slope(4:8),'Enable','off');
       set(h2.pr1,'Enable','off');
       set(h2.pr2,'Enable','off');
   end
    
    
%----------
case 'ref'
    if get(h2.ref,'Value') 
        set(h2.radio(7:9),'Enable','on');
        set(h2.Rayleigh_ave,'Enable','on');
        set(h2.Love_ave,'Enable','on');
        set(h2.icon(3:4),'Enable','on');
        set(h2.delim,'Enable','on');
    else
        set(h2.radio(7:9),'Enable','off');
        set(h2.Rayleigh_ave,'Enable','off');
        set(h2.Love_ave,'Enable','off');
        set(h2.icon(3:4),'Enable','off');
        set(h2.delim,'Enable','off');
    end
    
    
%---------
case 'vtaper2'
   if get(h2.vtaper2,'Value') 
       set(h2.vt_inter2,'Enable','on');
   else
       set(h2.vt_inter2,'Enable','off');
   end
    
%---------
case 'SNRflag'
   if get(h2.SNRflag,'Value') 
       set(h2.SNR,'Enable','on');
       set (h2.Nwin1,'Enable','on');
       set (h2.Nwin2,'Enable','on');
   else
       set(h2.SNR,'Enable','off');
       set (h2.Nwin1,'Enable','off');
       set (h2.Nwin2,'Enable','off');
   end
   
   
    
    
end
end