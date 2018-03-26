% ASSIGNMENT I
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Read me
%--------------------------------------------------------------------------

Structure for Assignment I source code:

Running data.m files creates a data.mat, need for the Excel File sheet.

Problem 1:
%--------------------------------------------------------------------------

Data: Data_prob1
      test_prob1 - aimed for validation


1.1. Main: ArcBasedFormulation      
      
1.2. Main: Column Generation Algorithm

     Functions Library: GenerateSet   - Integrates new columns into problem
                        SolveRPM1     - Main solver 

     Results: Results_PathBasedF.mat  - Optimality conditions are saved in 
                                        a structure OC

Problem 2:
%--------------------------------------------------------------------------

Data: data_prob2
      test_prob2 - aimed for validation

1.1 Main: MixFlowProblem
 
     Functions library: AddColumns
                        AddRows
                        buildC7       - Constraint (7)
                        ConstraintC6  - Constraint (6)   
                        SolveRPM2     - Main solver                     
