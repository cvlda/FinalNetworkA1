% ASSIGNMENT Ib:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Solve Pricing problem: Add columns
%--------------------------------------------------------------------------

function [Opt_col, v_addcol] = AddColumns(dv, recap, num_recap, delta, pi, sigma)

% AddColumns
% Inputs:
% recap = Recapture itineraries matrix
%         [From It, To It, b, Fare 'From', Fare 'To']
% pi, sigma slack variables

% Outputs:
% Opt_col : 1 if no more columns to be added
%           0 if new columns 
% v_addcol: array with row index in recap matrix to point at the recap
%           itinerary to be added


% Number of columns to be added
k=1;
Opt_col = 0;
v_addcol = [];
    
for i = 1:num_recap
   
    itp = recap(i,1)+1;
    itr = recap(i,2)+1;
    
    b = recap(i,3);
    fare_p = recap(i,4);
    fare_r = recap(i,5);
    
    sum_pi_p = pi'*delta(:,itp);
    sum_pi_r = pi'*delta(:,itr);
        
    cost(i) = fare_p-sum_pi_p - b*(fare_r-sum_pi_r) - sigma(itp);
    
    if cost(i)<0 && max(dv(:,1)==i)==0
    v_addcol(k) = i;
    k=k+1;
    end
end

if k==1
    Opt_col=1;
end
v_addcol = v_addcol';

end
