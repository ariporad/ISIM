data = readmatrix('calibration_data.csv');

T = data(:, 1);
V = data(:, 2);
V_smooth = movmean(V, 100);

clf; hold on;
plot(T, V_smooth);
legend("Raw", "Smooth");
hold off;

calibration = [4, 0.000000000; 9, 14.0; 30, 27.7; 45, 40.7]
calibration_points = calibration(:, 1) ./ calibration(:, 2)
calibration_coeff = mean(calibration_points)

