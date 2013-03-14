function [koef, cl_koef] = CV(X, Y, prop, iter)
	[l, m] = size(X);
	% find unique classes
	Cl = unique(Y);

	acc = zeros(1, iter);
	cl_acc = zeros(length(Cl), iter);
	for i = 1:iter
		Xl = [];
		Yl = [];
		Xt = [];
		Yt = [];
		for j = 1:length(Cl)
			TMP = find(Y == Cl(j));
			smp = randsample(length(TMP), length(TMP));
			Xl = [Xl; X(TMP(smp > prop*length(TMP)), :)];
			Yl = [Yl; Y(TMP(smp > prop*length(TMP)), :)];
			Xt = [Xt; X(TMP(smp <= prop*length(TMP)), :)];
			Yt = [Yt; Y(TMP(smp <= prop*length(TMP)), :)];
		end
		model = TreeBagger(100, Xl, Yl, 'OOBPred', 'on', 'OOBVarImp', 'on', 'NPrint', 30);
		%model = trainer(data, param);
		Yn = str2double(predict(model, Xt));
		acc(i) = sum(Yn == Yt)/size(Yn,1);
		for j = 1:length(Cl)
			TMP = find(Yt == Cl(j));
			cl_acc(j, i) = sum(Yn(TMP) == Yt(TMP))/length(Yn(TMP));
		end
	end;
	koef = mean(acc);
	cl_koef = mean(cl_acc, 2);
end