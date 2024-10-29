%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File:         BoAPRS.m
% Description: 	Real time APRS decoding
% Authors:      Theo von Arx (varxth), Noah Zarro (zarron)
%               ETH Zurich, Fall Semester 2018
% Notes:        To pipe audio from firefox to matlab in linux, see
%               https://unix.stackexchange.com/questions/82259/how-to-pipe-
%               audio-output-to-mic-input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear
%% Configuration
% set to 1 to:
% -enable debug plots
% -show packet data even if the checksum is not correct
% -show iteration counter
% default 0
debug = 1;

% set to 0 to:
% -read audiodata form 'filePath' file
% set to 1 to:
% -read audiodata from microphone
% set to 2 to:
% -read audiodata from file
online = 1;

% set to 0 to:
% -use checkFlagOnline implemented by students
% set to 1 to:
% -use solution checkFlagOnline function
checkFlagSolution = 1;

% set to 1 to use the completed solution functions, only for teacher!
solution = 0;

% path for audiofiles
filePath = "/Samples/finalTest.wav";
simulpath = "Samples/APRSfile.wav";


%% Initialize all devices

%cd(fileparts(which(mfilename)));
%cd('../')

% initialize audio reader with rate 13200/s
if online==2
    deviceReader = dsp.AudioFileReader(simulpath);
        [y,Fs] = audioread(simulpath);
        sound(y,Fs);
elseif online==1
    deviceReader = audioDeviceReader(13200);
else
    deviceReader = dsp.AudioFileReader(filePath);
end

setup(deviceReader);

% Frequencies in Hz
f0 = 2200;
f1 = 1200;
fsymbol = 1200;

% other variables
flagPositions = [];
lastFlagPosition = -inf;
flagValues = [];
message{1} = [];
origin = 0;

% initialize debugging plot variables if needed
if debug
    frameSizeHistory = [];
    dumpedSamplesHistory = [];
    samplesToPlot{1} = [];
    framesUntilFirstFlag = -1;
    figures = [];
    iterationcounter = 0;
end


%% first step
samplestmp = deviceReader();

% resample calculations
fstmp = deviceReader.SampleRate();
fsample = lcm(lcm(fsymbol, lcm(f0,f1)),fstmp);
samplesPerSymDur = fsample / fsymbol;
[P,Q] = rat(fsample/fstmp);

% normalize samples with rms of the signal
samplestmp = samplestmp/rms(samplestmp);
samplestmp(isnan(samplestmp)) = 0; % catch division with 0

% Buffers for first step
audioBuffer = resample(samplestmp,P,Q);
frameSize = length(audioBuffer);

% save samples for later debug plots
if debug
    sampleBuffer = audioBuffer';
end

% fill the first few samples with zeros
[samplesf0,samplesf1] = filterSignals(audioBuffer,fsample,fsymbol,f0,f1,samplesPerSymDur);
if solution == 1
    firstSymbolDecisions = decideCorrelationStudentsSolution(samplesf0,samplesf1,fsample,fsymbol,f0,f1,samplesPerSymDur);
else
    firstSymbolDecisions = decideCorrelationStudents(samplesf0,samplesf1,fsample,fsymbol,f0,f1,samplesPerSymDur);
end
symbolDecision = [zeros(1,2*samplesPerSymDur) firstSymbolDecisions(1:end-samplesPerSymDur)'];

%% Symbols
flag = [0,1,1,1,1,1,1,0];
flagExtended = [zeros(1,samplesPerSymDur), ones(1,6*samplesPerSymDur) zeros(1,samplesPerSymDur)];
flagExtendedNRZI = [ones(1,samplesPerSymDur), zeros(1,7*samplesPerSymDur), ones(1,samplesPerSymDur)];


%% Process Audio
while true
    % aquire new frame from soundcard
    [samplestmp, overrun] = deviceReader();
    % print, if an overrun happens, i.e. when samples are dumped
    if overrun ~= 0
        fprintf('warning, overrun: %d\n', overrun)
    end

    % normalize samples with rms of the signal
    samplestmp = samplestmp/rms(samplestmp);
    samplestmp(isnan(samplestmp)) = 0; % catch division with 0

    % resample data, use last few samples, to make sure the correlation is
    % correct
    audioBuffer = [audioBuffer(end-2*samplesPerSymDur+1:end); resample(samplestmp,P,Q)];

    % append symbolDecision
    [samplesf0,samplesf1] = filterSignals(audioBuffer,fsample,fsymbol,f0,f1,samplesPerSymDur);
    
    if solution == 1
        currentSymbolDecisions = decideCorrelationStudentsSolution(samplesf0,samplesf1,fsample,fsymbol,f0,f1,samplesPerSymDur);
    else
        currentSymbolDecisions = decideCorrelationStudents(samplesf0,samplesf1,fsample,fsymbol,f0,f1,samplesPerSymDur);
    end
  
    symbolDecision = [symbolDecision currentSymbolDecisions(1:end-samplesPerSymDur)'];

    % save data for debug plot
    if debug
        frameSizeHistory = [frameSizeHistory length(samplestmp)];
        dumpedSamplesHistory = [dumpedSamplesHistory overrun];

        if (length(flagPositions) == 0)
            framesUntilFirstFlag = framesUntilFirstFlag+1;
        end
        sampleBuffer = [sampleBuffer audioBuffer(2*samplesPerSymDur:end)'];
        iterationcounter = iterationcounter + 1;
        if mod(iterationcounter,100) == 0
            fprintf('iterations: %i, seconds: %f \n', iterationcounter,iterationcounter*frameSize/fsample);
        end
    end


    %% CheckFlag
    % if no flag has been found yet give origin = 0 to checkflag (means no flag
    % found yet), otherwise tell give origin from last found flag
    if length(origin)>1
        originForCheckFlag = origin(end-1);
    else
        originForCheckFlag = 0;
    end
    if checkFlagSolution == 1
        [flagPositions, flagValues, lastFlagPosition] = checkFlagOnlineStudentsSolution(symbolDecision, flagExtendedNRZI, samplesPerSymDur, flagPositions, flagValues, lastFlagPosition, originForCheckFlag, frameSize);
    else
        [flagPositions, flagValues, lastFlagPosition] = checkFlagOnlineStudents(symbolDecision, flagExtendedNRZI, samplesPerSymDur, flagPositions, flagValues, lastFlagPosition, originForCheckFlag, frameSize);
    end
        
    if(length(flagPositions) >= 1) % if at least 1 flagsequence has been found
	% go through all found flagsequences (here interpreted as startig flags)
        for i=1:length(flagPositions)
            if(origin(i) == 0) % first time
		% set origin
                origin(i) = 1;
		% append new message vector
                message{i} = symbolDecision;
		% set new origin vector
                origin(i+1) = 0;

                % set origin of lastFlagPosition to start of curr symbolDecision
                lastFlagPosition = lastFlagPosition - origin(i) * frameSize;

                % DebugPlot
                if debug
                    samplesToPlot{i} = sampleBuffer;
                end
            else
                % keep message
                message{i} = [message{i} symbolDecision(frameSize+1:end)];
                origin(i) = origin(i) + 1;

                % DebugPlot
                if debug
                    samplesToPlot{i} = [samplesToPlot{i} sampleBuffer(frameSize+1:end)];
                end
            end
        end

    end

    %% check if maximum length reached
    for i=1:length(flagPositions)
        if origin(i) > 700/(frameSize/samplesPerSymDur/8)
	    % maximum length reached

            % append last symbolDecision to message
            message{i} = [message{i} symbolDecision(frameSize+1:end)];

            % add dummy flag positions, which indicate end of message
            dummyFlagPositions = floor(length(message{i})/10*9);
            dummyFlagValues = flagValues(i);

            %% Process Data
            syncedMessage = syncAndCompress(message{i}, flagPositions(i), dummyFlagPositions, samplesPerSymDur);
            % decode, cut and unstuff
            decodedMessage = decode(syncedMessage,flag);
            unstuffedMessage = bitUnstuffing(decodedMessage);

            % cut till the checksum was found
            bitSequence = frameCheckSum(unstuffedMessage);
            if debug == 1
                if length(bitSequence)==0
                    % no valid checksum found
                    bitSequence = unstuffedMessage;
                end
            end

            % translate and display text
            [text, endAddress] = toText(bitSequence);
            toNiceText(text,endAddress);

            %% Debug Plot
            if debug
                samplesToPlot{i} = [samplesToPlot{i} sampleBuffer(frameSize+1:end)];
                figures(end+1) = figure();
                hold on;
                ylim([-4 4]);
		% show signal
                plot([1:length(samplesToPlot{i})],samplesToPlot{i})
                plot(flagPositions(i), samplesToPlot{i}(flagPositions(i)),'r*')
                plot(((1:length(samplesToPlot{i})/frameSize)-1)*frameSize+1,0,'xk')
                drawnow
                hold off;
                figures(end)

                disp('new message')
            end



            %% reset
            flagPositions(i) = [];
            flagValues(i) = [];
            origin(i) = [];
            message(i) = [];
            if debug
                samplesToPlot(i) = [];
            end

        end
    end


    %% remove outdated frames
    trustBuferOld = symbolDecision(1:frameSize);
    symbolDecision = symbolDecision(frameSize+1:end);

    if debug
        sampleBuffer = sampleBuffer(frameSize+1:end);
    end
end
