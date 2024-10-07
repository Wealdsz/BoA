classdef BER

    properties
    end
    
    methods(Static)
        function ber = calc_BER(sequence_source, sequence_dest)
            N = length(sequence_source);
            ber = sum(mod(sequence_source - sequence_dest, 2))/N;
        end
    end
end

