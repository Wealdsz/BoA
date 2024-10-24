u = Util();

N_rep = 3;
q = 1e-1;

s = Source(10, 0.6).bit_sequence;
s_enc = u.repencode(s, N_rep);

figure(3);
subplot(5, 1, 1);
scatter(1:length(s_enc), s_enc);

s_key = u.add_keys(s_enc);

s_mod = modulator.modulate(s_key);
figure(3);
subplot(5, 1, 2);
plot(1:length(s_mod), s_mod);

%channel----
% s_modnoise = awgn(s_mod, 0);
% s_someerr = [zeros(1, 345), s_modnoise, zeros(1,28)];
% figure(3);
% subplot(5, 1, 3);
% plot(1:length(s_someerr), s_someerr);
%----------------


s_symsync = Sync.symbolsync(s_mod);
s_demod = modulator.demodulate(s_symsync);

figure(3);
subplot(5, 1, 4);
scatter(1:length(s_demod), s_demod);

s_frame = Sync.framesync(s_demod);

figure(3);
subplot(5, 1, 5);
scatter(1:length(s_frame), s_frame);

s2_dec = u.repdecode(s_frame, N_rep);
ber = BER.calc_BER(s, s2_dec)
d = Drain(s2_dec);

