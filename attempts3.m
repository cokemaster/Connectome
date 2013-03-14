function attempts3
    N = 256;
    k = 1000;
    CIJ = makerandCIJ_und(N,k);
    %in = [1, 2, 3, 4, 1, 3, 5, 3, 4, 3, 1];
    %out = [1, 2, 3, 4, 3, 3, 5, 3, 1, 3, 3];
    %[CIJ, flag] = makerandCIJdegreesfixed(in, out);
    %disp(flag);
    %CIJ = maketoeplitzCIJ(N,k,20);
    [~, F] = motif3funct_bin(CIJ);
    HeatMap(double(CIJ))
    HeatMap(double(F))
end