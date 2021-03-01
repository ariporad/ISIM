data = readmatrix('calibration_data.csv');

T = data(:, 1);
V = data(:, 2);
V_smooth = movmean(V, 100);

figure(1); clf; hold on;
plot(T, V);
l = plot(T, V_smooth);
l.LineWidth = 2.5;
legend("Raw", "Smooth");
ylim([0, 0.05]);
hold off;

mV_0 = 4;
calibration = [9, 14.0; 30, 27.7; 45, 40.7]


% Linear regression code from: https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
Y = calibration(:, 1) % Y = weight
X = calibration(:, 2) % X = voltage
X_with1s = [X, ones(length(X), 1)]


B = X_with1s \ Y

Y_predicted = X_with1s * B;

R2 = 1 - sum((Y - Y_predicted).^2)/sum((Y - mean(Y)).^2)
sensitivity = 1 / B(1)

% TEST DATA
test_known_weight = 57.1
test_measured_voltage = 51
test_predicted_weight = [test_measured_voltage 1] * B
test_error = abs((test_predicted_weight - test_known_weight) / test_known_weight)

figure(2); clf; hold on;

title("Voltage vs. Weight (R^2 = " + R2 + ", Err = " + (test_error * 100) + "%)");
xlabel("Voltage (mV)");
ylabel("Weight (g)");

scatter(X, Y);

plot(X, Y_predicted, '-');

legend("Calibration Measurement", "Calibration Curve", 'Location', 'southeast');
hold off;