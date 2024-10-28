function Test3(fsymbol,fsample,f0,f1)
%% Test 3, flagsequence of 3 flags
% load samples
[samples,fsample] = audioread('Samples/3flags_with_noise.wav');
samplesPerSymDur = fsample/fsymbol;

% load solution
load('SolutionTest3.mat')

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
title('flag position, if solution not visible your result is perfect')
x = (1:length(symbolDecision));
hold on
plot(x,samples(samplesPerSymDur+1:end)','b')
plot(x,symbolDecisionSol,'r-o')
plot(x,symbolDecision,'g-o')
plot(flagPositionsSolution,0,'y*')
plot(flagPositions,0,'r*')
ylim([-2 2])
legend('samples','sample correlation solution', 'sample correlation','flag start position solution','flag start position');
hold off
end

