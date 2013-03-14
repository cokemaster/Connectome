function testRF_uni(exper_n)
    disp('preparing...');
	long_part = 'C:\Users\Acer\Documents\MATLAB\Connectome\TestRF\';
    %f_filename = strcat(long_part, '\w.txt');
    f_error = strcat(long_part, '\uni_oobError', int2str(exper_n), '.txt');
    f_varImp = strcat(long_part, '\uni_varImp', int2str(exper_n), '.txt');
    n = 266;  % sample size
    m = 18;    % features amount
    k = 13;    % random class size

    X = rand(n, m);
    Y = randsample(n, n);
    Y = sum(Y > (n-k), 2);
    disp('bagging forest...');
    [koef, cl_koef] = CV_RF(X,Y, 0.2, 30);
    koef
    cl_koef

    extra_options = struct('classwt', [13, 253], 'localImp', 1, 'proximity', 1, 'importance', 1);
    model = classRF_train(X, Y, 0, 0, extra_options);
    disp(size(model.importance))
    disp(size(model.importanceSD))
    disp(size(model.localImp))
    disp(size(model.votes))
    disp(size(model.proximity))
    disp(size(model.errtr))
    HeatMap(model.localImp);
    HeatMap(model.localImp(Y == -1, :));
    HeatMap(model.proximity);
    HeatMap(model.proximity(Y == -1, Y == -1));
    figure;
    plot(model.errtr);
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