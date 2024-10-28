function [bitsequence] = frameCheckSum(frame)
% PRE a bit frame, row vector with fcs somewhere in it
% POST vector, cut until fcs, but including fcs, if no fcs found, return []
    frame = [frame zeros(1,mod(8-mod(length(frame),8),8))];
    bytes = reshape(frame,8,[])';
    endByteIndex = -1; %index of last Byte before fcs
    bitsequence = [];
    
    G = [ 0 0 0 1  0 0 0 0  0 0 1 0  0 0 0 1 ]; % generatorpolynom
    GFlip = fliplr( G );                        % Flip the polynomial for the XOR operation in the loop
    r = 16;                                     % generatorpolynom length
    crc = ones(1,r);
    
    for endByte = 1:length(frame)/8-2
        for i = 1:8
            outBit = crc(r);
            crc = [0,crc(1:(r-1))];
            
            if (outBit ~= bytes(endByte,i))
                crc = xor(crc,GFlip);
            end
        end
        fcs = [bytes(endByte+1,:) bytes(endByte+2,:)];
        fcsCalc = fliplr( -crc+1 );
        if  all(fcsCalc == fcs)
            endByteIndex = endByte;
            break;
        end
    end
    
%     for endByte = 1:length(frame)/8-2 % loop trough all possible messages
%         calculatedFCS = CRC_CCITT_Generator(frame(1:endByte*8));
%         fcs = [bytes(endByte+1,:) bytes(endByte+2,:)];
%         if  all(calculatedFCS == fcs)
%             endByteIndex = endByte;
%         end
%     end
    
    if (endByteIndex ~= -1)
        bitsequence = frame(1:(endByteIndex+2)*8);
    end
    
    endByteIndex;
end