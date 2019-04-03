clear;
%% initial data settings
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_750.wav');

fs = 24000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 600;
Nfft = 2400;
nstart = 5000;
M = 32-3;
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
ceps_narrow = real(ifft(spectrum_nut));

[sub_cep1,sub_spec1] = get_peak_cepstrum(spectrum_nut,Nfft,1,M);

zero_boundry = fs/1000;
win_clear_low = [zeros(1,zero_boundry+1) ones(1,Nfft-2*zero_boundry-1)...
    zeros(1,zero_boundry)];

ceps_clear_low = win_clear_low.*ceps_narrow';
[var_rah1,loc_rah1] = max(ceps_clear_low(zero_boundry:1000));
loc_rah1 = loc_rah1+zero_boundry-1;

test = ceps_clear_low.^4;
ceps_clear_sqr = ceps_clear_low.^4;
max_rah_loc = loc_rah1;
left_sides = [];
right_sides = [];
var_l = [];
var_r = [];

rah_num = 2;
for i=1:rah_num
    stamp = 1;
    side_l = max_rah_loc-1;
    side_r = max_rah_loc+1;
    area_old = max_rah_loc;
    while stamp == 1
        area_new = area_old+ceps_clear_sqr(side_l)+ceps_clear_sqr(side_r);
        if abs(area_new - area_old) < 1
            left_sides = [left_sides,side_l];
            right_sides = [right_sides,side_r];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            var_l = [var_l,ceps_narrow(side_l)];
            var_r = [var_r,ceps_narrow(side_r)];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            stamp = 0;
        else
            area_old = area_new;
            side_l = side_l - 1;
            side_r = side_r + 1;
        end
    end
    ceps_clear_sqr(left_sides(i):right_sides(i)) = 0;
    [var_max_rah,max_rah_loc] = max(ceps_clear_sqr(1:1000));
end

[leftsides_f,rightsides_f] = triangleSideDetecter(test,41,rah_num);
ceps_subpeaks = ceps_narrow;

figure(31)
plot(ceps_narrow(1:500));
hold on
scatter(left_sides,var_l);
scatter(right_sides,var_r);
hold off

figure(1)
plot(friency_axis,spectrum_bla(1:axis_length));