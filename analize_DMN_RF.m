function analize_DMN(folder, exper_n)
    long_part = 'C:\Users\Acer\Documents\Мозги\';
    f_fullname = strcat(long_part, folder, '\fullname.txt');
    f_hierarchy = strcat(long_part, folder, '\hierarchy.txt');
    f_connectome = strcat(long_part, folder, '\connectome.txt');
    f_dmn = strcat(long_part, folder, '\DMN.txt');
    f_features = strcat(long_part, folder, '\features.txt');
    f_error = strcat(long_part, folder, '\oobError', int2str(exper_n), '.txt');
    f_varImp = strcat(long_part, folder, '\varImp', int2str(exper_n), '.txt');
    disp('importing connctome...');
    [nodes, CIJ, hier, leaf, dmn] = import_connectome(f_fullname, f_hierarchy, f_connectome, f_dmn);
    disp('importing features...');
    [F, ft_nm] = import_features(f_features);

    % take sub features
    subfeat = [1:13, 15:19];
    %subfeat = 1:20;
    F = F(:, subfeat);
    n = length(CIJ);
    dmn_bin = zeros(n, 1);
    dmn_bin(dmn) = 1;
    Y = dmn_bin;
    dmn_bin = logical(dmn_bin);
    % DMN features 
    dmn_feat = F(dmn, :);
    % remove empty rows
    dmn_bin(sum(F, 2) == 0) = [];
    Y(sum(F, 2) == 0) = [];
    F(sum(F, 2) == 0, :) = [];

    % normalization
    F = bsxfun(@minus, F, mean(F));
    F = bsxfun(@rdivide, F, sqrt(var(F)));
    % PCA
    %sigma = F' * F / size(F, 1);
    %[U, S, V] = svd(sigma);
    %eps = 1e-4;
    %F = F*U*diag(1./sqrt(diag(S) + eps));

    disp('analizing dmn...');
    % Cross validation
    [koef, cl_koef] = CV_RF(F,dmn_bin, 0.2, 30);
    koef
    cl_koef
    extra_options = struct('classwt', [253, 13], 'localImp', 1, 'proximity', 1, 'importance', 1);
    model = classRF_train(F, Y, 500, 4, extra_options);
    disp(size(model.importance))
    disp(size(model.importanceSD))
    disp(size(model.localImp))
    disp(size(model.votes))
    disp(size(model.proximity))
    disp(size(model.errtr))
    HeatMap(model.localImp);
    HeatMap(model.localImp(dmn_bin, :));
    HeatMap(model.proximity);
    HeatMap(model.proximity(dmn_bin, dmn_bin));
    figure;
    plot(model.errtr);
    %Yn = classRF_predict(F, model);
    %acc = Yn == Y;
    %figure;
    %plot(acc)
    %sum(acc)

    disp('writing...');
    %dlmwrite(f_error, oobError(b));
    %dlmwrite(f_varImp, b.OOBPermutedVarDeltaError);

    figure;
    hold all;
    plot(F(:,1), F(:,4), 'ro');
    plot(F(dmn_bin,1), F(dmn_bin,2), 'bo');
    hold off;
end