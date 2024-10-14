classdef constants
    properties (Constant)
        tau_S = 80
        tau_0 = 20
        f0 = 1/20
        tau_1 = 8
        f1 = 1/8

        praeambulare_begin = [1,-1,1,-1,1,-1,1,-1,1];
        praeambulare_end = [1,1,1,-1,1,-1,-1,-1,1];
        zpraeambulare_begin = [1,0,1,0,1,0,1,0,1];
        zpraeambulare_end = [1,1,1,0,1,0,0,0,1];
    end
end

