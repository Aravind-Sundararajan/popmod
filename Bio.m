% Growth Matrix

A=[0 0 0 0 127 4 80;
    0.6747 0.7370 0 0 0 0 0;
    0 0.0486 0.6610 0 0 0 0;
    0 0 0.0147 0.6907 0 0 0;
    0 0 0 0.0518 0 0 0;
    0 0 0 0 0.8091 0 0;
    0 0 0 0 0 0.8091 0.8089];

for a = 1:10
    for b = 1:10
        hospMat{a,b}= zeros(7,4);
    end
end

hospMat{1,1} = [0 0 0 0];
n = zeros(7,10,10,100);
for i =1:10
    for xi =1:10
spatMat{i,xi} = A;
    end
end
% Setting Up Model   
T=100;  
%n=zeros(7,T);
%n(stage,x,y,t)
n(1,1,1,1)=50;
n(2,1,1,1)=50;
n(3,1,1,1)=50;
n(4,1,1,1)=50;
n(5,1,1,1)=50;
n(6,1,1,1)=50;
n(7,1,1,1)=50;

for t=2:T
   % eval leslie matrices
    for x_loc = 1:10
       for y_loc = 1:10
           A = spatMat{x_loc,y_loc};
           n(:,x_loc,y_loc,t)=A*n(:,x_loc,y_loc,t-1);
       end
    end
   % migrate to cells
   
end
this_cell = squeeze(n(:,1,1,:));



% Plotting
plot(1:T,this_cell);
xlabel('Time (years)');
ylabel('Population Size')
title('Sea-Turtle Population')
legend('Yearlings','Small Juveniles','Large Juveniles','Subadults','Novice Breeders','1st-Yr Remigrants','Mature Breeders')

%{
% Eigenvalues
lambda=eig(A)
[eigenvectors,lambda2]=eig(A)
x=eigenvectors(:,3)/sum(eigenvectors(:,3))
%}