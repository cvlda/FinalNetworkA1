% ASSIGNMENT Ib:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Solve Separation problem: Add rows
%
% Check for constraint (7) of pax mix flow problem. 
% If not fulfilled --> add constraint to RPM
%--------------------------------------------------------------------------

function [Opt_row, v_addrow] = AddRows(v_addrow0, dv, it, recap, num_it)
% Input:
%
% dv: Decision vbles resulting from RPM
% recap
% it
% num_recap

Opt_row  = 0;
v_addrow = [];

% C11
%--------------------------------------------------------------------------
  ndv = length(dv(:,1));
  A11 = zeros(num_it,ndv);
  
  % Index of the recapture matrix of each decision vble
  index_r = dv(:,1);
  for j=1:num_it
    
      % origin itinerary for of each dv
      itp = recap(index_r,1)+1;    
    
      % Find all dv with originating itinerary = j
      p = find(itp==j);
    
    if min(size(p))>0 % no dv with originating itinerary = j
    
       A11(j,p) = 1;    

    end

  end

Dp = it(:,2);

C11 = A11*dv(:,2)-Dp;

% Check constraint (7)
j = find(C11>0); % Does not fulfill constraint

if isempty(v_addrow0)
   v_addrow = j;
   if isempty(j)
       Opt_row  = 1;
   end
else
    k=1;
    for i=1:length(j)
    
        if max(j(i)==v_addrow0) == 0 % not yet added
            v_addrow(k) = j(i);
            k = k+1;
        end
    end
    v_addrow=v_addrow';
    if k==1
      Opt_row  = 1;
    end
end

v_addrow = [v_addrow0; v_addrow];

end






