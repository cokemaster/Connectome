function [koef, cl_koef] = CV(X, Y, prop, iter)
	[l, m] = size(X);
	% find unique classes
	Cl = sort(unique(Y));
	proport = zeros(1, length(Cl));
	for i = 1:length(Cl)
		proport(i) = sum(Y == Cl(i));
	end
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
		extra_options = struct('classwt', proport);
		model = classRF_train(Xl, Yl, 30, 100, extra_options);
		%model = trainer(data, param);
		Yn = classRF_predict(Xt, model);
		acc(i) = sum(Yn == Yt)/size(Yn,1);
		for j = 1:length(Cl)
			TMP = find(Yt == Cl(j));
			cl_acc(j, i) = sum(Yn(TMP) == Yt(TMP))/length(Yn(TMP));
		end

		if i == 2
			figure;
		    hold on;
    		plot(Xl(Yl == Cl(1), 1), Xl(Yl == Cl(1), 2), 'ro')
		    plot(Xt(Yt == Cl(1), 1), Xt(Yt == Cl(1), 2), 'bo')
		    plot(Xl(Yl == Cl(2), 1), Xl(Yl == Cl(2), 2), 'go')
		    plot(Xt(Yt == Cl(2), 1), Xt(Yt == Cl(2), 2), 'ko')
		end;
	end;
	Cl
	koef = mean(acc);
	cl_koef = mean(cl_acc, 2);
end