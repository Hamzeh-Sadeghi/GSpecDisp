function folder_cbk(hobj,~)

global h2

switch get(hobj,'Tag')
case 'data_folder'      
    tmp= uigetdir(get(h2.data,'String'));
    if tmp~=0
        set(h2.data,'String',tmp)
    end    
    
    
%----------
case 'save_folder'      
    tmp= uigetdir(get(h2.save,'String'));
    if tmp~=0
        set(h2.save,'String',tmp)
    end    
   
%----------
case 'Rayleigh_file'
    [filename, pathname] = uigetfile( ...
        {'*.mat;*.xlsx;*.xls;*.txt;*.dat','Data Files (*.mat, *.xlsx, *.xls, *.txt, *.dat)';...
        '*.*',  'All Files (*.*)'}, 'Pick a file',get(h2.Rayleigh_ave,'String'));
    if filename~=0
        set(h2.Rayleigh_ave,'String',[pathname,filename])
    end    
    
%----------
case 'Love_file'  
    [filename, pathname] = uigetfile( ...
        {'*.mat;*.xlsx;*.xls;*.txt;*.dat','Data Files (*.mat, *.xlsx, *.xls, *.txt, *.dat)';...
        '*.*',  'All Files (*.*)'}, 'Pick a file',get(h2.Love_ave,'String'));
    if filename~=0
        set(h2.Love_ave,'String',[pathname,filename])
    end    
    
%----------
case 'map'
    [filename, pathname] = uigetfile( ...
        {'*.mat;*.xlsx;*.xls;*.txt;*.dat','Data Files (*.mat, *.xlsx, *.xls, *.txt, *.dat)';...
        '*.*',  'All Files (*.*)'}, 'Pick a file',get(h2.map,'String'));
    if filename~=0
        set(h2.map,'String',[pathname,filename])
    end    

    
    
end
end
