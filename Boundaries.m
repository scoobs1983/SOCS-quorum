function [left, right, up, down] = Boundaries(i0,j0,latticeSize)
    left            = i0-1;
    right           = i0+1;
    up              = j0-1;
    down            = j0+1;

    if(i0 == latticeSize)
        right       = i0;
    end

    if(i0 == 1)
        left        = i0;
    end

    if(j0 == latticeSize)
        down        = j0;
    end

    if(j0 == 1)
        up          = j0;
    end
end

