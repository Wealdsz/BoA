function Test2(fsymbol,fsample,f0,f1)
% Test 2, pure f0 cos wave, now with phase shift
% load samples
[samples,fsample] = audioread('Samples/only_zeros.wav');
samplesPerSymDur = fsample/fsymbol;

% load solution
load('SolutionTest2.mat')

% filter and correlate
[samplesf0,samplesf1] = filterSignals(samples,fsample,fsymbol,f0,f1,samplesPerSymDur);
symbolDecision = decideCorrelationStudents(samplesf0,samplesf1,fsample,fsymbol,f0,f1,samplesPerSymDur);

% plot data
figure;
title('only zeros, if solution not visible your result is perfect')
x = (1:length(symbolDecision));
hold on
plot(x,samples(samplesPerSymDur+1:end)','b')
plot(x,symbolDecisionSol,'r-o')
plot(x,symbolDecision,'g-o')
ylim([-2 2])
legend('samples','sample correlation solution', 'sample correlation');

end

