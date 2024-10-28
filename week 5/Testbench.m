%% Testbench for decideCorreleation and checkFlagOnline

% changes matlabs 'Current Folder' so relative paths work

%% set paramenters

% only change this line
testsUntil = 2; % runs all tests until including test number testUntil (1-5)
% nothing more

f0 = 2200;
f1 = 1200;
fsymbol = 1200;
fsample = 13200;

%% decideCorrelation

%% Test 1, pure f1 cos wave

Test1(fsymbol,fsample,f0,f1);
testsUntil = testsUntil-1;
if testsUntil == 0
    return
end

%% Test 2, pure f0 cos wave, now with phase shift

Test2(fsymbol,fsample,f0,f1);
testsUntil = testsUntil-1;
if testsUntil == 0
    return
end

%% checkFlagOnline

%% Test 3 find a flagsequence of 3 flags

Test3(fsymbol,fsample,f0,f1)
testsUntil = testsUntil-1;
if testsUntil == 0
    return
end

%% Test 4 find 2 flagsequences of 3 flags
% the distance between the 2 sequences is higher than 10 Bytes (minDistanceToNextFlag), so both
% should be detected

Test4(fsymbol,fsample,f0,f1)
testsUntil = testsUntil-1;
if testsUntil == 0
    return
end

%% Test 5 find 1 flagsequence of 3 flags
% there are 2 sequences of flags which are to close togehter. It should
% only rekognize the second one, the first one has errors in it and should
% have a worse correlation

Test5(fsymbol,fsample,f0,f1)
testsUntil = testsUntil-1;
if testsUntil == 0
    return
end
