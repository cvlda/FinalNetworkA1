function all_paths = find_all_paths(solution,Ground,max_flights)
    %create empty results matrix 
    p = []; 
    for r=1:length(solution(:,1))
        row = solution(r,:); 
        %disp(row)
        if length(row) == max_flights
            %add to results matrix
            p = [p ; row];  
        else
            delta = max_flights - length(row); 
            %add to result matrix [row delta*0]
            p = [p ; [row zeros(1,delta)]];
            %Get new solutions and repeat process
            new_solution = print_new_solutions(row,Ground); 
            %recursive call
            p = [p ; find_all_paths(new_solution,Ground,max_flights)]; 
        end
    end 
    all_paths = p; 
end   