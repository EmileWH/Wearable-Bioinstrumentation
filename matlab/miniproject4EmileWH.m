clear 
clc
close all

% load pressureSensor output table 
%data = readtable('C:\Users\username\git\wearable-bioinstrumentation\data\Whittle-HageEmile_Respiration.csv');
data = readtable("WhittleHageEmile_Respiration.csv");

% remove portions of the data when you were not lying on the sensor (when pressed was false)
time = data.Var1;
resp = data.Var2;

% time = data.time(logical(data.pressed));
% resp = data.voltage(logical(data.pressed));

time = time(:);
resp = resp(:);

% specify plotsOn true or false
plotsOn = true;

% specify timeSteps
totalTime = 300;
stepTime = 30;
timeSteps = 0:stepTime:300;

% initialize output table
output = array2table(nan([length(timeSteps)-1,3]),'VariableNames',{'time','rr','rr_fft'});

% loop through each window of time and run analyzeRESP to calculate RR and
% RR FFT, save respiration rates to output table
for i = 2:length(timeSteps)
    % only look at specificed portion of the time and resp signals
    startTime = timeSteps(i-1);
    endTime = timeSteps(i);
    ind = time >= startTime & time < endTime;
    timeTemp = time(ind);
    respTemp = resp(ind);
    if numel(timeTemp)<5
        rr = NaN;
        rr_fft = NaN;
    else
        [rr, rr_fft] = respanalyze(timeTemp, respTemp, plotsOn);
    end

  %  save respiration rates to output table
    output.time(i-1) = endTime;
    output.rr(i-1) = rr;
    output.rr_fft(i-1) = rr_fft;
end
% [rr, rr_fft] = respanalyze(time, resp, plotsOn);
% plot respiration rate over time
figure
plot(output.time,output.rr,'.-')
hold on 
plot(output.time,output.rr_fft,'.-')
hold off
xlabel('time')
ylabel('respiration rate')
hold off
grid on
xlabel('Time (s)')
ylabel('Respiration Rate (brpm)')
legend('RR (time domain)','RR_{FFT} (frequency domain)','Location','best')
title('Respiration Rate Over Time')

disp(output)
