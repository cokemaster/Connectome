function testRF_wine(exper_n)
	long_part = 'C:\Users\Acer\Documents\MATLAB\Connectome\TestRF\';
    f_filename = strcat(long_part, '\w.txt');
    f_error = strcat(long_part, '\wine_oobError', int2str(exper_n), '.txt');
    f_varImp = strcat(long_part, '\wine_varImp', int2str(exper_n), '.txt');
    W = load(f_filename);
    X = W(:, 2:end);
    Y = W(:, 1);

    % normalization
    X = bsxfun(@minus, X, mean(X));
    X = bsxfun(@rdivide, X, sqrt(var(X, 0 , 2)));

    disp('bagging forest...');
    [koef, cl_koef] = CV_RF(X,Y, 0.2, 30);
    koef
    cl_koef

    extra_options = struct('localImp', 1, 'proximity', 1, 'importance', 1);
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
end