% ASSIGNMENT II:  Problem 1
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% FAM: Fleet Allocation Problem ( Standard Formulation)
%--------------------------------------------------------------------------

function P_FAM = FAM

% The size of this problem is for ndv_FAM


% Load data for the problem
load('Data_FAM.mat')

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
    i = i+F(k).nL;   
    
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
i = i+F(k).nL;
end
b7 = ones(nL,1);

% C8
%--------------------------------------------------------------------------
ma = sum([N.n]);
A8 = zeros(ma,ndv);
b8 = zeros(ma,1);

ia = 0;
jaf = 0;
jag = nf;
for k=1:nK    
    
        Af = zeros(N(k).n, F(k).nL );
        
        % Nodes of flight legs
        for i=1:F(k).nL
        Af(F(k).arc(i,1),i) = 1;
        Af(F(k).arc(i,2),i) = -1;

        end
        
        Ag = zeros(N(k).n, G(k).nG + NG(k).nG );
        
        % Nodes of ground legs
        for i=1:G(k).nG
        Ag(G(k).arc(i,1),i) = 1;
        Ag(G(k).arc(i,2),i) = -1;
        end
        % Nodes of night ground legs
        for i=1:NG(k).nG
        Ag(NG(k).arc(i,1),G(k).nG+i) = 1;
        Ag(NG(k).arc(i,2),G(k).nG+i) = -1;
        end      
        
        A8(ia+1:ia+N(k).n, jaf+1:jaf+F(k).nL) = Af;      
        A8(ia+1:ia+N(k).n, jag+1:jag+G(k).nG+NG(k).nG) = Ag;
        [ma, naf] = size(Af);
        [~, nag] = size(Ag);
        ia = ia+ma;
        jaf = jaf+naf;
        jag = jag+nag;

end

Aeq = A7;
beq = b7;
[m7,n] = size(A7);
[m8,~] = size(A8);
Aeq(m7+1:m7+m8,1:n) = A8;
beq(m7+1:m7+m8) = b8;


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

% C10
%--------------------------------------------------------------------------
A10 = zeros(nL,ndv);
I = eye(nL);
i=0;
for k = 1:nK
    
A10(:,i+1:i+F(k).nL) = - K.seats(k) .* I(:,F(k).L);
i = i+F(k).nL;
end
% Legs between Hub airports have different capacities
[ia,ja] = find(A10(H,:)~=0);
for i=1:length(ia)
        A10(ia(i),ja(i)) = - 4*54; % 4 buses with 54 seats each
end

% Boundaries
%--------------------------------------------------------------------------
LB = zeros(ndv,1);
UB = ones(ndv,1); UB(nf+1:end)=Inf;

%--------------------------------------------------------------------------

P_FAM.ndv = ndv;
P_FAM.ObjFun =ObjFun;
P_FAM.Aeq = Aeq;
P_FAM.beq = beq;
P_FAM.Aineq = Aineq;
P_FAM.bineq = bineq;
P_FAM.UB = UB;
P_FAM.LB = LB;
P_FAM.A10 = A10;

end








