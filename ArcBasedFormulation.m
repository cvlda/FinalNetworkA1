% ASSIGNMENT Ia:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Arc-based formulation
%--------------------------------------------------------------------------
% trying git
clear all; close all; clc;

load('Data_prob1.mat')
% load('test_prob1.mat')

% Display Network
figure
map = plot(Network,'Layout','force','EdgeLabel',Network.Edges.Weight);

% %  intlinprog Mixed integer linear programming.
% %  
% %     X = intlinprog(f,intcon,A,b) attempts to solve problems of the form
% %  
% %              min f'*x    subject to:  A*x  <= b
% %               x                       Aeq*x = beq
% %                                       lb <= x <= ub
% %                                       x(i) integer, where i is in the index
% %                                       vector intcon (integer constraints)




% 1. Objective function:
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

f = zeros(nA*nK,1);

for i = 1:nK
    
f(1+nA*(i-1):nA*i) = C;
end


% 2. Constraints:
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


% (2) 
%--------------------------------------------------------------------------
Aeq = zeros(n,nA);

for i = 1:nA
    
    Aeq(Oa(i),i) = 1;
    Aeq(Da(i),i) = -1;
end


beq = zeros(n*nK,1);
Aeq_extended = zeros(n*nK,nA*nK);
for i=1:nK

    beq(Ok(i)+(i-1)*n) = d(i);
    beq(Dk(i)+(i-1)*n) = -d(i);
    
    % Extended Aeq:
    krow = n*(i-1)+1;
    kcol = nA*(i-1)+1;
    Aeq_extended(krow:krow+n-1,kcol:kcol+nA-1) = Aeq;
end

% (3)
%--------------------------------------------------------------------------

for i=1:nK
    
    k = nA*(i-1)+1;
    Aineq(1:nA,k:k+nA-1) = eye(nA);
end

bineq = u;


% (4)
%--------------------------------------------------------------------------
LB = zeros(nA*nK,1);
UB = [];


% 3. Solve LP:
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% Integers:
intcon = [1 nA*nK];
[x,FVAL,EXITFLAG] = intlinprog(f,intcon,Aineq,bineq,Aeq_extended,beq,LB,UB);


