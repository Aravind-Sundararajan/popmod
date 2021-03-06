% Growth Matrix
clear all
%{
A=[ 0      0      0      0 127 4   80;
    0.6747 0.7370 0      0 0   0   0;
    0      0.0486 0.6610 0 0   0   0;
    0 0 0.0147 0.6907 0 0 0;
    0 0 0 0.0518 0 0 0;
    0 0 0 0 0.8091 0 0;
    0 0 0 0 0 0.8091 0.8089];
%}

%eggs, young, adults
%leslie matrix for the beach
A=[.2        0       110;
   0.6747   0.7370    0;
   0        0.0486  0.6610];

%leslie matrix when we aren't on the beach (turtles have to breed on the
%sand)
A2=[.2        0       0;
    0.6747   0.7370    0;
    0        0.0486  0.6610];
gridSize_X = 25;
gridSize_Y = 25;
%eggs, babies, adults
%north South west EAST
%1-2 BEACH, 3-6: SHALLOW, 7-10: DEEP

%eggs
HSI{1} = zeros(gridSize_X,gridSize_Y);
HSI{1}(1:gridSize_X,1:2) = 1;
%juveniles
HSI{2} = zeros(gridSize_X,gridSize_Y);
HSI{2}(1:gridSize_X,1:2*floor(gridSize_Y*.3)) =repmat([linspace(0,.66,floor(gridSize_Y*.3)),linspace(.6,0,floor(gridSize_Y*.3))],gridSize_X,1);
%adults
HSI{3} = zeros(gridSize_X,gridSize_Y);
%HSI{3} = repmat([linspace(1/3,2/3,floor(gridSize_Y*.5)),linspace(2/3,1/3,gridSize_Y-floor(gridSize_Y*.5))],gridSize_X,1);
HSI{3}(1:gridSize_X,1:gridSize_Y) = repmat([linspace(0,.6,floor(gridSize_Y*.7)),linspace(.7,.6,gridSize_Y-floor(gridSize_Y*.7))],gridSize_X,1);

clear hospMat
for ki = 1:2
 for i = 1:gridSize_X
  for j = 1:gridSize_Y
   check = HSI{ki+1}(i,j);
   hospMat{i,j}(ki,:) = [0,0,0,0];
   if i>1
    hospMat{i,j}(ki,1) = HSI{ki+1}(i-1,j);
   end
   if i<gridSize_X
    hospMat{i,j}(ki,2) = HSI{ki+1}(i+1,j);
   end
   if j>1
    hospMat{i,j}(ki,3) = HSI{ki+1}(i,j-1);
   end
   if j<gridSize_Y
    hospMat{i,j}(ki,4) = HSI{ki+1}(i,j+1);
   end
  end
 end
end
T=100;
n = zeros(3,gridSize_X,gridSize_Y,T);
for x =1:gridSize_X
    spatMat{x,1} = A;
    spatMat{x,2} = A;
end
for x =1:gridSize_X
    for y =3:gridSize_Y
        spatMat{x,y} = A2;
    end
end
% Setting Up Model

%n=zeros(7,T);
%n(stage,x,y,t)
%n(1,1:10,1:10,1)=5;
n(2,1:gridSize_X,1:gridSize_Y,1)=100;
n(3,1:gridSize_X,1:gridSize_Y,1)=500;

for t=2:T
    % eval leslie matrices
    for x_loc = 1:gridSize_X
        for y_loc = 1:gridSize_Y
            A = spatMat{x_loc,y_loc};
            n(:,x_loc,y_loc,t)=A*n(:,x_loc,y_loc,t-1);
            %n(:,x_loc,y_loc,t)=n(:,x_loc,y_loc,t-1);
        end
    end
    % migrate to cells
    migrants_all = zeros(2,gridSize_X,gridSize_Y);
    for x_loc = 1:gridSize_X
        for y_loc = 1:gridSize_Y
            thishospMat = hospMat{x_loc,y_loc};
            migrants_thiscell = [(1-HSI{2}(x_loc,y_loc))*rand(1)*n(2,x_loc,y_loc,t);(1-HSI{3}(x_loc,y_loc))*rand(1)*n(3,x_loc,y_loc,t)];
            migDir = migrants_thiscell.*(thishospMat);
            migrants_thiscell = sum(migDir,2);
            migDirStore(:,x_loc,y_loc) = migrants_thiscell;
            

            if x_loc > 1
                migrants_all(:,x_loc-1, y_loc) = migrants_all(:,x_loc-1, y_loc) + migDir(:,1);
            end
            if x_loc < gridSize_X
                migrants_all(:,x_loc+1, y_loc) = migrants_all(:,x_loc+1, y_loc) + migDir(:,2);
            end
            if y_loc > 1
                migrants_all(:,x_loc, y_loc-1) = migrants_all(:,x_loc, y_loc-1) + migDir(:,3);
            end
            if y_loc < gridSize_Y
                migrants_all(:,x_loc, y_loc+1) = migrants_all(:,x_loc, y_loc+1) + migDir(:,4);
            end   
          
        end
    end
    
    n(2:3,:,:,t) = n(2:3,:,:,t)- migDirStore + migrants_all;
    n(1:3,:,:,t) = n(1:3,:,:,t);
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
    axis([0 gridSize_X+1 0 gridSize_Y+1]);
    subplot(1,3,2)
    imagesc(squeeze(this_cell(2,:,:)))
    title(['babies: ', num2str(sum(sum(squeeze(this_cell(2,:,:)))))])
    xlabel('X position');
    xlabel('Y position');
    axis([0 gridSize_X+1 0 gridSize_Y+1]);
    subplot(1,3,3)
    imagesc(squeeze(this_cell(3,:,:)))
    title(['adults: ', num2str(sum(sum(squeeze(this_cell(3,:,:)))))])
    xlabel('X position');
    xlabel('Y position');
    axis([0 gridSize_X+1 0 gridSize_Y+1]);
    print(['output/1D/output_frame_',num2str(sprintf('%03d',t-1))],'-dpng');
    pause(.01)
    
end

%{
% Eigenvalues
lambda=eig(A)
[eigenvectors,lambda2]=eig(A)
x=eigenvectors(:,3)/sum(eigenvectors(:,3))
%}