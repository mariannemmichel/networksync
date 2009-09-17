%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Adjacency Matrices %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

%%% Scale-free Community Network with Connection to External Network %%%

A = [ 0 1 1 1 1 1 1 1 1
      1 0 0 0 0 1 1 0 0 
      1 0 0 0 0 0 0 1 1 
      1 0 0 0 1 0 0 0 0 
      1 0 0 1 0 0 0 0 0 
      1 1 0 0 0 0 1 0 0 
      1 1 0 0 0 1 0 0 0 
      1 0 1 0 0 0 0 0 1 
      1 0 1 0 0 0 0 1 0 ];
      
save('matrices.mat','A') 