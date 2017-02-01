function [pointslist,xselect,yselect] = closestpoint(xy,xdata,ydata,dx,dy)
  % find the single closest point to xy, in scaled units
  D = sqrt(((xdata - xy(1))/dx).^2 + ((ydata - xy(2))/dy).^2);
  [dd,pointslist] = min(D(:));
  if dd<.02
      xselect = xdata(pointslist);
      yselect = ydata(pointslist);
  else
      pointslist=[];
      xselect=[];
      yselect=[];
  end

end 