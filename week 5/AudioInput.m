%use for example https://www.youtube.com/watch?v=VOVaGxfJVUA
%Parameters
close all
clear
numberOfFrames = 100;

%Setup AudioReader
deviceReader = audioDeviceReader();
sampleRate = deviceReader.SampleRate();

%Plot
totalLength = (deviceReader.SamplesPerFrame)/(deviceReader.SampleRate)*numberOfFrames;
sampleLength = 1/(deviceReader.SampleRate);
frameLength = deviceReader.SamplesPerFrame;
hold on;

%Loop
time = 0;
figure(gcf) %bring Plot Window in foreground
allSamples = [];

       % set a dummy character
while time<numberOfFrames   % which gets changed when key is pressed
    time = time + 1;
    sample = deviceReader();
    plot(time*frameLength*sampleLength + [0:frameLength-1]*sampleLength,sample)
    drawnow
    allSamples = [allSamples sample'];
end
    
%Release
sound(allSamples,sampleRate)
release(deviceReader);
hold off

