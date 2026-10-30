%% Graph 1: GPS Accuracy (Latitude Error) vs Time
clear; clc;

% 1. Populate log data matrix 
timestamps = [93510, 93516, 93522, 93528, 93534, 93540, 93546, 93552, 93558, ...
              93564, 93600, 93606, 93612, 93618, 93624, 93630, 93636, 93642, ...
              93648, 93654, 93660, 93666, 93672, 93678, 93684, 93690, 93696, ...
              93702, 93708, 93714, 93720, 93726, 93732, 93738, 93744, 93750, ...
              93756, 93762, 93768, 93774, 93780, 93786, 93792, 93798, 93804, ...
              93810, 93816, 93822, 93828, 93835, 93841, 93847, 93853, 93859, ...
              93865, 93871, 93877, 93883, 93889, 93895, 93901, 93907, 93913, ...
              93919, 93925, 93931];

latitudes = zeros(1, length(timestamps)); % All values are 0.000000 in this log run

% 2. Calculate Deviation Error (Converted to meters: 1 deg lat ≈ 111,320m)
mean_lat = mean(latitudes);
lat_error_meters = (latitudes - mean_lat) * 111320;

% 3. Plotting
figure('Color', [1 1 1]);
plot(timestamps, lat_error_meters, '-o', 'LineWidth', 1.5, 'Color', [0.85 0.33 0.1]);
grid on;
title('GPS Accuracy (Latitude Drift Error Over Time)');
xlabel('GPS Sequence Timestamp Reference');
ylabel('Latitude Position Error (Meters)');