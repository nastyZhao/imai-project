clear



sweep_vocal_raw = audioread('..\data\CR_A_truth\SWEEP_VOCAL_CR.wav');
sweep_box_raw = audioread('..\data\CR_A_truth\SWEEP_BOX.wav');

fs_origin=44100;
fs = 20000;

sweep_vocal=resample(sweep_vocal_raw,fs,fs_origin);
sweep_box=resample(sweep_box_raw,fs,fs_origin);

fft_origin = fft(sweep_vocal);

axis_length = 8000/(fs/length(fft_origin));
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/length(fft_origin));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
origin_spectrum_vocal = 20*log10(abs(fft(sweep_vocal)));
[vocal_envelop,vocal_cepstrum]=getcepstrum(origin_spectrum_vocal,200);
[vocal_loc,vocal_val] = findpeaks(vocal_envelop(1:axis_length));
vocal_val = vocal_val(:)*(fs/length(fft_origin));


origin_spectrum_box = 20*log10(abs(fft(sweep_box)));


transfer_spectrum = origin_spectrum_vocal - origin_spectrum_box;
[transfer_envelope,cepstrum]=getcepstrum(transfer_spectrum,50);
[loc,val] = findpeaks(transfer_envelope(1:axis_length));
val = val(:)*(fs/length(fft_origin));


transfer_verse_spectrum = 32-transfer_spectrum(:);
transfer_verse_envelope = 32-transfer_envelope(:);
[v_loc,v_val] = findpeaks(transfer_verse_envelope(1:axis_length));
v_val = v_val(:)*(fs/length(fft_origin));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(1);
% plot(friency_axis,origin_spectrum_vocal(1:axis_length))
% hold on
% plot(friency_axis,vocal_envelop(1:axis_length),'LineWidth',3.0);
% scatter(vocal_val,vocal_loc,'k');
% title('Vocal Envelope','FontWeight','bold');
% hold off

figure(2);
plot(friency_axis,transfer_spectrum(1:axis_length))
hold on
plot(friency_axis,transfer_envelope(1:axis_length),'LineWidth',2.0);
xlabel('Frequency(Hz)');
ylabel('Amplitude(db)');
% scatter(val,loc,'k');
% title('Transfer Function','FontWeight','bold');
hold off

% figure(3);
% plot(friency_axis,transfer_verse_spectrum(1:axis_length))
% hold on
% plot(friency_axis,transfer_verse_envelope(1:axis_length),'LineWidth',3.0);
% scatter(v_val,v_loc,'k');
% title('Reverse Transfer Function','FontWeight','bold');
% hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TransferFunction = table([val',NaN,v_val']');
% TransferFunction.Properties.VariableNames = {'Transfer_Function'};
% writetable(TransferFunction, 'Transfer_Function_CR.csv')


 