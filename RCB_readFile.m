% This function opens the .csv given and returns what we will eventually
% plot.

function [plotX, plotY] = RCB_readFile(filename, plotMode, plotTare)

    plotStart = 0;
    plotEnd = 0;
    plotValsFound = 0;
    
    plotTime = 0;
    
    plotX = [];
    plotY = [];
    
    vals = csvread(filename,2);
    
    % Calls another function to the averageTare that we should subtract
    % from all our Thrust values as a correction factor.
    if(plotTare)
        averageTare = RCB_getTare(vals);
    end       
    cropCol = vals(:, 14);
    
    
    % We are searching over all the vals from the file, and checking for
    % when we find the last reading of 0 RPM before data starts occurring,
    % and then we find the first 0 RPM after we started recording actual
    % RPM values. We then crop out everything not inside the range of the 2
    % 0 RPM readings already mentioned.
    
    for i = 1:length(vals)
        if(cropCol(i) ~= 0)
            plotValsFound = 1;
            if(plotStart == 0)
                plotTime = vals(i, 1);
                plotStart = i;
            end
        else
            if(plotValsFound)
                if(plotEnd == 0)
                    plotEnd = i;
                end
            end            
        end
        
    end
    
    cropVals = vals(plotStart:plotEnd, :);

    switch(plotMode) 
        
        % In this case we will be plotting Thrust vs Omega^2
        case 0
            for i = 1:length(cropVals(:, 10))
                if(cropVals(i, 10) > 0.2 && cropVals(i, 14) > 5000)
                    plotX(length(plotX) + 1) = cropVals(i, 14);
                    plotY(length(plotY) + 1) = cropVals(i, 10); 
                end
            end
            
            if(plotTare)
                plotY = plotY - averageTare;
            end
            plotX = (plotX ./(120 * pi)).^2;
            
        % In this case we will be plotting Thrust vs Time    
        case 1
            
            for i = 1:length(cropVals(:, 10))
                if(cropVals(i, 10) > 0.2)
                    plotX(length(plotX) + 1) = cropVals(i, 1);
                    plotY(length(plotY) + 1) = cropVals(i, 10); 
                end
            end
            if(plotTare)
                plotY = plotY - averageTare;
            end
            
            plotX = plotX - plotTime;
            
        % In this case we will be plotting RPM vs Time
        case 2
            plotX = cropVals(: , 1);
            plotY = cropVals(:, 14);
            
            plotX = plotX - plotTime;
            
        % In this case we will be plotting Omega2 vs Time
        case 3
            plotX = cropVals(:, 1);
            plotY = cropVals(:, 14);
            
            plotX = plotX - plotTime;
            plotY = (plotY .*(120 * pi)).^2;
            
        % In this case we will be plotting Thrust vs RPM.
        case 4
            for i = 1:length(cropVals(:, 10))
                if(cropVals(i, 10) > 0.2 && cropVals(i, 14) > 5000)
                    plotX(length(plotX) + 1) = cropVals(i, 14);
                    plotY(length(plotY) + 1) = cropVals(i, 10); 
                end
            end
            
            if(plotTare)
                plotY = plotY - averageTare;
            end           
    
    end
end

