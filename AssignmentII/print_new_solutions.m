%Array Struct --> Matrix with rows being solutions
%Finds neighboring solutions of a solution 
function paths = print_new_solutions(current_solution,Ground)
    %Get neighbors 
    solutions = []; 
    nb = neighbors(current_solution, Ground); 
    %Combine 
    for n=1:length(nb)
        neighbor = nb(n); 
        %print
        row = [current_solution neighbor]; 
        %add to new solution
        if isempty(solutions)
            solutions = row; 
        else 
            solutions = [solutions ; row]; 
        end 
    end 
    if isempty(solutions)
        paths = [0 0 0 0]; 
    else
        paths = solutions; 
    end
    
end 
