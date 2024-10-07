u = Util();

N_rep = 1;
q = 1e-1;

s = Source(100, 0.6).bit_sequence;
s_enc = u.repencode(s, N_rep);

s_mod = modulator.modulate(s_enc);
%add some whitenoise
s_modnoise = awgn(s_mod, 0);
s_demod = modulator.demodulate(s_modnoise);

s2_dec = u.repdecode(s_demod, N_rep);
ber = BER.calc_BER(s, s2_dec)
d = Drain(s2_dec);