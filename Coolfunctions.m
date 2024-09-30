classdef Coolfunctions
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        loopsize
        N
    end
    
    methods
        function obj = Coolfunctions(loopsize, N)
            obj.loopsize = loopsize;
            obj.N = N;
        end

        function loop(self)
            means = zeros(self.loopsize);

            %bit_sequence = Source(??)
            bit_sequence = rand(1, 1e3);

            for i=1:self.loopsize
                d = Drain(bit_sequence);
                means(i) = d.Mean;
            end

            histogram(means, 30);
        end

        function gauss(self, mu, sig)
            x = linspace(-4*sig, 4*sig, 1000);
            fx = 1/(2*pi*sig)*exp(-(x-mu).^2/(2*sig^2));
            plot(x,fx);
        end
    end
end
