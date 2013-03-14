function testRF_brain_random(exper_n)
    disp('preparing...');

	long_part = 'C:\Users\Acer\Documents\MATLAB\Connectome\TestRF\';
    long_part2 = 'C:\Users\Acer\Documents\Мозги\CoCoMac\';
    long_part3 = 'C:\Users\Acer\Documents\MATLAB\Connectome\';
    addpath(long_part3);
    %f_filename = strcat(long_part, '\w.txt');
    f_error = strcat(long_part, '\brain_oobError', int2str(exper_n), '.txt');
    f_varImp = strcat(long_part, '\brain_varImp', int2str(exper_n), '.txt');
    f_features = strcat(long_part2, '\features.txt');
    disp('importing features...');
    [F, ft_nm] = import_features(f_features);
    n = size(F,1);  % sample size
    m = 16;         % random subnetwork size

    X = F;
    Y = randsample(n, n);
    Y = uint8(Y > (n-m));
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