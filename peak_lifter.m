% function [spectrum,ceps_base,base_loc,base_val] = peak_lifter(FILENAME)
clear;
%% global paramaters
global fs;
global Nframe;
global Nfft;
global axis_length;
global friency_axis;

%% initial data settings
[wave_origin,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_450.wav');
% ..\data\20181009(SC VOWEL CLEAN)\SC_150.wav
fs = 44100;
% vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],wave_origin);

%FFT paramaters setting%
Nframe = 1100;
Nfft = 4096;
nstart = 5000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

peak_pick_len = 4500/(fs/Nfft);
dip_pick_len = 6500/(fs/Nfft);

%spectrum calculating%
M =30;
vowel_blocked = vowel_filtered(nstart+1:nstart+Nframe);
spectrum_nut = getspectrum(vowel_blocked,Nframe,Nfft,'nut');
spectrum_bla = getspectrum(vowel_blocked,Nframe,Nfft,'bla');
[env_baseline,cepstrum]=getcepstrum(spectrum_bla,M)

%% time averaging

env_cep_pool = [];
env_DT_pool = [];

for timestamp = 15000:441:23820
    vowel_slice = vowel_filtered(timestamp+1:timestamp+Nframe);
    spec_slice = getspectrum(vowel_slice,Nframe,Nfft,'bla');

    env_DP_slice = delta_cep_sub(vowel_slice,M,0);
    [env_cep,cep_slice] = getcepstrum(spec_slice,M);
    
    env_cep_pool = [env_cep_pool,env_cep'];
    env_DT_pool = [env_DT_pool,env_DP_slice'];
    
end

env_cep = mean(env_cep_pool,2);
env_DT = mean(env_DT_pool,2);

[peak_val_cep,peak_loc_cep] = findpeaks(env_cep(1:peak_pick_len));
peak_loc_cep = peak_loc_cep*(fs/Nfft);
[peak_val_DT,peak_loc_DT] = findpeaks(env_DT(1:peak_pick_len));
peak_loc_DT = peak_loc_DT*(fs/Nfft);

[dip_val_cep,dip_loc_cep] = findpeaks(-env_cep(1:dip_pick_len));
dip_loc_cep = dip_loc_cep*(fs/Nfft);
[dip_val_DT,dip_loc_DT] = findpeaks(-env_DT(1:dip_pick_len));
dip_loc_DT = dip_loc_DT*(fs/Nfft);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(10)
plot(friency_axis,spectrum_nut(1:axis_length),'color',[96 96 96]/255);
hold on
plot(friency_axis,env_DT(1:axis_length),'LineWidth',2.0);
scatter(peak_loc_DT,peak_val_DT,'k');
hold off

% figure(2)
% % plot(friency_axis,spectrum(1:axis_length),'color',[96 96 96]/255);
% hold on
% plot(friency_axis,env_cep(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,env_DT(1:axis_length),'LineWidth',1.0);
% scatter(peak_loc_DT,peak_val_DT,'k');
% hold off

%% functions

function env_delta_sub = delta_cep_sub(signal,M,show)
global fs;
global Nfft;
global Nframe;
global axis_length;
global friency_axis;

zero_boundry = floor(fs/1000);
lifter = 30;
len_constant = 120;
len_damp = 0;
rah_num = 4;

win_clear_low = [zeros(1,zero_boundry+1) ones(1,Nfft-2*zero_boundry-1)...
    zeros(1,zero_boundry)];
win_edit = [zeros(1,lifter+1)  ones(1,3*lifter) zeros(1,Nfft-8*lifter-1)...
    ones(1,3*lifter) zeros(1,lifter)];
win_damp = window(@blackman,2*len_damp)';
win_env = [ones(1,len_constant) win_damp(len_damp+1:2*len_damp)...
    zeros(1,Nfft-2*(len_constant+len_damp))...
    win_damp(1:len_damp) ones(1,len_constant)];

spec_narrow = getspectrum(signal,Nframe,Nfft,'nut');
spec_wide = getspectrum(signal,Nframe,Nfft,'bla');
ceps_narrow = real(ifft(spec_narrow));
ceps_bla = real(ifft(spec_wide));

ceps_clear_low = win_clear_low.*ceps_narrow';
[var_rah1,loc_rah1] = max(ceps_clear_low(zero_boundry:500));
loc_rah1 = loc_rah1+zero_boundry-1;

ceps_clear_sqr = ceps_clear_low.^4;
max_rah_loc = loc_rah1;
[left_sides,right_sides] = triangleSideDetecter(ceps_clear_sqr,max_rah_loc,rah_num);

[sub_cep1,sub_spec1,sub_env1] = get_peak_cepstrum(spec_wide,Nfft,0,lifter);
[sub_cep2,sub_spec2,sub_env2] = get_peak_cepstrum(spec_wide,Nfft,1,lifter);

[base_ceps1,base_spec1,base_env1] = get_base_cepstrum(spec_wide,Nfft,0,lifter);
[base_ceps2,base_spec2,base_env2] = get_base_cepstrum(spec_wide,Nfft,1,lifter);
base_env_middle = 0.5*(0.5*(base_env1+base_env2)+base_env1);
base_spec_middle = max(base_spec1-base_env_middle,0);
ceps_base_slice = real(ifft(base_spec_middle));

% delta2 = sub_cep1 - sub_cep2;
delta2 = ceps_base_slice;
% delta2 = sub_cep1;
delta2_edit = win_clear_low.*max(delta2,0);

% ceps_clear = win_clear_low.*ceps_narrow';
% multi_para = floor(max(ceps_clear)/max(delta2_edit));
multi_para = floor(ceps_bla(loc_rah1)/delta2(loc_rah1));
ceps_restore = multi_para*delta2_edit;

%   = [];
% val_r = [];
ceps_peak_subed = ceps_bla';
for i = 1:rah_num
%     val_l = [val_l,ceps_bla(left_sides(i))]; 
%     val_r = [val_r,ceps_bla(right_sides(i))];
    l_side = left_sides(i);
    r_side = right_sides(i);
    ceps_peak_subed(l_side:r_side)=...
        ceps_bla(l_side:r_side)'-ceps_restore(l_side:r_side);
    l_mirror = Nfft - r_side + 1;
    r_mirror = Nfft - l_side + 1;
    ceps_peak_subed(l_mirror:r_mirror) = ceps_bla(l_mirror:r_mirror)'...
        -ceps_restore(l_mirror:r_mirror);
end

cep_peak_env = win_env.*ceps_peak_subed;
spec_peak_subed = real(fft(ceps_peak_subed));
env_peak_final = real(fft(cep_peak_env));

env_delta_sub = env_peak_final;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if show == 1
    figure(21)
    plot(friency_axis,spec_wide(1:axis_length));
    hold on
        plot(friency_axis,spec_peak_subed(1:axis_length),'LineWidth',2.0);
%     plot(friency_axis,spec_delta_subed(1:axis_length),'LineWidth',1.0);
        hold off
    
    figure(22)
    plot(ceps_bla(1:300));
    hold on
    plot(ceps_peak_subed(1:300));
%     %     plot(ceps_delta_subed(1:200));
%     scatter(left_sides,val_l,'k');
%     scatter(right_sides,val_r,'k');
    hold off
    
%     figure(23)
%     ax1 = subplot(2,1,1);
%     plot(ceps_bla(1:300));
%     xlabel(ax1,'Frequency(Hz)');
%     ylabel(ax1,'Amplitude(db)');
%     hold off
%     
%     ax2 = subplot(2,1,2);
%     plot(ceps_peak_subed(1:300));
%     ylabel(ax2,'Amplitude(db)');
%     xlabel(ax2,'Quefrency(samples)');
%     hold off
end
    
end