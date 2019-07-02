% This functions is responsible for getting the average tare and then
% returning that value.

function averageTare = RCB_getTare(vals)
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