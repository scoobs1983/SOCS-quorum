function [bacterialLocation, BacterialLattice] = Move(bacterialLocation,Signals,BacterialLattice,...
    Nutrients)
    sigThres =3;
    nutrientThres = 0.5;
    nBacteria = size(bacterialLocation,2);
    latticeSize = size(Signals,1);
    iBacteria = randperm(nBacteria);
    i = 1;
    while(i < nBacteria)
        i0 = bacterialLocation(1,iBacteria(i));
        j0 = bacterialLocation(2,iBacteria(i));
        if(Signals(i0,j0) > sigThres)
            nutrientThres = 0.8;
        end
        if(Nutrients(i0,j0) < nutrientThres && Nutrients(i0,j0) >= 0.1 || Nutrients(i0,j0) > inf)
            left = i0-1;
            right = i0+1;
            up = j0-1;
            down = j0+1;
            if(i0 == latticeSize)
                right = 1;
            end
            if(i0 == 1)
                left = latticeSize;
            end
            if(j0 == latticeSize)
                down = 1;
            end
            if(j0 == 1)
                up = latticeSize;
            end

            winningIndex = [i0 j0];
            winning = 0;
            if(BacterialLattice(left,j0) == 0 && winning < Nutrients(left,j0))
                winning = Nutrients(left,j0);
                winningIndex = [left j0];
            end
            if(BacterialLattice(right,j0) == 0 && winning < Nutrients(right,j0))
                winning = Nutrients(right,j0);
                winningIndex = [right j0];
            end
            if(BacterialLattice(i0,up) == 0 && winning < Nutrients(i0,up))
                winning = Nutrients(i0,up);
                winningIndex = [i0 up];
            end
            if(BacterialLattice(i0,down) == 0 && winning < Nutrients(i0,down))
                winning = Nutrients(i0,down);
                winningIndex = [i0 down];
            end
            if(winning < inf)
                BacterialLattice(i0,j0) = 0;
                bacterialLocation(:,iBacteria(i)) = winningIndex;
                BacterialLattice(winningIndex(1),winningIndex(2)) = 1;
            elseif(winning >= inf)
                bacterialLocation = [bacterialLocation winningIndex'];
                BacterialLattice(winningIndex(1),winningIndex(2)) = 1;
            end
        end
        if(Nutrients(i0,j0) < 0.1)
            bacterialLocation(:,iBacteria(i)) = [];
            BacterialLattice(i0,j0) = 0;
            nBacteria = size(bacterialLocation,2);
            iBacteria = randperm(nBacteria);
        end
        i = i+1;   
    end
        
            
