function data = RCBenchmark_Analysis()
%{

    These are the settings for running this program and how they will
    effect the plots and the graphs.
    
    Prefixes: Refers to set-up that we are using.
        HP: Half-Blockage Plane.
        VP: Vertical Plane to mirror flow.
        ST: Square Tube.
        HPVP: Half-Blockage Plane with Vertical Plane.
    
    Plot Half-Blockage Plane (plotHP)
        0: Doesn't Plot
        1: Plots
    
    Plot Vertical Plane (plotVP)
        0: Doesn't Plot
        1: Plots
    
     Plot Square Tube (plotST)
        0: Doesn't Plot
        1: Plots
    
    Plot Half-Blockage Plane with Vertical Plane (plotHPVP)
        0: Doesn't Plot
        1: Plots
       
    Distances: Refers to the Prop to Plane distance
        N.DD Format (Number . Decimal Decimal)
    
    Plot Linear Fit (plotLinear) [Doesn't Currently Work. Must be 0]
        0: Plots won't contain line of best fit.
        1: Plots will contain line of best fit.
    
    Plot Sub Plots (plotSubPlot)
        0: Plots all data points grouped by "Prefix"
        1: Plots all data points grouped by "Distances"
    
    Clear Existing Plots (plotClear)
        0: Plots won't clear when program is run.
        1: Plots will clear when program is run.
    
    Plot Mode (plotMode)
        0: Plots Thrust vs Omega^2
        1: Plots Thrust vs Time
        2: Plots RPM vs Time
        3: Plots Omega^2 vs Time
        4: Thrust vs RPM
    
    Plot Tare (plotTare)
        0: Plots data as it is.
        1: Plots data that is adjusted by the tare value so it is
        'Normalized' in a sense.


%}
    
    %%%     Settings        %%%
    
    plotLinear = 0;
    plotSubPlot = 0;
 
    plotClear = 1;
    plotTare = 1; 
    plotPrecision = 0;
    plotStatistics = 1;
    
    plotMode = 0;
   
    
    prefixes = strings(0);
    
    plotTitle = "";
    plotXLabel = "";
    plotYLabel = "";
    plotX = 0; %Values Plotted on X-Axis
    plotY = 0; %Values Plotted on Y-Axis
    
    plotHP = 1;
    plotVP = 1;
    plotST = 1;
    plotHPVP = 1;
    plotCTRL = 1;
    
  
    
    
    %For now this needs to be manually entered. It is fairly irrelevant and
    %not really used for anything important.
    
    distances = ["0.75", "1.50", "2.25",  "3.00", "3.75", "4.50", "5.25", "6.00", "6.75", "7.50"];
    
    
    % This is the file that we will display the statistics in. We also
    % print the first line of the file which is just for organization and
    % shows the categories or the columns of data that we are about to
    % enter.
    
    fileID = fopen("plotStatistics.txt", 'w');
    spacer = "     ";
    fprintf(fileID, "%10s %8s %8s %8s\r\n\r\n", "Configuration", "Thrust", "RPM", "Ct");
    
    %%%     Settings        %%%
    
    
    % Checks if we should clear the plots
    if(plotClear)
        close all;
    end

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
    
   for x = 1:length(prefixes)
        
        % Variable intialization.
        fprintf("Calculating information for %s\n\n", prefixes(x));
        counter = 0;
        distanceCounter = 0;
        currentPrefix = (prefixes(x));
        
        % Checking a new Directory for CSV Files to read from. 
        % May need to change V1 to V2 or vice versa
        newDirectory = sprintf("/home/tg_computer/Desktop/Summer_2019/V2/%s", currentPrefix);
        cd(newDirectory);
        
        % Loads all files that contain csv to filenames variable.
        filenames = dir('*.csv');
        
        if(plotCTRL)
          ctrlDirectory = sprintf("/home/tg_computer/Desktop/Summer_2019/V2/CTRL");  
          cd(ctrlDirectory);
          ctrlFilename = dir('*.csv');
          filenames(length(filenames) + 1) = ctrlFilename;
        end
            
        cd(newDirectory);
        
        % If we aren't doing a subplot, we make sure to create a new figure
        % based on where we are in the prefixes list.
        if(~plotSubPlot)
            figure(x);
        end
        
        for i = 1: length(filenames)
            
            if(i == length(filenames))
                cd(ctrlDirectory);
            end
            
            counter = counter + 1;
            filename = filenames(i).name
            
            
            
            

            %%% Get rpm and thrust values from RC Benchmarks .csv file
            [plotX, plotY] = read_file(filename, plotMode, plotTare);
            [plotX, plotY] = cleanValues(plotX, plotY, plotMode, plotPrecision);

            switch(plotMode)
                case 0
                    plotTitle = "Thrust vs Omega^2";
                    plotXLabel = "Omega^2 (Rad / S)";
                    plotYLabel = "Thrust (N)";
                case 1
                    plotTitle = "Thrust vs Time";
                    plotXLabel = "Time (S)";
                    plotYLabel = "Thrust (N)";
                case 2
                    plotTitle = "RPM vs Time";
                    plotXLabel = "Time (S)";
                    plotYLabel = "RPM";
                case 3
                    plotTitle = "Omega^2 vs Time";
                    plotXLabel = "Time (S)";
                    plotYLabel = "Omega^2 (Rad / S)";
                case 4
                    plotTitle = "Thrust vs RPM";
                    plotXLabel = "RPM";
                    plotYLabel = "Thrust (N)";                   
                    
            end
            
            
            %%% that for free space or the corrent r/R value
            distanceCounter = distanceCounter + 1;
            if(distanceCounter == length(filenames) && plotCTRL)
                leg = sprintf("CTRL");
            else
                leg = sprintf("%s", distances(distanceCounter));
            end
            
            if(plotStatistics)
                averagePlotX (1) = 0;
                averagePlotY (1) = 0;
                runningTotalPlotX = 0;
                runningTotalPlotY = 0;
                dataCounter = 1;
                plotCounter = 0;
           
                fprintf(fileID, "%10s %10s %10s %10s\r\n", filename, spacer, spacer, spacer);
                for j = 2:length(plotX)
                    if((plotX(j-1) <= plotX(j) + 100 && plotX(j-1) >= plotX(j) - 100) && j ~= length(plotX))
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
            fprintf(fileID, "\r\n\r\n");
            
            % Let's Read over this and see what we are doing over here????"
            if(plotSubPlot)
                fprintf("%s - %s \n", prefixes(x), distances(counter));
                leg = sprintf("%s", prefixes(x));
                subplot(3, 4, counter);
                plot(plotX,plotY,'.','DisplayName',leg)
                
                hold on
                title(sprintf("%s (%s)", plotTitle, distances(counter)));
                xlabel(plotXLabel)
                ylabel(plotYLabel)
                legend('show', 'Location', 'Best')
            else
                plot(plotX, plotY,'.','DisplayName',leg);
                if(distanceCounter == length(filenames) && plotCTRL)
                    fprintf("\nLinear fit for sample: CTRL\n");
                else
                    fprintf("\n\nLinear fit for sample: %s_%s\n", prefixes(x), distances(counter));
                end
                p = polyfit(plotX, plotY, 1);
                if(plotLinear)
                    hold on                    
                    leg1 = sprintf("%s Fit" , distances(distanceCounter));
                    plotX(length(plotX) + 1) = 0;
                    plot(plotX, plotX * p(1) + p(2));
                end
                fprintf("%fx + %f\n", p(1), p(2));
                hold on
            end
        end

        %%% Plot properties
        if(~plotSubPlot)
            title(sprintf("%s (%s)", plotTitle, currentPrefix));
            xlabel(plotXLabel)
            ylabel(plotYLabel)
            legend('show', 'Location', 'Best')
        end

    end
end


%%% -----------
%%% Functions
%%% -----------

%This function opens the .csv given and returns the rpm(rad/s) and thrust
%value (kg*f)
function [plotX, plotY] = read_file(filename, plotMode, plotTare)
    plotStart = 0;
    plotEnd = 0;
    plotValsFound = 0;
    
    plotTime = 0;
    
    plotX = [];
    plotY = [];
    
    vals = csvread(filename,2);
    if(plotTare)
        averageTare = getTare(vals);
    end       
    cropCol = vals(:, 14);
    
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
        % We should be plotting Thrust vs Omega^2
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
            
        % We should be plotting Thrust vs Time    
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
        % We should be plotting RPM vs Time
        case 2
            plotX = cropVals(: , 1);
            plotY = cropVals(:, 14);
            
            plotX = plotX - plotTime;
        % We should be plotting Omega^2 vs Time
        case 3
            plotX = cropVals(:, 1);
            plotY = cropVals(:, 14);
            
            plotX = plotX - plotTime;
            plotY = (plotY .*(120 * pi)).^2;
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

% This functions is responsible for getting the average tare and then
% returning that value.
function averageTare = getTare(vals)
    tare = [];
    rpmColumn = vals(:, 14);
    for i = 1:length(vals)
        if(rpmColumn(i) == 0)
            if(vals(i,10) ~= 0)
                tare(length(tare) + 1) = vals(i , 10);
            end
        end
    end
        
    if(isempty(tare))
        averageTare = 0;
    else
        averageTare = mean(tare);
    end
end

function [cleanPlotX, cleanPlotY] = cleanValues(plotX, plotY, plotMode, plotPrecision)
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


%{
                xsquared = plotX .^2;
                sum(xsquared)
                xy = plotX .* plotY
                n = length(plotX)
                slope = (n * sum(xy) - sum(plotX) * sum(plotY)) / (n * sum(xsquared) - sum(xsquared))
                b = (sum(plotY) - slope * sum(plotX))/n
                hold on
                plot(plotX, plotX * slope + b);

%}



