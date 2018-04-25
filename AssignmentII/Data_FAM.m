% ASSIGNMENT II - Problem 1
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% DATA FAM
%--------------------------------------------------------------------------

clear all; close all; clc;

datafile='Assignment2.xlsx'; 

%Load excel data 
%--------------------------------------------------------------------------
[Flight_num, Flight_txt, Flight_raw] = xlsread(datafile,'Flight','A2:I233');
[Aircraft_num, Aircraft_txt, Aircraft_raw] = xlsread(datafile,'Aircraft','A2:D5');

% Aircraft Type:
%--------------------------------------------------------------------------
Kset  = Aircraft_txt;
nK = length(Kset);

K.units = Aircraft_num(:,1);
K.seats = Aircraft_num(:,2);
K.TAT   = Aircraft_num(:,3)./60./24;  % days

% Flight legs:
%--------------------------------------------------------------------------
Lset = Flight_txt(:,1);
nL =  length(Lset);

L.c = Flight_num(:,2+1:2+nK);

for i = 1:nL
    O.l(i) = Flight_raw(i,2);
    O.t(i) = Flight_num(i,1);
    I.l(i) = Flight_raw(i,3);
    I.t(i) = Flight_num(i,2);    
end
O.l = O.l';
O.t = O.t';
I.l = I.l';
I.t = I.t';

% Airports:
%--------------------------------------------------------------------------
A(1:nL) = Flight_raw(:,2);
A(nL+1:nL*2) = Flight_raw(:,3);
Apset = unique(A)';
nAp = length(Apset);

% Assign flights to fleet:
%--------------------------------------------------------------------------
    % Ak matrix: rows = legs, cols =  AC type (K)
    %            1 if leg belongs to AC type / 0 otherwise  
    A_lk = zeros(nL,nK);
for k = 1:nK
    A_lk(:,k) = not(strcmp(Flight_txt(:,5+k),'NA'));
end

% Separate ground arcs between Hub airports
% -------------------------------------------------------------------------- 
Hub = {'AEP', 'EZE'};

iground = 0;
for i = 1:nL
    
    % Ground legs:
    if (sum(strcmp(Flight_raw(i,2:3), Hub)) == 2) ||  (sum(strcmp(Flight_raw(i,2:3), fliplr(Hub))) == 2)
        iground = iground+1;
        H(iground) = i;
        
        L.c(i, A_lk(i,:)==1 ) = 4500; % Cost of flights operated by buses
    end
end

% Nodes (N(k).t / N(k).l) and flight legs (F(k).L) associated to fleet:
%--------------------------------------------------------------------------

for k=1:nK
    
    p    = 0;  % Index in Nk set (Nodes_k)
    op   = 0;  % Index in O set (Origin_k)
    ip   = 0;  % Index in I set (Terminate_k)
    ileg = 0;  % Index in flight legs of k
    
    N(k).t = [];
    N(k).l = {};
    for i=1:nL
        if A_lk(i,k)
           ileg = ileg+1; 
           F(k).L(ileg) = i;
           
           % Find if O node already exists 
           jO=find(( N(k).t == O.t(i)) & ( strcmp(N(k).l, O.l(i))));
           if isempty(jO) 
           p = p+1; 
           N(k).l(p) = O.l(i);
           N(k).t(p) = O.t(i);
                     
            F(k).arc(ileg,1) = p;
           else

             F(k).arc(ileg,1) = jO;
           end           

           % Find if I node already exists        
           jI=find(( N(k).t == I.t(i)+K.TAT(k)) & ( strcmp(N(k).l, I.l(i))));
           if isempty(jI) 
                   p = p+1;
                   N(k).l(p) = I.l(i);
                   N(k).t(p) = I.t(i)+K.TAT(k); 
                   
                   F(k).arc(ileg,2) = p;
           else 
                   F(k).arc(ileg,2) = jI;
               
           end           
        
        end
    end 
    N(k).n = length(N(k).t);
    F(k).nL = ileg;
end


% Ground arcs ( G(k).arc = [n+, n-] ) associated to fleet:
%--------------------------------------------------------------------------

for k = 1:nK
    
    iground = 0;
    iovernight = 0;
     
  for i = 1:nAp
            
    % Pointer to Nk set of nodes at Airpot(i)  
    i_n = find(strcmp(N(k).l, Apset{i}) ); 
    
    % Sort them in time
    [nsorted, nindex] =  sort(N(k).t(i_n));  

         if length(i_n)>1
         
           for j = 1:length(i_n)-1
               iground = iground+1;
               
               G(k).arc(iground,1:2) = [ i_n(nindex(j)), i_n(nindex(j+1))];
           end
         end
         % Night ground arc         
         if not(isempty(i_n))
           iovernight = iovernight+1;
             
           NG(k).arc(iovernight,1:2) = [ i_n(nindex(end)), i_n(nindex(1))];

         end
  end
  G(k).nG = iground;
  NG(k).nG = iovernight;
         
end
       



% Ground arcs in A330 aircraft type
%--------------------------------------------------------------------------
k = 1;
% Number of ground arcs between hub airports
y=0;
for i = 1:F(k).nL    
    if sum(F(k).L(i)==H)>0
        y = y+1;
    end
end

fprintf('Ground arcs in aircraft:    %s\n',Kset{k})
fprintf('Total ground arc:    %6f\n',y+G(k).nG+NG(k).nG)
fprintf('Ground arc:    %6f\n',G(k).nG)
fprintf('Total ground arc:    %6f\n',NG(k).nG)
fprintf('Arcs between hub airports:    %6f\n',y)




 

save('Data_FAM')
