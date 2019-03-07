clear

Filelist = [150,200,250,300,350,400,450,500,550,600,650,700,750];
FileCotainer = '..\data\CR_A_30HNR_JITTER\';

%parameters setting
%%

fs = 16000;

Nframe = 320;
Nfft = 2048;
nstart = 10000;

cepstrum_lifter_order = fix(fs./Filelist);
cepstrum_lifter_order(1:3) = cepstrum_lifter_order(1:3)/2;

axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

formant_pool = cell(1,13);
max_val_length = 0;
% Spectrum = [];
% Ceps_base = [];
% Base_Loc = {};
% Base_val = {};
%Reading files length(Filelist)
%%
for i=1:1:13
    
    FILENAME = [FileCotainer,'CR_A_',num2str(Filelist(i)),'.wav'];
    %     [vowel_origin,fs_origin] = audioread(FILENAME);
    %     [spectrum,ceps_base,base_loc,base_val] = F0_regression(FILENAME);
    %     Spectrum = [Spectrum,spectrum];
    %     Ceps_base = [Ceps_base,ceps_base];
    %     Base_Loc(i,:) = {Filelist(i);base_loc};
    %     Base_val(i,:) = {Filelist(i);base_val};
    %     vowel_resample=resample(sidetest,fs,fs_origin);
    %     vowel_filtered=filter([1,-0.99],[1],vowel_resample);
    if i < 4, 
        firstfilter = 100;
    elseif i >= 4 && i < 8, 
        firstfilter = 50;
    else i >= 8, 
        firstfilter = 40;
    end
    [spectrum_pool,ceps_base_pool] = CEPS_baseline(FILENAME,firstfilter)
    spectrum = mean(spectrum_pool,2);
    ceps_base = mean(ceps_base_pool,2);
    
    [base_loc,base_val] = findpeaks(ceps_base);
    base_val = base_val(:)*(fs/Nfft);
    
    inverse_ceps_base = -ceps_base;
    [i_base_loc,i_base_val] = findpeaks(inverse_ceps_base);
    i_base_val = i_base_val(:)*(fs/Nfft);
    i_base_loc = -i_base_loc;
    
    if max_val_length < length([base_val',0,i_base_val'])
        max_val_length = length([base_val',0,i_base_val']);
    end
    
    formant_val = {[base_val',0,i_base_val']};
    formant_pool(1,i) = formant_val;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    cepstrum_env_result = cepstrum_env(FILENAME,cepstrum_lifter_order(i))
    cepstrum_env_results(1,i) = cepstrum_env_result;
end

ceps_base_results = zeros(max_val_length,13);
for j = 1:1:13
    ceps_base_slice = cell2mat(formant_pool(1,j))';
    ceps_base_results(1:length(ceps_base_slice),j) = ceps_base_slice;
end
% xlswrite('CR_30HNR_RESULTS_30ms.xls', ceps_base_results)

cepstrum_results = zeros(max_val_length,13);
for f = 1:1:13
    cepstrum_results_slice = cell2mat(cepstrum_env_results(1,f))';
    cepstrum_results(1:length(cepstrum_results_slice),f) = cepstrum_results_slice;
end
% xlswrite('CR_30HNR_CEPSTRUM_RESULTS_30ms.xls', cepstrum_results);

