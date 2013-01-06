function attempts2
    N = 64;
    k = 1000;
    %CIJ = makerandCIJ_und(N,k);
    %in = [1, 2, 3, 4, 1, 3, 5, 3, 4, 3, 1];
    %out = [1, 2, 3, 4, 3, 3, 5, 3, 1, 3, 3];
    %[CIJ, flag] = makerandCIJdegreesfixed(in, out);
    %disp(flag);
    CIJ = makeevenCIJ(N,k,4);
    CIJ = CIJ|CIJ';
    HeatMap(uint8(CIJ));
    %CIJ = makefractalCIJ(10, 1.4, 6);
    D = distance_bin(double(CIJ));
    HeatMap(uint8(D));
    disp('Begin scale')
    %disp(D)
    Y = mdscale(D, 2, 'Criterion', 'metricsstress');
    %disp(Y)
    %plot3(Y(:,1), Y(:,2), Y(:,3), '+');
    figure;
    hold on;
    t = uint8(max(size(Y))/4);
    plot(Y(1:t,1), Y(1:t,2), '+', 'Color', 'r');
    plot(Y(t+1:2*t,1), Y(t+1:2*t,2), '+', 'Color', 'b');
    plot(Y(2*t+1:3*t,1), Y(2*t+1:3*t,2), '+', 'Color', 'g');
    plot(Y(3*t+1:4*t,1), Y(3*t+1:4*t,2), '+', 'Color', 'y');
end