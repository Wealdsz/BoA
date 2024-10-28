function Test1(fsymbol,fsample,f0,f1)
% Test 1, pure f1 cos wave
% load samples
[samples,fsample] = audioread('Samples/only_ones.wav');
samplesPerSymDur = fsample/fsymbol;

% load solution
load('SolutionTest1.mat')

% filter and correlate
[samplesf0,samplesf1] = filterSignals(samples,fsample,fsymbol,f0,f1,samplesPerSymDur);
symbolDecision = decideCorrelationStudents(samplesf0,samplesf1,fsample,fsymbol,f0,f1,samplesPerSymDur);

% plot data
figure;
title('only ones, if solution not visible your result is perfect')
x = (1:length(symbolDecision));
hold on
plot(x,samples(samplesPerSymDur+1:end)','b')
plot(x,symbolDecisionSol,'r-o')
plot(x,symbolDecision,'g-o')
ylim([-2 2])
legend('samples','sample correlation solution', 'sample correlation');


end
