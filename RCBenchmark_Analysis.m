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
        1: Plots    for e = 1:length(averageRPM)
        figure(100 * e);
        slicePlotY = [];
        slicePlotX = [];
        
        fprintf("Distance: %f\n", distances(i));
        fprintf("RPM Range: %s\n\n", num2str(averageRPM(e)));
        for b = 1:length(plotY)
            if(plotX(b) < averageRPM(e) + 50 && plotX(b)  > averageRPM(e) - 50)
               slicePlotY(length(slicePlotY) + 1) = plotY(b);
               fprintf("RPM Value: %f\n", plotX(b));  
               %slicePlotX[length(slicePlotY)] = plotX(b);
           end
        end
        averageSlicePlotY = 0;
        for q = 1:length(slicePlotY)
            averageSlicePlotY = averageSlicePlotY + slicePlotY(q);
        end
        averageSlicePlotY = averageSlicePlotY / length(slicePlotY)
        leg = sprintf("%s", distances(r));
        plot(str2num(distances(i)), averageSlicePlotY, '.', 'DisplayName', leg);
        title(sprintf("Average Omega^2 (%s)", num2str(averageRPM(e))));
        legend('show', 'Location', 'Best')
        hold on;
    end 
    
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

    Plot White Blade Data (plotWhite)
        0: Plots the data with the Black Blade.
        1: Plots the data with the White Blade.

    Plot Statistics (plotStatistics)
        0: Won't plot Coefficient of Thrust nor produce statistics file.
        1: Plots Coefficient of Thrust and produces statistics file.

    Plot Analyticalal (plotAnalytical) Thrust vs Distance plot.
        0: Will not plot Analytical Data at specific distances
        1: Plots Analytical Data in form Thrust vs Distance.

%}

    %----------------------------------------------%
    %%%                 Settings                 %%%
    %----------------------------------------------%

    
    % The following settings control the configuration of the plots and
    % what you actually see on the plots.
    
    plotLinear = 0;
    plotSubPlot = 0;
    plotStatistics = 0;
    plotAnalytical = 1;
    plotThrustDistance = 1;
 
    
    % The following settings control how we treat some of the data and
    % clean up stuff in program when plotting.

    plotClear = 1;
    plotTare = 1; 
    plotPrecision = 0;
    plotWhite = 0;
    debugMessages = 0;

    
    % The following settings control which files we look for when
    % attempting to plot any of the data.
    
    plotMode = 0;
    plotHP = 1;
    plotVP = 0;
    plotST = 0;
    plotHPVP = 0;
    plotCTRL = 1;

    %----------------------------------------------%
    %%%                 Settings                 %%%
    %----------------------------------------------%
   

    
                      
    %For now this needs to be manually entered. It is fairly irrelevant and
    %not really used for anything important.
    
    distances = ["0.75", "1.50", "2.25",  "3.00", "3.75", "4.50", "5.25", "6.00", "6.75"];
    averageRPM = [2450, 4650, 6600, 8500, 10300, 11000];
    
    % Calls function to get the Prefixes that we need. Also just the prefix
    % of the filenames.
    prefixes = RCB_getFiles(plotHP, plotVP, plotHPVP, plotST, plotStatistics);

    
    if(plotMode == 0)
        averageRPM = averageRPM .* (2 * pi / 60);
    end
    
    rotorRadius = 4;
    
    
    % This is the file that we will display the statistics in. We also
    % print the first line of the file which is just for organization and
    % shows the categories or the columns of data that we are about to
    % enter.
    
    
    fileID = fopen("plotStatistics.txt", 'w');
    spacer = "     ";
    fprintf(fileID, "%10s %8s %8s %8s\r\n\r\n", "Configuration", "Thrust", " Omega^2", "Ct");
    
    
    
    % This is where we will select which directory we should be in.
    if(plotWhite)
        baseDirectory = "/home/tg_computer/Desktop/Summer_2019/V2/White/";
    else
        baseDirectory = "/home/tg_computer/Desktop/Summer_2019/V2/Black/";
    end        
    
    
    % Checks if we should clear the plots
    if(plotClear)
        close all;
    end
        
   for x = 1:length(prefixes)
        
        % Variable intialization.
        if(debugMessages)
            fprintf("Calculating information for %s\n\n", prefixes(x));
        end
        counter = 0;
        distanceCounter = 0;
        currentPrefix = (prefixes(x));
        
        % Checking a new Directory for CSV Files to read from. 
        % May need to change V1 to V2 or vice versa
        newDirectory = sprintf("%s%s", baseDirectory, currentPrefix);
        cd(newDirectory);
        
        % Loads all files that contain csv to filenames variable.
        filenames = dir('*.csv');
            
        if(plotCTRL)
          ctrlDirectory = sprintf("%sCTRL", baseDirectory);  
          cd(ctrlDirectory);
          ctrlFilename = dir('*.csv');
          filenames(length(filenames) + 1) = ctrlFilename;
        end
     
        cd(newDirectory);
       
        for i = 1:length(filenames)
            % If we aren't doing a subplot, we make sure to create a new figure
            % based on where we are in the prefixes list.
            if(~plotSubPlot)
                figure(x);
            end
        
            if(i == length(filenames) && plotCTRL)
                cd(ctrlDirectory);
            end
            
            if(i == length(filenames) && plotCTRL)
                leg = sprintf("CTRL");
            else
                leg = sprintf("%s", distances(i));
            end
            
            filename = filenames(i).name;

            %%% Get rpm and thrust values from RC Benchmarks .csv file
            [plotX, plotY] = RCB_readFile(filename, plotMode, plotTare);
            [plotX, plotY] = RCB_cleanValues(plotX, plotY, plotMode, plotPrecision);

            switch(plotMode)
                case 0
                    plotTitle = "Thrust vs Omega^2";
                    plotXLabel = "Omega^2 (Rad / S)";
                    plotYLabel = "Thrust (N)";
                    Y_Axis = [0, 12];
                case 1
                    plotTitle = "Thrust vs Time";
                    plotXLabel = "Time (S)";
                    plotYLabel = "Thrust (N)";
                    Y_Axis = [0, 12];

                case 2
                    plotTitle = "RPM vs Time";
                    plotXLabel = "Time (S)";
                    plotYLabel = "RPM";
                    Y_Axis = [0, 14000];

                case 3           
                    plotTitle = "Omega^2 vs Time";
                    plotXLabel = "Time (S)";
                    plotYLabel = "Omega^2 (Rad / S)";
                    Y_Axis = [0, 1300];

                case 4
                    plotTitle = "Thrust vs RPM";
                    plotXLabel = "RPM";
                    plotYLabel = "Thrust (N)"; 
                    Y_Axis = [0, 12];        
            end
           
           
            
            fprintf(fileID, "\r\n\r\n");
            
            % Let's Read over this and see what we are doing over here????"
            if(plotSubPlot)
                fprintf("%s - %s \n", prefixes(x), distances(counter));
                leg = sprintf("%s", prefixes(x));
                subplot(3, 4, counter);
                plot(plotX,plotY,'.','DisplayName',leg)
                
                hold on
                title(sprintf("%s (%s)", plotTitle, distances(counter)));ctrlDirectory
                xlabel(plotXLabel)
                ylabel(plotYLabel)
                legend('show', 'Location', 'Best')
            else
                hp = plot(plotX, plotY,'.','DisplayName',leg, 'Color', [mod(i, 2), (mod(i, 3) / 3), mod(i, 4) / 3], 'MarkerSize', 15);
                title(sprintf("%s (%s)", plotTitle, currentPrefix));
                xlabel(plotXLabel);
                ylabel(plotYLabel);
                hLegend = legend('show', 'location', 'NorthWest', 'Fontsize', 10);
                
                p = polyfit(plotX, plotY, 1);
                
                
                % If plotLinear is true, we will plot a line that is the
                % linear average of the data, a Linear Fit.
                if(plotLinear)
                    hold on                    
                    leg1 = sprintf("%s Fit" , distances(distanceCounter));
                    plotX(length(plotX) + 1) = 0;
                    plot(plotX, plotX * p(1) + p(2));
                end                      

                RCB_formatPlots(hp);
                
                ylim(Y_Axis);
                grid on;
                
                if(debugMessages)
                    fprintf("%fx + %f\n", p(1), p(2));
                end
                hold on
                
                if(plotStatistics && plotMode == 0)
                    figure (10 * x);
                    %leg = sprintf("%s", distances(i));

                    averagePlotXAxis = [];
                    correctionMax = 0 ;
                    for j = 1:length(averagePlotX)
                        if(averagePlotX(j) > correctionMax)
                            correctionMax = averagePlotX(j);
                            averagePlotXAxis(j) = averagePlotX(j);
                        else
                            averagePlotXAxis(j) = correctionMax * 2 - averagePlotX(j);
                        end
                    end
                    
                    plot(averagePlotXAxis, averagePlotY ./ averagePlotX, 'DisplayName', leg);
                    plotXLabels = [0, 250, 500, 750, 1000, 1250, 1000, 750, 500, 250, 0];
                    xlim([0, 2500]);
                    set(gca,'xtick',0:250:2500,'xticklabel',plotXLabels)
                    ylim(Y_Axis);
                    grid on;
                    title(sprintf("Coefficient of Thrust (%s)", prefixes(x)));
                    ylabel("Coefficient of Thrust");
                    xlabel("Averaged Omega^2 Values");
                    ylim([0.0065, 0.009]);
                    xtickangle(90);
                    
                    RCB_formatPlots();
                    
                    hold on
                    figure(x)
                end
            end
            
            % -------------------------------------------------- %
            %       Calling Major Sub-Functions to Plot other    %
            %                       Settings                     %
            % -------------------------------------------------- %
            
            if(plotStatistics)
                RCB_plotStatistics(filename, spacer, plotX, plotY);
            end
            
            if(plotAnalytical && ((i == (length(filenames) - 1) && plotCTRL) || i == length(filenames) && ~ plotCTRL))
                RCB_plotAnalytical(plotX, plotY, prefixes, x, distances, averageRPM, rotorRadius, i)
            end
            
            if(plotThrustDistance)
                RCB_ThrustvsDistance(); 
            end
            
        end

        %%% Plot properties
        if(~plotSubPlot)
            title(sprintf("%s (%s)", plotTitle, currentPrefix));
            xlabel(plotXLabel);
            ylabel(plotYLabel);
            hLegend = legend('show', 'location', 'NorthWest', 'Fontsize', 10);
            
            %Increases the size of the markers in the legend so that they
            %are more visible.
            %if(plotAnalytical)
            %   loopLength = 2 * (length(filenames) - 1)
            %else
            loopLength = length(filenames);
            %end
           % for k = 1:loopLength
           %     hLegendEntry = hLegend.EntryContainer.NodeChildren(k);
           %     hLegendIconLine = hLegendEntry.Icon.Transform.Children.Children;
           %     hLegendIconLine.Size = 25;    
           % end
        end

    end
end

function RCB_formatPlots(hp)
    ts = 13;
    fn = 'helvetica';
    lw = 2;
    set(gca, 'fontsize', ts)
    legend('show');
    set(hp, 'linewidth', lw)
    set(get(gca, 'XLabel'), 'FontSize', ts, 'FontName', fn)
    set(get(gca, 'YLabel'), 'FontSize', ts, 'FontName', fn)
    set(get(gca, 'ZLabel'), 'FontSize', ts, 'FontName', fn)
    set(get(gca, 'title'), 'FontSize', ts, 'FontName', fn)
    set(gca, 'fontname', fn) 

end

