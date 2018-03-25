% ASSIGNMENT Ib:  Mix Flow Problem
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

clear all; close all; clc;

load('Data_prob2.mat')
%load('test_prob2.mat')

%_______________RPM________________________________________________________
%Decision variables t^0_1, t^0_2, ..., (t^1_1, t^1_2 ....)
numdv=length(ficticious(:,1)); 
dv(:,1)=[1:numdv]';

%Objective function
obj=zeros(numdv,1);
for i=1:numdv
    obj(i) = it(i,3); %fare 
end

%Constraints (6)
[Aineq,rhs] = ConstraintC6(dv, recap_rate, it, capacity, delta, num_flights);

lb = zeros(numdv,1); 
ub = []; 

[x,fval,exitflag,output,lambda] = linprog(obj,Aineq,rhs,[],[],lb,[]); 

pi = lambda.ineqlin;
sigma  = - lambda.eqlin;
if min(size(sigma))==0
    sigma=zeros(num_it,1);
end
dv(:,2)= x;

% Main Passenger Mix Flow:
%--------------------------------------------------------------------------

Opt_col = 0;
Opt_row = 0;
v_addrow = [] ;


while Opt_col==0 || Opt_row==0
    
    while Opt_col == 0
                   
        % Solve pricing problem
        [Opt_col, v_addcol] = AddColumns(dv, recap_rate, num_recap,  delta, pi, sigma);        
         if Opt_col==1
             break;
         else
             Opt_row = 0;
         end  
    
        % Column generation
        [dv, FVAL, pi, sigma] = SolveRPM2(dv,recap_rate,delta,num_flights,num_it,capacity,it, v_addcol, v_addrow);
    end
    
    
    while Opt_row == 0                                 
    
        % Solve separation problem
         [Opt_row, v_addrow] = AddRows(v_addrow, dv, it, recap_rate, num_it);       
         if Opt_row==1
             break;
         else
             Opt_col = 0;
         end
         
        % Row generation
        [dv, FVAL, pi, sigma] = SolveRPM2(dv,recap_rate,delta,num_flights,num_it,...
                                          capacity,it, v_addcol, v_addrow);
    end
        
    
end

% Results
%--------------------------------------------------------------------------
fprintf('Objective Function:    %6f\n',FVAL)

%print flow table for flights between AEP and EZE 
print_flow_table(dv,delta,it,recap_rate,x_Flight_txt)

%print flow table per itinerary for flights between AEP and EZE 




