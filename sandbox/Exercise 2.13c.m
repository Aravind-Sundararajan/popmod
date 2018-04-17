%%% Third Script for Exercise 2.13, Ellner & Guckenheimer
%%% Data from Brault and Caswell 1993 Ecology 74:1444
%%% for killer whales (Orcinus orca)


%%% Four age-stage classes
%%% Yearlings, Juveniles, Mature, Postreproductive

%%% Growth matrix

A=[0	0.0043	0.1132	0;
0.9775	0.9111	0	0;
0	0.0736	0.9534	0;
0	0	0.0452	0.9804];

%% Finish time (years)
T=50;

%% Create a data matrix to store output (numbers per class at time t)
%% rows are classes, columns will be time steps
n=zeros(4,T);

%% Initial condition
n(1,1)=10;n(2,1)=60;n(3,1)=110;n(4,1)=70;

%% Growth dynamics given by n(t=2)=A*n(t=1), n(t=3)=A*n(t=2), etc.
%% Use a loop command to ask the computer to repeat the 
%% matrix multiplication step (like dragging down to fill in columns in Excel).

for t=2:T;		%% repeat the action until time t=Finish time T
   n(:,t)=A*n(:,t-1);   
end

%% calculate total population size at each time-step
N=sum(n); 		%% Matlab sums columns of data matrices by default

figure(1);
plot(1:T,N);
xlabel('Time (years)');
ylabel('Total Population size')

figure(2);plot(1:T-1,N(2:T)./N(1:T-1));
xlabel('Time (years)');
ylabel('Total Population Growth Rate')

%% calculate the proportion of the population in each stage at each time step
%% (Divide each of the 4 rows of our data matrix n by total population size N)

for stage=1:4;
proportion(stage,:)=n(stage,:)./N;
end

figure(3);plot(1:T,proportion)
xlabel('Time (years)');
ylabel('Proportion in each stage')
legend('Yearlings','Juveniles','Mature','Postreproductive')


%%%%% Try 4 different initial conditions
%n(1,1)=250;n(2,1)=0;n(3,1)=0;n(4,1)=0;
%n(1,1)=0;n(2,1)=250;n(3,1)=0;n(4,1)=0;
%n(1,1)=0;n(2,1)=0;n(3,1)=250;n(4,1)=0;
%n(1,1)=0;n(2,1)=0;n(3,1)=0;n(4,1)=250;

