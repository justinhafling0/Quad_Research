function RCB_plotAnalytical(plotX, plotY, prefixes, x, distances, averageRPM, rotorRadius, i)
    groundEffectArea = 0;
    prefixes(x)

    switch(prefixes(x))
        case("HP")
            groundEffectArea = rotorRadius * 3.1415 * rotorRadius / 2;
        case("VP")                                   
            groundEffectArea = 0;
        case("HPVP")
            groundEffectArea = rotorRadius * 3.1415 * rotorRadius / 2;

        case("ST")
            groundEffectArea = rotorRadius * 1;
    end
    
    for(r = 1:i - 1)
        leg = sprintf("Analytical (%s)", distances(r));
        analyticalPlotY = plotY .* (1/ (1 - (groundEffectArea/(16 * 3.1415 * str2num(distances(r))^2))));
        plot(plotX, analyticalPlotY, 'DisplayName', leg);
        hold on;         
    end
end

