figure(1); clf; hold on;

ekg_data = readmatrix('ekg.csv');

include_ekg = ekg_data(:, 3) >= .278; % starts clean on the second cycle
ekg_time = ekg_data(include_ekg, 3);
ekg_volts = ekg_data(include_ekg, 4);

plot(ekg_time, ekg_volts);

bpm = calculate_heartrate(ekg_time, ekg_volts)

title(sprintf("Subject's EKG (%2.0f bpm)", bpm));
xlabel("Time (seconds)");
ylabel("Voltage");

hold off;

figure(2); clf; 

bode_data = readmatrix('bode.csv');

freq = bode_data(:, 1);
gain = bode_data(:, 2);
phase = bode_data(:, 3);

% There's a phase wrap-around in the middle of the data, so correct it to the smooth curve it actually represents
phase(1:32) = phase(1:32) + 360;

title("Bode Plot of System");

yyaxis left;
semilogx(freq, gain);
ylabel("Gain (dB)");

yyaxis right;
semilogx(freq, phase);
ylabel("Phase (Degrees)"); % TODO

xlabel("Frequency (Hz)");

hold off;

function bpm = calculate_heartrate(ekg_time, ekg_volts)
	% EKGs have lots of local maxima, but there's only one big spike per heart beat. In the data we
	% collected, all of those spikes are >= 0.5 but none under it are. Therefore, only take data
	% points above 0.5 then find the local maxima.
	include_only_peaks = ekg_volts >= 0.5;
	peaks_volts = ekg_volts(include_only_peaks)
	peaks_times = ekg_time(include_only_peaks)
	[~, locs] = findpeaks(peaks_volts)
	times = peaks_times(locs)
	intervals = diff(times)
	avg_interval = mean(intervals)

	bpm = 60 / avg_interval
end