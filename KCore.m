function nodes = KCore(CIJ)
    % compute k vector
    nodes = zeros(1, size(CIJ, 1));
    k = 1;
    while 1
        kcore_arr = kcore_bd(CIJ, k);
        [id,od,deg] = degrees_dir(kcore_arr);
        % exit
        if (sum(deg) == 0) break; end;
        % increment
        nodes = nodes + (deg>0);
        k = k + 1;
    end
end