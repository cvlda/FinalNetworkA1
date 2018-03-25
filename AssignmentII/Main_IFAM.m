% ASSIGNMENT II:  Problem 1
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Itinerary-based formulation (IFAM)
%--------------------------------------------------------------------------


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



%--------------------------------------------------------------------------
%                                 Main IFAM
%--------------------------------------------------------------------------

Opt_col = 0;
Opt_row = 0;
v_addrow = [] ;


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
                      it, P_FAM.A10, v_addcol, v_addrow);
                                       
                                       
         [X,P_PMF, FVAL, pi, sigma] = solveIFAM( P_FAM, P_PMF, v_addrow, num_it );
           
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
                      it, P_FAM.A10, v_addcol, v_addrow);
                                       
                                       
         [X,P_PMF, FVAL, pi, sigma] = solveIFAM( P_FAM, P_PMF, v_addrow, num_it );
         
    end
     
    
end

% Reasume MILP
%--------------------------------------------------------------------------




