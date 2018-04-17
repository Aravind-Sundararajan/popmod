%% Growth Matrix

A=[0 0 0 0 127 4 80;
    0.6747 0.7370 0 0 0 0 0;
    0 0.0486 0.6610 0 0 0 0;
    0 0 0.0147 0.6907 0 0 0;
    0 0 0 0.0518 0 0 0;
    0 0 0 0 0.8091 0 0;
    0 0 0 0 0 0.8091 0.8089];
%% Setting Up Model   
T=100;
n=zeros(7,T);
n(1,1)=50;n(2,1)=50;n(3,1)=50;n(4,1)=50;n(5,1)=50;n(6,1)=50;n(7,1)=50;

for t=2:T;
   n(:,t)=A*n(:,t-1);
end

%% Plotting
plot(1:T,n);
xlabel('Time (years)');
ylabel('Population Size')
title('Sea-Turtle Population')
legend('Yearlings','Small Juveniles','Large Juveniles','Subadults','Novice Breeders','1st-Yr Remigrants','Mature Breeders')

%% Eigenvalues
lambda=eig(A)
[eigenvectors,lambda2]=eig(A)
x=eigenvectors(:,3)/sum(eigenvectors(:,3))
