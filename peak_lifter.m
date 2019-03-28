% function [spectrum,ceps_base,base_loc,base_val] = peak_lifter(FILENAME)
clear;
%% global paramaters
global fs;
global Nframe;
global Nfft;
global axis_length;
global friency_axis;

%% initial data settings
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_750.wav');

fs = 24000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 600;
Nfft = 2048;
nstart = 5000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

peak_pick_len = 4500/(fs/Nfft);
dip_pick_len = 6500/(fs/Nfft);

%spectrum calculating%
M =32;
vowel_blocked = vowel_filtered(nstart+1:nstart+Nframe);
spectrum_nut = getspectrum(vowel_blocked,Nframe,Nfft,'nut');
spectrum_bla = getspectrum(vowel_blocked,Nframe,Nfft,'bla');
[env_baseline,cepstrum]=getcepstrum(spectrum_bla,M)

%% time averaging

env_cep_pool = [];
env_SP_pool = [];
env_DT_pool = [];

for timestamp = 1000:200:22000
    vowel_slice = vowel_filtered(timestamp+1:timestamp+Nframe);
    spec_slice = getspectrum(vowel_slice,Nframe,Nfft,'bla');
    env_SP_slice = simple_cep_sub(spec_slice,M);
    env_DP_slice = delta_cep_sub(vowel_slice,M,0);
    [env_cep,cep_slice] = getcepstrum(spec_slice,M);
    
    env_cep_pool = [env_cep_pool,env_cep'];
    env_SP_pool = [env_SP_pool,env_SP_slice'];
    env_DT_pool = [env_DT_pool,env_DP_slice'];
    
end

env_cep = mean(env_cep_pool,2);
env_SP = mean(env_SP_pool,2);
env_DT = mean(env_DT_pool,2);

[peak_val_cep,peak_loc_cep] = findpeaks(env_cep(1:peak_pick_len));
peak_loc_cep = peak_loc_cep*(fs/Nfft);
[peak_val_SP,peak_loc_SP] = findpeaks(env_SP(1:peak_pick_len));
peak_loc_SP = peak_loc_SP*(fs/Nfft);
[peak_val_DT,peak_loc_DT] = findpeaks(env_DT(1:peak_pick_len));
peak_loc_DT = peak_loc_DT*(fs/Nfft);

[dip_val_cep,dip_loc_cep] = findpeaks(-env_cep(1:dip_pick_len));
dip_loc_cep = dip_loc_cep*(fs/Nfft);
[dip_val_SP,dip_loc_SP] = findpeaks(-env_SP(1:dip_pick_len));
dip_loc_SP = dip_loc_SP*(fs/Nfft);
[dip_val_DT,dip_loc_DT] = findpeaks(-env_DT(1:dip_pick_len));
dip_loc_DT = dip_loc_DT*(fs/Nfft);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
plot(friency_axis,spectrum_nut(1:axis_length),'color',[96 96 96]/255);
hold on
plot(friency_axis,env_DT(1:axis_length),'LineWidth',2.0);
scatter(peak_loc_DT,peak_val_DT,'k');
% hold off
% % 
% figure(2)
% % plot(friency_axis,spectrum(1:axis_length),'color',[96 96 96]/255);
% hold on
% plot(friency_axis,env_cep(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,env_DT(1:axis_length),'LineWidth',1.0);
% scatter(peak_loc_DT,peak_val_DT,'k');
% hold off

%% delta ceptrum subtraction
lifter = M-5;
len_constant = 70;
len_damp = 20;

% spec_raw = getspectrum(vowel_blocked,Nframe,Nfft,fs,nstart);
% ceps_raw = real(ifft(spec_raw));

env_delta_final = delta_cep_sub(vowel_blocked,M,1);

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


function env_delta_sub = delta_cep_sub(signal,M,show)
global fs;
global Nfft;
global Nframe;
global axis_length;
global friency_axis;

zero_boundry = fs/1000;
lifter = M-3;
len_constant = 80;
len_damp = 80;

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

ceps_clear_low = win_clear_low.*ceps_narrow';
[var_rah1,loc_rah1] = max(ceps_clear_low(zero_boundry:500));
loc_rah1 = loc_rah1+zero_boundry-1;

ceps_clear_sqr = ceps_clear_low.^3;
max_rah_loc = loc_rah1;
left_sides = [];
right_sides = [];
for i=1:3
    stamp = 1;
    side_l = max_rah_loc-1;
    side_r = max_rah_loc+1;
    area_old = max_rah_loc;
    while stamp == 1
        area_new = area_old+ceps_clear_sqr(side_l)+ceps_clear_sqr(side_r);
        if abs(area_new - area_old) <= 1
            left_sides = [left_sides,side_l];
            right_sides = [right_sides,side_r];
            stamp = 0;
        else
            area_old = area_new;
            side_l = side_l - 1;
            side_r = side_r + 1;
        end
    end
    ceps_clear_sqr(side_l(i):side_r(i)) = 0;
    [var_max_rah,max_rah_loc] = max(ceps_clear_low(zero_boundry:500));
end


[sub_cep1,sub_spec1] = get_peak_cepstrum(spec_wide,Nfft,1,lifter);
[sub_cep2,sub_spec2] = get_peak_cepstrum(spec_wide,Nfft,2,lifter);
[sub_cep3,sub_spec3] = get_peak_cepstrum(spec_wide,Nfft,3,lifter);

delta2 = sub_cep1 - sub_cep2;
delta2_edit = win_clear_low.*max(delta2,0);

ceps_clear = win_clear_low.*ceps_narrow';
% multi_para = floor(max(ceps_clear)/max(delta2_edit));
multi_para = floor(ceps_narrow(loc_rah1)/delta2(loc_rah1));

ceps_restore = multi_para*delta2_edit;
ceps_delta_subed = ceps_narrow' - ceps_restore;
cep_delta_env = win_env.*ceps_delta_subed;

% ceps_delta_subed(35:62)=ceps_narrow(35:62);
% ceps_delta_subed(67:96)=ceps_narrow(67:96);
% ceps_delta_subed(101:119)=ceps_narrow(101:119);
% ceps_delta_subed(1988:2015)=ceps_narrow(1988:2015);
% ceps_delta_subed(1954:1983)=ceps_narrow(1954:1983);
% ceps_delta_subed(1931:1949)=ceps_narrow(1931:1949);

spec_delta_subed = real(fft(ceps_delta_subed));

env_delta_final = real(fft(cep_delta_env));
env_delta_sub = env_delta_final;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if show == 1
    figure(21)
    plot(friency_axis,spec_narrow(1:axis_length));
    hold on
    %     plot(friency_axis,env_delta_final(1:axis_length),'LineWidth',2.0);
    plot(friency_axis,spec_delta_subed(1:axis_length),'LineWidth',1.0);
    %     hold off
    
    figure(22)
    plot(ceps_clear_sqr(1:200));
    hold on
    plot(ceps_restore(1:200));
    %     plot(ceps_delta_subed(1:200));
%     scatter(loc_rah1,ceps_clear_low(loc_rah1),'k');
    hold off
end
    
end