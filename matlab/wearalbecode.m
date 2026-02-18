clear 
clc
close all

%% Connect Arduino

a = arduino();

%% Collect and Save Data

% define variables and call pressureSensor function
sampleTime = 300;
thresh = 4;
livePlot = false;
pauseTime = 0;
% disp("Trial 1: No Object")
data1 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
% pause(3)
% disp("Trial 2: No Object")
%data2 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
% pause(3)
% disp("Trial 1: Lemon Cake")
%data3 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
% pause(3)
% disp("Trial 2: Lemon Cake")
% data4 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
% pause(3)
% disp("Trial 1: Speaker")
% data5 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
% pause(3)
% disp("Trial 2: Speaker")
% data6 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);

%for the changing R1
%disp("Single R1")
%data1 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
% pause(60)
%disp("R1 in series")
%data2 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
% pause(60)
%disp("R1 in Parallel")
%data3 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);

%Vout = [mean(data1.voltage) mean(data2.voltage) mean(data3.voltage)];


%figure
%plot(data1.time,data1.voltage); 
% calcuate data acqusition rate
fs = 1/diff(data1.time);

% calculate R2 using R1, Vin, and Vout
% R1 = 100;
% Vin = 5;
% Vout = [mean(data1.voltage) mean(data2.voltage) mean(data3.voltage) mean(data4.voltage) mean(data5.voltage) mean(data6.voltage)];
% r2 = R1.*Vout./(Vin-Vout);

% save pressureSensor output table to a study array, table, or structure
study = data1;

% save pressureSensor output table to a csv in your data folder
writetable(data1, fullfile(pwd,'pressureSensorData.csv'))


%% Figure 1. Calculate Resistance
% 
% figure
% plot(data1.time,data1.voltage, 'DisplayName', ['No Object 1: R2 ' num2str(r2(1))])
% hold on
% plot(data2.time,data2.voltage, 'DisplayName',  ['No Object 2: R2 ' num2str(r2(2))])
% hold on
% plot(data3.time,data3.voltage, 'DisplayName',  ['Lemon Cake 1: R2 ' num2str(r2(3))])
% hold on
% plot(data4.time,data4.voltage, 'DisplayName',  ['Lemon Cake 2: R2 ' num2str(r2(4))])
% hold on
% plot(data5.time,data5.voltage, 'DisplayName',  ['Speaker 1: R2 ' num2str(r2(5))])
% hold on
% plot(data6.time,data6.voltage, 'DisplayName',  ['Speaker 2: R2 ' num2str(r2(6))])
% legend('show')
% xlabel('Elapsed Time (seconds)')
% ylabel('Voltage (V)')
% title('Figure 1. Calculate Resistance')


%% Figure 2. Changing R1

% figure
% plot(data1.time,data1.voltage, 'DisplayName', ['Single Resistor ' num2str(Vout(1))])
% hold on
% plot(data2.time,data2.voltage, 'DisplayName', ['Two Resistors in Series ' num2str(Vout(2))])
% hold on
% plot(data3.time,data3.voltage, 'DisplayName', ['Two Resistors in Parallel ' num2str(Vout(3))])
% legend('show')
% xlabel('Elapsed Time (seconds)')
% ylabel('Voltage (V)')
% title('Figure 2. Changing R1')

%% Figure 3. Respiration

figure
plot(data1.time,data1.voltage)
 xlabel('Elapsed Time (seconds)')
 ylabel('Voltage (V)')
 title('Figure 3. Emile Respiration')
result = [data1.time, data1.voltage];
writematrix(result, fullfile(pwd,'WhittleHageEmile_Respiration.csv'))