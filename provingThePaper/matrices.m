%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Adjacency Matrices %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

%%% Scale-free Network %%%

A = [ 0 1 1 1 1 1 1 1 1
      1 0 0 0 0 1 1 0 0
      1 0 0 0 0 0 0 1 1
      1 0 0 0 1 0 0 0 0
      1 0 0 1 0 0 0 0 0
      1 1 0 0 0 0 1 0 0
      1 1 0 0 0 1 0 0 0
      1 0 1 0 0 0 0 0 1
      1 0 1 0 0 0 0 1 0 ];
  
  
%%% 3-Community-Level  %%%
%%% Network            %%%

B1 = ones(8,8) - eye(8);
B  = blkdiag(B1,B1,B1,B1,B1,B1,B1,B1);

for i=0:3
    for j=1:16
        k = i*16+j;
        r = i*16+randi(16);
        if(r~=k)
            B(k,r) = 1;
            B(r,k) = 1;
        end
        r = randi(64);
        if(r~=k)
            B(k,r) = 1;
            B(r,k) = 1;
        end
    end
end

%%% Random Network     %%%

C1 = ones(20,20) - eye(20);
C  = C1 .* (randi(2,20,20)-1);

save('matrices.mat','A','B','C') 

%%% Ring Network deg=4 %%%

D = [ 0 1 1 0 0 0 0 0 0 0 1 1
      1 0 1 1 0 0 0 0 0 0 0 1
      1 1 0 1 1 0 0 0 0 0 0 0
      0 1 1 0 1 1 0 0 0 0 0 0
      0 0 1 1 0 1 1 0 0 0 0 0
      0 0 0 1 1 0 1 1 0 0 0 0
      0 0 0 0 1 1 0 1 1 0 0 0
      0 0 0 0 0 1 1 0 1 1 0 0
      0 0 0 0 0 0 1 1 0 1 1 0
      0 0 0 0 0 0 0 1 1 0 1 1
      1 0 0 0 0 0 0 0 1 1 0 1
      1 1 0 0 0 0 0 0 0 1 1 0 ];
   
   
   