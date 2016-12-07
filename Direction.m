function winningIndex = Direction(i0,j0,left,right,up,down,...
    nutrients,bacteriaLattice,crowdLimit)
    winningIndex    = [i0 j0];

    if(bacteriaLattice(left, j0) < crowdLimit && ...
            winning < nutrients(left, j0))
        winning     = nutrients(left, j0);
        winningIndex = [left j0];
    end

    if(bacteriaLattice(right,j0) < crowdLimit && ...
            winning < nutrients(right, j0))
        winning     = nutrients(right, j0);
        winningIndex = [right j0];
    end

    if(bacteriaLattice(i0,up) < crowdLimit && winning < nutrients(i0,up))
        winning = nutrients(i0,up);
        winningIndex = [i0 up];
    end

    if(bacteriaLattice(i0,down) < crowdLimit && ...
            winning < nutrients(i0,down))
        winning = nutrients(i0,down);
        winningIndex = [i0 down];
    end
end