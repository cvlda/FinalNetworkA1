% ASSIGNMENT II
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Read me
%--------------------------------------------------------------------------

Structure for Assignment II source code:

Running data.m files creates a data.mat, needs the Assignment's Excel File sheet.

Problem 1:
%--------------------------------------------------------------------------

1.1. Main: Data_FAM
           Data_PMF     
      
1.2. Main: IFAM Problem

     Functions Library: Data_FAM      - Network data FAM problem
                        FAM           - FAM optimization problem, matrix construction
                        Data_PMF      - Network data PMF problem
                        PMF           - PMF optimization problem, matrix construction
                        solveIFAM     - Merge problems
                        solveMILP     - Reassume Integer variables 
                        AddColumns    
                        AddRows
                        OperatedFlights
                        Main_IFAM     - Main file


Problem 2:
%--------------------------------------------------------------------------

Data: data_prob2
      test_prob2 - aimed for validation

1.1 Main: MixFlowProblem
 
     Functions library: Duty Time
                        find_all_paths
                        Main_CrewPairing
                        neighbors  