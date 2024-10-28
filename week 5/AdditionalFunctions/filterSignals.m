function [samplesf0,samplesf1] = filterSignals(samples,fsample,fsymbol,f0,f1,samplesPerSymDur)
%FILTERSIGNALS Filters the signal with matched filters for f0 and f1
% PRE:  samples:            audio sample in a vector
%       fsample:            sample rate in Hz
%       fsymbol:            1/T_symbol, where T_symbol is the duration of one symbol (bit)
%                           in Hz
%       f0:                 frequency of symbol 0 in Hz
%       f1:                 frequency of symbol 1 in Hz
%       samplesPerSymDur:   samples per symbol (bit), is actually
%                           rendundant, is equal to fsample/fsymbol
%
% POST:     samplesf0, which are filtered with matched filter for f0
%           smaplesf1, which are filtered with matched filter for f1
%          
%% Generate patterns
t = linspace(0, 1/fsymbol, fsample/fsymbol);

cos0 = cos(t*2*pi*f0);
cos1 = cos(t*2*pi*f1);

%% Filter samples
% samples get filtered with two different filters for the two different
% frequencies. samplesf0 can now be used for correlation with f0, samplesf1
% can be used for correlation with f1
% construct matched filter
f0filter = cos0(end:-1:1);
f0filter = f0filter/(f0filter*f0filter');
f1filter = cos1(end:-1:1);
f1filter = f1filter/(f1filter*f1filter');

samplesf0 = filter(f0filter,1,samples);
samplesf1 = filter(f1filter,1,samples);

% throw first sample away because after filtering its useless
samplesf0 = samplesf0(samplesPerSymDur+1:end);
samplesf1 = samplesf1(samplesPerSymDur+1:end);
end

