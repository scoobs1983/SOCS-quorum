% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [ neighbours ] = MooreNeighbours3D( volumeLattice )
% Compiles an "n x 26" matrix of the "Moore Neighbourhood" of a cell in 3 
% dimensions, where 'n' equals the total number of elements 
% of "volumeLattice", each of which has 26 "moore neighbours" (besides 
% itself).

dim                 = size(volumeLattice, 1);
nElements           = dim*dim*dim;
neighbours          = zeros(nElements, 26);

for i = 1 : nElements
    [y, x, z]               = ind2sub([dim, dim, dim], i);
    
    %% Record Linear Index of Upper Neighbour
    if y ~= 1  
        neighbours(i, 1)    = sub2ind([dim, dim, dim], y - 1, x, z);                    
    elseif y == 1
        neighbours(i, 1)    = sub2ind([dim, dim, dim], dim, x, z);          % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Upper-Right Neighbour
    if y ~= 1 && x ~= dim  
        neighbours(i, 2)    = sub2ind([dim, dim, dim], y - 1, x + 1, z);   
    elseif y ~= 1 && x == dim
        neighbours(i, 2)    = sub2ind([dim, dim, dim], y - 1, 1, z); 
    elseif y == 1 && x ~= dim
        neighbours(i, 2)    = sub2ind([dim, dim, dim], dim, x + 1, z);      % Ensure Periodic Boundary Conditions
    elseif y == 1 && x == dim
        neighbours(i, 2)    = sub2ind([dim, dim, dim], dim, 1, z); 
    end
    
    %% Record Linear Index of Right Neighbour
    if x ~= dim  
        neighbours(i, 3)    = sub2ind([dim, dim, dim], y, x + 1, z);                    
    elseif x == dim
        neighbours(i, 3)    = sub2ind([dim, dim, dim], y, 1, z);            % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Lower-Right Neighbour
    if y ~= dim && x ~= dim  
        neighbours(i, 4)    = sub2ind([dim, dim, dim], y + 1, x + 1, z); 
    elseif y ~= dim && x == dim
        neighbours(i, 4)    = sub2ind([dim, dim, dim], y + 1, 1, z); 
    elseif y == dim && x ~= dim
        neighbours(i, 4)    = sub2ind([dim, dim, dim], 1, x + 1, z);        % Ensure Periodic Boundary Conditions
    elseif y == dim && x == dim
        neighbours(i, 4)    = sub2ind([dim, dim, dim], 1, 1, z); 
    end
    
    %% Record Linear Index of Lower Neighbour
    if y ~= dim  
        neighbours(i, 5)    = sub2ind([dim, dim, dim], y + 1, x, z);                    
    elseif y == dim
        neighbours(i, 5)    = sub2ind([dim, dim, dim], 1, x, z);            % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Lower-Left Neighbour
    if y ~= dim && x ~= 1  
        neighbours(i, 6)    = sub2ind([dim, dim, dim], y + 1, x - 1, z);                    
    elseif y ~= dim && x == 1
        neighbours(i, 6)    = sub2ind([dim, dim, dim], y + 1, dim, z); 
    elseif y == dim && x ~= 1
        neighbours(i, 6)    = sub2ind([dim, dim, dim], 1, x - 1, z);        % Ensure Periodic Boundary Conditions
    elseif y == dim && x == 1
        neighbours(i, 6)    = sub2ind([dim, dim, dim], 1, dim, z); 
    end
    
    %% Record Linear Index of Left Neighbour
    if x ~= 1  
        neighbours(i, 7)    = sub2ind([dim, dim, dim], y, x - 1, z);                    
    elseif x == 1
        neighbours(i, 7)    = sub2ind([dim, dim, dim], y, dim, z);          % Ensure Periodic Boundary Conditions
    end
    
    %% Record Linear Index of Upper-Left Neighbour
    if y ~= 1 && x ~= 1  
        neighbours(i, 8)    = sub2ind([dim, dim, dim], y - 1, x - 1, z);                    
    elseif y == 1 && x ~= 1
        neighbours(i, 8)    = sub2ind([dim, dim, dim], dim, x - 1, z); 
    elseif y ~= 1 && x == 1
        neighbours(i, 8)    = sub2ind([dim, dim, dim], y - 1, dim, z);      % Ensure Periodic Boundary Conditions
    elseif y == 1 && x == 1
        neighbours(i, 8)    = sub2ind([dim, dim, dim], dim, dim, z); 
    end
    
    %% Record Linear Index of Entire "Front" Neighbourhood (z - 1)
    if z == 1                                                               % Periodic Boundaries in front
        neighbours(i, 9)    = sub2ind([dim, dim, dim], y, x, dim);          % Central (z - 1) neighbour
        [yy, xx, ~]         = ind2sub([dim, dim, dim], neighbours(i, 1:8));
        neighbours(i, 10:17)= ...
            sub2ind([dim, dim, dim], yy, xx, ones(1, 8)*dim);
    else
        neighbours(i, 9)    = sub2ind([dim, dim, dim], y, x, z - 1);        % Central (z - 1) neighbour
        [yy, xx, ~]         = ind2sub([dim, dim, dim], neighbours(i, 1:8));
        neighbours(i, 10:17)= ...
            sub2ind([dim, dim, dim], yy, xx, ones(1, 8)*(z - 1));
    end
  
    %% Record Linear Index of Entire "Back" Neighbourhood (z + 1)
    if z == dim                                                             % Periodic Boundaries in back
        neighbours(i, 18)   = sub2ind([dim, dim, dim], y, x, 1);            % Central (z + 1) neighbour
        [yy, xx, ~]         = ind2sub([dim, dim, dim], neighbours(i, 1:8));
        neighbours(i, 19:26)= ...
            sub2ind([dim, dim, dim], yy, xx, ones(1, 8));
    else
        neighbours(i, 18)   = sub2ind([dim, dim, dim], y, x, z + 1);        % Central (z + 1) neighbour
        [yy, xx, ~]         = ind2sub([dim, dim, dim], neighbours(i, 1:8));
        neighbours(i, 19:26)= ...
            sub2ind([dim, dim, dim], yy, xx, ones(1, 8)*(z + 1));
    end
end