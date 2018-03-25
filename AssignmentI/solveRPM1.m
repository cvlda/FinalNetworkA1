% ASSIGNMENT Ia:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Solve RPM for problem 1a
%--------------------------------------------------------------------------


function [X, FVAL, pi, sigma] = solveRPM1(u,C,nK,nA,d,Set,Kp,Ap,s)


% Solve RPM 
% Inputs:
% Set
% s slack variables

% Outputs:
% f = solution array with 0-1 fraction commodity/demmand
% s = slack variable
% pi, sigma = dual variables


% 2. Cost function:
%--------------------------------------------------------------------------
% Path cost array:
nptot = length(Set(1,:));
cp = Ap'*C;
for i=1:nptot
f(i)  = (cp(i).*Kp(:,i))'*d;
end

% Add slack variables:
M = 1000;
ns = length(find(s>0));
f(nptot+1:nptot+ns) = M;

% 4. Constraints
%--------------------------------------------------------------------------
Aineq=zeros(nA,nptot+ns);
Aineq(1:nA,1:nptot) = Set;
s_arc=find(s>0);
for i=1:ns
    Aineq(s_arc(i),nptot+i) = -1;
end
bineq = u;

Aeq(1:nK,1:nptot)   = Kp;
Aeq(1:nK,nptot+1:nptot+ns) = zeros(nK,ns);
beq   = ones(nK,1);

LB = zeros(nptot+ns,1);
UB = [];

% 5. Solve problem with slack variables:
%--------------------------------------------------------------------------
[X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = linprog(f,Aineq,bineq,Aeq,beq,LB,UB);

% write dual variables:
pi    = - LAMBDA.ineqlin;
sigma = - LAMBDA.eqlin;



end


