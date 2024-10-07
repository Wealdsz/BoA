classdef BSC_channel
    properties
        
    end
    
    methods(Static)
        function channel_bit_sequence = channel(bit_sequence, q)
            rnd = rand(1, length(bit_sequence));
            flip = rnd <= q;
            bit_sequence(flip) = mod(bit_sequence(flip) + 1,2);
            channel_bit_sequence = bit_sequence;
        end
    end
end

