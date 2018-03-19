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

function [Opt_row, v_addrow] = AddRows(v_addrow0, dv, it, recap_rate, num_it)
% Input:
%
% dv: Decision vbles resulting from RPM
% recap
% it
% num_recap

Opt_row  = 0;
v_addrow = [];

Aineq_C7 = buildC7(dv, recap_rate, num_it);
Dp = it(:,2);

C7 = Aineq_C7*dv(:,2)-Dp;

% Check constraint (7)
j = find(C7>0); % Does not fulfill constraint

if length(v_addrow0)==0
   v_addrow = j;
   if length(j)==0
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






