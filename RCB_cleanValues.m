% This function will take in what we plan on plotting as plotX and plotY,
% and filter out some of the data that seems as if it doesn't belong.

function [cleanPlotX, cleanPlotY] = RCB_cleanValues(plotX, plotY, plotMode, plotPrecision)
    diffPlotX = abs(diff(plotX));
    diffPlotY = abs(diff(plotY));
    
    % Experimental precision factor (I don't know if it actually works)
    if(plotPrecision)
        diffPlotX(length(diffPlotX) + 1) = 0;
        diffPlotY(length(diffPlotY) + 1) = 0;

        diffPlotX = abs(diff(diffPlotX));
        diffPlotY = abs(diff(diffPlotY));
    end
    cleanPlotX = [];
    cleanPlotY = [];
    
    varX = 0;
    varY = 0;
    
    switch(plotMode)
        case 0
            varX = 10;
            varY = 0.1;
        case 1
            varX = 10;
            varY = 0.1;
        case 2
            varX = 100;
            varY = 100;
        case 3
            varX = 100;
            varY = 100;
        case 4
            varX = 10;
            varY = 0.1;            
    end
    
    for i = 1:length(diffPlotX)
       if(diffPlotX(i) < varX && diffPlotY(i) < varY)
          cleanPlotX(length(cleanPlotX) + 1) = plotX(i); 
          cleanPlotY(length(cleanPlotY) + 1) = plotY(i); 
       end
    end


end
