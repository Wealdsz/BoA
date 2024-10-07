u = Util();
%c.loop();
%c.gauss(0.67, 0.11);

N_rep = 1;
q = 1e-1;

s = Source(100, 0.6).bit_sequence;
s_enc = u.repencode(s, N_rep);
s2 = BSC_channel.channel(s_enc, q);
s2_dec = u.repdecode(s2, N_rep);
ber = BER.calc_BER(s, s2_dec)
d = Drain(s2_dec);

disp(d.Mean);