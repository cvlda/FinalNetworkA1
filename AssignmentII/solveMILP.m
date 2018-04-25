function [x,fval,flag] = solveMILP(X,IFAMformulation) 
%All decision variables (f^k_i, y^k_r and t^r_p) should be integer
intcon = linspace(1,length(X),length(X));

%Reassign upperbound of f^k_i to 1 
load('Data_FAM.mat','F');       %load variable F, representing flight arcs 
nf = sum([F.nL]);               % sum_k(flight legs of k) 
UB = IFAMformulation.UB;
UB(1:nf)=1;
% options = optimoptions('intlinprog','Display','off');
 
[x,fval,flag] = intlinprog(IFAMformulation.ObjFun,intcon,...
    IFAMformulation.Aineq,IFAMformulation.bineq,IFAMformulation.Aeq,...
    IFAMformulation.beq,IFAMformulation.LB,UB);
  
    
end 

