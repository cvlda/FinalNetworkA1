function [dv, FVAL, pi, sigma] = solveRPM2(dv,recap_rate,delta,num_flights,...
                                           num_it,capacity,it, v_addcol, v_addrow)

% Inputs:
% dv :: Array of size numdvx2 with decision variables:
%       dv(:,1) = index  :: Location in recap_rate of the recapture itinerary
%       dv(:,2) = X      :: Value of the decision variable (Empty at input)

%__________________________________________________________________________


    numdv=length(dv(:,1)); 
    % Add Columns:
    dv(numdv+1:numdv+length(v_addcol),1) = v_addcol;
    numdv=numdv+length(v_addcol);
    
    num_recap = length(recap_rate(:,1));
    p=recap_rate(:,1);
    r=recap_rate(:,2);
    b=recap_rate(:,3); 
    fare_p=recap_rate(:,4); 
    fare_r=recap_rate(:,5); 
    
    %Objective function
    obj=zeros(numdv,1);
    for i = 1:numdv
        j = dv(i,1);
        obj(i)=fare_p(j)-b(j)*fare_r(j); 
    end         
    
    
    % Constraints
    Aineq = zeros(num_flights,numdv);
    rhs   = zeros(num_flights,1);
    
    %Constraints (6)
    [Aineq,rhs] = ConstraintC6(dv, recap_rate, it,capacity, delta,num_flights);

    %Constraints (7)
    Aineq7      = buildC7(dv, recap_rate, num_it);
    rhs7        = it(:,2);      
    % Add rows:        
    Aineq=[Aineq;Aineq7(v_addrow,:)];
    rhs = [rhs;rhs7(v_addrow)];
    
    % Solve optimization problem
    lb = zeros(numdv,1); 
    ub = []; 
    [X,FVAL,exitflag,output,lambda] = linprog(obj,Aineq,rhs,[],[],lb,ub); 
    
    % Dual variables associated to C6
    pi = lambda.ineqlin(1:num_flights);
    % Dual variables associated to C7
    sigma=zeros(num_it,1);
    if length(v_addrow)>0
    sigma(v_addrow)=lambda.ineqlin(num_flights+1:end);
    end
    
    % Decision variables
    dv(:,2) = X;

end 
