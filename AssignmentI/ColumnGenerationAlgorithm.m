% ASSIGNMENT Ia:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Column Generation Algorithm
%--------------------------------------------------------------------------
clear all; close all; clc;

% Load data for the problem
load('Data_prob1.mat')

% Load data for validation
% load('test_prob1.mat')

% A. Initial set of columns for RMP:  shortest path algorithm
%--------------------------------------------------------------------------

Set1 = zeros(nA,nK);
Ap = zeros(nA,nK);
Kp = zeros(nK,nK);

% Path structure:
% K(k).P(p).path =[];
% p    :: path counter
% k    :: commodity counter
% path :: array containing the nodes in order of the path

p = 1; 

for i = 1:nK
    
K(i).P(p).path = shortestpath(Network,Ok(i),Dk(i));

%    % Set1 is the initial set of columns.
%    % The rows correspond to each arc, the columns to the path of each
%    % commodity. The elements are the quantities. 
%    % ( See tableaux path formulation )
   for j=1:length(K(i).P(p).path)-1
       
       ni = K(i).P(p).path(j);
       nj = K(i).P(p).path(j+1); 
       
   i_arc = find(Oa==ni & Da==nj);
       
   Set1(i_arc,i) = d(i);
   
   % path arc matrix: 
   Ap(i_arc,i) = 1;
   
   end
   
   % path commodity matrix:
   Kp(i,i) = 1;

end
K0=K;
Ap0=Ap;
Kp0=Kp;
% Compute slack variables:
%--------------------------------------------------------------------------
stemp = sum(Set1')'-u;
s = max(0,stemp);
ns = length(find(s>0));

figure
map = plot(Network,'Layout','force','EdgeLabel',Network.Edges.Weight);
highlight(map, K(1).P(p).path,'EdgeColor','red')


% Iteration
%--------------------------------------------------------------------------
Maxit = 100;
Set   = Set1;
it    = 1;
stop_cond = 0;

while stop_cond == 0 && it < Maxit
% B. Solve RMP
%--------------------------------------------------------------------------
[f, fval, pi, sigma] = solveRPM1(u,C,nK,nA,d,Set,Kp,Ap,s);
fval


% C. Modify costs and pricing problem
%--------------------------------------------------------------------------

cost = C-pi;
[K, Set, Ap, Kp, stop_cond] = GenerateSet(C,pi,Oa, Da, nA, Ok, Dk, nK, K, Set, cost, sigma, d);

it=it+1;
end

% Results:
Results.pi = pi;
Results.sigma = sigma;
Results.f = f;
Results.OF = fval;
Results.Kstructure = K;

Results.Ap = Ap;
Results.Kp = Kp;



% Check optimality conditions

% 1. Primal feasibility:

Results.OC.PrimalF1 = Ap*((Kp'*d).*f(1:end-ns))-u; % <=0
Results.OC.PrimalF2 = Kp*f(1:end-ns)-1; % =0

% 2. Complementary slackness
Results.OC.Compslack1 = pi.*(Ap*((Kp'*d).*f(1:end-ns))-u); %=0
Results.OC.Compslack2 = sigma.*(Kp*f(1:end-ns)-1); %=0

%3. Dual feasibility
Results.OC.DualFeas =  Ap'*(C-pi)-Kp'*(sigma./d); %>=0


save('Results_PathBasedF','-struct', 'Results')

% Results
%--------------------------------------------------------------------------
fprintf('Objective Function:    %6f\n',fval)

fprintf('number of iterations:  %2i\n',it-1)
