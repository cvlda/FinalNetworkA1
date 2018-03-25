% ASSIGNMENT II:  Problem 1
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% PMF: Passenger Mix Flow Problem
%--------------------------------------------------------------------------

function P_PMF = PMF(ndv_FAM, dv, recap, delta, num_flights, num_it,...
                     it, A10_FAM, v_addcol, v_addrow)
                                       
% The size of this problem is for ndv_FAM+ndv_PMF


    ndv=length(dv(:,1)); 

    % Add Columns:
    dv(ndv+1:ndv+length(v_addcol),1) = v_addcol;
    ndv=ndv+length(v_addcol);
    
    num_recap = length(recap(:,1));
    p=recap(:,1);
    r=recap(:,2);
    b=recap(:,3); 
    fare_p=recap(:,4); 
    fare_r=recap(:,5); 

% Objective function
%--------------------------------------------------------------------------
ObjFun=zeros(ndv_FAM+ndv,1);
    for i = 1:ndv
        j = dv(i,1);
        ObjFun(ndv_FAM+i)=fare_p(j)-b(j)*fare_r(j); 
    end   
    
    
% Constraints    
%--------------------------------------------------------------------------    
  
  % C10
  %-------------------------------------------------------------------------- 
  A10 = zeros(num_flights,ndv_FAM+ndv);
  A10(:,1:ndv_FAM) = A10_FAM;
for i=1:ndv
    
    i_recap = dv(i,1);
    itp = recap(i_recap,1)+1;
    itr = recap(i_recap,2)+1;
    b = recap(i_recap,3);
    
    A10(:,ndv_FAM+i) = -(delta(:,itp)-b*delta(:,itr));
end  
    b10 = -delta*it(:,2);
    
    Aineq = A10;
    bineq = b10;
    
    
  % C11
  %-------------------------------------------------------------------------- 
  A11 = zeros(num_it,ndv_FAM+ndv);
  
  % Index of the recapture matrix of each decision vble
  index_r = dv(:,1);
  for j=1:num_it
    
      % origin itinerary for of each dv
      itp = recap(index_r,1)+1;    
    
      % Find all dv with originating itinerary = j
      p = find(itp==j);
    
    if min(size(p))>0 % no dv with originating itinerary = j
    
       A11(j,ndv_FAM+p) = 1;    

    end

  end
    b11 = it(:,2);      
    % Add rows:        
    Aineq=[Aineq;A11(v_addrow,:)];
    bineq = [bineq;b11(v_addrow)];   
    
    
% Boundaries
%--------------------------------------------------------------------------
LB = zeros(ndv_FAM+ndv,1); 

%--------------------------------------------------------------------------

P_PMF.ndv    = ndv;
P_PMF.dv     = dv;
P_PMF.ObjFun = ObjFun;
P_PMF.Aineq  = Aineq;
P_PMF.bineq  = bineq;
P_PMF.LB     = LB;

end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    