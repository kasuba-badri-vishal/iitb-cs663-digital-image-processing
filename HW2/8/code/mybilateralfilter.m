function BF = mybilateralfilter(I,sigs,sigr)
    BF = zeros(size(I));
    BWby2 = ceil(3*sigs);
    [r, c] = size(I);
    for x = 1:c
        for y = 1:r
            i1 = max(y-BWby2,1); 
            i2 = min(y+BWby2,r); 
            j1 = max(x-BWby2,1); 
            j2 = min(x+BWby2,c);
            LI = I(i1:i2,j1:j2);
            [X, Y] = meshgrid(j1:j2,i1:i2);
            Gs = exp(-1*((X-x).^2+(Y-y).^2)/(2*sigs^2));
            Gr = exp(-1*((LI-I(y,x)).^2)/(2*sigr^2));
            BF(y,x) = sum(Gs.*Gr.*LI,'all')/sum(Gs.*Gr,'all');
        end
    end    
end