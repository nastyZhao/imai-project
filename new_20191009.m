clear;
%% initial data settings
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_750.wav');
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

%spectrum calculating%
vowel_blocked = vowel_filtered(nstart+1:nstart+Nframe);
spectrum_bla = getspectrum(vowel_blocked,Nframe,Nfft,'bla');
ceps_bla = real(ifft(spectrum_bla));

%% Cepstrum Editor
low_boundry = floor(fs/900);
ceps_search = ceps_bla(1:Nfft/2);
ceps_search(1:low_boundry) = 0;
[val_P1,loc_P1] = max(ceps_search);
M = low_boundry;

[sub_cep1,sub_spec1,sub_env1] = get_peak_cepstrum(spectrum_bla,Nfft,0,M);
[sub_cep2,sub_spec2,sub_env2] = get_peak_cepstrum(spectrum_bla,Nfft,7,M);
[sub_cep3,sub_spec3,sub_env3] = get_peak_cepstrum(spectrum_bla,Nfft,9,M);
[sub_cep4,sub_spec4,sub_env4] = get_peak_cepstrum(spectrum_bla,Nfft,11,M);

[base_ceps0,base_spec0,base_env0] = get_invertImai_peak(spectrum_bla,0,M);
[base_ceps1,base_spec1,base_env1] = get_invertImai_peak(spectrum_bla,1,M);
[base_ceps2,base_spec2,base_env2] = get_invertImai_peak(spectrum_bla,2,M);
[base_ceps3,base_spec3,base_env3] = get_invertImai_peak(spectrum_bla,3,M);

spec_overhar =  max(spectrum_bla'-base_env1,0);
% spec_overhar =  max(spectrum_bla'-base_env2,0);
% spec_overhar =  max(spectrum_bla'-base_env3,0);
% spec_overhar =  max(spectrum_bla'-base_env4,0);
ceps_overhar = real(ifft(spec_overhar));

delta1 = (sub_cep1 - sub_cep2).^2;
delta2 = (sub_cep1 - sub_cep3).^2;
delta3 = (sub_cep1 - sub_cep4).^2;
deltasum = delta1+delta2+delta3;

deltasumCache = deltasum;
deltamean = mean(deltasumCache);
deltasumCache(1:floor(loc_P1/2)) = 0;
anti_deltasum = -deltasumCache;

loc_Rams = [];
l_bonds = [];
r_bonds = [];
ceps_peak_subed = ceps_bla';


rah_used = 0;
i = 0;
while 1
    i = i+1;
    if i == 1
        loc_Ram = loc_P1;
        val_Ram = deltasumCache(loc_Ram);
    else
        [val_Ram,loc_Ram] = max(deltasumCache(loc_Rams(i-1)+loc_P1-floor(low_boundry/2):... 
            loc_Rams(i-1)+loc_P1+floor(low_boundry/2)));
        loc_Ram = loc_Ram + loc_Rams(i-1)+loc_P1-floor(low_boundry/2)-1;
    end
    
    if val_Ram <= deltamean
        rah_used = i-1;
        break
    end
 
    loc_Rams = [loc_Rams,loc_Ram];
    
    [var_l_zeros,loc_l_zeros] = findpeaks(anti_deltasum(loc_Rams(i)-10:loc_Rams(i)));
    [var_r_zeros,loc_r_zeros] = findpeaks(anti_deltasum(loc_Rams(i):loc_Rams(i)+10));
    
    l_bond = loc_Rams(i)-10+loc_l_zeros(length(loc_l_zeros))-1;
    r_bond = loc_Rams(i)+loc_r_zeros(1)-1;
%     if i == 1
%         l_bond = l_bond - 2;
%         r_bond = r_bond + 2;
%     end
    
    
    l_mirror = Nfft - r_bond + 1;
    r_mirror = Nfft - l_bond + 1;
    
    l_bonds = [l_bonds,l_bond];
    r_bonds = [r_bonds,r_bond];
    
    ceps_peak_subed(l_bond:r_bond)=...
        ceps_bla(l_bond:r_bond)'- ceps_overhar(l_bond:r_bond);
    ceps_peak_subed(l_mirror:r_mirror) = ceps_bla(l_mirror:r_mirror)'...
        -ceps_overhar(l_mirror:r_mirror);
end
spec_subed = real(fft(ceps_peak_subed));

%% Envelope calculation
lifter = 60;
nlift = 2*lifter-4; 
if floor(nlift/2) == nlift/2, nlift=nlift-1; end; % make it odd
w = boxcar(nlift)'; % rectangular window
w_env = [w(((nlift+1)/2):nlift),zeros(1,Nfft-nlift), ...
       w(1:(nlift-1)/2)];
cep_subed_liftered = w_env.*ceps_peak_subed;
env_ceplifter = real(fft(cep_subed_liftered));



len_constant = 50;
len_damp = 50;
win_damp = window(@blackman,2*len_damp)';
win_env = [ones(1,len_constant) win_damp(len_damp+1:2*len_damp)...
    zeros(1,Nfft-2*(len_constant+len_damp))...
    win_damp(1:len_damp) ones(1,len_constant)];
cep_peak_env = win_env.*ceps_peak_subed;
env_peak_final = real(fft(cep_peak_env));


[cc,ee,env_imai] = get_peak_cepstrum(spec_subed',Nfft,3,lifter);
[cc1,ee1,env_i_imai] = get_invertImai_peak(spec_subed',1,lifter);
% [yupper,ylower] = envelope(spec_subed,np,'peak');
%% Extra Experipents_1: Boundary Validation
var_lbonds = [];
var_rbonds = [];

for j=1:length(l_bonds)
    var_lbond = deltasum(l_bonds(j));
    var_rbond = deltasum(r_bonds(j));
    var_lbonds = [var_lbonds,var_lbond];
    var_rbonds = [var_rbonds,var_rbond];
end

%% Figures
figure(31)
plot(deltasum(1:600));
hold on
% plot(ceps_peak_subed(1:150));
scatter(l_bonds,var_lbonds,'k');
scatter(r_bonds,var_rbonds,'k');
hold off

figure(71)
plot(friency_axis,spectrum_bla(1:axis_length),'k');
hold on
plot(friency_axis,spec_subed(1:axis_length));
plot(friency_axis,env_imai(1:axis_length),'Linewidth',1.0);
% plot(friency_axis,env_i_imai(1:axis_length),'Linewidth',1.0);
% plot(friency_axis,env_peak_final(1:axis_length),'Linewidth',1.0);
hold off

figure(41)
plot(ceps_bla(1:600));

