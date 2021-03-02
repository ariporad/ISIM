data = readmatrix('calibration_data.csv');

avg_window = 50;

T = data(:, 1);
T = T + (0 - min(T));
V = data(:, 2);
V_smooth = movmean(V, avg_window);
avg_time = mean(diff(T)) * avg_window;

figure(1); clf; hold on;
title("Strain Gauge Voltage Over Time")
xlabel("Time (seconds)")
ylabel("Voltage (mV)")
plot(T, V);
l = plot(T, V_smooth);
l.LineWidth = 2.5;
legend("Raw", sprintf("Rolling Average (n=%1.0f, t=%1.0fs)", avg_window, avg_time), 'Location', 'northwest');
ylim([-0.01, 0.05]);
hold off;

mV_0 = 4;
calibration = [9, 14.0; 30, 27.7; 45, 40.7]


% Linear regression code from: https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
Y = calibration(:, 1) % Y = weight
X = calibration(:, 2) % X = voltage
X_with1s = [X, ones(length(X), 1)]


B = X_with1s \ Y

Y_predicted = X_with1s * B;
trendline_X = linspace(10, 60, 100)'
trendline_Y = [trendline_X, ones(100, 1)] * B

R2 = 1 - sum((Y - Y_predicted).^2)/sum((Y - mean(Y)).^2)
sensitivity = 1 / B(1)

% TEST DATA
test_known_weight = 57.1
test_measured_voltage = 51
test_predicted_weight = [test_measured_voltage 1] * B
test_error = abs((test_predicted_weight - test_known_weight) / test_known_weight)

figure(2); clf; hold on;

title(sprintf("Voltage vs. Weight (R^2 = %0.2f)", R2));
xlabel("Voltage (mV)");
ylabel("Weight (g)");

scatter(X, Y);

plot(trendline_X, trendline_Y, '-');


% plot(test_measured_voltage, test_predicted_weight, 'b+')

% plot(linspace(10, 60, 5), ones(5, 1) .* test_known_weight);

legend("Calibration Measurement", sprintf("Calibration Trendline (m = %1.2fV + %1.2f)", B(1), B(2)), "Test Measurement", sprintf("Test Known Weight (%0.1fg, Error: %1.2f%%)", test_known_weight, test_error * 100), 'Location', 'southeast');
hold off;