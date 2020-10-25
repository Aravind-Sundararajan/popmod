%%% Fourth script for Exercise 2.13, Ellner & Guckenheimer
%%% Data from Brault and Caswell 1993 Ecology 74:1444
%%% for killer whales (Orcinus orca)
%%% Harvesting problem

%%% Four age-stage classes
%%% Yearlings, Juveniles, Mature, Postreproductive

%%% Growth matrix

A=[0	0.0043	0.1132	0;
0.9775	0.9111	0	0;
0	0.0736	0.9534	0;
0	0	0.0452	0.9804];

%% If I just want to know the eigenvalues:
lambda=eig(A)
dominant=max(lambda);

%% If I also want to know the corresponding eigenvectors
%% Matlab needs a little more syntax
[eigenvectors,lambda2]=eig(A)

%% If I want to express the eigenvector as proportion:
proportion=eigenvectors(:,3)/sum(eigenvectors(:,3));

%% Finish time (years)
T=50;

%% Create a data matrix to store output (numbers per class at time t)
%% rows are classes, columns will be time steps
n=zeros(4,T);

%% Initial condition
n(:,1)=250*proportion;

%% harvest
h=[(dominant-1)*n(1,1);0;0;0];

%% Growth dynamics with harvest n(t)=An(t-1)-h.

for t=2:T;		%% repeat the action until time t=Finish time T
   n(:,t)=A*n(:,t-1)-h;
end

plot(1:T,n);
xlabel('Time (years)');
ylabel('Population size')
legend('Yearlings','Juveniles','Mature','Postreproductive')

