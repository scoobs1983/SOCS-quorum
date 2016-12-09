% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [ neighbours ] = MooreNeighbours3D( areaLattice )
% Compiles an "m x 8" matrix of von Neumann neighbours, where 'm' equals
% the total number of elements of "areaLattice", the 1st column
% representing upper neighbours, 2nd column bottom neighbours, 3rd column
% left neighbours and 4th column right neighbours.

m                   = size(areaLattice, 1);
nElements           = m*m*m;
neighbours          = zeros(nElements, 26);

for i = 1 : nElements
    [y, x, z]                   = ind2sub([m, m, m], i);
    
    %% Record Linear Index of Upper Neighbour
    if y ~= 1  
        neighbours(i, 1)        = sub2ind([m, m, m], y - 1, x, z);                    
    elseif y == 1
        neighbours(i, 1)        = sub2ind([m, m, m], m, x, z);              % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Upper-Right Neighbour
    if y ~= 1 && x ~= m  
        neighbours(i, 2)        = sub2ind([m, m, m], y - 1, x + 1, z);   
    elseif y ~= 1 && x == m
        neighbours(i, 2)        = sub2ind([m, m, m], y - 1, 1, z); 
    elseif y == 1 && x ~= m
        neighbours(i, 2)        = sub2ind([m, m, m], m, x + 1, z);          % Ensure Periodic Boundary Conditions
    elseif y == 1 && x == m
        neighbours(i, 2)        = sub2ind([m, m, m], m, 1, z); 
    end
    
    %% Record Linear Index of Right Neighbour
    if x ~= m  
        neighbours(i, 3)        = sub2ind([m, m, m], y, x + 1, z);                    
    elseif x == m
        neighbours(i, 3)        = sub2ind([m, m, m], y, 1, z);              % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Lower-Right Neighbour
    if y ~= m && x ~= m  
        neighbours(i, 4)        = sub2ind([m, m, m], y + 1, x + 1, z); 
    elseif y ~= m && x == m
        neighbours(i, 4)        = sub2ind([m, m, m], y + 1, 1, z); 
    elseif y == m && x ~= m
        neighbours(i, 4)        = sub2ind([m, m, m], 1, x + 1, z);          % Ensure Periodic Boundary Conditions
    elseif y == m && x == m
        neighbours(i, 4)        = sub2ind([m, m, m], 1, 1, z); 
    end
    
    %% Record Linear Index of Lower Neighbour
    if y ~= m  
        neighbours(i, 5)        = sub2ind([m, m, m], y + 1, x);                    
    elseif y == m
        neighbours(i, 5)        = sub2ind([m, m, m], 1, x);                 % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Lower-Left Neighbour
    if y ~= m && x ~= 1  
        neighbours(i, 6)        = sub2ind([m, m, m], y + 1, x - 1, z);                    
    elseif y ~= m && x == 1
        neighbours(i, 6)        = sub2ind([m, m, m], y + 1, m, z); 
    elseif y == m && x ~= 1
        neighbours(i, 6)        = sub2ind([m, m, m], 1, x - 1, z);          % Ensure Periodic Boundary Conditions
    elseif y == m && x == 1
        neighbours(i, 6)        = sub2ind([m, m, m], 1, m, z); 
    end
    
    %% Record Linear Index of Left Neighbour
    if x ~= 1  
        neighbours(i, 7)        = sub2ind([m, m, m], y, x - 1, z);                    
    elseif x == 1
        neighbours(i, 7)        = sub2ind([m, m, m], y, m, z);              % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Upper-Left Neighbour
    if y ~= 1 && x ~= 1  
        neighbours(i, 8)        = sub2ind([m, m, m], y - 1, x - 1, z);                    
    elseif y == 1 && x ~= 1
        neighbours(i, 8)        = sub2ind([m, m, m], m, x - 1, z); 
    elseif y ~= 1 && x == 1
        neighbours(i, 8)        = sub2ind([m, m, m], y - 1, m, z);          % Ensure Periodic Boundary Conditions
    elseif y == 1 && x == 1
        neighbours(i, 8)        = sub2ind([m, m, m], m, m, z); 
    end
    
    %% Record Linear Index of Entire "Front" Neighbourhood (z - 1)
    if z == 1                                                               % Periodic Boundaries in front
        neighbours(i, 9)        = sub2ind([m, m, m], y, x, m);              % Central (z - 1) neighbour
        [yy, xx, ~]             = ind2sub([m, m, m], neighbours(i, 1:8));
        neighbours(i, 10:17)    = ...
            sub2ind([m, m, m], yy, xx, ones(1, 8)*m);
    else
        neighbours(i, 9)        = sub2ind([m, m, m], y, x, z - 1);          % Central (z - 1) neighbour
        [yy, xx, ~]             = ind2sub([m, m, m], neighbours(i, 1:8));
        neighbours(i, 10:17)    = ...
            sub2ind([m, m, m], yy, xx, ones(1, 8)*(z - 1));
    end
  
    %% Record Linear Index of Entire "Back" Neighbourhood (z + 1)
    if z == m                                                               % Periodic Boundaries in back
        neighbours(i, 18)       = sub2ind([m, m, m], y, x, 1);              % Central (z + 1) neighbour
        [yy, xx, ~]             = ind2sub([m, m, m], neighbours(i, 1:8));
        neighbours(i, 19:26)    = ...
            sub2ind([m, m, m], yy, xx, ones(1, 8));
    else
        neighbours(i, 18)       = sub2ind([m, m, m], y, x, z + 1);          % Central (z + 1) neighbour
        [yy, xx, ~]             = ind2sub([m, m, m], neighbours(i, 1:8));
        neighbours(i, 19:26)    = ...
            sub2ind([m, m, m], yy, xx, ones(1, 8)*(z + 1));
    end
end