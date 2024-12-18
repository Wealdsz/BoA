classdef Sync
    properties
        
    end
    
    methods(Static)
        function offset = signalsync(a, b)
            c = xcorr(a,b);
            [~,i] = max(c);
            offset = i-length(a)+1;
        end

        function y = symbolsync(a)
            b = [0, 1];
            b_mod = modulator.modulate(b);

            offset = mod(Sync.signalsync(a, b_mod), constants.tau_S);
            y = a(offset:end);
            l = mod(length(y), constants.tau_S);
            y = y(1:end-l);
        end

        function y = framesync(x)
            xcp = x;
            to_rep = xcp == 0;
            xcp(to_rep) = -1;

            i1 = Sync.signalsync(xcp, constants.praeambulare_begin);
            cut = i1 + length(constants.praeambulare_begin);
            y = x(cut:end);

            i2 = Sync.signalsync(xcp, constants.praeambulare_end);
            y = y(1:i2-cut);
        end
    end
end

