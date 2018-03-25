% ASSIGNMENT II:  Problem 1
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% FAM: Fleet Allocation Problem ( Standard Formulation)
%--------------------------------------------------------------------------

function [ObjFun, Aeq, beq, Aineq, bineq, UB, LB] = FAM


% Load data for the problem
load('Data2_prob1.mat')

% Decision variables
%--------------------------------------------------------------------------
nf = sum([F.nL]);               % sum_k(flight legs of k) 
ny = sum([G.nG])+sum([NG.nG]);  % sum_k(ground legs of k and night ground legs of k)
ndv = nf+ny;  
                  

% Objective function
%--------------------------------------------------------------------------
ObjFun = zeros(ndv,1);
i = 0;
for k = 1:nK
   
    ObjFun(i+1:i+F(k).nL) = L.c(F(k).L,k);
    i = F(k).nL;
    
    
end

% Constraints
%--------------------------------------------------------------------------

% Equality constraints
%--------------------------------------------------------------------------

% C7
%--------------------------------------------------------------------------
A7 = zeros(nL,ndv);
I = eye(nL);
i=0;
for k = 1:nK
    
A7(:,i+1:i+F(k).nL) = I(:,F(k).L);
i = F(k).nL;
end
b7 = ones(nL,1);

% C8
%--------------------------------------------------------------------------
ma = 2*sum([N.n]);
na = ndv; 
A8 = zeros(ma,na);
b8 = zeros(ma,1);

% Nodes of flight legs
ia = 0;
ja = 0;
for k=1:nK                 
        A = zeros(N(k).n, F(k).nL );
        
        for i=1:F(k).nL
        A(F(k).O(i),i) = 1;
        A(F(k).I(i),i) = -1;
        end
        A8(ia+1:ia+N(k).n, ja+1:ja+F(k).nL) = A;
        [ma, na] = size(A);
        ia = ia+ma;
        ja = ja+na;

end


% Nodes of ground legs
for k=1:nK                 
        A = zeros(N(k).n, G(k).nG + NG(k).nG );
        
        for i=1:G(k).nG
        A(G(k).arc(i,1),i) = 1;
        A(G(k).arc(i,2),i) = -1;
        end
        for i=1:NG(k).nG
        A(NG(k).arc(i,1),i) = 1;
        A(NG(k).arc(i,2),i) = -1;
        end
        A8(ia+1:ia+N(k).n, ja+1:ja+G(k).nG+NG(k).nG) = A;
        [ma, na] = size(A);
        ia = ia+ma;
        ja = ja+na;

end

Aeq = A7;
beq = b7;
[m7,n] = size(Aeq);
[m8,~] = size(Aeq);
Aeq(m7+1:m7+m8,1:n) = A8;
beq(m7+1:m7+m8,1:n) = b8;


% Inequality constraints
%--------------------------------------------------------------------------

% C9
%--------------------------------------------------------------------------
A9=zeros(nK,ndv);
i = 0;
for k=1:nK
    i = i+G(k).nG;
    A9(k, nf+i+1:nf+i+NG(k).nG) = ones(1, NG(k).nG);
    i = i+NG(k).nG;
end
b9 = K.units;

Aineq = A9;
bineq = b9;


% Boundaries
%--------------------------------------------------------------------------
LB = zeros(ndv,1);
UB = ones(ndv,1); UB(nf+1:end)=Inf;

end








