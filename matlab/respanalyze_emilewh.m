% analyzeRESP calculates respiration rate using time and frequency domain
% analyses
function [rr,rr_fft] = respanalyze(time,resp,plotsOn)
    % INPUTS: 
    % time: elapsed time (seconds)
    % resp: output from pressure sensor (voltage)
    % plotsOn: true for plots, false for no plots
    
    % OUTPUT:
    % rr: respiration rate (brpm) found from time domain data
    % rr_fft: respiration rate (brpm) found from frequency domain data

    % save orgiinal data
    time_raw = time;
    resp_raw = resp;

    % calculate fs
    fs = 1/mean(diff(time)); % FILL IN CODE HERE

    % remove offset
    resp = resp - mean(resp);

    % bandpass pass filter resp
    w1 = 0.05; % FILL IN CODE HERE
    w2 = 1; % FILL IN CODE HERE
    resp = bandpass(resp,[w1 w2],fs);

    % find peaks
    minimaldist = 1.5;

    [pks, locs] = findpeaks(resp,time, 'MinPeakDistance', minimaldist, 'Minpeakprom', 0.25*std(resp)); % FILL IN CODE HERE (look at findpeaks documentation)


    % calcuate rr
    T = time(end) - time(1);
    if numel(locs)>= 1
        rr = 60/mean(diff(locs));
    elseif T>0
        rr = (numel(pks)/T)*60;
    else 
        rr = NaN;
    end



    % FILL IN CODE HERE

    % fft
    L= length(resp);
    Y = fft(resp);
    P2 = abs(Y/L);
    P1 = P2(1:floor(L/2)+1);
     if numel(P1) > 2
        P1(2:end-1) = 2*P1(2:end-1);
     end
    f = fs*(0:floor(L/2))/L; % FILL IN CODE HERE (look at fft documentation)

    % calcuate rrFft
    bandIdx = (f>=w1) & (f<=w2);
    if any(bandIdx)
        Pbandpass = P1(bandIdx);
        fbandpass = f(bandIdx);
        [peakVal,imax] = max(Pbandpass);
        if peakVal > 0.000001
        fpeaks = fbandpass(imax);
        rr_fft = fpeaks*60; % FILL IN CODE HERE (hint: look at max documentation)
        else
            rr_fft = NaN;
            fpeaks = NaN;
        end
    else
        rr_fft = NaN;
        fpeaks = NaN;
    end

    if plotsOn
        %raw signal
        figure % FILL IN CODE HERE to add legends, axes labels, and * for peaks
        subplot(3,1,1) 
        plot(time_raw,resp_raw)
        grid on
        xlabel('Elapsed Time (s)')
        ylabel('Voltage (V)')


        %filtered signal
        subplot(3,1,2)
        plot(time,resp)
        plot(time, resp, 'b-'); hold on
        if ~isempty(pks)
            plot(locs,pks,'r*')
        end
        hold off
        grid on
        xlabel('Elapsed Time (s)')
        ylabel('Filtered Voltage (V)')
        legend(sprintf('RESP (RR = %.2f brpm)', rr), 'Peaks', 'Location','best')

  

        subplot(3,1,3)
        plot(f,P1,'b-'); hold on
        if ~ isnan(fpeaks)
            [~,k] = min(abs(f - fpeaks));
            plot(f(k), P1(k), 'r*')
        end
        hold off
        grid on
        xlabel('Frequency (Hz)')
        ylabel('P1(f)')
        legend(sprintf('RESP (RR_{FFT} = %.2f brpm)', rr_fft), 'FFT Peak', 'Location','best')
    end
    end