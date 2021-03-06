function [y, heartRate, peakLoc] = calcHR(x, fs)
% FUNCTION CALCHR(X) calculate heart rate according to .... algorithm
%
% In:
%   x : data vector
%   fs: Sampling Frequency
%
% Out:
%   y: filtered, smooth data
%   heartRate: heart rate


%% Initializing
data=x;
L=length(data); 
% fs=L/20;
x=x-mean(x);

%% Pre-processing
fNorm = [1 10] / (fs/2);         %normalized cutoff frequency
type='bandpass';    N=2;
[b,a] = butter(N, fNorm, type);  % 10th order filter
y = filtfilt(b, a, x);
y=y/max(y);
y = smooth(y, 7);



%% R peaks enhancing
% y_slope1=diff(x);y_slope1=[0,y_slope1.^2]';
h_d = [-1 -2 0 2 1]*(1/8); %1/8*fs
y_slope2 = conv (y ,h_d);
y_slope2= y_slope2/max(y_slope2);y_slope2=y_slope2.^2;

% y_savitzky = sgolayfilt(y,0,41);
% y_slope3=y-y_savitzky; y_slope3=y_slope3.^2;

y_slope=y_slope2; % choose slope2


%%  Find peaks
[pks,locs] = findpeaks(y_slope,'MINPEAKDISTANCE',round(0.2*fs));
Thres1_R=mean(pks);
R1=find(pks>=Thres1_R);
R2=locs(R1(:));

% assignin('base', 'pks', pks);
% assignin('base', 'locs', locs);
% assignin('base', 'R1', R1);
% assignin('base', 'R2', R2);

%% Heartbeat Threshold
RR=diff(R2);
heartRate = mean(RR)*60/fs;

peakLoc = R2;

% For DEBUGGING
% figure;
% plot(x);
% hold on;
% plot(y, '--', 'Color', [1 0.5 0.5], 'LineWidth',3);
% plot(R2, x(R2), 'gx', 'MarkerSize', 15, 'LineWidth',2);

