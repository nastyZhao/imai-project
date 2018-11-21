clear

[sidetest,fs_origin] = audioread('..\data\20181009(SC VOWEL CLEAN)\SC_650_clean.wav');

fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.99],[1],vowel_resample);
% vowel_filtered=filter([1,-0.99],[1],vowel_resample);

Nframe = 480;
Nfft = Nframe*4;
nstart = 10000;

axis_length = 8000/(fs/Nfft);
M =100
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

spectrum = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart);
spectrum_show = spectrum(1:axis_length)';

[envelope,cepstrum]=getcepstrum(spectrum,M);
envelope_show = envelope(1:axis_length)';
[loc,val] = findpeaks(envelope_show);
val = val(:)*(fs/Nfft);


[ceps_base,E] = imai_base(spectrum,M,6);
ceps_base_show = ceps_base(1:axis_length)';
E_show = E(1:axis_length);
[b_loc,b_val] = findpeaks(ceps_base_show);
b_val = b_val(:)*(fs/Nfft);

verse_envelope = 32-envelope_show(:);
[v_loc,v_val] = findpeaks(verse_envelope(1:axis_length));
v_val = v_val(:)*(fs/Nfft);

verse_ceps_base = 32-ceps_base_show(:);
[v_b_loc,v_b_val] = findpeaks(verse_ceps_base(1:axis_length));
v_b_val = v_b_val(:)*(fs/Nfft);

figure(1);
plot(friency_axis,spectrum_show,'color',[96 96 96]/255);
hold on
% plot(friency_axis,envelope_show,'k','LineWidth',2.0);
% scatter(val,loc,'k');
plot(friency_axis,ceps_base_show,'r','LineWidth',2.0);
scatter(b_val,b_loc,'k');
ylabel('amplitude(db)');xlabel('Frequency(Hz)');
title('750Hz fundamental frequency, Lfter order: 100','FontWeight','bold');
hold off

% figure(4);
% plot(friency_axis,verse_envelope,'k','LineWidth',2.0);
% hold on
% scatter(v_val,v_loc,'k');
% plot(friency_axis,verse_ceps_base,'r','LineWidth',2.0);
% scatter(v_b_val,v_b_loc,'k');
% hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CepstrumResult = table(val);
% CepstrumResult.Properties.VariableNames = {'Cepstrum_Result'};
% writetable(CepstrumResult, 'CepstrumResult_130Hz_CR.csv')
% 
% NewMethodResult = table(b_val);
% NewMethodResult.Properties.VariableNames = {'NewMethod_Result'};
% writetable(NewMethodResult, 'NewMethodResult_130Hz_CR.csv')


