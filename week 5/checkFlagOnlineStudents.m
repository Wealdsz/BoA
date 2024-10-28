function [flagPositions, flagValues, lastFlagPosition] = checkFlagOnlineStudents(symbolDecision, flagExtendedNRZI, samplesPerSymDur, flagPositions, flagValues, lastFlagPosition, origin, frameSize)
% checkFlag
%   PRE:  symbolDecision containing values from -1 to 1 corresponding to
%       the two frequencies. The two last frames are in the buffer
%
%       flagExtendedNRZI;   flag already in NRZI, which is already 'stretched'
%                           with the number of samples sent per bit.
%
%       samplesPerSymDur;   number of samples sent per bit
%
%       flagPositions;      vector with positions of all flags (from distinct flag sequences) found in the last calls
%                           of this funiction. It is more dimensional because more than one
%                           message could have been recieved
%                           if no flag has been found yet, then there is
%                           only on entry, with '-inf'
%
%       flagValues;         vector, which stores the correlation value for all flags in
%                           the flagPosition vector
%
%       lastFlagPosition;   position of the last time the correlation was
%                           higher than the threshhold, doesn't have to be a flag position,
%                           because maybe there was a besser correlating flag a litte bit
%                           before
%
%       origin;             is used to convert flagPositions from global
%                           coordinate system into the local one of the function (not relevant for impelmentation)
%
%       frameSize;          size of a frame read from the soundcard, also
%                           used for coordinate transformation (not relevant for impelmentation)
%   POST:
%       flagPositions;       '-inf' if no flag found, positve numbers if
%                           position(s) of flag(s) is(are) within the symbolDecision, it is a
%                           row vector
%                           if vector is not '-inf' at the beginig, keep
%                           initial values and append own found flag(s)
%       
%       flagValues;         correlation value(s) of flag(s), not normed,
%                           row vector
%
%       lastFlagPositon;    Position of the last time a correlation value
%                           was higher than the threshold. Even if it was
%                           not the best value. This value is only scalar
%
%   comment: calculate crossrelation between flag and symbolDecision, if it's
%       higher as the threshhold, store position into FlagPositionthreshholdCorr = length(flagExtendedNRZI)*0.3;

%% Initialize
% Load global variables
numberOfFlags = 3; % with how many flags to correlate

flagExtendedNRZI = [flagExtendedNRZI repmat(flagExtendedNRZI(samplesPerSymDur+1:end), 1, numberOfFlags - 1)]; % construct sequence to correlate with (flag get not just added, but they share one bit, beaucse of NRZI)
threshholdCorr = length(flagExtendedNRZI)*0.5; % sets the correlation threshhold

bytesToNextFlag = 10;   % sets the minimal distance in bytes between two flag sequneces (i.e. two messages, or begin and end of message)
minDistanceToNextFlag = samplesPerSymDur*8*bytesToNextFlag; % minimal distance in samples

%% Coordinate Transformation
% transforms the flagPositions to the local coordinate system
if origin > 0
    flagPositionsLocal = flagPositions - origin * frameSize ;
    lastFlagPositionLocal = lastFlagPosition - origin * frameSize;
else
    flagPositionsLocal = -inf;
    lastFlagPositionLocal = -inf;
end

%% Implement your code here

%% Compute correlation
% compute correlation of symbolDecision and flagExtendedNRZI. Don't forget to expand flagExtendedNRZI from 0,1 to -1,1.
% keep the length of the correlated vector in mind. You may want to shorten or transform it.

%% Iterate over the correlation values
% implement the sketched algorithm here.

%% stop implementing your code here

%% inverse coordinate transformation
if flagPositionsLocal(1) == -inf
   flagPositionsLocal(1) = []; 
end

flagPositions = flagPositionsLocal + origin * frameSize;
lastFlagPosition = lastFlagPositionLocal + origin * frameSize;
