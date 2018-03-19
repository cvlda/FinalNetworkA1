% ASSIGNMENT Ia:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% DATA for validation 
%--------------------------------------------------------------------------

clear all; close all; clc;
% Note: All arrays are writen in columns.


n = 5;
% Cost
C = [1 1 2 4 8 5 3]';
% Capacity
u = [20 10 10 20 40 10 30]';
% Commodity
d =  [15 5 10 5]';

% Assign node number to arcs:
nA = 7;
Oa = [1 1 2 2 3 3 4]'; 
Da = [2 3 3 4 4 5 5]';

  Network =  digraph(Oa,Da,C);

 
% Assign node number to Commodity:
nK=4;
Ok = [1 1 2 3]'; 
Dk = [4 5 5 5]';


    
  save('test_prob1')
    
