% Growth Matrix
clear all
%{
A=[0 0 0 0 127 4 80;
    0.6747 0.7370 0 0 0 0 0;
    0 0.0486 0.6610 0 0 0 0;
    0 0 0.0147 0.6907 0 0 0;
    0 0 0 0.0518 0 0 0;
    0 0 0 0 0.8091 0 0;
    0 0 0 0 0 0.8091 0.8089];
 %}

%eggs, young, adults
%leslie matrix for the beach
A=[0 0 .42;
   .6 0 0;
   0 .75 .95];

%leslie matrix when we arent on the beach (turtles have to breed on the
%sand)
A2=[0 0 0;
   .6 0 0;
   0 .75 .95];
    
for a = 1:10
    for b = 1%:10
        hospMat{a,b}= zeros(3,4);
    end
end
%eggs, babies, adults
%north east south west
%1-2 BEACH, 3-6: SHALLOW, 7-10: DEEP
hospMat{1} = [0 1;
                0 1]; 
            
hospMat{2} = [.10 .90;
                .5 .5]; 
            
hospMat{3} = [.10 .90;
                .25 .75]; 
            
hospMat{4} = [.20 .80;
                .5 .5]; 
            
hospMat{5} = [.40 .60;
                .5 .5];  
            
hospMat{6} = [.60 .40;
                .5 .5]; 
            
hospMat{7} = [.90 .10;
                .5 .5];  
            
hospMat{8} = [.95 .05;
                .5 .5];  
            
hospMat{9} = [.99 .01;
                .5 .5]; 
            
hospMat{10} = [1 0;
                1 0];  
n = zeros(3,10,100);
spatMat{1} = A;
spatMat{2} = A;
for i =3:10
spatMat{i} = A2;
end
% Setting Up Model   
T=100;  
%n=zeros(7,T);
%n(stage,x,y,t)
n(1,1,1)=50;
n(2,1,1)=0;
n(3,1,1)=0;

for t=2:T
   % eval leslie matrices
    for x_loc = 1:10
           A = spatMat{x_loc};
           n(:,x_loc,t)=A*n(:,x_loc,t-1);
    end
   % migrate to cells
   migrants_all = zeros(2,10);
   for x_loc = 1:10
       thishospMat = hospMat{x_loc};
       migrants_thiscell = .75*rand(2,1).*n(2:3,x_loc,t)
       migDir = migrants_thiscell.*thishospMat
       migDirStore(:,x_loc) = migrants_thiscell;
       if x_loc > 1
       migrants_all(:,x_loc-1) = migrants_all(:,x_loc-1) + migDir(:,1);
       end
       if x_loc < 10
       migrants_all(:,x_loc+1) = migrants_all(:,x_loc+1) + migDir(:,2);
       end
   end
   
   n(2:3,:,t) = n(2:3,:,t)- migDirStore + migrants_all
end

% Plotting
mkdir('output/1D')
for t =1:T
clf
this_cell = squeeze(n(:,:,t));
hold on;
bar(1:10,this_cell');
xlabel('X position');
ylabel('Population Size')
title(['Sea-Turtle Population, Year: ',num2str(t)])
legend('eggs on the beach', 'juveniles','adults')

axis([0 11 0 50]);
print(['output/1D/output_frame_',num2str(sprintf('%03d',t-1))],'-dpng');
pause(.2)
end

%{
% Eigenvalues
lambda=eig(A)
[eigenvectors,lambda2]=eig(A)
x=eigenvectors(:,3)/sum(eigenvectors(:,3))
%}