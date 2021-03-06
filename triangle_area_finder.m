clear;
%% initial data settings
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_350.wav');
% ..\data\CR_A_30HNR_JITTER\CR_A_750.wav
% ..\data\yuke voice\YUKE_600.wav
% ..\data\CR_A_30HNR_JITTER\CR_A_550.wav
fs = 24000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],vowel_resample);

%FFT paramaters setting% 
Nframe = 600;
Nfft = 4096;
nstart = 10000;
%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);
  
peak_pick_len = 4500/(fs/Nfft);
dip_pick_len = 6500/(fs/Nfft);
loc_rahs = [];
%spectrum calculating%

vowel_blocked = vowel_filtered(nstart+1:nstart+Nframe);
spectrum_nut = getspectrum(vowel_blocked,Nframe,Nfft,'nut');
spectrum_bla = getspectrum(vowel_blocked,Nframe,Nfft,'bla');
spectrum_han = getspectrum(vowel_blocked,Nframe,Nfft,'han');
ceps_narrow = real(ifft(spectrum_nut));
ceps_bla = real(ifft(spectrum_bla));
ceps_han = real(ifft(spectrum_han));

low_boundry = floor(fs/900);
ceps_search = ceps_bla(1:Nfft/2);
ceps_search(1:low_boundry) = 0;
[val_P1,loc_P1] = max(ceps_search);
loc_rahs = [loc_rahs,loc_P1];
Period1 = floor(fs/300);
Period2 = floor(fs/600);
if loc_P1 < Period2
    M = low_boundry;
elseif Period2 <= loc_P1 < Period2
    M = Period2;
else 
    M = Period1;
end

[sub_cep1,sub_spec1,sub_env1] = get_peak_cepstrum(spectrum_nut,Nfft,0,M);
[sub_cep2,sub_spec2,sub_env2] = get_peak_cepstrum(spectrum_nut,Nfft,1,M);
[sub_cep3,sub_spec3,sub_env3] = get_peak_cepstrum(spectrum_nut,Nfft,2,M);
[sub_cep4,sub_spec4,sub_env4] = get_peak_cepstrum(spectrum_nut,Nfft,3,M);
sub_env_middle = 0.5*(0.5*(sub_env1+sub_env2)+sub_env1);
sub_spec_middle = max(spectrum_nut'-sub_env_middle,0);

delta1 = (sub_cep1 - sub_cep2).^2;
delta2 = (sub_cep2 - sub_cep3).^2;
delta3 = (sub_cep3 - sub_cep4).^2;
deltasum = delta1+delta2+delta3;
% deltasquare = deltasum.^2;
% deldelta1 = delta1 - delta2;
% deldelta2 = delta2 - delta3;
% sub_cep_middle = 0.5*(0.5*(sub_cep1 + sub_cep2)+sub_cep1);

rahNum = 4;
deltasumCache = deltasum;
deltasumCache(1:loc_P1+floor(loc_P1/2)) = 0;
for i=1:rahNum-1
    [val_MaxP,loc_MaxP] = max(deltasumCache(1:Nfft/2));
    loc_rahs = [loc_rahs,loc_MaxP];
    deltasumCache(1:loc_MaxP+floor(loc_P1/2)) = 0;
end
deltasum(deltasum < deltasum(loc_rahs(rahNum))) = 0;

l_bonds = [];
r_bonds = [];
for i=1:rahNum
    P = loc_rahs(i)+1;
    l_bond = P-1;
    r_bond = P+1;
    while deltasum(l_bond) ~= 0
        l_bond = l_bond-1;
    end
    while deltasum(r_bond) ~= 0
        r_bond = r_bond+1;
    end
    l_bonds = [l_bonds,l_bond];
    r_bonds = [r_bonds,r_bond];
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[base_ceps1,base_spec1,base_env1] = get_base_cepstrum(spectrum_nut,0,M);
[base_ceps2,base_spec2,base_env2] = get_base_cepstrum(spectrum_nut,1,M);
base_env_middle =0.5*(0.5*(base_env1+base_env2)+base_env1); 
base_spec_middle = max(base_spec1-base_env2,0);
ceps_base_slice = real(ifft(base_spec_middle));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zero_boundry = floor(fs/1000);
win_clear_low = [zeros(1,zero_boundry+1) ones(1,Nfft-2*zero_boundry-1)...
    zeros(1,zero_boundry)];
% 
% ceps_slice = sub_cep1 - sub_cep2;
ceps_slice = ceps_base_slice;
% ceps_slice = real(fft(sub_spec1-sub_spec_middle));
ceps_slice_clear = win_clear_low.*ceps_slice;

ceps_clear_low = win_clear_low.*ceps_narrow';
[var_rah1,loc_rah1] = max(ceps_clear_low(zero_boundry:1000));
loc_rah1 = loc_rah1+zero_boundry-1;

multi_para = ceps_bla(loc_rah1)/ceps_slice(loc_rah1);
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
            var_l = [var_l,deltasum(side_l-1)];
            var_r = [var_r,deltasum(side_r)];
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

var_l = [];
var_r = [];
ceps_peak_subed = ceps_bla';
for i = 1:rah_num
    var_l = [var_l,deltasum(l_bonds(i))];
    var_r = [var_r,deltasum(r_bonds(i))];
    l_side = l_bonds(i);
    r_side = r_bonds(i);
    ceps_peak_subed(l_side:r_side)=...
        ceps_bla(l_side:r_side)'- ceps_restore(l_side:r_side);
    l_mirror = Nfft - r_side + 1;
    r_mirror = Nfft - l_side + 1;
    ceps_peak_subed(l_mirror:r_mirror) = ceps_bla(l_mirror:r_mirror)'...
        -ceps_restore(l_mirror:r_mirror);
end
cep_restore_subed = ceps_bla - ceps_restore;

spec_subed = real(fft(ceps_peak_subed));
spec_restore_subed = real(fft(cep_restore_subed));

len_constant = 100;
len_damp =50;
win_damp = window(@blackman,2*len_damp)';
win_env = [ones(1,len_constant) win_damp(len_damp+1:2*len_damp)...
    zeros(1,Nfft-2*(len_constant+len_damp))...
    win_damp(1:len_damp) ones(1,len_constant)];
cep_subed_env = win_env.*ceps_peak_subed;
env_subed_final = real(fft(cep_subed_env));

[noise_cep,noise_spec,imai_env] = get_peak_cepstrum(spec_subed',Nfft,6,len_constant);



figure(31)
plot(ceps_narrow(1:300));
hold on
% plot(sub_cep1(1:300));
% plot(sub_cep2(1:300));
% plot(sub_cep3(1:300));
% plot(deltasum(1:300),'Linewidth',1.0);
% plot(deltasum(1:300));
% plot(delta3(1:300));
scatter(l_bonds,ceps_narrow(l_bonds),'k');
scatter(r_bonds,ceps_narrow(r_bonds),'k');
hold off

figure(1)
plot(friency_axis,spectrum_nut(1:axis_length));
hold on
plot(friency_axis,spec_subed(1:axis_length));
% plot(friency_axis,sub_spec2(1:axis_length),'Linewidth',1.0);

hold off

figure(3)
plot(deltasum(1:300));
hold on
% scatter(loc_delpeak,val_delpeak,'k');
scatter(l_bonds,var_l,'k');
scatter(r_bonds,var_r,'k');
hold off

figure(4)
plot(sub_cep1(1:300));
hold on
% scatter(loc_delpeak,val_delpeak,'k');
scatter(l_bonds,sub_cep1(l_bonds),'k');
scatter(r_bonds,sub_cep1(r_bonds),'k');
hold off