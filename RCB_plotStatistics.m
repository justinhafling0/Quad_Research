function RCB_plotStatistics(filename, spacer, plotX, plotY)
    averagePlotX (1) = 0;
    averagePlotY (1) = 0;
    runningTotalPlotX = 0;
    runningTotalPlotY = 0;
    dataCounter = 1;
    plotCounter = 0;

    fprintf(fileID, "%10s %10s %10s %10s\r\n", filename, spacer, spacer, spacer);
    for j = 2:length(plotX)                        
        if((plotX(j-1) <= plotX(j) + 60 && plotX(j-1) >= plotX(j) - 60) && j ~= length(plotX))
            plotCounter = plotCounter + 1;
            runningTotalPlotX = runningTotalPlotX + plotX(j);
            runningTotalPlotY = runningTotalPlotY + plotY(j);
        else
            averagePlotX(dataCounter) = runningTotalPlotX / plotCounter;
            averagePlotY(dataCounter) = runningTotalPlotY / plotCounter;
            plotCounter = 0;
            dataCounter = dataCounter + 1;
            runningTotalPlotX = 0;
            runningTotalPlotY = 0;
        end
    end
    for k = 1:length(averagePlotX)
       fprintf(fileID, "%10s %10.3f %10.3f %10.5f\r\n", spacer, averagePlotY(k), averagePlotX(k), averagePlotY(k) / averagePlotX(k)); 
    end
end

