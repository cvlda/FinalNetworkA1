% ASSIGNMENT Ia:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Solve Problem 1a.2 for different capacities (u_mod)
%--------------------------------------------------------------------------

function fval=f_increaseC(K0,Ap0, Kp0,Set1,u_mod)

% Load data for the problem
load('Data_prob1.mat')
clear u
u=u_mod;
K=K0;
Ap=Ap0;
Kp=Kp0;
% Load data for validation
% load('test.mat')


% Compute slack variables:
%--------------------------------------------------------------------------
stemp = sum(Set1')'-u;
s = max(0,stemp);
ns = length(find(s>0));


% Iteration
%--------------------------------------------------------------------------
Maxit = 100;
Set   = Set1;
it    = 1;
stop_cond = 0;

while stop_cond == 0 && it < Maxit
% B. Solve RMP
%--------------------------------------------------------------------------
[f, fval, pi, sigma] = solveRPM(u,C,nK,nA,d,Set,Kp,Ap,s);


% C. Modify costs and pricing problem
%--------------------------------------------------------------------------

cost = C-pi;
[K, Set, Ap, Kp, stop_cond] = GenerateSet(Oa, Da, nA, Ok, Dk, nK, K, Set, cost, sigma, d);
stemp2 = sum(Set')'-u;
s2 = max(0,stemp2);
it=it+1;
end




end