classdef BoAudio < handle
    properties
        arec
    end
    
    methods
        function self = BoAudio()
            nbits = 16;
            self.arec = audiorecorder(constants.fs, nbits, 1);
        end

        function y = recordsound(self)
            self.arec.record();
            input("Press a key to stop recording.");
            self.arec.stop();
            rec = self.arec.getaudiodata();
            rec = reshape(rec, [1, length(rec)]);
            y = [zeros(1, 1e3), rec, zeros(1, 1e3)];
            disp("recording finished");
        end

        function playsound(self, x)
            in = reshape(x, [length(x), 1]);
            disp("playing some audio for u <3");
            player = audioplayer(in, constants.fs, 16);
            player.playblocking();
            disp("finished playing");
        end

        function y = playcord(self, sig)
            r = audiorecorder(constants.fs, 16, 1);
            s = [zeros(1, 2e3), sig, zeros(1, 2e3)];
            s = reshape(s, [length(s), 1]);
            pl = audioplayer(s, constants.fs, 16);
            r.record();
            pl.playblocking();
            r.stop();

            rec = r.getaudiodata();
            y = reshape(rec, [1, length(rec)]);
        end
    end
end

