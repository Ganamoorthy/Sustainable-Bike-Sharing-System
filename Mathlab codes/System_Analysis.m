%% Complete System Analysis - GPS, Battery, and Cellular
% Analyzes GPS performance, battery health, and cellular network status
% from the system log output

clear; clc; close all;

%% ==================== DATA EXTRACTION ====================
% Raw GPS Data from Log (Extracted)
% Each row represents one GPS publish event
% Format: [timestamp, lat, lon, alt, speed, hdop, sat, v1, v2, v3, vtot, rssi, mcc, mnc, lac, cid]

gps_data = [
    % [ts, lat, lon, alt, spd, hdop, sat, v1, v2, v3, vtot, rssi, mcc, mnc, lac, cid]
    072157, 6.972353, 79.915001, 49.4, 1.52, 1.2, 7, 3.75, 3.07, 3.92, 10.74, 99, 0, 0, 0, 0;
    072158, 6.972354, 79.914999, 49.5, 1.02, 1.2, 7, 3.75, 3.06, 3.93, 10.74, 99, 0, 0, 0, 0;
    072159, 6.972351, 79.915002, 49.3, 1.28, 1.4, 6, 3.75, 3.06, 3.93, 10.74, 99, 0, 0, 0, 0;
    072200, 6.972345, 79.915005, 49.2, 1.22, 1.4, 6, 3.75, 3.06, 3.93, 10.74, 99, 413, 8, 40022, 570470;
    072201, 6.972349, 79.915008, 49.7, 1.22, 2.2, 6, 3.75, 3.06, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072202, 6.972351, 79.915009, 50.2, 2.26, 2.2, 5, 3.75, 3.06, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072203, 6.972345, 79.915017, 49.4, 1.72, 2.2, 5, 3.75, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072204, 6.972347, 79.915019, 49.9, 1.33, 2.2, 5, 3.75, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072205, 6.972345, 79.915023, 49.7, 1.06, 3.1, 4, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072206, 6.972343, 79.915022, 50.1, 1.69, 1.4, 6, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072207, 6.972347, 79.915021, 50.8, 1.04, 1.2, 8, 3.75, 3.06, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072208, 6.972344, 79.915026, 50.8, 0.69, 1.4, 9, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072209, 6.972346, 79.915032, 50.6, 1.06, 1.3, 9, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072210, 6.972350, 79.915033, 51.3, 0.59, 1.0, 9, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072211, 6.972353, 79.915027, 52.2, 1.20, 1.0, 9, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072212, 6.972362, 79.915022, 54.1, 0.46, 1.0, 9, 3.75, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072213, 6.972370, 79.915016, 56.0, 0.22, 1.0, 9, 3.75, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072215, 6.972377, 79.915016, 58.2, 0.41, 1.0, 11, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072216, 6.972378, 79.915019, 59.7, 0.17, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072217, 6.972380, 79.915020, 61.0, 0.06, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072218, 6.972383, 79.915016, 62.5, 0.72, 0.9, 10, 3.75, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072219, 6.972387, 79.915019, 63.9, 0.85, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072220, 6.972388, 79.915021, 64.5, 0.83, 0.9, 10, 3.75, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072221, 6.972386, 79.915020, 64.8, 1.37, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072222, 6.972383, 79.915024, 65.8, 1.43, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072223, 6.972380, 79.915022, 65.6, 0.80, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072224, 6.972382, 79.915023, 66.5, 0.30, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072225, 6.972378, 79.915024, 66.6, 0.19, 0.9, 10, 3.75, 3.06, 3.93, 10.74, 31, 413, 8, 40022, 570470;
    072226, 6.972376, 79.915026, 66.5, 0.07, 1.0, 10, 3.75, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072227, 6.972374, 79.915027, 66.8, 0.07, 1.3, 10, 3.75, 3.07, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072228, 6.972372, 79.915033, 67.0, 1.61, 1.0, 10, 3.75, 3.07, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072229, 6.972372, 79.915031, 67.5, 0.74, 0.9, 11, 3.75, 3.07, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072230, 6.972377, 79.915037, 68.8, 2.30, 0.9, 10, 3.75, 3.07, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072231, 6.972375, 79.915042, 69.7, 2.41, 0.9, 10, 3.75, 3.07, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072232, 6.972378, 79.915046, 70.6, 2.50, 0.9, 10, 3.74, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072233, 6.972384, 79.915054, 71.0, 2.98, 0.9, 10, 3.74, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072234, 6.972388, 79.915064, 70.7, 3.39, 0.9, 10, 3.74, 3.07, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072235, 6.972389, 79.915070, 69.7, 1.70, 0.9, 10, 3.74, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072236, 6.972389, 79.915073, 69.5, 0.61, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072237, 6.972386, 79.915077, 69.3, 0.91, 0.9, 10, 3.74, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072239, 6.972384, 79.915080, 69.0, 0.50, 1.0, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072240, 6.972386, 79.915083, 68.8, 0.57, 0.9, 10, 3.75, 3.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072241, 6.972387, 79.915085, 69.0, 0.61, 1.0, 11, 3.75, 3.06, 3.93, 10.74, 31, 413, 8, 40022, 570470;
    072242, 6.972386, 79.915089, 68.4, 1.59, 1.0, 10, 3.75, 3.07, 3.93, 10.74, 31, 413, 8, 40022, 570470;
    072243, 6.972386, 79.915095, 68.0, 2.19, 1.0, 11, 3.75, 3.07, 3.93, 10.74, 31, 413, 8, 40022, 570470;
    072244, 6.972391, 79.915101, 67.9, 2.93, 0.9, 11, 3.74, 3.07, 3.93, 10.74, 31, 413, 8, 40022, 570470;
    072245, 6.972397, 79.915108, 68.2, 3.13, 0.9, 11, 3.74, 3.07, 3.93, 10.74, 31, 413, 8, 40022, 570470;
    072246, 6.972397, 79.915117, 67.7, 3.22, 0.9, 11, 3.74, 3.07, 3.93, 10.74, 31, 413, 8, 40022, 570470;
    072247, 6.972396, 79.915124, 67.5, 3.07, 1.0, 10, 3.74, 3.07, 3.93, 10.74, 31, 413, 8, 40022, 570470;
    072248, 6.972392, 79.915130, 67.5, 2.37, 0.9, 11, 3.74, 3.07, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072249, 6.972390, 79.915134, 67.3, 1.81, 0.9, 11, 3.67, 3.14, 3.93, 10.75, 31, 413, 8, 40022, 570470;
    072250, 6.972391, 79.915138, 67.4, 1.33, 0.9, 11, 3.60, 3.21, 3.94, 10.75, 29, 413, 8, 40022, 570470;
    072251, 6.972396, 79.915142, 67.5, 2.13, 1.0, 10, 3.53, 3.28, 3.93, 10.75, 29, 413, 8, 40022, 570470;
    072252, 6.972391, 79.915144, 67.7, 2.43, 1.0, 9, 3.46, 3.35, 3.94, 10.75, 29, 413, 8, 40022, 570470;
    072253, 6.972385, 79.915149, 67.6, 2.44, 1.0, 9, 3.39, 3.42, 3.93, 10.74, 29, 413, 8, 40022, 570470;
    072254, 6.972384, 79.915151, 67.7, 1.89, 1.0, 10, 3.46, 3.35, 3.93, 10.74, 29, 413, 8, 40022, 570470;
    072255, 6.972384, 79.915146, 68.2, 0.87, 0.9, 11, 3.52, 3.29, 3.93, 10.74, 29, 413, 8, 40022, 570470;
    072256, 6.972378, 79.915145, 67.7, 1.24, 0.9, 11, 3.52, 3.29, 3.93, 10.74, 29, 413, 8, 40022, 570470;
    072257, 6.972373, 79.915150, 67.6, 1.19, 0.9, 11, 3.51, 3.29, 3.94, 10.75, 29, 413, 8, 40022, 570470;
    072258, 6.972370, 79.915158, 67.2, 1.59, 0.9, 11, 3.44, 3.36, 3.94, 10.75, 29, 413, 8, 40022, 570470;
    072259, 6.972369, 79.915159, 67.1, 1.33, 0.9, 11, 3.37, 3.43, 3.94, 10.75, 29, 413, 8, 40022, 570470;
    072300, 6.972368, 79.915151, 67.3, 1.09, 0.9, 11, 3.30, 3.50, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072302, 6.972361, 79.915150, 67.6, 0.87, 0.9, 11, 3.23, 3.57, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072303, 6.972360, 79.915152, 67.6, 0.67, 0.9, 11, 3.16, 3.64, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072304, 6.972361, 79.915150, 67.6, 0.24, 0.9, 11, 3.09, 3.71, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072305, 6.972355, 79.915154, 67.5, 0.76, 1.0, 10, 3.02, 3.78, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072306, 6.972354, 79.915153, 67.6, 0.09, 1.0, 10, 2.95, 3.85, 3.95, 10.76, 31, 413, 8, 40022, 570470;
    072307, 6.972349, 79.915158, 67.5, 1.33, 1.0, 10, 2.88, 3.92, 3.95, 10.75, 31, 413, 8, 40022, 570470;
    072308, 6.972343, 79.915164, 67.5, 3.22, 1.0, 10, 2.81, 3.99, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072309, 6.972338, 79.915169, 67.4, 3.39, 0.9, 11, 2.74, 4.06, 3.94, 10.75, 31, 413, 8, 40022, 570470;
    072310, 6.972334, 79.915172, 66.9, 3.24, 0.9, 10, 2.74, 4.06, 3.94, 10.75, 29, 413, 8, 40022, 570470;
    072311, 6.972324, 79.915176, 66.9, 3.15, 0.9, 10, 2.67, 4.13, 3.94, 10.75, 29, 413, 8, 40022, 570470;
    072312, 6.972319, 79.915180, 66.8, 2.78, 0.9, 10, 2.60, 4.20, 3.94, 10.75, 29, 413, 8, 40022, 570470;
    072313, 6.972316, 79.915183, 66.7, 2.22, 0.9, 10, 2.53, 4.26, 3.94, 10.74, 29, 413, 8, 40022, 570470;
    072314, 6.972314, 79.915185, 66.4, 1.78, 0.9, 10, 2.46, 4.31, 3.94, 10.72, 29, 413, 8, 40022, 570470;
    072315, 6.972312, 79.915188, 66.3, 1.22, 0.9, 10, 2.39, 4.35, 3.95, 10.69, 29, 413, 8, 40022, 570470;
    072316, 6.972308, 79.915193, 66.3, 1.48, 0.9, 11, 2.32, 4.38, 3.94, 10.65, 29, 413, 8, 40022, 570470;
    072317, 6.972308, 79.915198, 66.1, 1.43, 0.9, 11, 2.25, 4.40, 3.94, 10.60, 29, 413, 8, 40022, 570470;
    072318, 6.972307, 79.915209, 66.0, 2.19, 0.9, 11, 2.18, 4.42, 3.94, 10.55, 29, 413, 8, 40022, 570470;
    072319, 6.972313, 79.915219, 65.3, 3.24, 0.9, 11, 2.11, 4.44, 3.94, 10.50, 29, 413, 8, 40022, 570470;
    072320, 6.972310, 79.915222, 64.6, 1.24, 0.9, 11, 2.04, 4.45, 3.94, 10.44, 31, 413, 8, 40022, 570470;
    072321, 6.972308, 79.915223, 64.5, 1.07, 0.9, 11, 1.97, 4.46, 3.93, 10.37, 31, 413, 8, 40022, 570470;
    072322, 6.972302, 79.915225, 63.8, 0.46, 0.9, 11, 1.90, 4.47, 3.93, 10.31, 31, 413, 8, 40022, 570470;
    072323, 6.972296, 79.915228, 63.3, 2.32, 0.9, 11, 1.90, 4.47, 3.93, 10.31, 31, 413, 8, 40022, 570470;
    072324, 6.972287, 79.915235, 62.6, 2.24, 0.9, 11, 1.83, 4.47, 3.94, 10.25, 31, 413, 8, 40022, 570470;
    072326, 6.972282, 79.915250, 61.5, 1.02, 0.9, 11, 1.76, 4.48, 3.94, 10.18, 31, 413, 8, 40022, 570470;
    072327, 6.972285, 79.915251, 61.2, 1.24, 0.9, 10, 1.80, 4.48, 3.94, 10.22, 31, 413, 8, 40022, 570470;
    072328, 6.972288, 79.915253, 61.2, 1.09, 0.9, 11, 1.87, 4.41, 3.94, 10.22, 31, 413, 8, 40022, 570470;
    072329, 6.972291, 79.915256, 61.2, 1.26, 0.9, 11, 1.94, 4.34, 3.94, 10.22, 31, 413, 8, 40022, 570470;
    072330, 6.972294, 79.915251, 60.7, 1.87, 0.9, 11, 2.01, 4.27, 3.94, 10.22, 31, 413, 8, 40022, 570470;
    072331, 6.972294, 79.915255, 60.9, 0.39, 0.8, 12, 2.08, 4.20, 3.94, 10.22, 29, 413, 8, 40022, 570470;
    072332, 6.972293, 79.915257, 61.1, 0.93, 0.8, 12, 2.15, 4.13, 3.94, 10.23, 29, 413, 8, 40022, 570470;
    072333, 6.972292, 79.915258, 61.2, 0.17, 0.8, 12, 2.08, 4.20, 3.94, 10.22, 29, 413, 8, 40022, 570470;
    072334, 6.972289, 79.915259, 60.4, 0.06, 0.8, 11, 2.01, 4.26, 3.94, 10.21, 29, 413, 8, 40022, 570470;
    072335, 6.972288, 79.915262, 59.8, 0.41, 0.9, 10, 1.94, 4.31, 3.94, 10.19, 29, 413, 8, 40022, 570470;
    072336, 6.972288, 79.915265, 59.6, 0.61, 0.9, 10, 1.87, 4.35, 3.94, 10.16, 29, 413, 8, 40022, 570470;
    072337, 6.972290, 79.915268, 59.5, 1.19, 0.9, 11, 1.87, 4.35, 3.94, 10.16, 29, 413, 8, 40022, 570470;
    072338, 6.972292, 79.915269, 59.7, 0.98, 0.8, 11, 1.80, 4.38, 3.94, 10.12, 29, 413, 8, 40022, 570470;
    072339, 6.972297, 79.915272, 60.0, 1.54, 0.8, 11, 1.73, 4.40, 3.94, 10.07, 29, 413, 8, 40022, 570470;
    072340, 6.972303, 79.915275, 60.6, 1.80, 0.8, 11, 1.66, 4.42, 3.94, 10.02, 31, 413, 8, 40022, 570470;
    072341, 6.972312, 79.915278, 60.4, 2.22, 0.8, 11, 1.59, 4.44, 3.94, 9.97, 31, 413, 8, 40022, 570470;
    072342, 6.972313, 79.915278, 61.2, 0.80, 0.9, 9, 1.52, 4.45, 3.94, 9.91, 31, 413, 8, 40022, 570470;
    072343, 6.972313, 79.915281, 61.2, 0.46, 0.9, 10, 1.45, 4.46, 3.94, 9.85, 31, 413, 8, 40022, 570470;
    072344, 6.972314, 79.915283, 61.4, 0.48, 0.9, 9, 1.38, 4.47, 3.94, 9.79, 31, 413, 8, 40022, 570470;
    072345, 6.972317, 79.915284, 61.9, 0.37, 0.8, 11, 1.31, 4.47, 3.95, 9.73, 31, 413, 8, 40022, 570470;
    072346, 6.972313, 79.915289, 62.1, 2.76, 0.9, 10, 1.24, 4.48, 3.94, 9.66, 31, 413, 8, 40022, 570470;
    072347, 6.972317, 79.915295, 62.0, 2.63, 0.9, 11, 1.17, 4.48, 3.94, 9.60, 31, 413, 8, 40022, 570470;
    072349, 6.972324, 79.915308, 62.0, 3.11, 1.1, 8, 1.10, 4.49, 3.94, 9.53, 31, 413, 8, 40022, 570470;
    072350, 6.972328, 79.915310, 62.0, 2.17, 1.5, 8, 1.10, 4.49, 3.94, 9.53, 31, 413, 8, 40022, 570470;
    072351, 6.972330, 79.915317, 62.2, 1.39, 1.5, 8, 1.03, 4.49, 3.94, 9.46, 31, 413, 8, 40022, 570470;
    072352, 6.972327, 79.915320, 60.6, 1.31, 1.0, 10, 0.96, 4.49, 3.94, 9.39, 31, 413, 8, 40022, 570470;
    072353, 6.972327, 79.915323, 60.4, 0.69, 1.0, 9, 0.89, 4.49, 3.93, 9.32, 31, 413, 8, 40022, 570470;
    072354, 6.972325, 79.915326, 60.2, 0.61, 1.0, 9, 0.83, 4.49, 3.94, 9.26, 31, 413, 8, 40022, 570470;
    072355, 6.972320, 79.915329, 59.4, 1.09, 1.0, 10, 0.77, 4.50, 3.94, 9.21, 31, 413, 8, 40022, 570470;
    072356, 6.972319, 79.915333, 60.0, 1.48, 1.0, 10, 0.73, 4.50, 3.94, 9.17, 31, 413, 8, 40022, 570470;
    072357, 6.972314, 79.915336, 59.4, 2.04, 0.8, 11, 0.70, 4.50, 3.94, 9.13, 31, 413, 8, 40022, 570470;
    072358, 6.972310, 79.915340, 58.7, 1.52, 0.8, 11, 0.67, 4.50, 3.94, 9.11, 31, 413, 8, 40022, 570470;
    072359, 6.972307, 79.915342, 57.9, 1.11, 0.8, 11, 0.65, 4.50, 3.94, 9.09, 31, 413, 8, 40022, 570470;
    072400, 6.972305, 79.915341, 56.8, 0.44, 0.8, 11, 0.63, 4.50, 3.94, 9.07, 31, 413, 8, 40022, 570470;
    072401, 6.972303, 79.915341, 56.2, 0.09, 0.8, 11, 0.62, 4.50, 3.94, 9.05, 31, 413, 8, 40022, 570470;
    072402, 6.972305, 79.915340, 56.2, 0.28, 0.8, 11, 0.61, 4.50, 3.94, 9.04, 31, 413, 8, 40022, 570470;
    072403, 6.972297, 79.915336, 56.2, 3.39, 0.8, 11, 0.61, 4.50, 3.94, 9.04, 31, 413, 8, 40022, 570470;
    072404, 6.972291, 79.915335, 55.6, 2.28, 0.8, 11, 0.60, 4.50, 3.94, 9.03, 31, 413, 8, 40022, 570470;
    072405, 6.972290, 79.915328, 55.7, 2.44, 0.8, 11, 0.59, 4.50, 3.93, 9.01, 31, 413, 8, 40022, 570470;
    072406, 6.972292, 79.915321, 55.7, 2.35, 1.0, 10, 0.58, 4.50, 3.93, 9.01, 31, 413, 8, 40022, 570470;
    072407, 6.972296, 79.915318, 55.3, 1.81, 1.0, 10, 0.58, 4.50, 3.94, 9.01, 31, 413, 8, 40022, 570470;
    072408, 6.972300, 79.915317, 55.3, 1.89, 1.0, 9, 0.57, 4.50, 3.94, 9.01, 31, 413, 8, 40022, 570470;
    072409, 6.972307, 79.915316, 55.2, 2.04, 1.0, 10, 0.57, 4.50, 3.94, 9.01, 31, 413, 8, 40022, 570470;
    072410, 6.972307, 79.915309, 55.1, 2.82, 1.0, 9, 0.57, 4.50, 3.94, 9.01, 30, 413, 8, 40022, 570470;
    072411, 6.972315, 79.915301, 54.9, 3.28, 1.0, 9, 0.57, 4.50, 3.94, 9.01, 30, 413, 8, 40022, 570470;
    072413, 6.972309, 79.915294, 55.1, 2.13, 1.0, 9, 0.56, 4.50, 3.94, 9.00, 30, 413, 8, 40022, 570470;
    072414, 6.972304, 79.915293, 55.2, 2.24, 1.0, 10, 0.56, 4.50, 3.94, 9.00, 30, 413, 8, 40022, 570470;
    072415, 6.972300, 79.915286, 54.9, 2.72, 1.0, 10, 0.56, 4.50, 3.93, 8.99, 30, 413, 8, 40022, 570470;
    072416, 6.972297, 79.915280, 54.4, 2.91, 1.0, 10, 0.56, 4.50, 3.94, 9.00, 30, 413, 8, 40022, 570470;
    072417, 6.972292, 79.915274, 54.2, 3.15, 1.0, 9, 0.56, 4.50, 3.94, 9.00, 30, 413, 8, 40022, 570470;
    072418, 6.972289, 79.915268, 54.2, 2.93, 1.0, 10, 0.56, 4.50, 3.94, 8.99, 30, 413, 8, 40022, 570470;
    072419, 6.972292, 79.915282, 54.0, 0.67, 1.0, 10, 0.55, 4.50, 3.94, 9.00, 30, 413, 8, 40022, 570470;
    072420, 6.972297, 79.915282, 53.9, 1.19, 1.0, 10, 0.55, 4.50, 3.94, 8.99, 30, 413, 8, 40022, 570470;
];

%% ==================== EXTRACT DATA ====================
time_idx = 1:size(gps_data, 1);
timestamp = gps_data(:, 1);
lat = gps_data(:, 2);
lon = gps_data(:, 3);
altitude = gps_data(:, 4);
speed = gps_data(:, 5);
hdop = gps_data(:, 6);
satellites = gps_data(:, 7);

% Battery Data
v1 = gps_data(:, 8);  % Cell 1 voltage
v2 = gps_data(:, 9);  % Cell 2 voltage  
v3 = gps_data(:, 10); % Cell 3 voltage
vtot = gps_data(:, 11); % Total battery voltage
cell_imbalance = max([v1, v2, v3], [], 2) - min([v1, v2, v3], [], 2);

% Cellular Data
rssi = gps_data(:, 12); % Received Signal Strength Indicator
mcc = gps_data(:, 13);  % Mobile Country Code
mnc = gps_data(:, 14);  % Mobile Network Code
lac = gps_data(:, 15);  % Location Area Code
cid = gps_data(:, 16);  % Cell ID

%% ==================== CREATE FIGURES ====================

%% FIGURE 1: GPS Accuracy
figure('Position', [50, 50, 900, 600]);
subplot(2,1,1);
ref_lat = lat(1);
lat_error = (lat - ref_lat) * 111320;
plot(time_idx, lat_error, 'b-', 'LineWidth', 2);
hold on;
yline(0, 'r--', 'Reference', 'LineWidth', 1.5);
grid on;
xlabel('Sample Number');
ylabel('Latitude Error (meters)');
title('GPS Accuracy: Latitude Error');
legend('Latitude Error', 'Reference');
xlim([1, length(time_idx)]);

subplot(2,1,2);
plot(time_idx, lat, 'g-', 'LineWidth', 2);
grid on;
xlabel('Sample Number');
ylabel('Latitude (degrees)');
title('GPS Latitude Measurements');
xlim([1, length(time_idx)]);
sgtitle('Figure 1: GPS Accuracy');

%% FIGURE 2: HDOP vs Time
figure('Position', [50, 50, 900, 500]);
plot(time_idx, hdop, 'r-o', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
yline(1.0, 'g--', 'Good (≤1.0)', 'LineWidth', 1.5);
yline(2.0, 'y--', 'Warning (≤2.0)', 'LineWidth', 1.5);
yline(5.0, 'r--', 'Poor (>5.0)', 'LineWidth', 1.5);
grid on;
xlabel('Sample Number');
ylabel('HDOP');
title('Figure 2: HDOP vs Time');
legend('HDOP', 'Good', 'Warning', 'Poor');
xlim([1, length(time_idx)]);
ylim([0, max(hdop) + 0.5]);

% Add shaded regions
yl = ylim;
patch([1, length(time_idx), length(time_idx), 1], [0, 0, 1.0, 1.0], [0, 1, 0, 0.1], 'EdgeColor', 'none');
patch([1, length(time_idx), length(time_idx), 1], [1.0, 1.0, 2.0, 2.0], [1, 1, 0, 0.1], 'EdgeColor', 'none');

%% FIGURE 3: Satellite Count
figure('Position', [50, 50, 900, 500]);
bar(time_idx, satellites, 'FaceColor', [0.2, 0.6, 0.8]);
hold on;
yline(6, 'r--', 'Min Fix (6)', 'LineWidth', 1.5);
yline(8, 'g--', 'Good (8+)', 'LineWidth', 1.5);
grid on;
xlabel('Sample Number');
ylabel('Satellite Count');
title('Figure 3: Satellite Count vs Time');
legend('Satellites', 'Min Fix', 'Good');
xlim([1, length(time_idx)]);
ylim([0, max(satellites) + 2]);
avg_sat = mean(satellites);
yline(avg_sat, 'b--', sprintf('Avg: %.1f', avg_sat));

%% FIGURE 4: Altitude
figure('Position', [50, 50, 900, 500]);
plot(time_idx, altitude, 'm-s', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
grid on;
xlabel('Sample Number');
ylabel('Altitude (meters)');
title('Figure 4: Altitude vs Time');
xlim([1, length(time_idx)]);

% Add trend line
p = polyfit(time_idx, altitude, 1);
trend = polyval(p, time_idx);
plot(time_idx, trend, 'k--', 'LineWidth', 1.5);
legend('Altitude', sprintf('Trend: %.2f m/sample', p(1)));

%% FIGURE 5: GPS Publish Success (Fixed)
figure('Position', [50, 50, 900, 500]);

total_publishes = length(time_idx);
failed_publishes = sum(hdop > 3.0 | satellites < 4);
offline_queue = 0;
successful = total_publishes - failed_publishes;
success_rate = 100 * successful / total_publishes;

% Pie Chart
subplot(1,2,1);
failure_data = [successful, failed_publishes, offline_queue];
labels = {
    sprintf('Published\n%.1f%%', 100*successful/total_publishes), 
    sprintf('Failed\n%.1f%%', 100*failed_publishes/total_publishes), 
    sprintf('Queue\n%.1f%%', 0)
};
colors = [0, 0.7, 0; 0.9, 0.2, 0.2; 0.5, 0.5, 0.5];
h_pie = pie(failure_data, labels);
% Make the pie labels more readable
set(findobj(h_pie, 'Type', 'Text'), 'FontSize', 11, 'FontWeight', 'bold');
colormap(colors);
title('GPS Publish Success Distribution', 'FontSize', 12, 'FontWeight', 'bold');

% Bar Chart with Statistics
subplot(1,2,2);
bar_data = [successful, failed_publishes, 0];
hb = bar(1:3, bar_data);
hb.FaceColor = 'flat';
hb.CData(1,:) = colors(1,:);
hb.CData(2,:) = colors(2,:);
hb.CData(3,:) = colors(3,:);
grid on;
set(gca, 'XTickLabel', {'Published', 'Failed', 'Queue'}, 'FontSize', 11);
ylabel('Number of Messages', 'FontSize', 11);
title('Publish Statistics', 'FontSize', 12, 'FontWeight', 'bold');

% Add value labels on top of bars
for i = 1:3
    if bar_data(i) > 0
        text(i, bar_data(i) + max(bar_data)*0.02, ...
            sprintf('%d', bar_data(i)), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', ...
            'FontSize', 11, 'FontWeight', 'bold');
    end
end

% Add summary text box
summary_text = sprintf(['Total Messages: %d\n' ...
                        'Published: %d (%.1f%%)\n' ...
                        'Failed: %d (%.1f%%)\n' ...
                        'Queue: %d (%.1f%%)'], ...
                        total_publishes, ...
                        successful, 100*successful/total_publishes, ...
                        failed_publishes, 100*failed_publishes/total_publishes, ...
                        0, 0);

% Position the text box at the bottom
annotation('textbox', [0.78, 0.02, 0.2, 0.25], ...
    'String', summary_text, ...
    'FontSize', 10, ...
    'BackgroundColor', [0.95, 0.95, 0.95], ...
    'EdgeColor', [0.3, 0.3, 0.3], ...
    'LineWidth', 1, ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle');

% Add title to the whole figure
sgtitle('Figure 5: GPS Publish Success Analysis', 'FontSize', 14, 'FontWeight', 'bold');
%% ==================== BATTERY ANALYSIS ====================

%% FIGURE 6: Battery Health Overview
figure('Position', [50, 50, 1000, 700]);

% Subplot 1: Individual Cell Voltages
subplot(2,2,1);
plot(time_idx, v1, 'r-', 'LineWidth', 2); hold on;
plot(time_idx, v2, 'g-', 'LineWidth', 2);
plot(time_idx, v3, 'b-', 'LineWidth', 2);
grid on;
xlabel('Sample Number');
ylabel('Voltage (V)');
title('Cell Voltages');
legend('Cell 1', 'Cell 2', 'Cell 3');
xlim([1, length(time_idx)]);
ylim([0, 5]);

% Subplot 2: Total Battery Voltage
subplot(2,2,2);
plot(time_idx, vtot, 'k-', 'LineWidth', 2);
hold on;
yline(12.6, 'g--', 'Full (12.6V)', 'LineWidth', 1.5);
yline(11.1, 'y--', 'Warning (11.1V)', 'LineWidth', 1.5);
yline(10.5, 'r--', 'Critical (10.5V)', 'LineWidth', 1.5);
grid on;
xlabel('Sample Number');
ylabel('Total Voltage (V)');
title('Battery Pack Voltage');
legend('Vtotal', 'Full', 'Warning', 'Critical');
xlim([1, length(time_idx)]);
ylim([8, 13]);

% Subplot 3: Cell Imbalance
subplot(2,2,3);
plot(time_idx, cell_imbalance, 'm-', 'LineWidth', 2);
hold on;
yline(0.5, 'y--', 'Warning (0.5V)', 'LineWidth', 1.5);
yline(1.0, 'r--', 'Critical (1.0V)', 'LineWidth', 1.5);
grid on;
xlabel('Sample Number');
ylabel('Imbalance (V)');
title('Cell Imbalance');
legend('Imbalance', 'Warning', 'Critical');
xlim([1, length(time_idx)]);
ylim([0, max(cell_imbalance) + 0.2]);

% Subplot 4: Battery Health Dashboard
subplot(2,2,4);
% Create a dashboard with key metrics
text(0.1, 0.9, 'BATTERY HEALTH DASHBOARD', 'FontSize', 12, 'FontWeight', 'bold');
text(0.1, 0.8, sprintf('Start Voltage: %.2f V', vtot(1)));
text(0.1, 0.7, sprintf('End Voltage: %.2f V', vtot(end)));
text(0.1, 0.6, sprintf('Voltage Drop: %.2f V', vtot(1) - vtot(end)));
text(0.1, 0.5, sprintf('Average Cell 1: %.3f V', mean(v1)));
text(0.1, 0.4, sprintf('Average Cell 2: %.3f V', mean(v2)));
text(0.1, 0.3, sprintf('Average Cell 3: %.3f V', mean(v3)));
text(0.1, 0.2, sprintf('Max Imbalance: %.3f V', max(cell_imbalance)));
text(0.1, 0.1, sprintf('Avg Imbalance: %.3f V', mean(cell_imbalance)));
axis off;
title('Battery Health Summary');

sgtitle('Figure 6: Battery Analysis');

%% FIGURE 7: Battery Discharge Curve
figure('Position', [50, 50, 900, 500]);
plot(time_idx, vtot, 'k-', 'LineWidth', 2);
hold on;
% Add individual cells
plot(time_idx, v1, 'r-', 'LineWidth', 1.5);
plot(time_idx, v2, 'g-', 'LineWidth', 1.5);
plot(time_idx, v3, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('Sample Number');
ylabel('Voltage (V)');
title('Figure 7: Battery Discharge Curve');

% Add shaded regions for battery state
yl = ylim;
patch([1, length(time_idx), length(time_idx), 1], [12.6, 12.6, 11.1, 11.1], [0, 1, 0, 0.1], 'EdgeColor', 'none');
patch([1, length(time_idx), length(time_idx), 1], [11.1, 11.1, 10.5, 10.5], [1, 1, 0, 0.1], 'EdgeColor', 'none');
patch([1, length(time_idx), length(time_idx), 1], [10.5, 10.5, yl(2), yl(2)], [1, 0, 0, 0.1], 'EdgeColor', 'none');

legend('Total', 'Cell 1', 'Cell 2', 'Cell 3', 'Full', 'Warning', 'Critical', 'Location', 'best');
xlim([1, length(time_idx)]);
ylim([8, 13]);

%% ==================== CELLULAR ANALYSIS ====================

%% FIGURE 8: Cellular Signal Strength
figure('Position', [50, 50, 900, 600]);

subplot(2,1,1);
plot(time_idx, rssi, 'b-o', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
yline(20, 'r--', 'Poor (<20)', 'LineWidth', 1.5);
yline(40, 'y--', 'Fair (20-40)', 'LineWidth', 1.5);
yline(60, 'g--', 'Good (>60)', 'LineWidth', 1.5);
grid on;
xlabel('Sample Number');
ylabel('RSSI (dBm)');
title('Cellular Signal Strength (RSSI)');
legend('RSSI', 'Poor', 'Fair', 'Good');
xlim([1, length(time_idx)]);
ylim([0, 100]);

subplot(2,1,2);
% Detect network registration
reg_valid = (mcc ~= 0 & mnc ~= 0);
plot(time_idx, reg_valid * 100, 'g-', 'LineWidth', 2);
hold on;
plot(time_idx, ~reg_valid * 100, 'r-', 'LineWidth', 2);
grid on;
xlabel('Sample Number');
ylabel('Status (%)');
title('Network Registration Status');
legend('Registered', 'Not Registered');
xlim([1, length(time_idx)]);
ylim([0, 100]);

sgtitle('Figure 8: Cellular Network Analysis');

%% FIGURE 9: Cellular Network Details
figure('Position', [50, 50, 1000, 600]);

subplot(1,3,1);
% Unique Network operators
unique_networks = unique([mcc, mnc], 'rows');
valid_networks = unique_networks(unique_networks(:,1) ~= 0, :);
network_count = size(valid_networks, 1);
if network_count > 0
    bar(1:network_count, ones(network_count, 1), 'FaceColor', [0.3, 0.6, 0.9]);
    set(gca, 'XTickLabel', arrayfun(@(i) sprintf('MCC:%d MNC:%d', valid_networks(i,1), valid_networks(i,2)), 1:network_count, 'UniformOutput', false));
    title('Network Operators Detected');
else
    text(0.5, 0.5, 'No Network Data', 'HorizontalAlignment', 'center');
    axis off;
    title('Network Operators');
end
ylabel('Occurrences');

subplot(1,3,2);
% Cell IDs
unique_cells = unique(cid(cid ~= 0));
if ~isempty(unique_cells)
    bar(unique_cells, ones(length(unique_cells), 1), 'FaceColor', [0.8, 0.3, 0.3]);
    xlabel('Cell ID');
    title('Cell Tower IDs');
    ylabel('Occurrences');
else
    text(0.5, 0.5, 'No Cell Data', 'HorizontalAlignment', 'center');
    axis off;
    title('Cell Towers');
end

subplot(1,3,3);
% LAC (Location Area Code)
unique_lac = unique(lac(lac ~= 0));
if ~isempty(unique_lac)
    bar(unique_lac, ones(length(unique_lac), 1), 'FaceColor', [0.3, 0.8, 0.3]);
    xlabel('LAC');
    title('Location Area Codes');
    ylabel('Occurrences');
else
    text(0.5, 0.5, 'No LAC Data', 'HorizontalAlignment', 'center');
    axis off;
    title('Location Areas');
end

sgtitle('Figure 9: Cellular Network Details');

%% FIGURE 10: Battery vs Network Correlation
figure('Position', [50, 50, 1000, 500]);

subplot(1,2,1);
scatter(vtot, rssi, 30, satellites, 'filled');
xlabel('Battery Voltage (V)');
ylabel('RSSI (dBm)');
title('Battery Voltage vs Signal Strength');
colorbar_label = colorbar;
colorbar_label.Label.String = 'Satellites';
grid on;

subplot(1,2,2);
scatter(cell_imbalance, rssi, 30, 'b', 'filled');
xlabel('Cell Imbalance (V)');
ylabel('RSSI (dBm)');
title('Battery Health vs Signal Strength');
grid on;
hold on;
% Add trend line
p = polyfit(cell_imbalance, rssi, 1);
x_trend = linspace(min(cell_imbalance), max(cell_imbalance), 100);
y_trend = polyval(p, x_trend);
plot(x_trend, y_trend, 'r--', 'LineWidth', 2);
legend('Data', 'Trend Line');

sgtitle('Figure 10: Battery-Cellular Correlation');

%% ==================== SYSTEM STATISTICS ====================

% Create Statistics Table
fprintf('\n========== SYSTEM PERFORMANCE SUMMARY ==========\n\n');

fprintf('--- GPS Performance ---\n');
fprintf('Total Samples: %d\n', length(time_idx));
fprintf('Average HDOP: %.2f\n', mean(hdop));
fprintf('Average Satellites: %.1f\n', mean(satellites));
fprintf('Good HDOP (<2.0): %.1f%%\n', 100*sum(hdop < 2.0)/length(hdop));
fprintf('Poor HDOP (>3.0): %.1f%%\n', 100*sum(hdop > 3.0)/length(hdop));
fprintf('Publish Success Rate: %.1f%%\n', 100*successful/total_publishes);

fprintf('\n--- Battery Health ---\n');
fprintf('Start Battery: %.2f V\n', vtot(1));
fprintf('End Battery: %.2f V\n', vtot(end));
fprintf('Voltage Drop: %.2f V (%.1f%%)\n', vtot(1)-vtot(end), 100*(vtot(1)-vtot(end))/vtot(1));
fprintf('Max Cell Imbalance: %.3f V\n', max(cell_imbalance));
fprintf('Average Cell Imbalance: %.3f V\n', mean(cell_imbalance));
fprintf('Battery Warnings: %d\n', sum(cell_imbalance > 0.5));

fprintf('\n--- Cellular Network ---\n');
fprintf('Average RSSI: %.1f dBm\n', mean(rssi(rssi > 0)));
fprintf('Min RSSI: %d dBm\n', min(rssi(rssi > 0)));
fprintf('Max RSSI: %d dBm\n', max(rssi(rssi > 0)));
fprintf('Good Signal (>60): %.1f%%\n', 100*sum(rssi > 60)/length(rssi));
fprintf('Poor Signal (<20): %.1f%%\n', 100*sum(rssi < 20 & rssi > 0)/length(rssi));
fprintf('Network Registered: %.1f%%\n', 100*sum(mcc ~= 0)/length(mcc));

fprintf('\n--- Combined Metrics ---\n');
% Find correlations
corr_batt_rssi = corr(vtot, rssi);
fprintf('Battery-Signal Correlation: %.3f\n', corr_batt_rssi);
corr_batt_sat = corr(vtot, satellites);
fprintf('Battery-Satellite Correlation: %.3f\n', corr_batt_sat);
fprintf('==================================================\n');

disp('All figures generated successfully!');