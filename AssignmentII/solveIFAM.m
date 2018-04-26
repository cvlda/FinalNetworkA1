function [X,P_PMF, FVAL, pi, sigma,IFAMformulation] = solveIFAM( P_FAM, P_PMF, v_addrow, num_it )

% Link Problem
%--------------------------------------------------------------------------

% This function enlarges the problem FAM to the size of ndv_FAM+ndv_PMF
% and linkes it to the PMF, then solves it

% Objective Function
ObjFun = P_PMF.ObjFun;
ObjFun(1:P_FAM.ndv) = P_FAM.ObjFun;

% Equality Constraint
m = length(P_FAM.Aeq(:,1)); % Rows in Aeq FAM
Aeq = zeros(m ,P_FAM.ndv+P_PMF.ndv);
Aeq(:,1:P_FAM.ndv) = P_FAM.Aeq;
beq = P_FAM.beq;

% Inequality Constraint
mFAM = length(P_FAM.Aineq(:,1)); % Rows in Aineq FAM
mPMF = length(P_PMF.Aineq(:,1)); % Rows in Aineq PMF
m = mFAM+mPMF;
Aineq = zeros(m, P_FAM.ndv+P_PMF.ndv);
bineq = zeros(m, 1);
Aineq(1:mFAM,1:P_FAM.ndv) = P_FAM.Aineq;
Aineq(mFAM+1:m,:) = P_PMF.Aineq;
bineq(1:mFAM) = P_FAM.bineq;
bineq(mFAM+1:m) = P_PMF.bineq;

% Boundaries
LB = zeros(P_FAM.ndv+P_PMF.ndv,1);
UB = zeros(P_FAM.ndv+P_PMF.ndv,1);
UB(1:P_FAM.ndv) = P_FAM.UB;
UB(P_FAM.ndv+1:P_FAM.ndv+P_PMF.ndv) = Inf;


% Solve Problem
%--------------------------------------------------------------------------
[X,FVAL,~,~,lambda] = linprog(ObjFun,Aineq,bineq,Aeq,beq,LB,UB);
IFAMformulation.ObjFun = ObjFun; 
IFAMformulation.Aineq = Aineq;
IFAMformulation.bineq = bineq;
IFAMformulation.Aeq = Aeq;
IFAMformulation.beq = beq;
IFAMformulation.LB = LB;
IFAMformulation.UB = UB;



pi = - lambda.ineqlin(mFAM+1:m-length(v_addrow));

sigma=zeros(num_it,1);
    if not(isempty(v_addrow))
    sigma(v_addrow) = -lambda.ineqlin(m-length(v_addrow)+1:m);
    end

P_PMF.dv(:,2)= X(P_FAM.ndv+1:P_FAM.ndv+P_PMF.ndv);

end





