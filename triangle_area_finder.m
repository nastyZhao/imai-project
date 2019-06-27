clear;
%% initial data settings
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_750.wav');
% ..\data\CR_A_30HNR_JITTER\CR_A_750.wav
% ..\data\yuke voice\YUKE_600.wav
fs = 24000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],vowel_resample);

%FFT paramaters setting% 
Nframe = 600;
Nfft = Nframe*4;
nstart = 5000;
M = 30;
%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

peak_pick_len = 4500/(fs/Nfft);
dip_pick_len = 6500/(fs/Nfft);

%spectrum calculating%

vowel_blocked = vowel_filtered(nstart+1:nstart+Nframe);
spectrum_nut = getspectrum(vowel_blocked,Nframe,Nfft,'nut');
spectrum_bla = getspectrum(vowel_blocked,Nframe,Nfft,'bla');
spectrum_han = getspectrum(vowel_blocked,Nframe,Nfft,'han');
ceps_narrow = real(ifft(spectrum_nut));
ceps_bla = real(ifft(spectrum_bla));
ceps_han = real(ifft(spectrum_han));

[sub_cep1,sub_spec1,sub_env1] = get_peak_cepstrum(spectrum_nut,Nfft,0,M);
[sub_cep2,sub_spec2,sub_env2] = get_peak_cepstrum(spectrum_nut,Nfft,1,M);
sub_env_middle = 0.5*(0.5*(sub_env1+sub_env2)+sub_env1);
sub_spec_middle = max(spectrum_nut'-sub_env_middle,0);
% sub_cep_middle = 0.5*(0.5*(sub_cep1 + sub_cep2)+sub_cep1);
% [y1,ceps]=imai_peak(spectrum_nut,M,1,1,ws)
% [y2,ceps]=imai_peak(spectrum_nut,M,1,2,ws)

zero_boundry = floor(fs/1000);
win_clear_low = [zeros(1,zero_boundry+1) ones(1,Nfft-2*zero_boundry-1)...
    zeros(1,zero_boundry)];

ceps_slice = sub_cep1 - sub_cep2;
% ceps_slice = real(fft(sub_spec1-sub_spec_middle));
ceps_slice_clear = win_clear_low.*ceps_slice;

ceps_clear_low = win_clear_low.*ceps_narrow';
[var_rah1,loc_rah1] = max(ceps_clear_low(zero_boundry:1000));
loc_rah1 = loc_rah1+zero_boundry-1;

multi_para = ceps_narrow(loc_rah1)/ceps_slice(loc_rah1);
ceps_restore = multi_para*ceps_slice_clear;

test = ceps_clear_low.^4;
ceps_clear_sqr = ceps_restore.^4;
max_rah_loc = loc_rah1; 
left_sides = [];
right_sides = [];
var_l = [];
var_r = [];

rah_num = 4;
for i=1:rah_num
    stamp = 1;
    side_l = max_rah_loc-1;
    side_r = max_rah_loc+1;
    area_old = max_rah_loc;
    while stamp == 1
        area_new = area_old+ceps_clear_sqr(side_l)+ceps_clear_sqr(side_r);
        if abs(area_new - area_old) < 1
            left_sides = [left_sides,side_l-1];
            right_sides = [right_sides,side_r];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            var_l = [var_l,ceps_narrow(side_l-1)];
            var_r = [var_r,ceps_narrow(side_r)];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            stamp = 0;
        else
            area_old = area_new;
            side_l = side_l - 1;
            side_r = side_r + 1;
        end
    end
%     ceps_clear_sqr(left_sides(i):right_sides(i)) = 0;
    ceps_clear_sqr(1:i*loc_rah1+floor(loc_rah1/2)) = 0;
    [var_max_rah,max_rah_loc] = max(ceps_clear_sqr(1:1000));
end

ceps_peak_subed = ceps_narrow';
for i = 1:rah_num
%     val_l = [val_l,ceps_bla(left_sides(i))];
%     val_r = [val_r,ceps_bla(right_sides(i))];
    l_side = left_sides(i)-1;
    r_side = right_sides(i)+1;
    ceps_peak_subed(l_side:r_side)=...
        ceps_narrow(l_side:r_side)'- ceps_restore(l_side:r_side);
    l_mirror = Nfft - r_side + 1-1;
    r_mirror = Nfft - l_side + 1+1;
    ceps_peak_subed(l_mirror:r_mirror) = ceps_narrow(l_mirror:r_mirror)'...
        -ceps_restore(l_mirror:r_mirror);
end

spec_subed = real(fft(ceps_peak_subed));

figure(31)
plot(ceps_narrow(1:150));
hold on
% plot(ceps_restore(1:200));
plot(ceps_peak_subed(1:150));
% scatter(left_sides,var_l,'k');
% scatter(right_sides,var_r,'k');
hold off

figure(1)
plot(friency_axis,spectrum_bla(1:axis_length));
hold on
% plot(friency_axis,sub_env1(1:axis_length));
% plot(friency_axis,sub_env2(1:axis_length));
plot(friency_axis,spec_subed(1:axis_length));
hold off

figure(3)
plot(ceps_clear_sqr(1:200));
hold on

% figure(2)
% ax1 = subplot(2,1,1); 
% plot(friency_axis,sub_spec1(1:axis_length));
% hold on
% plot(friency_axis,sub_spec2(1:axis_length));
% xlabel(ax1,'Frequency(Hz)');
% ylabel(ax1,'Amplitude(db)');
% hold off
% 
% 
% ax2 = subplot(2,1,2); 
% plot(sub_cep1(1:150));
% hold on
% plot(sub_cep2(1:150));
% ylabel(ax2,'Amplitude(db)');
% xlabel(ax2,'Quefrency(samples)');
% hold off