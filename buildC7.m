function Aineq_C7 = buildC7(dv, recap_rate, num_it)

% Value of decision vbles
num_dv = length(dv(:,1));

% Index of the recapture matrix of each decision vble
index_r = dv(:,1);

Aineq_C7 = zeros(num_it,num_dv);

for j=1:num_it
    
    % origin itinerary for of each dv
    itp = recap_rate(index_r,1)+1;    
    
    % Find all dv with originating itinerary = j
    p = find(itp==j);
    
  if min(size(p))>0 % no dv with originating itinerary = j
    
     Aineq_C7(j,p) = 1;    

  end

end


end

