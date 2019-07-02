function prefixes = RCB_getFiles(plotHP, plotVP, plotHPVP, plotST, plotStatistics)
    prefixes = strings(0);

    % Loads the prefixes variables based on which options we wish to plot.
    if(plotHP)
       prefixes(length(prefixes) + 1) = "HP";
    end
    
    if(plotVP)
       prefixes(length(prefixes) + 1) = "VP";
    end
    
    if(plotST)
       prefixes(length(prefixes) + 1) = "ST";
    end
    
    if(plotHPVP)
       prefixes(length(prefixes) + 1) = "HPVP";
    end
    
    if(plotStatistics)
       prefixes(length(prefixes) + 1) = "CTRL"; 
    end
    
end

