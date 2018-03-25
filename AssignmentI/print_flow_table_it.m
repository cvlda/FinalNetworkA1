function print_flow_table_it(dv,delta,it,recap_rate,x_Flight_txt)
%Get demand per flight
flight_demand = zeros(232,738); 

%for each flight look at the itineraries it contains using delta
%Add the demands of these itineraries to the table 
for i=1:length(delta(:,1)) %i is flight index 
    for j=1:length(delta(1,:)) %j is itinerary index
        flight_demand(i,j)=it(j,2)*delta(i,j);
    end 
end 

%Get total spill 
total_spill = zeros(232,738); 
for i=1:length(dv) %loop over decision variables
    spill = dv(i,2); 
    spill_source_it = recap_rate(dv(i,1),1); %look spill source it number up for dv 
    for j=1:length(delta(:,1)) %loop over all flights
        if delta(j,spill_source_it+1) == 1
            total_spill(j,spill_source_it+1) = spill; 
        end 
    end 
end 

%Get amount moved to flight
spilled_here = zeros(232,738);
for i=1:length(dv) %loop over decision variables
    spill = dv(i,2); 
    spill_dest_it = recap_rate(dv(i,1),2); %look spill dest it number up for dv 
    rate = recap_rate(dv(i,1),3); 
    for j=1:length(delta(:,1)) %loop over all flights
        if delta(j,spill_dest_it+1) == 1
                %add number to spilled_here 
                spilled_here(j, spill_dest_it) = spill*rate; 
        end
    end 
end 

flows = flight_demand - total_spill + spilled_here; 

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
    fprintf('%s &',number{1}); 
    for l=1:length(delta(1,:))
        if flows(flight_index(k),l) >= 0.1
            itinerarynumber = l - 1;
            if floor(flows(flight_index(k),l))==flows(flight_index(k),l)
                fprintf('%d ($i_{%d}$)&',flows(flight_index(k),l),itinerarynumber)
            else
                fprintf('%.1f ($i_{%d}$)&',flows(flight_index(k),l),itinerarynumber)
            end
        end 
    end 
    fprintf('\\\\ \n')
end 

