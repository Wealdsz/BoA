function Test4(fsymbol,fsample,f0,f1)
%% Test 5, 2 flagsequences, only second one is good
% load samples
[samples,fsample] = audioread('Samples/bad_first_sequence.wav');
samplesPerSymDur = fsample/fsymbol;

% load solution
load('SolutionTest5.mat')

% filter and correlate
[samplesf0,samplesf1] = filterSignals(samples,fsample,fsymbol,f0,f1,samplesPerSymDur);
symbolDecision = decideCorrelationStudents(samplesf0,samplesf1,fsample,fsymbol,f0,f1,samplesPerSymDur);

%% check flag
% set parameters
flagExtendedNRZI = [ones(1,samplesPerSymDur), zeros(1,7*samplesPerSymDur), ones(1,samplesPerSymDur)];
originForCheckFlag = 0;
frameSize = 0;
flagPositions = [];
lastFlagPosition = -inf;
flagValues = [];

% check flag
[flagPositions, flagValues, lastFlagPosition] = checkFlagOnlineStudents(symbolDecision, flagExtendedNRZI, samplesPerSymDur, flagPositions, flagValues, lastFlagPosition, originForCheckFlag, frameSize);

% plot
figure;
title('flag positions, if solution not visible your result is perfect')
x = (1:length(symbolDecision));
hold on
plot(x,samples(samplesPerSymDur+1:end)','b')
plot(x,symbolDecisionSol,'r-o')
plot(x,symbolDecision,'g-o')
plot(flagPositions,0,'y*')
plot(flagPositionsSolution,0,'r*')
ylim([-2 2])
legend('samples','sample correlation solution', 'sample correlation','flag start positions solution','flag start positions');
hold off
end

