function output = update_persons(input, lengde)
    tidsarray = input.time;
    dataarray = input.data;
    tidsarray = ceil(tidsarray);
    if(tidsarray(1) == 0)
    output(1) = dataarray(1);
    else
        output(1) = 0;
    end
for k = 2:lengde %k = 228
    if(ismember(k,tidsarray)) % true
        holdindex = find(k == tidsarray);
        
        output(k) = dataarray(holdindex(end)); 
    else
        output(k) = output(k-1);
    end
end
end

