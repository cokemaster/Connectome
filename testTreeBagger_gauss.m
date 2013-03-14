function testRF_gauss(exper_n)
    disp('preparing...');
	long_part = 'C:\Users\Acer\Documents\MATLAB\Connectome\TestRF\';
    %f_filename = strcat(long_part, '\w.txt');
    f_error = strcat(long_part, '\gauss_oobError', int2str(exper_n), '.txt');
    f_varImp = strcat(long_part, '\gauss_varImp', int2str(exper_n), '.txt');
    f_data = strcat(long_part, '\gauss', '.txt');
    n = 266;  % sample size
    m = 18;    % features amount
    k = 13;    % random class size

    mu1 = zeros(1, m);
    mu2 = zeros(1, m);
    mu2(1:2) = 5;

    v = [1, -1; 1, 1];
    s1 = eye(m);
    s2 = eye(m);
    s1(1:2, 1:2) = v' * [10, 0; 0, 1] * v;
    s2(1:2, 1:2) = v' * [1, 0; 0, 1] * v;

    X(1:(n-k), :) = mvnrnd(mu1, s1, n-k);
    Y(1:(n-k), :) = ones(n-k, 1);
    X((n-k+1):n, :) = mvnrnd(mu2, s2, k);
    Y((n-k+1):n, :) = -ones(k, 1);

    %[koef, cl_koef] = CV(X,Y, 0.2, 30);
    %koef
    %cl_koef
    disp('bagging forest...');
    b = TreeBagger(300, X, Y, 'OOBPred', 'on', 'OOBVarImp', 'on', 'NPrint', 30);
    % Learning setr quality
    %Yn = str2double(predict(b, X));
    %acc = Yn == Y;
    %figure;
    %plot(acc)
    %sum(acc)
    disp('writing...');
    dlmwrite(f_error, oobError(b));
    dlmwrite(f_varImp, b.OOBPermutedVarDeltaError);
    dlmwrite(f_data, [Y, X]);

    omargin = oobMargin(b);
    HeatMap(omargin);
    small_omargin = omargin((n-k):n, :);
    HeatMap(small_omargin);

    marg = margin(b, X, Y);
    HeatMap(marg);
    small_marg = marg((n-k):n, :);
    HeatMap(small_marg);

    figure;
    plot(oobError(b));
    figure;
    plot(b.OOBPermutedVarDeltaError);
    figure;
    hold on;
    plot(X(1:(n-k), 1), X(1:(n-k), 2), 'ro')
    plot(X((n-k+1):n, 1), X((n-k+1):n, 2), 'bo')
    disp(b);
end