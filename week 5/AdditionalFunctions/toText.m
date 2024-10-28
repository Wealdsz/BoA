function [text, endAddress] = toText(bitSequence)
% PRE: Sequence of bits, total number dividable by 8
% POST: corresponding char vector
%           - respect that LSB is sent first
%           - revert left shifted addresses
%Handle bitSequences not dividable by 8
%   appends zeros or cuts message
%% Handle bitSequences not dividable by 8
if mod(length(bitSequence),8)~=0
    if (mod(bitSequence,8)<4)   %cut the end
        bitSequence = bitSequence(1:length(bitSequence)-mod(length(bitSequence),8));
    else                        % append zeros at the end
        bitSequence = [bitSequence,zeros(1,8-mod(length(bitSequence),8))];
    end
end

    
%% revert flip (LSB was arrived first)
binMsg =reshape(bitSequence,8,[])';              % rearange to matrix: one line == one byte
bitSequenceLSB = reshape(fliplr(binMsg)',1,[]);  % flip each byte, rearrange to stream

%% revert left shifted addresses
% find end of Address, search for bit '1' on every 8th position
endAddress = find(bitSequenceLSB(8:8:end) == 1,1);
% remove this 'endbit' and insert '0' at the beginning
bitSequenceUnshifted = [0 bitSequenceLSB(1:endAddress*8 - 1) bitSequenceLSB(endAddress*8 + 1:end)];

if length(bitSequenceUnshifted)<8
   bitSequenceUnshifted = zeros(1,8);
end
%% convert to ASCII
binByRow = (reshape(bitSequenceUnshifted,8,[]))'; % rearange to matrix: one line == one byte
pow2 = [128 64 32 16 8 4 2 1]';
decByRow = binByRow * pow2;                       % compute decimal value
text = char(decByRow');                           % translate to char.

end

