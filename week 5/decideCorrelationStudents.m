function symbolDecision = decideCorrelationStudents(samplesf0,samplesf1,fsample,fsymbol,f0,f1,samplesPerSymDur)
% PRE:  samplesf0:          audio samples filtered with matched filter for f0
%       samplesf1:          audio samples filtered with matched filter for f1
%       fsample:            sample rate in Hz
%       fsymbol:            1/T_symbol, where T_symbol is the duration of one symbol (bit)
%                           in Hz
%       f0:                 frequency of symbol 0 in Hz
%       f1:                 frequency of symbol 1 in Hz
%       samplesPerSymDur:   samples per symbol (bit), is actually
%                           rendundant, is equal to fsample/fsymbol
%
% POST:     symbolDecision (row vector) contains corresponding correlation values between -1
%           and +1.
%           -1 for logic 0, +1 for logic 1
%           
%
% notes:    normalize signal to its highest peak
%           test correlation with all possible phases
%           
%           Signals are already filtered, use samplesf0 for correlation
%           with f0 and samplesf1 for correlation with f1
% 
%% TODO
% implement complex correlation, so that symbolDecision contains corresponding correlation values
%           -1 for logic 0 (f0), +1 for logic 1 (f1)
%           use samplesf0 for correlation with f0, samplesf1 for correlation with f1
%           The normation is already done by us.
%           
%           if you get stuck look at your correlation code from Nachmittag
%           4, or consult an assistant

t = linspace(0, 1/fsymbol, samplesPerSymDur);
c0 = cos(2*pi*f0*t);
s0 = sin(2*pi*f0*t);
xc0 = xcorr(samplesf0, c0);
xc0 = xc0(end-length(samplesf0)+1:end);

xs0 = xcorr(samplesf0, s0);
xs0 = xs0(end-length(samplesf0)+1:end);

z0 = xc0 + 1j*xs0;
z0_mag = abs(z0);

c1 = cos(2*pi*f1*t);
s1 = sin(2*pi*f1*t);

xc1 = xcorr(samplesf1, c1);
xc1 = xc1(end-length(samplesf1)+1:end);

xs1 = xcorr(samplesf1, s1);
xs1 = xs1(end-length(samplesf1)+1:end);

z1 = xc1 + 1j*xs1;
z1_mag = abs(z1);

symbolDecision = (z1_mag-z0_mag)./max(z1_mag,z0_mag);