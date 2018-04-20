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
A=[0   0 110;
  .2   0   0;
  .1 .25 .75];

%leslie matrix when we aren't on the beach (turtles have to breed on the
%sand)
A2=[0  0   0;
  .2   0   0;
  .1 .25 .75];

for a = 1:10
    for b = 1%:10
        hospMat{a,b}= zeros(3,4);
    end
end
%eggs, babies, adults
%north South west EAST
%1-2 BEACH, 3-6: SHALLOW, 7-10: DEEP

%first row
hospMat{1,1} = [0 1 0 9;
                0 5 0 5];

hospMat{1,2} = [0 1    0    9;
                0 10/3 10/3 10/3];

hospMat{1,3} = [0 2     2    6;
                0 10/3 10/3 10/3];

hospMat{1,4} = [0 1    2     7;
                0 10/3 10/3 10/3];

hospMat{1,5} = [0 10/3 10/3 10/3;
                0 10/3 10/3 10/3];

hospMat{1,6} = [0 1    7    2;
                0 10/3 10/3 10/3];

hospMat{1,7} = [0 0    8   2;
                0 10/3 10/3 10/3];

hospMat{1,8} = [0 0    0   1;
                0 10/3 10/3 10/3];

hospMat{1,9} = [0 0    10   0;
                0 10/3 10/3 10/3];

hospMat{1,10} = [0 0 10 0;
                 0 5 5 0];

%middle rows
for xi = 2:9
    hospMat{xi,1} =[1    1    0 8;
                    10/3 10/3 0 10/3];
    
    hospMat{xi,2} =[1 1 1 7;
                    2.5 2.5 2.5 2.5];
    
    hospMat{xi,3} =[1 1 1 7;
                    2.5 2.5 2.5 2.5];
    
    hospMat{xi,4} =[1 1 2 6;
                    2.5 2.5 2.5 2.5];
    
    hospMat{xi,5} =[1 1 3 5;
                    2.5 2.5 2.5 2.5];
    
    hospMat{xi,6} =[1 1 4 4;
                    2.5 2.5 2.5 2.5];
    
    hospMat{xi,7} =[1 1 5 3;
                    2.5 2.5 2.5 2.5];
    
    hospMat{xi,8} =[1 1 6 2;
                    2.5 2.5 2.5 2.5];
    
    hospMat{xi,9} =[1 1 7 1;
                    2.5 2.5 2.5 2.5];
    
    hospMat{xi,10}=[1 1 8 0;
                    10/3 10/3 10/3 0];
end
%last row
hospMat{10,1} = [1 0 0 9;
                 0 5 0 5];

hospMat{10,2} = [1 0 1 8;
                10/3 0 10/3 10/3];

hospMat{10,3} = [1 0 1 8;
                10/3 0 10/3 10/3];

hospMat{10,4} = [1 0 2 7;
                10/3 0 10/3 10/3];

hospMat{10,5} = [1 0 3 6;
                10/3 0 10/3 10/3];

hospMat{10,6} = [1 0 4 5;
                10/3 0 10/3 10/3];

hospMat{10,7} = [1 0 5 4;
                10/3 0 10/3 10/3];

hospMat{10,8} = [1 0 6 3;
                10/3 0 10/3 10/3];

hospMat{10,9} = [1 0 7 2;
                10/3 0 10/3 10/3];

hospMat{10,10} = [1 0 9 0;
                  5 0 5 0];

n = zeros(3,10,10,100);
for x =1:10
    spatMat{x,1} = A;
    spatMat{x,2} = A;
end
for x =1:10
    for y =3:10
        spatMat{x,y} = A2;
    end
end
% Setting Up Model
T=100;
%n=zeros(7,T);
%n(stage,x,y,t)
%n(1,1:10,1:10,1)=5;
n(2,1:10,1:10,1)=1;
n(3,1:10,1:10,1)=5;

for t=2:T
    % eval leslie matrices
    for x_loc = 1:10
        for y_loc = 1:10
            A = spatMat{x_loc,y_loc};
            %n(:,x_loc,y_loc,t)=A*n(:,x_loc,y_loc,t-1);
            n(:,x_loc,y_loc,t)=n(:,x_loc,y_loc,t-1);
        end
    end
    % migrate to cells
    migrants_all = zeros(2,10,10);
    for x_loc = 1:10
        for y_loc = 1:10
            thishospMat = hospMat{x_loc,y_loc};
            migrants_thiscell = [randi([0,n(2,x_loc,y_loc,t)]);randi([0,n(3,x_loc,y_loc,t)])];
            migDir = floor(migrants_thiscell.*(thishospMat/10))
            migrants_thiscell = sum(migDir,2);
            migDirStore(:,x_loc,y_loc) = migrants_thiscell;
            

            if x_loc > 1
                migrants_all(:,x_loc-1, y_loc) = migrants_all(:,x_loc-1, y_loc) + migDir(:,1);
            end
            if x_loc < 10
                migrants_all(:,x_loc+1, y_loc) = migrants_all(:,x_loc+1, y_loc) + migDir(:,2);
            end
            if y_loc > 1
                migrants_all(:,x_loc, y_loc-1) = migrants_all(:,x_loc, y_loc-1) + migDir(:,3);
            end
            if y_loc < 10
                migrants_all(:,x_loc, y_loc+1) = migrants_all(:,x_loc, y_loc+1) + migDir(:,4);
            end   
          
        end
    end
    
    n(2:3,:,:,t) = n(2:3,:,:,t)- migDirStore + migrants_all;
end

% Plotting
mkdir('output/1D')
for t =1:T
    clf
    this_cell = squeeze(n(:,:,:,t));
    hold on;
    %bar3(squeeze(this_cell(1,:,:)),squeeze(this_cell(2,:,:)),squeeze(this_cell(3,:,:)));
    subplot(1,3,1)
    imagesc(squeeze(this_cell(1,:,:)))
    title(['eggs: ', num2str(sum(sum(squeeze(this_cell(1,:,:)))))])
    xlabel('X position');
    xlabel('Y position');
    axis([0 11 0 11]);
    subplot(1,3,2)
    imagesc(squeeze(this_cell(2,:,:)))
    title(['babies: ', num2str(sum(sum(squeeze(this_cell(2,:,:)))))])
    xlabel('X position');
    xlabel('Y position');
    axis([0 11 0 11]);
    subplot(1,3,3)
    imagesc(squeeze(this_cell(3,:,:)))
    title(['adults: ', num2str(sum(sum(squeeze(this_cell(3,:,:)))))])
    xlabel('X position');
    xlabel('Y position');
    axis([0 11 0 11]);
    print(['output/1D/output_frame_',num2str(sprintf('%03d',t-1))],'-dpng');
    pause(.01)
    
end

%{
% Eigenvalues
lambda=eig(A)
[eigenvectors,lambda2]=eig(A)
x=eigenvectors(:,3)/sum(eigenvectors(:,3))
%}