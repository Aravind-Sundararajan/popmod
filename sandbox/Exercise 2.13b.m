%%% Second script for Exercise 2.13, Ellner & Guckenheimer
%%% Data from Brault and Caswell 1993 Ecology 74:1444
%%% for killer whales (Orcinus orca)
%%% Compute eigenvalues and eigenvectors

%%% Four age-stage classes
%%% Yearlings, Juveniles, Mature, Postreproductive

%%% Growth matrix

A=[0	0.0043	0.1132	0;
0.9775	0.9111	0	0;
0	0.0736	0.9534	0;
0	0	0.0452	0.9804];

%% If I just want to know the eigenvalues:
lambda=eig(A)

%% If I also want to know the corresponding eigenvectors
%% Matlab needs a little more syntax
[eigenvectors,lambda2]=eig(A)

%% If I want to express the eigenvector as proportion:
eigenvectors(:,3)/sum(eigenvectors(:,3))