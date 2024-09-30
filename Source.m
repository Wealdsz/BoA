classdef Source
    %SOURCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        len
        p
    end

    properties(Dependent)
        bit_sequence
    end
    
    methods
        function obj = Source(seq_len, p)
            obj.len = seq_len;
            obj.p = p;
        end
        function a = get.bit_sequence(self)
            rnd = rand(1, self.len);
            change = rnd <= self.p;
            rnd(:) = 1;
            rnd(change) = 0;
            a = rnd;
        end
        
        
    end
end

