% ASSIGNMENT Ia:  Air Cargo Multi-commodity Flow
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Column generation: Adding new columns to existing set
%--------------------------------------------------------------------------


function [K, Set, Ap, Kp, stop_cond] = GenerateSet(C,pi,Oa, Da, nA, Ok, Dk, nK, K, Set1, cost, sigma, d)

Network  = digraph(Oa,Da,cost);

np = 0;
% Path counter in new set
npold=0;
% Patch counter in previous set
npold1=0;

% Stop condition:
stop_cond = 0;

for k=1:nK

   path = shortestpath(Network,Ok(k),Dk(k));
   
   
   % Find arcs corresponding to arcs:
   Ap_temp  = zeros(nA,1);
   set_temp = zeros(nA,1);
   for j=1:length(path)-1
       
       ni = path(j);
       nj = path(j+1); 
       
       i_arc = find(Oa==ni & Da==nj);
         
      Ap_temp(i_arc)  = 1;
      set_temp(i_arc) = d(k);
   
   end
  
   
       np = length(K(k).P);
       Set(1:nA,1+npold:np+npold)= Set1(:,1+npold1:np+npold1);
       Kp(k,1+npold:np+npold) = 1;
       
           npold=npold+np;
           npold1=npold1+np;
           
           % check new path to be different from old ones:
           rep_path=0;
           for p=1:np
               if length(K(k).P(p).path)==length(path)
                  if  K(k).P(p).path == path
                      rep_path = 1;
                  end
               end
           end

   if ((Ap_temp'*cost) < (sigma(k)/d(k))) && (rep_path ==0)    
           Set(:,npold+1) = set_temp;
           Kp(k,1+npold)  = 1;
           K(k).P(np+1).path = path;
           npold=npold+1;

   end

   
end

Ap=Set;
Ap(find(Set>0))=1;

if size(Set)==size(Set1)
    stop_cond=1;
end

end
