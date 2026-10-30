%% Graph 5: Network Transmission Statistics Group Comparison
clear; clc;

checkpoint_names = {'Check 1', 'Check 2', 'Check 3', 'Check 4', 'Check 5'};
published_ok = [6, 11, 16, 26, 40];
failed = [0, 0, 0, 0, 0];
offline_queue_depth = [0, 0, 0, 0, 0];

chart_data = [published_ok; failed; offline_queue_depth]';

figure('Color', [1 1 1]);
b = bar(chart_data, 'grouped');

b(1).FaceColor = [0.12, 0.53, 0.22]; 
b(2).FaceColor = [0.84, 0.11, 0.38]; 
b(3).FaceColor = [0.75, 0.75, 0.75]; 

grid on;
set(gca, 'XTickLabel', checkpoint_names);
title('GPS Telemetry Packet Network Success Status');
xlabel('Log Milestone Intervals');
ylabel('Total MQTT Message Count');
legend('Published Successfully', 'Failed Transmissions', 'Offline Backlog Queue', 'Location', 'northwest');