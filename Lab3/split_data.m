data = readmatrix('data.csv');

V_in = data(:, 4);

T = data(:, 1);
T = T + (0 - min(T));
V_resistor = data(:, 2);
V_humidity = V_resistor;

figure(1); clf; hold on;
title("Humidity Transducer Voltage Over Time")
xlabel("Time (seconds)")
ylabel("Voltage (mV)")
plot(T, V_in, "b-");
plot(T, V_humidity, '-');
legend("V_{in}", "V_{transducer}", 'Location', 'southeast');
% ylim([-0.01, 0.05]);
hold off;

calibration = [100, 84.84; 120, 102.7; 150, 118.4; 180, 123.5; 220, 150.4];


% Linear regression code from: https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
Y = calibration(:, 1) % Y = weight
X = calibration(:, 2) % X = voltage
X_with1s = [X, ones(length(X), 1)]


B = X_with1s \ Y

Y_predicted = X_with1s * B;
trendline_X = linspace(80, 160, 100)'
trendline_Y = [trendline_X, ones(100, 1)] * B

R2 = 1 - sum((Y - Y_predicted).^2)/sum((Y - mean(Y)).^2)
sensitivity = 1 / B(1)

% TEST DATA
test_known_weight = 170.7;
test_measured_voltage = 124.9
test_predicted_weight = [test_measured_voltage 1] * B
test_error = abs((test_predicted_weight - test_known_weight) / test_known_weight)

figure(2); clf; hold on;

title(sprintf("Voltage vs. Capacitance (R^2 = %0.2f)", R2));
xlabel("Voltage (mV)");
ylabel("Capacitance (pF)");

scatter(X, Y);

plot(trendline_X, trendline_Y, '-');


% plot(test_measured_voltage, test_predicted_weight, 'b+')

% plot(linspace(80, 160, 5), ones(5, 1) .* test_known_weight);

legend("Calibration Measurement", sprintf("Calibration Trendline (C = %1.2fV + %1.2f)", B(1), B(2)), "Humidity Capacitance Measurement", sprintf("Known Humidity Capacitance (%0.1fpF, Error: %1.2f%%)", test_known_weight, test_error * 100), 'Location', 'southeast');
hold off;