% ASSIGNMENT I - Problem 2
%
% TU Delft 2018
%
% Johanna Korte
% Carmen Velarde
%--------------------------------------------------------------------------
% DATA
%--------------------------------------------------------------------------
clear all; close all; clc;

datafile='Input_AE4424_Ass1P2.xlsx'; 

%Load excel data 
[x_Flight_num, x_Flight_txt, x_Flight_raw] = xlsread(datafile,'Flight','A2:F233');
[x_Itinerary_num, x_Itinerary_txt, x_Itinerary_raw] = xlsread(datafile,'Itinerary','A2:G738');
x_RecapRate = xlsread(datafile,'Recapture Rate','A2:E300');

%flight_no:array of flight numbers
%num_flights: number of flights in total
%capacity: array of flight capacities
flight_no=string(x_Flight_txt(:,1));
num_flights=length(flight_no); 
capacity= x_Flight_num(:,3);

%legs = [leg1,leg2]
legs=string(x_Itinerary_txt(:,5:6)); 
legs=[legs;["", ""]]; %Add ficticious 

%It = [no., demand, fare]
it=[x_Itinerary_num(:,1),x_Itinerary_num(:,4),x_Itinerary_num(:,5)]; 
it=[it;[738,10000,0]]; %Add ficticious itinerary with unlimited demand
num_it=length(it(:,1)); 

% Add fictitius itinerary to recaptures
ficticious=zeros(num_it,5); 
ficticious(:,2)=737; %Destination itinerary is 738 for now, because an itinerary 0 already exists
ficticious(:,3)=1; %Recap rate, all people are willing to recap to this one
for i=1:num_it-1
    ficticious(i,1)=i-1; %Origin itinerary 
    ficticious(i,4)=it(i,3); %Fare of preferred itinerary
end 

%Recap = [From It, To It, b, Fare 'From', Fare 'To']
recap_rate = x_RecapRate(:,1:5); 
recap_rate=[ficticious;recap_rate];
num_recap = length(recap_rate(:,1)); 

%Set of already included columns
Set = linspace(1,737,737); 


%Delta matrix, which flight legs part of which itineraries 
delta=zeros(num_flights,num_it); 
for f=1:num_flights
    fnum = flight_no(f); 
    for i=1:num_it
        leg1 = legs(i,1);
        leg2 = legs(i,2);
        % If flight leg part of itinerary, add itinerary demand and add to
        % Delta matrix as 1 
        if fnum==leg1
            delta(f,i)=1;
        elseif fnum==leg2
            delta(f,i)=1; 
        end   
    end
end 

save('Data_prob2')
