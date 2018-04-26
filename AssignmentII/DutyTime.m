% Array --> Float 
% Takes current solution and returns the corresponding duty time 
function dt = DutyTime(current_solution,Origin,Destination)
    first_leg = current_solution(1);
    last_leg = current_solution(end); 
    delta = Destination.time(last_leg) - Origin.time(first_leg); 
    if delta < 0
        dt = 1-Origin.time(first_leg)+Destination.time(last_leg); 
    else
        dt = delta; 
    end  
end 

