function [syncedMessage] = syncAndCompress(symbolDecision, beginFlagPosition, endFlagPosition, samplesPerSymDur)
%syncAndCompress returns vector with sample data of full message.
%   PRE: boolMessage vector containig all bools for each sample
%   POST: trustBits containing the non-error probability for each bit in
%         cut Message.


%% cut message

cutMessage = symbolDecision(beginFlagPosition:endFlagPosition+9*samplesPerSymDur-1);

if mod(length(cutMessage),samplesPerSymDur)~=0
    %fill with zeros or cut
    if (mod(cutMessage,samplesPerSymDur)< samplesPerSymDur/2)
        cutMessage = cutMessage(1:length(cutMessage)-mod(length(cutMessage),samplesPerSymDur));
    else
        cutMessage = [cutMessage,zeros(1,samplesPerSymDur-mod(length(cutMessage),samplesPerSymDur))];
    end
end

% window uniform
% window = ones(1,samplesPerSymDur);
% sine
% window = sin((1:samplesPerSymDur)strrep/samplesPerSymDur*pi);
% Gauss
% window = gaussmf(1:samplesPerSymDur,[samplesPerSymDur/4 samplesPerSymDur/2]);
% Tukey window
% window = tukeywin(samplesPerSymDur,0.7)';

% select sample in the middle
window = zeros(1,samplesPerSymDur);
window(ceil(samplesPerSymDur/2)) = 1;

summs = (reshape(cutMessage,samplesPerSymDur,[])')*window'/sum(window);
syncedMessage = ((summs ./ abs(summs) +1)/2)';
syncedMessage(isnan(syncedMessage)) = 0; % catch division with 0

end

