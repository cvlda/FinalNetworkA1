% ASSIGNMENT II:  Problem 2
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% Crew Scheduling
%--------------------------------------------------------------------------
% Please run the MainIFAM.m first, to obtain the 737-700 and 737-800 flight
% legs for this problem!
%--------------------------------------------------------------------------
load('Data_FAM.mat', 'O', 'I', 'Lset'); 
load('B73.mat')
flightindices = B73_legs; 

% Make flight arcs 
%----------------------------------------------------------------------
num_legs = length(flightindices); 
Origin.a = cell(num_legs,1); 
Origin.time = zeros(num_legs,1); 
Origin.fnum = cell(num_legs,1); 
Destination.a = cell(num_legs,1); 
Destination.time = zeros(num_legs,1); 
Destination.fnum = cell(num_legs,1); 

%Import all flight legs and make new structs 
for i=1:num_legs
    Origin.a(i) = O.l(flightindices(i)); 
    Origin.time(i) = O.t(flightindices(i)); 
    Origin.fnum(i) = Lset(flightindices(i)); 
    Destination.a(i) = I.l(flightindices(i)); 
    Destination.time(i) = I.t(flightindices(i)); 
    Destination.fnum(i) = Lset(flightindices(i)); 
end 

% Ground arcs between indices in the Origin and Destination structures 
%----------------------------------------------------------------------
min_length = 45/(60*24); %45 minutes divided by total minutes in day
max_length = 180/(60*24);
Departing_AEP = find(ismember(Origin.a,'AEP'));

%Ground legs are indicated as a relation between two flight legs. 
Ground.fromindex = [];
Ground.fromleg = {}; 
Ground.toindex = []; 
Ground.toleg = {}; 
Ground.duration = []; 

for i=1:num_legs
    % Check if not itself
    for j=1:num_legs
        if i~=j %Cannot connect to two the same flight legs. 
            if strcmp(Destination.a(i),Origin.a(j)) %ground legs can only exist 
                %when flights are connected at the same airport. 
                delta = Origin.time(j) - Destination.time(i); 
                if delta < 0 %Check if departure j is earlier than arrival i (next day case)
                    delta = 1-Destination.time(i)+Origin.time(j); 
                end 
                %check if flight is in between maximum groundleg length
                if delta >= min_length && delta <= max_length
                    Ground.fromindex = [Ground.fromindex i]; 
                    Ground.fromleg{end +1} = Destination.fnum(i); 
                    Ground.toindex = [Ground.toindex j]; 
                    Ground.toleg{end+1} = Origin.fnum(j); 
                    Ground.duration = [Ground.duration delta]; 
                end  
            end  
        end 
    end
end 

save('crewpairing.mat'); 

%Generate all possible pairings of length 2 to max_legs
%__________________________________________________________________________
paths = {};
max_flights = 4; 
max_duty_time = 8/24; 
base = 'AEP'; 

%get indices in Origin of flights departing from base 
legs_from_base = [];
for b=1:length(Origin.a)
    if Origin.a{b} == base
        legs_from_base = [legs_from_base b];
    end
end  
legs_from_base = legs_from_base'; 

all_pairs = [];
for l=1:length(legs_from_base)
    initial_solution = legs_from_base(l);
    if isempty(all_pairs)
        all_pairs = find_all_paths(initial_solution,Ground,max_flights); 
    else 
        all_pairs = [all_pairs ;find_all_paths(initial_solution,Ground,max_flights)];
    end 
end

%Remove violating pairings
%__________________________________________________________________________
allowed_pairs = []; 

for a=1:length(all_pairs(:,1))
    duty = all_pairs(a,:);
    %2 or more flights
    non_zero = find(duty); 
    if length(non_zero) >= 2
       %Test if ends at base 
       first_leg = duty(1); 
       last_leg = duty(non_zero(end));
       if Destination.a{last_leg}== base
           %Test if within duty time
           delta = Destination.time(last_leg) - Origin.time(first_leg); 
           if delta < 0
               delta = 1-Origin.time(first_leg)+Destination.time(last_leg);
           end 
           if delta <= max_duty_time
               allowed_pairs = [allowed_pairs ; duty];  
           end
       end    
    end
end 

%Find one day pairing using Greedy
%__________________________________________________________________________
covered_legs = unique(allowed_pairs);
all_covered_legs = reshape(allowed_pairs,[length(allowed_pairs(:,1))*max_flights,1]); 
all_covered_legs(all_covered_legs==0) = [];
all_unique_legs = unique(all_covered_legs); 

cover = []; %cover of the flight legs
pairs = []; %index of allowed_pairs matrix 
while isempty(setdiff(all_unique_legs,cover)) == 0
    max = 0;
    max_duty=[]; 
    max_index = 0; 
    %loop over all pairs in allowed_pairs
    for p=1:length(allowed_pairs)
        duty = allowed_pairs(p,:); 
        duty(duty==0)=[];
        %Calculate how many not yet added legs this duty will add to cover
        value = length(setdiff(duty,cover));         
        if value > max
            max = value;
            max_duty = duty; 
            max_index = p; 
        end
    end
    if max == 0 
        break
    end 
    cover = [cover max_duty]; 
    pairs = [pairs ; allowed_pairs(max_index,:)]; 
end 

%Print latex table 
%__________________________________________________________________________
i=1; 
for p=1:length(pairs(:,1))
    pair = pairs(p,:); 
    pair(pair==0)=[]; 
    fprintf('%i& ',i)
    for q=1:length(pair)
        leg = pair(q); 
        fprintf('%s ',Origin.fnum{leg})
    end 
    fprintf(' & %s ',Origin.a{pair(1)})
    for q=1:length(pair)
        leg = pair(q); 
        fprintf('%s ',Destination.a{leg})
    end 
    fprintf('& %.2f', DutyTime(pair,Origin,Destination)*24)
    fprintf('\\\\ \n')
    i=i+1; 
end 