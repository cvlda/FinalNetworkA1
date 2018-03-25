% ASSIGNMENT Ia:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Increase 1 unit of capacity
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


% Increase 1 unit of capacity 
%--------------------------------------------------------------------------

i_inc = find(s>0);
i_arc=zeros(nA,1);

OF=zeros(size(nA/2));

for i=1:length(i_inc)

    if i_inc(i)<=nA/2
        i_arc(i_inc(i)) = 1;
        i_arc(i_inc(i)+nA/2) = 1;
    else
        i_arc(i_inc(i)) = 1;
        i_arc(i_inc(i)-nA/2) = 1;    
    end
    
    
    for j=1:nA/2
        if i_arc(j)==1
        u_mod=u;
        u_mod(j) = u_mod(j)+1;
        u_mod(j+nA/2) = u_mod(j)+1;
        
        OF(j)=f_increaseC(K0,Ap0, Kp0,Set1,u_mod);
        end
    end
end

    
figure
Plot_increaseC([1:30],OF)
axis([0 31 2585 2633])

% Results
%--------------------------------------------------------------------------
fprintf('Route to increase 1 unit of capacity:   %d\n',8)