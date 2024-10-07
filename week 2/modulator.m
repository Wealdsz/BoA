classdef modulator
    properties 
    end
    
    methods(Static)
        function y = modulate(b)
            figure(1);

            n = 1:length(b);
            u = Util();
            
            b_rep = u.repencode(b, constants.tau_S);
            t = 1:length(b_rep);

            %y = sum(b* + (1-b)*)*p(t-n*constants.tau_S);
            subplot(4, 1, 1);
            scatter(n, b);

            subplot(4,1,2);
            scatter(t, b_rep);

            subplot(4, 1, 3);
            a = reshape(1-b_rep, [1,length(b_rep)]);
            c0 = a .* cos(2*pi*constants.f0*t);
            plot(t, c0);
            
            subplot(4, 1, 4);
            a2 = reshape(b_rep, [1, length(b_rep)]);
            c1 = a2 .* cos(2*pi*constants.f1*t);
            plot(t, c1);


            y = c0 + c1;
            subplot(5,1,5);
            plot(t, y);
        end
        
        function y = demodulate(r)
            assert(~mod(constants.tau_S, constants.tau_0));
            assert(~mod(constants.tau_S, constants.tau_1));
            
            N = length(r);
            n = N/constants.tau_S;
            fprintf("N: %i, n: %i", N, n);
            
            k = 1:n;
            t = 1:N;

            x0 = cos(2*pi*constants.f0*t);
            x1 = cos(2*pi*constants.f1*t);
            
            figure(2);
            
            subplot(7, 1, 1);
            plot(t, r);
            

            subplot(7, 1, 2);
            rx0 = r.*x0;
            plot(t, rx0);

            subplot(7, 1, 3)
            z0_mat = reshape(rx0, [constants.tau_S, n]);
            z0 = sum(z0_mat);
            scatter(k, z0);

            subplot(7, 1, 4);
            rx1 = r.*x1;
            plot(t, rx1);

            subplot(7, 1, 5);
            z1_mat = reshape(rx1, [constants.tau_S, n]);
            z1 = sum(z1_mat);
            scatter(k, z1, "filled");

            subplot(7, 1, 6);
            z_diff = z1 - z0;
            scatter(k, z_diff, "filled");

            subplot(7, 1, 7);
            b_hat = modulator.detect(z_diff);
            scatter(k, b_hat, "pentagram", "filled");

            y = b_hat;
        end
        
        function r = p(input)
            r = 0;
            if input >= 0 && input < constants.tau_S
                r = 1;
            end
        end

        function r = detect(input)
            pos = input > 0;
            r = zeros(1, length(input));
            r(pos) = 1;
        end
    end
end

