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

    b = TreeBagger(300, X, Y, 'OOBPred', 'on', 'OOBVarImp', 'on', 'NPrint', 30);
    
    

    dlmwrite(f_error, oobError(b));
    dlmwrite(f_varImp, b.OOBPermutedVarDeltaError);
    figure;
    plot(oobError(b));
    figure;
    plot(b.OOBPermutedVarDeltaError);
    disp(b);

    margin = oobMargin(b);
    HeatMap(margin);

    % prediction
    margin = b.margin(X, Y);
    HeatMap(margin);
end