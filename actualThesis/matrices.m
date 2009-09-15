%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Adjacency Matrices %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

%%% Scale-free Community Network %%%

A = [ 0 1 1 1 1 1 1 1 1 1
      1 0 0 0 0 1 1 0 0 0
      1 0 0 0 0 0 0 1 1 0
      1 0 0 0 1 0 0 0 0 0
      1 0 0 1 0 0 0 0 0 0
      1 1 0 0 0 0 1 0 0 0
      1 1 0 0 0 1 0 0 0 0
      1 0 1 0 0 0 0 0 1 0
      1 0 1 0 0 0 0 1 0 0 
      1 0 0 0 0 0 0 0 0 0 ];
      
save('matrices.mat','A') 