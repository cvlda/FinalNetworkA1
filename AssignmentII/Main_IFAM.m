% ASSIGNMENT II:  Problem 1
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Itinerary-based formulation (IFAM)
%--------------------------------------------------------------------------

clear all; close all; clc;
% FAM Formulation
%--------------------------------------------------------------------------
P_FAM = FAM;


load('Data_PMF')


% PMF Formulation
%--------------------------------------------------------------------------

% RMP: Ficticious
%--------------------------------------------------------------------------

P_PMF.ndv = length(ficticious(:,1)); 
P_PMF.dv(:,1) = [1:P_PMF.ndv]';

%Objective function
P_PMF.ObjFun=zeros(P_FAM.ndv+P_PMF.ndv,1);
for i=1:P_PMF.ndv
    P_PMF.ObjFun(P_FAM.ndv+i) = it(i,3); %fare 
end

% C10
%--------------------------------------------------------------------------
  A10 = zeros(nL,P_FAM.ndv+P_PMF.ndv);
  A10(:,1:P_FAM.ndv) = P_FAM.A10;
for i=1:P_PMF.ndv
    
    i_recap = P_PMF.dv(i,1);
    itp = recap(i_recap,1)+1;
    itr = recap(i_recap,2)+1;
    b = recap(i_recap,3);
    
    A10(:,P_FAM.ndv+i) = -(delta(:,itp)-b*delta(:,itr));
end  
    b10 = -delta*it(:,2);
    
    P_PMF.Aineq = A10;
    P_PMF.bineq = b10;

P_PMF.LB = zeros(P_FAM.ndv+P_PMF.ndv,1); 
P_PMF.UB = []; 


% Solve initial IFAM
%--------------------------------------------------------------------------
[X,P_PMF, FVAL, pi, sigma] = solveIFAM( P_FAM, P_PMF, [], num_it );

initial_constraints = 1864 + length(P_PMF.Aineq(:,1));
initial_variables = length(X);
initial_objective = FVAL;
%--------------------------------------------------------------------------
%                                 Main IFAM
%--------------------------------------------------------------------------

Opt_col = 0;
Opt_row = 0;
v_addrow = [] ;

iterations = 0;
% generation_matrix keeps track of added columns and rows for each
% iteration, in addition to the total number of variables and constraints at
% every iteration
% (1,:) are added rows, (2,:) are added columns, (3,:) is total number of
% constraints, (4,:) is the total number of variables
generation_matrix = [];
fval_evolution = [];
while Opt_col==0 || Opt_row==0
    while Opt_col == 0
                   
        % Solve pricing problem
        [Opt_col, v_addcol] = AddColumns(P_PMF.dv, recap, num_recap,  delta, pi, sigma);
         if Opt_col==1
             break;
         else
             Opt_row = 0;
         end  
    
        % Column generation
          P_PMF = PMF(P_FAM.ndv, P_PMF.dv, recap, delta, nL, num_it,...
                      it, P_FAM.A10, v_addcol, 1, v_addrow);
                                       
                                       
         [X,P_PMF, FVAL, pi, sigma,IFAMformulation] = solveIFAM( P_FAM, P_PMF, v_addrow, num_it );
         iterations=iterations+1;
         generation_matrix(2,iterations)=length(v_addcol);
         generation_matrix(3,iterations)=length(IFAMformulation.Aineq(:,1))+length(IFAMformulation.Aeq(:,1));
         generation_matrix(4,iterations)=length(IFAMformulation.Aineq(1,:)); 
         fval_evolution(iterations)=FVAL;
    end
    
    
    while Opt_row == 0                                 
    
        % Solve separation problem
         [Opt_row, v_addrow] = AddRows(v_addrow, P_PMF.dv, it, recap, num_it);
         if Opt_row==1
             break;
         else
             Opt_col = 0;
         end
         
        % Row generation
          P_PMF = PMF(P_FAM.ndv, P_PMF.dv, recap, delta, nL, num_it,...
                      it, P_FAM.A10, v_addcol, 1, v_addrow);
                                       
                                       
         [X,P_PMF, FVAL, pi, sigma,IFAMformulation] = solveIFAM( P_FAM, P_PMF, v_addrow, num_it ); 
         iterations=iterations+1;
         %Add number of added rows to matrix 
         if iterations > 1
            generation_matrix(1,iterations)=length(v_addrow)-sum(generation_matrix(1,1:iterations-1));
         else 
            generation_matrix(1,iterations)=length(v_addrow);
         end
         fval_evolution(iterations)=FVAL;
         generation_matrix(3,iterations)=length(IFAMformulation.Aineq(:,1))+length(IFAMformulation.Aeq(:,1));
         generation_matrix(4,iterations)=length(IFAMformulation.Aineq(1,:)); 
    end
end

% Reassume MILP
%--------------------------------------------------------------------------
[X,FVAL,flag] = solveMILP(X,IFAMformulation); 
iterations=iterations+1;
fval_evolution(iterations)=FVAL;

% Plot objective function
%--------------------------------------------------------------------------
figure 
plot(1:iterations+1,horzcat(initial_objective,fval_evolution),'Color',[0,0.6509,0.8392]); 
xlabel('Iteration');
ylabel('Objective value'); 
title('Objective Function Evolution')
grid on

% Flights operated by A340
% -------------------------------------------------------------------------
load('Data_FAM.mat','F','H')
k = 2; % A340 aircraft type
A340_legs = OperatedFlights(F, X, k);
B737_legs = OperatedFlights(F, X, 3);
B738_legs = OperatedFlights(F, X, 4);
% Flights operated by B737 and B738
% --------------------------------------------------------------------------
B73_legs = sort([round(nonzeros(OperatedFlights(F, X, 3))); round(nonzeros(OperatedFlights(F, X, 4)))]); 

save('B73','B73_legs')
%Correct for flights operated by buses
% for i = 1:F(k).nL
%     if sum(A340_legs(i)==H)>0
%         A340_legs(i)=0;
%     end
% end

%Print A340 flights table
% fprintf('\\textbf{Flight Number} \\\\ \n')
% for i = 1:length(A340_legs)
%     if A340_legs(i)>0
%         fprintf('%s \\\\ \n', Lset{i})
%     end
% end 

% Spilled pax 
%--------------------------------------------------------------------------
% Spill = zeros(num_it,1); 
% Recaptured = zeros(num_it,1); 
% 
% for i=2532:length(X)
%     spilled = X(i); 
%     
%     %translate index in X go to index in P_PMF.dv 
%     P_PMF_dv_index = i - 2531; 
%     %tranlate index in P_PMF.dv go to index in recap
%     recap_index = P_PMF.dv(P_PMF_dv_index,1); 
%       
%     source = recap(recap_index,1) + 1;  %source it index in it
%     target = recap(recap_index,2) + 1;  %target it index in it 
%    
%     if target==738 %if target is fictitious itinerary
%         %add spill to fictitious 
%         Spill(source) = spilled; 
%     else
%         Recaptured(source) = Recaptured(source) + spilled;
%     end  
% end 
% 
% %print latex table 
% fprintf("Itinerary & Spill \\\\ \n");
% nonzero = find(Spill);
% for k=1:length(nonzero)
%     %k is itinerary index 
%     element = nonzero(k);
%     fprintf("$i_{%i}$ & %i \\\\ \n",element-1,round(Spill(element)));
% end 



