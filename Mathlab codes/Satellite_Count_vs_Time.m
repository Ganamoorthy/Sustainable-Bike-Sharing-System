%% Graph 3: Satellite Count vs Time
clear; clc;

timestamps = [115530, 115532, 115533, 115534, 115535, 115536, 115537, 115538, ...
              115539, 115540, 115541, 115542, 115543, 115544, 115545, 115546, ...
              115547, 115548, 115549, 115550, 115551, 115552, 115553, 115554, ...
              115556, 115557, 115558, 115559, 115600, 115601, 115602, 115603, ...
              115604, 115605, 115606, 115607, 115608, 115609, 115610, 115611, 115612];

satellites = [6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, ...
              6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7];

figure('Color', [1 1 1]);
plot(timestamps, satellites, '-^', 'LineWidth', 1.5, 'Color', [0.47 0.67 0.19]);
grid on;
title('Visible Satellite Connections vs Time');
xlabel('GPS Timestamp (HHMMSS)');
ylabel('Number of Satellites Locked');
ylim([0, max(satellites)+2]);