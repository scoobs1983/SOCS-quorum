function [winning, winningIndex] = Direction(i0,j0,left,right,up,down,...
    nutrients,bacteriaLattice)
    winningIndex    = [i0 j0];
    winning         = 0;

    if(bacteriaLattice(left, j0) < 5 && ...
            winning < nutrients(left, j0))
        winning     = nutrients(left, j0);
        winningIndex = [left j0];
    end

    if(bacteriaLattice(right,j0) < 5 && ...
            winning < nutrients(right, j0))
        winning     = nutrients(right, j0);
        winningIndex = [right j0];
    end

    if(bacteriaLattice(i0,up) < 5 && winning < nutrients(i0,up))
        winning = nutrients(i0,up);
        winningIndex = [i0 up];
    end

    if(bacteriaLattice(i0,down) < 5 && ...
            winning < nutrients(i0,down))
        winning = nutrients(i0,down);
        winningIndex = [i0 down];
    end
end