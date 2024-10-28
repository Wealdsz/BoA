function [] = toNiceText(message,endAddress)
% PRE:   message: full message as string
%        endAddress: position of end of address block in number of bytes
% POST:  message split up into different fields
% reference: AX.25 Link Access Protocol for Amateur Packet Radio, Version 2.2

%% Initialize
% keep a copy of original message
originalMsg = message;

% search for specific postition of PID
pos_pid = strfind(message, char((hex2dec('F0'))));

if length(pos_pid) == 0
    return
end

% define lengths
N_address = endAddress;
N_control = 1;  % may be 8 or 16 bits
N_pid = 1;      % only in I frames
N_fcs = 2;  
N_digipeater = pos_pid(end) - N_address - N_control-1;

%% split message into fields
% each time "eat" message until the block ends
address = message(1:N_address);
message = message(N_address+1:end);

digipeater = message(1:N_digipeater);
message = message(N_digipeater+1:end);

control = message(1:N_control);
message = message(N_control+1:end);

PID = message(1:N_pid);

info = originalMsg(pos_pid+1:end-N_fcs);

fcs = originalMsg(end-N_fcs+1: end);

%% print message split into different fields

fprintf('================\nDecoded message:\n================\n');
fprintf('Address: %s\n', address);
fprintf('digipeater: %s\n', digipeater);
fprintf('control: %s\n', control);
fprintf('pid: %s\n', PID);
fprintf('info: %s\n', info);
fprintf('fcs (bin): %s\n', dec2bin(double(fcs)));

end     