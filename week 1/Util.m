classdef Util
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Util()
            
        end

        function loop(self, loopsize, N)
            means = zeros(1, loopsize);
            s = Source(N, 0.3);

            for i=1:loopsize
                bit_sequence = s.bit_sequence;
                d = Drain(bit_sequence);
                means(i) = d.Mean;
            end
            figure(1);
            hist(means, 50);
        end

        function gauss(self, mu, sig)
            figure(2);
            x = linspace(0, 1, 1000);
            fx = 1/(2*pi*sig)*exp(-(x-mu).^2/(2*sig^2));
            plot(x,fx);
        end

        function ret = repencode(self, seq, N)
            ret = repmat(seq, N, 1);
            ret = reshape(ret, [1 N*length(seq)]);
        end

        function ret = repdecode(self, seq, N)
            n = length(seq)/N;
            mat = reshape(seq, [N n]);
            ret = zeros(1, n);

            for i=1:n
                ret(i) = round(mean(mat(:,i)));
            end
        end
    end
end
