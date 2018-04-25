% ASSIGNMENT II:  Problem 1.3
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Strategy to study the new demand per itinerary
%--------------------------------------------------------------------------

disp('Run first Main_IFAM')

i_recap = P_PMF.dv(:,1);
p=recap(i_recap,1);
r=recap(i_recap,2);

tpr = X(P_FAM.ndv+1:P_FAM.ndv+P_PMF.ndv);


new_D=it(:,2);

for i=1:length(i_recap)
    
   new_D(p(i)+1) = new_D(p(i)+1)-tpr(i);
   new_D(r(i)+1) = new_D(r(i)+1)+tpr(i);
     
end



figure
plot(it(:,1),sigma,'r')
hold on
plot(it(:,1),new_D,'b')
hold on
plot(it(:,1),it(:,3),'c')

legend('\sigma','New Demand','fare')

