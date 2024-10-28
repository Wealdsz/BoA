function decodedCutSequence = decode(bitSequence,flag)
%decode
%   PRE: bit string, containing message, flags and noise
%   POST: bit string, NRZS decoded
%   NRZI decodation: change==0, hold==1

%Add a Zero from left/rigth
bitSequenceLeft = [0 bitSequence];
bitSequenceRigth = [bitSequence 0];

%XOR both vectors, to check changes (change==0, hold==1)
changes = xor(bitSequenceLeft,bitSequenceRigth);

%Cut off added zeros
cut = changes(2:length(changes)-1);

%invert
decodedSequence = not(cut);

%removeflag
noFlags = str2num(strrep(num2str(decodedSequence), num2str(flag), '2'));
decodedCutSequence = noFlags(noFlags~=2);
end

