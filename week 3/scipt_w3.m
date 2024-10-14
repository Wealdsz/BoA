u = Util();

N_rep = 4;
q = 1e-1;

s = Source(100, 0.6).bit_sequence;
s_enc = u.repencode(s, N_rep);
s_key = u.add_keys(s_enc);
s_mod = modulator.modulate(s_key);

%channel----
s_modnoise = awgn(s_mod, 10);
s_someerr = [zeros(1, 136), s_modnoise, zeros(1,28)];
%----------------

s_symsync = Sync.symbolsync(s_someerr);
s_demod = modulator.demodulate(s_modnoise);
s_frame = Sync.framesync(s_demod);
s2_dec = u.repdecode(s_frame, N_rep);
ber = BER.calc_BER(s, s2_dec)
d = Drain(s2_dec);
