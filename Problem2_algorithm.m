% ASSIGNMENT I - Problem 2
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Combined Column and Row generation Algorithm 
%--------------------------------------------------------------------------
clear all; close all; clc;

% Load data for the problem
load('Data_prob2.mat');
% load('Data_prob2.mat');


%Loop over flights and itineraries to make path matrix delta with as 
%rows flights,and itineraries as columns. Is 1 when flight is in itinerary.
delta=zeros(num_flights,num_it); 
for f=1:num_flights
    fnum = flight_no(f); 
    for i=1:num_it
        leg1 = legs(i,1);
        leg2 = legs(i,2);
        % If flight leg part of itinerary, add itinerary demand and add to
        % Delta matrix as 1 
        if fnum==leg1 %|| fnum==leg2
            delta(f,i)=1;
        elseif fnum==leg2
            delta(f,1)=1; 
        end   
    end
end 

%_______________RPM________________________________________________________
%Decision variables t^0_1, t^0_2, ..., (t^1_1, t^1_2 ....)
numdv=num_it; 
dv(:,1)=[1:numdv]';

%Objective function
obj=zeros(numdv,1);
for i=1:numdv
    obj(i) = it(i,3); %fare 
end

%Constraints (6)
% C6=zeros(num_flights,numdv); 
% for f=1:num_flights
%     for i=1:numdv
%         %-1 because of >= 
%         C6(f,i)=-1 * delta(f,i); 
%     end        
% end
p=recap_rate(:,1);
r=recap_rate(:,2);
b=recap_rate(:,3); 
fare_p=recap_rate(:,4); 
fare_r=recap_rate(:,5); 
C6=zeros(num_flights,numdv); 
    for f=1:num_flights
        for p6=1:num_it
            for r6=1:num_it
                recap_index = find(r==r6 & p==p6); %Find right index for dv
                if isempty(recap_index)
                    continue 
                else
                    dv_index = find(dv(:,1)==recap_index);
                    C6(dv_index)= C6(dv_index) -1* delta(f,p6); %-1 because >= constraint
                end     
            end   
        end   
        
        for r6=1:num_it
            for p6=1:num_it
                recap_index = find(r==p6 & p==r6); 
                if isempty(recap_index)
                    continue
                else
                    dv_index = find(dv(:,1)==recap_index); 
                    C6(dv_index)= C6(dv_index) -1 * -1*b(recap_index);  %-1 because >= constraint and in constraint      
                end  
            end
        end 
           
    end
    disp('columns 6 added')

%Because constraint >= multiply by -1 
rhs6=delta*it(:,2)-capacity; 
rhs6 = rhs6*-1;
rhs=rhs6;
Aineq=C6; 

lb = zeros(numdv,1); 
ub = []; 
[x,fval,exitflag,output,lambda] = linprog(obj,Aineq,rhs,[],[],lb,[]); 
pi = lambda.ineqlin;
sigma  = - lambda.eqlin;
if min(size(sigma))==0
    sigma=zeros(num_it,1);
end
dv(:,2)= x;
disp('Solved initial RPM')

% Main Passenger Mix Flow:
%--------------------------------------------------------------------------

Opt_col = 0;
Opt_row = 0;
v_addrow = [] ;


while Opt_col==0 || Opt_row==0
    
    while Opt_col == 0
                   
        % Solve pricing problem
        [Opt_col, v_addcol] = AddColumns(recap_rate, num_recap,  delta, pi, sigma);
        disp('Pricing problem solved') 
        
         if Opt_col==1
             break;
         else
             Opt_row = 0;
         end  
    
        % Column generation
        [dv, FVAL, pi, sigma] = SolveRPM2(dv,recap_rate,delta,num_flights,num_it,capacity,it, v_addcol, v_addrow);
        disp('Column Generation done')
    
    end
    
    
    while Opt_row == 0                                 
    
        % Solve separation problem
         [Opt_row, v_addrow] = AddRows(dv, it, recap_rate, num_it);
         disp('separation problem solved')
         
         if Opt_row==1
             break;
         else
             Opt_col = 0;
         end
         
        % Row generation
        [dv, FVAL, pi, sigma] = SolveRPM2(dv,recap_rate,delta,num_flights,num_it,...
                                          capacity,it, v_addcol, v_addrow);
        disp('Row generation solved')
    end
     
    
end



    
    
    
    

