% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [ neighbours ] = MooreNeighbours( areaLattice )
% Compiles an "m x 8" matrix of von Neumann neighbours, where 'm' equals
% the total number of elements of "areaLattice", the 1st column
% representing upper neighbours, 2nd column bottom neighbours, 3rd column
% left neighbours and 4th column right neighbours.

[m, n]      = size(areaLattice);
nElements   = m*m;
neighbours  = zeros(nElements, 8);

for i = 1 : nElements
    [y, x]      = ind2sub([m, m], i);
    
    %% Record Linear Index of Upper Neighbour
    if y ~= 1  
        neighbours(i, 1)    = sub2ind([m, m], y - 1, x);                    
    elseif y == 1
        neighbours(i, 1)    = sub2ind([m, m], m, x);                        % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Upper-Right Neighbour
    if y ~= 1 && x ~= m  
        neighbours(i, 2)    = sub2ind([m, m], y - 1, x + 1);   
    elseif y ~= 1 && x == m
        neighbours(i, 2)    = sub2ind([m, m], y - 1, 1); 
    elseif y == 1 && x ~= m
        neighbours(i, 2)    = sub2ind([m, m], m, x + 1);                        % Ensure Periodic Boundary Conditions
    elseif y == 1 && x == m
        neighbours(i, 2)    = sub2ind([m, m], m, 1); 
    end
    
    %% Record Linear Index of Right Neighbour
    if x ~= m  
        neighbours(i, 3)    = sub2ind([m, m], y, x + 1);                    
    elseif x == m
        neighbours(i, 3)    = sub2ind([m, m], y, 1);                        % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Lower-Right Neighbour
    if y ~= m && x ~= m  
        neighbours(i, 4)    = sub2ind([m, m], y + 1, x + 1); 
    elseif y ~= m && x == m
        neighbours(i, 4)    = sub2ind([m, m], y + 1, 1); 
    elseif y == m && x ~= m
        neighbours(i, 4)    = sub2ind([m, m], 1, x + 1);                        % Ensure Periodic Boundary Conditions
    elseif y == m && x == m
        neighbours(i, 4)    = sub2ind([m, m], 1, 1); 
    end
    
    %% Record Linear Index of Lower Neighbour
    if y ~= m  
        neighbours(i, 5)    = sub2ind([m, m], y + 1, x);                    
    elseif y == m
        neighbours(i, 5)    = sub2ind([m, m], 1, x);                        % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Lower-Left Neighbour
    if y ~= m && x ~= 1  
        neighbours(i, 6)    = sub2ind([m, m], y + 1, x - 1);                    
    elseif y ~= m && x == 1
        neighbours(i, 6)    = sub2ind([m, m], y + 1, m); 
    elseif y == m && x ~= 1
        neighbours(i, 6)    = sub2ind([m, m], 1, x - 1);                        % Ensure Periodic Boundary Conditions
    elseif y == m && x == 1
        neighbours(i, 6)    = sub2ind([m, m], 1, m); 
    end
    
    %% Record Linear Index of Left Neighbour
    if x ~= 1  
        neighbours(i, 7)    = sub2ind([m, n], y, x - 1);                    
    elseif x == 1
        neighbours(i, 7)    = sub2ind([m, n], y, n);                        % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Upper-Left Neighbour
    if y ~= 1 && x ~= 1  
        neighbours(i, 8)    = sub2ind([m, m], y - 1, x - 1);                    
    elseif y == 1 && x ~= 1
        neighbours(i, 8)    = sub2ind([m, m], m, x - 1); 
    elseif y ~= 1 && x == 1
        neighbours(i, 8)    = sub2ind([m, m], y - 1, m);                        % Ensure Periodic Boundary Conditions
    elseif y == 1 && x == 1
        neighbours(i, 8)    = sub2ind([m, m], m, m); 
    end
    
end