clear;
%% initial data settings
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_350.wav');
% ..\data\CR_A_30HNR_JITTER\CR_A_750.wav
% ..\data\yuke voice\YUKE_600.wav
% ..\data\CR_A_30HNR_JITTER\CR_A_550.wav
fs = 20000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],vowel_resample);

%FFT paramaters setting% 
Nframe = 600;
Nfft = 4096;
nstart = 10000;
%axis scaling%
axis_length = 5000/(fs/Nfft);
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

% M = 25;

[sub_cep1,sub_spec1,sub_env1] = get_peak_cepstrum(spectrum_bla,Nfft,0,M);
[sub_cep2,sub_spec2,sub_env2] = get_peak_cepstrum(spectrum_bla,Nfft,7,M);
[sub_cep3,sub_spec3,sub_env3] = get_peak_cepstrum(spectrum_bla,Nfft,9,M);
[sub_cep4,sub_spec4,sub_env4] = get_peak_cepstrum(spectrum_bla,Nfft,11,M);


[base_ceps0,base_spec0,base_env0] = get_invertImai_peak(spectrum_bla,0,M);
[base_ceps1,base_spec1,base_env1] = get_invertImai_peak(spectrum_bla,1,M);
% [base_ceps3,base_spec3,base_env3] = get_invertImai_peak(spectrum_bla,2,M);
% [base_ceps4,base_spec4,base_env4] = get_invertImai_peak(spectrum_bla,3,M);

spec_overhar =  max(spectrum_bla'-base_env1,0);
ceps_overhar = real(ifft(spec_overhar));

delta1 = (sub_cep1 - sub_cep2).^2;
delta2 = (sub_cep1 - sub_cep3).^2;
delta3 = (sub_cep1 - sub_cep4).^2;
deltasum = delta1+delta2+delta3;
deltasum_show = deltasum;
anti_delta = 0-deltasum;
% deltasquare = deltasum.^2;
% deldelta1 = delta1 - delta2;
% deldelta2 = delta2 - delta3;
% sub_cep_middle = 0.5*(0.5*(sub_cep1 + sub_cep2)+sub_cep1);

rahNum = 15;
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
   



zero_boundry = floor(fs/1000);
win_clear_low = [zeros(1,zero_boundry+1) ones(1,Nfft-2*zero_boundry-1)...
    zeros(1,zero_boundry)];
% 
ceps_slice = sub_cep1 - sub_cep2;
% ceps_slice = ceps_base_slice;
% ceps_slice = real(fft(sub_spec1-sub_spec_middle));
ceps_slice_clear = win_clear_low.*ceps_slice;

multi_para = floor(ceps_bla(loc_rahs(1))/ceps_slice(loc_rahs(1)));
ceps_restore = multi_para*ceps_slice_clear;

rah_num = rahNum;


ceps_peak_subed = ceps_bla';
ceps_har = zeros(1,Nfft);

for i = 1:rah_num
%     val_l = [val_l,ceps_bla(left_sides(i))];
%     val_r = [val_r,ceps_bla(right_sides(i))];
    l_side = l_bonds(i);
    r_side = r_bonds(i);
    ceps_peak_subed(l_side:r_side)=...
        ceps_bla(l_side:r_side)'- ceps_overhar(l_side:r_side);
    ceps_har(l_side:r_side) = ceps_slice(l_side:r_side);
    l_mirror = Nfft - r_side + 1;
    r_mirror = Nfft - l_side + 1;
    ceps_peak_subed(l_mirror:r_mirror) = ceps_bla(l_mirror:r_mirror)'...
        -ceps_overhar(l_mirror:r_mirror);
    ceps_har(l_mirror:r_mirror) = ceps_slice(l_mirror:r_mirror);
end

spec_har = real(fft(ceps_har));
spec_subed = real(fft(ceps_peak_subed));

spec_ok = spectrum_bla - spec_har;



figure(31)
plot(deltasum_show(1:150));
% plot(deltasum_show(1:300));
hold on
% plot(ceps_peak_subed(1:150));
% plot(sub_cep2(1:300));
% plot(sub_cep3(1:300));
% plot(deltasum(1:300),'Linewidth',1.0);
% plot(ceps_peak_subed(1:300));
% plot(delta3(1:300));
% scatter(loc_delpeak,val_delpeak,'k');
% scatter(right_sides,var_delpeak,'k');
hold off

figure(1)
plot(friency_axis,spectrum_bla(1:axis_length));
hold on
plot(friency_axis,spec_subed(1:axis_length));
% plot(friency_axis,sub_env2(1:axis_length),'Linewidth',1.0);
% plot(friency_axis,sub_env3(1:axis_length),'Linewidth',1.0);
% plot(friency_axis,sub_env4(1:axis_length),'Linewidth',1.0);

hold off

% figure(3)
% plot(ceps_clear_sqr(1:200));
% hold on
