% Array --> Array 
% Takes the current solution and outputs its neighbors 
function nb = neighbors(current_solution,Ground)
    all_neighbors = []; 
    last_leg = current_solution(end);
    for j=1:length(Ground.fromindex)
        if Ground.fromindex(j) == last_leg 
            all_neighbors = [all_neighbors Ground.toindex(j)]; 
        end     
    end 
    nb = all_neighbors; 
end 