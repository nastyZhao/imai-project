% function [spectrum,ceps_base,base_loc,base_val] = peak_lifter(FILENAME)
clear;
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_500.wav');
% [sidetest,fs_origin] = audioread('400.wav');
fs = 24000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 600;
Nfft = 2400;
nstart = 5000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

peak_pick_len = 4500/(fs/Nfft);
dip_pick_len = 6500/(fs/Nfft);
%spectrum calculating%
spectrum = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart);

M =38;
%% time averaging

% env_cep_pool = [];
% env_SP_pool = [];
% env_DT_pool = [];
% 
% for timestamp = 1000:200:22000
% 
%     spec_slice = getspectrum(vowel_filtered,Nframe,Nfft,fs,timestamp);
%     env_SP_slice = simple_cep_sub(spec_slice,M);
%     env_DP_slice = delta_cep_sub(spec_slice,M);
%     [env_cep,cep_slice] = getcepstrum(spec_slice,M);
%     
%     env_cep_pool = [env_cep_pool,env_cep'];
%     env_SP_pool = [env_SP_pool,env_SP_slice'];
%     env_DT_pool = [env_DT_pool,env_DP_slice'];
%     
% end
% 
% env_cep = mean(env_cep_pool,2);
% env_SP = mean(env_SP_pool,2);
% env_DT = mean(env_DT_pool,2);
% 
% [peak_val_cep,peak_loc_cep] = findpeaks(env_cep(1:peak_pick_len));
% peak_loc_cep = peak_loc_cep*(fs/Nfft);
% [peak_val_SP,peak_loc_SP] = findpeaks(env_SP(1:peak_pick_len));
% peak_loc_SP = peak_loc_SP*(fs/Nfft);
% [peak_val_DT,peak_loc_DT] = findpeaks(env_DT(1:peak_pick_len));
% peak_loc_DT = peak_loc_DT*(fs/Nfft);
% 
% [dip_val_cep,dip_loc_cep] = findpeaks(-env_cep(1:dip_pick_len));
% dip_loc_cep = dip_loc_cep*(fs/Nfft);
% [dip_val_SP,dip_loc_SP] = findpeaks(-env_SP(1:dip_pick_len));
% dip_loc_SP = dip_loc_SP*(fs/Nfft);
% [dip_val_DT,dip_loc_DT] = findpeaks(-env_DT(1:dip_pick_len));
% dip_loc_DT = dip_loc_DT*(fs/Nfft);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(1)
% plot(friency_axis,spectrum(1:axis_length),'color',[96 96 96]/255);
% hold on
% plot(friency_axis,env_SP(1:axis_length),'LineWidth',2.0);
% scatter(peak_loc_SP,peak_val_SP,'k');
% hold off
% % 
% figure(2)
% % plot(friency_axis,spectrum(1:axis_length),'color',[96 96 96]/255);
% hold on
% plot(friency_axis,env_cep(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,env_DT(1:axis_length),'LineWidth',1.0);
% scatter(peak_loc_DT,peak_val_DT,'k');
% hold off

%% cepstrum method
w=ones(1,2*M+1);
h=[w(M+1:-1:1) zeros(1,Nfft-2*M-1) w(1:M)];%w(M+1:-1:1) -1表示反向赋值，h(1)=w(M+1)...h(M+1)=w(1)

cepstrum = real(ifft(spectrum'));
cep_liftered = h.*real(ifft(spectrum'));
env_cep = real(fft(cep_liftered));

%% Simple cepstrum subtraction

% lifter = M-5;
% len_constant = 40;
% len_damp = 30;
% 
% spec_raw = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart);
% ceps_raw = real(ifft(spec_raw));
% 
% win_edit = [zeros(1,lifter+1)  ones(1,3*lifter) zeros(1,Nfft-8*lifter-1)...
%     ones(1,3*lifter) zeros(1,lifter)];
% win_env = [ones(1,len_constant) window(@hanning,len_damp)' ...
%     zeros(1,Nfft-2*(len_constant+len_damp))...
%     window(@hanning,len_damp)' ones(1,len_constant)];
% 
% ceps_edited = (win_edit.*max(ceps_raw,0)')';
% ceps_subed = ceps_raw - ceps_edited;
% cep_env = win_env.*ceps_subed';
% 
% spec_subed = real(fft(ceps_subed));
% env_final = real(fft(cep_env));
% 
% [peak_val_SP,peak_loc_SP] = findpeaks(env_final(1:axis_length));
% peak_loc_SP = peak_loc_SP*(fs/Nfft);
% 
% env_scep_sub = simple_cep_sub(spec_raw,M);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(11)
% plot(friency_axis,spec_raw(1:axis_length),'color',[96 96 96]/255);
% hold on
% plot(friency_axis,spec_subed(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,env_final(1:axis_length),'LineWidth',2.0);
% hold off
% 
% figure(12)
% plot(cepstrum(1:200));
% hold on
% plot(ceps_edited(1:200));
% % plot(ceps_subed(1:200));
% % plot(env_final(1:200));
% hold off

%% delta ceptrum subtraction
lifter = M-5;
len_constant = 40;
len_damp = 40;

spec_raw = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart);
ceps_raw = real(ifft(spec_raw));

win_damp = window(@hanning,2*len_damp)';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a = 0:len_damp-1;
% damp_test1 = (0.5).^a;
% damp_test1_inv = fliplr(damp_test1);
% 
% win_best = [ones(1,len_constant) window(@hanning,len_damp)' ...
%     zeros(1,Nfft-2*(len_constant+len_damp))...
%     window(@hanning,len_damp)' ones(1,len_constant)];
% win_test = [ones(1,M) tukeywin(M,0.25)' tukeywin(M,0.25)'...
%     zeros(1,Nfft-6*M)...
%     tukeywin(M,0.25)' tukeywin(M,0.25)' ones(1,M)];
% 
% win_test1 = [ones(1,len_constant) damp_test1 ...
%     zeros(1,Nfft-2*(len_constant+len_damp))...
%     damp_test1 ones(1,len_constant)];
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
win_edit = [zeros(1,lifter+1)  ones(1,4*lifter) zeros(1,Nfft-10*lifter-1)...
    ones(1,4*lifter) zeros(1,lifter)];
win_env = [ones(1,len_constant) win_damp(len_damp+1:2*len_damp)...
    zeros(1,Nfft-2*(len_constant+len_damp))...
    win_damp(1:len_damp) ones(1,len_constant)];

[sub_cep1,sub_spec1] = get_peak_cepstrum(spec_raw,Nfft,1,lifter);
[sub_cep2,sub_spec2] = get_peak_cepstrum(spec_raw,Nfft,2,lifter);
[sub_cep3,sub_spec3] = get_peak_cepstrum(spec_raw,Nfft,3,lifter);

delta1 = ceps_raw' - sub_cep1;
delta2 = sub_cep1 - sub_cep2;
delta3 = sub_cep2 - sub_cep3;

delta2 = win_edit.*max(delta2,0);
delta3 = win_edit.*max(delta3,0);

ceps_clear = win_edit.*ceps_raw';
multi_para = floor(max(ceps_clear)/max(delta2));

ceps_restore = multi_para*delta2;
ceps_delta_subed = ceps_raw' - ceps_restore;
cep_delta_env = win_env.*ceps_delta_subed;

spec_delta_subed = real(fft(ceps_delta_subed));
env_delta_final = real(fft(cep_delta_env));

[peak_val_cep,peak_loc_cep] = findpeaks(env_delta_final(1:axis_length));
peak_loc_cep = peak_loc_cep*(fs/Nfft);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cep_test = [cep_delta_env(1:40) ceps_raw(41:80)' zeros(Nfft-160) ceps_raw(1967:2007)' cep_delta_env(2008:2048)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(21)
plot(friency_axis,spec_raw(1:axis_length),'color',[96 96 96]/255);
hold on
plot(friency_axis,env_cep(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,env_delta_final(1:axis_length),'LineWidth',2.0);
% plot(friency_axis,env_delta_sub(1:axis_length),'LineWidth',2.0);
hold off

figure(22)
plot(cepstrum(1:200));
hold on
% plot(ceps_restore(1:200));
% plot(ceps_delta_subed(1:200));
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mvf_size = 3;
% mvf_half_band = (mvf_size-1)/2;
% mvf_win = ones(1,mvf_size);
% 
% restore = 5*delta2+5*delta3;
% 
% mvf_cep = restore;
% for i = mvf_half_band+1:length(restore)-mvf_half_band-1
%     mvf_cep(i) = ...
%         mean(restore(i-mvf_half_band:i+mvf_half_band));
% end
% 
% mvf_cep = max(mvf_cep,0);
% % restore = 5*delta2+5*delta3;
% aa = 8*delta2;
% 
% restore_cep = cepstrum-aa;
% % restore_cep = edit_h.*restore_cep;
% restore_spec = real(ifft(restore_cep'));
% mvf_restore = restore_spec;
% for i = mvf_half_band+1:length(restore_spec)-mvf_half_band-1
%     mvf_restore(i) = ...
%         mean(restore_spec(i-mvf_half_band:i+mvf_half_band));
% end
% restore_env = getcepstrum(restore_spec,41);
% raw_spec = real(ifft(cepstrum));



%% functions

function env_scep_sub = simple_cep_sub(spectrum,M)

Nfft = max(size(spectrum));

lifter = M-5;
len_constant = 40;
len_damp = 40;

spec_raw = spectrum;
ceps_raw = real(ifft(spec_raw));

win_edit = [zeros(1,lifter+1)  ones(1,3*lifter) zeros(1,Nfft-8*lifter-1)...
    ones(1,3*lifter) zeros(1,lifter)];
win_env = [ones(1,len_constant) window(@hanning,len_damp)' ...
    zeros(1,Nfft-2*(len_constant+len_damp))...
    window(@hanning,len_damp)' ones(1,len_constant)];

ceps_edited = (win_edit.*max(ceps_raw,0)')';
ceps_subed = ceps_raw - ceps_edited;
cep_env = win_env.*ceps_subed';

env_final = real(fft(cep_env));
env_scep_sub = env_final;

end

function env_delta_sub = delta_cep_sub(spectrum,M)
Nfft = max(size(spectrum));

lifter = M-3;
len_constant = 50;
len_damp = 0;

spec_raw = spectrum;
ceps_raw = real(ifft(spec_raw));

win_edit = [zeros(1,lifter+1)  ones(1,3*lifter) zeros(1,Nfft-8*lifter-1)...
    ones(1,3*lifter) zeros(1,lifter)];
% win_env = [ones(1,len_constant) window(@hanning,len_damp)' ...
%     zeros(1,Nfft-2*(len_constant+len_damp))...
%     window(@hanning,len_damp)' ones(1,len_constant)];
win_damp = window(@hanning,2*len_damp)';
win_env = [ones(1,len_constant) win_damp(len_damp+1:2*len_damp)...
    zeros(1,Nfft-2*(len_constant+len_damp))...
    win_damp(1:len_damp) ones(1,len_constant)];

[sub_cep1,sub_spec1] = get_peak_cepstrum(spec_raw,Nfft,1,lifter);
[sub_cep2,sub_spec2] = get_peak_cepstrum(spec_raw,Nfft,2,lifter);
[sub_cep3,sub_spec3] = get_peak_cepstrum(spec_raw,Nfft,3,lifter);

delta2 = sub_cep1 - sub_cep2;
delta2 = win_edit.*max(delta2,0);

ceps_clear = win_edit.*ceps_raw';
multi_para = floor(max(ceps_clear)/max(delta2));

ceps_restore = multi_para*delta2;
ceps_delta_subed = ceps_raw' - ceps_restore;
cep_delta_env = win_env.*ceps_delta_subed;

env_delta_final = real(fft(cep_delta_env));
env_delta_sub = env_delta_final;
end