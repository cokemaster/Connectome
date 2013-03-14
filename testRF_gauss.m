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
    mu2(1:2) = 10;

    v = [1, -1; 1, 1];
    s1 = eye(m);
    s2 = eye(m);
    s1(1:2, 1:2) = v' * [10, 0; 0, 1] * v;
    s2(1:2, 1:2) = v' * [1, 0; 0, 1] * v;

    X(1:(n-k), :) = mvnrnd(mu1, s1, n-k);
    Y(1:(n-k), :) = ones(n-k, 1);
    X((n-k+1):n, :) = mvnrnd(mu2, s2, k);
    Y((n-k+1):n, :) = -ones(k, 1);

    % normalization
    %X = bsxfun(@minus, X, mean(X));
    %X = bsxfun(@rdivide, X, sqrt(var(X)));
    X = bsxfun(@minus, X, min(X));
    X = bsxfun(@rdivide, X, max(X));

    [koef, cl_koef] = CV_RF(X,Y, 0.2, 60);
    koef
    cl_koef
    disp('bagging forest...');
    extra_options = struct('classwt', [13, 253], 'localImp', 1, 'proximity', 1, 'importance', 1);
    model = classRF_train(X, Y, 0, 0, extra_options);
    disp(size(model.importance))
    disp(size(model.importanceSD))
    disp(size(model.localImp))
    disp(size(model.votes))
    disp(size(model.proximity))
    disp(size(model.errtr))
    %HeatMap(model.localImp);
    %HeatMap(model.localImp(Y == -1, :));
    %HeatMap(model.proximity);
    %HeatMap(model.proximity(Y == -1, Y == -1));
    %figure;
    %plot(model.errtr);
    %Yn = classRF_predict(F, model);
    %acc = Yn == Y;
    %figure;
    %plot(acc)
    %sum(acc)

    disp('writing...');

    figure;
    hold on;
    plot(X(1:(n-k), 1), X(1:(n-k), 2), 'ro')
    plot(X((n-k+1):n, 1), X((n-k+1):n, 2), 'bo')
    disp(model);
end