function flagsRestored = bitUnstuffing(bitSequence)
%bitUnstuffing
    % PRE: stuffed bitsequence with flags
    % POST: unstuffed bitsequence with flags
    %sprintf('Length before unstuffing: %d',length(bitSequence))
    
    %% initialize: convert to string
    bitSequenceStr = cellstr(num2str(bitSequence));
    strStuffed =   cellstr(num2str([1 1 1 1 1 0 ]));
    strUnstuffed = cellstr(num2str([1 1 1 1 1 ]));

    % manually bit Stuffing
    %% unstuff
    unstuffedSequence = strrep (bitSequenceStr, strStuffed,strUnstuffed);
   
    %% convert back to array
    flagsRestored = str2num(char(unstuffedSequence));
end

