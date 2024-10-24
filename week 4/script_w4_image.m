sound = BoAudio();
util = Util();

%read image file
file = fopen("week 4/res/file.txt");
seq = fread(file, 'ubit1');
fclose(file);
%-----------

seq = reshape(seq, [1, length(seq)]);
seq = util.repencode(seq, 1);
seq = util.add_keys(seq);
s_mod = modulator.modulate(seq);
s_mod = [zeros(1, 1e3), s_mod, zeros(1, 1e3)];

figure(4);
subplot(2, 1, 1);
plot(seq);

subplot(2, 1, 2);
plot(s_mod);

input("press enter to start.");
sound.playsound(s_mod);