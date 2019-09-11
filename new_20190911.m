clear;
%% initial data settings
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_750.wav');
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

[sub_cep1,sub_spec1,sub_env1] = get_peak_cepstrum(spectrum_bla,Nfft,0,M);
[sub_cep2,sub_spec2,sub_env2] = get_peak_cepstrum(spectrum_bla,Nfft,1,M);
[sub_cep3,sub_spec3,sub_env3] = get_peak_cepstrum(spectrum_bla,Nfft,2,M);
[sub_cep4,sub_spec4,sub_env4] = get_peak_cepstrum(spectrum_bla,Nfft,3,M);
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
[base_ceps1,base_spec1,base_env1] = get_base_cepstrum(spectrum_nut,Nfft,0,M);
[base_ceps2,base_spec2,base_env2] = get_base_cepstrum(spectrum_nut,Nfft,1,M);
base_env_middle =0.5*(0.5*(base_env1+base_env2)+base_env1); 
base_spec_middle = max(base_spec1-base_env2,0);
ceps_base_slice = real(ifft(base_spec_middle));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

rah_num = 1;


ceps_peak_subed = ceps_bla';
for i = 1:rah_num
%     val_l = [val_l,ceps_bla(left_sides(i))];
%     val_r = [val_r,ceps_bla(right_sides(i))];
    l_side = l_bonds(i);
    r_side = r_bonds(i);
    ceps_peak_subed(l_side:r_side)=...
        ceps_bla(l_side:r_side)'- ceps_restore(l_side:r_side);
    l_mirror = Nfft - r_side + 1;
    r_mirror = Nfft - l_side + 1;
    ceps_peak_subed(l_mirror:r_mirror) = ceps_bla(l_mirror:r_mirror)'...
        -ceps_restore(l_mirror:r_mirror);
end

spec_subed = real(fft(ceps_peak_subed));




figure(31)
% plot(ceps_narrow(1:300));
hold on
% plot(sub_cep1(1:300));
% plot(sub_cep2(1:300));
% plot(sub_cep3(1:300));
% plot(deltasum(1:300),'Linewidth',1.0);
plot(deltasum(1:300));
% plot(delta3(1:300));
% scatter(loc_delpeak,val_delpeak,'k');
% scatter(right_sides,var_delpeak,'k');
hold off

figure(1)
plot(friency_axis,spectrum_nut(1:axis_length));
hold on
plot(friency_axis,spec_subed(1:axis_length));
plot(friency_axis,sub_env1(1:axis_length),'Linewidth',1.0);
plot(friency_axis,sub_env2(1:axis_length),'Linewidth',1.0);

hold off

% figure(3)
% plot(ceps_clear_sqr(1:200));
% hold on