classdef Drain
    %DRAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bit_sequence
    end

    properties (Dependent)
        Mean
        Std
    end
    
    methods
        function obj = Drain(bit_sequence)
            obj.bit_sequence = bit_sequence;
        end

        function a = get.Mean(self)
            a = mean(self.bit_sequence);
        end

        function a = get.Std(self)
            a = std(self.bit_sequence);
        end
    end
end

