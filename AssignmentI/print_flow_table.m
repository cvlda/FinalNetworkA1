function print_flow_table(dv,delta,it,recap_rate,x_Flight_txt)
%Get demand per flight
flight_demand = delta * it(:,2); 

%Get total spill 
total_spill = zeros(232,1); 
for i=1:length(dv) %loop over decision variables
    spill = dv(i,2); 
    spill_source_it = recap_rate(dv(i,1),1); %look spill source it number up for dv 
    for j=1:length(delta(:,1)) %loop over all flights
        %Check if delta(j,spill_source_it+1) is 1, then it spill_source contains flight
        %j
        if delta(j,spill_source_it+1) == 1
            %add number to total spill 
            total_spill(j) = total_spill(j) + spill; 
        end 
    end 
end 

%Get amount moved to flight
spilled_here = zeros(232,1);
for i=1:length(dv) %loop over decision variables
    spill = dv(i,2); 
    spill_dest_it = recap_rate(dv(i,1),2); %look spill dest it number up for dv 
    rate = recap_rate(dv(i,1),3); 
    for j=1:length(delta(:,1)) %loop over all flights
        if delta(j,spill_dest_it+1) == 1
                %add number to spilled_here 
                spilled_here(j) = spilled_here(j) + (spill*rate); 
        end
    end 
end 

flows = flight_demand - total_spill + spilled_here; 
%find(flows > capacity+1); %check if flow < capacity  

flight_index=[]; 
for i=1:length(x_Flight_txt(:,2)) %i is flight index in flight table and delta table
    if (strcmp(x_Flight_txt(i,2),'EZE') && strcmp(x_Flight_txt(i,3), 'AEP'))...
             || (strcmp(x_Flight_txt(i,2),'AEP') && strcmp(x_Flight_txt(i,3), 'EZE'))
        %Lookup flight index in delta. Result: indexes of itineraries that
        %use the flight
        flight_index = [flight_index i]; 
    end
end 

flight_index = flight_index'; 
for k=1:length(flight_index)
    number = x_Flight_txt(flight_index(k),1);
    or = x_Flight_txt(flight_index(k),2);
    dest = x_Flight_txt(flight_index(k),3);
    fprintf('%s & %s & %s & %.1f \n',number{1},or{1},dest{1},flows(flight_index(k)))
end 