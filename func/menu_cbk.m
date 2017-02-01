function menu_cbk(~,eventdata)

old = get(eventdata.OldValue,'Userdata');
new = get(eventdata.NewValue,'Userdata');

set (old, 'visible', 'off')
set (new, 'visible', 'on')

end