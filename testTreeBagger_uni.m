function testRF_uni(exper_n)
    disp('preparing...');
	long_part = 'C:\Users\Acer\Documents\MATLAB\Connectome\TestRF\';
    %f_filename = strcat(long_part, '\w.txt');
    f_error = strcat(long_part, '\uni_oobError', int2str(exper_n), '.txt');
    f_varImp = strcat(long_part, '\uni_varImp', int2str(exper_n), '.txt');
    n = 383;  % sample size
    m = 4;    % features amount
    k = 16;    % random class size

    X = rand(n, m);
    Y = randsample(n, n);
    Y = uint8(Y > (n-k));
    disp('bagging forest...');
    b = TreeBagger(300, X, Y, 'OOBPred', 'on', 'OOBVarImp', 'on', 'NPrint', 30);
    disp('writing...');
    dlmwrite(f_error, oobError(b));
    dlmwrite(f_varImp, b.OOBPermutedVarDeltaError);
    figure;
    plot(oobError(b));
    figure;
    plot(b.OOBPermutedVarDeltaError);
    disp(b);
end