clear

Filelist = [150,200,250,300,350,400,450,500,550,600,650,700,750];
FileCotainer = '..\data\20180828(CR vowel a test)\';

%parameters setting
%%

fs = 16000;

Nframe = 320;
Nfft = 1024;
nstart = 10000;

axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

Spectrum = [];
Ceps_base = [];
Base_Loc = {};
Base_val = {};
%Reading files length(Filelist)
%%
for i=1:1:1
    
    FILENAME = [FileCotainer,'CR_a_',num2str(Filelist(i)),'Hz.wav'];
    [vowel_origin,fs_origin] = audioread(FILENAME);
    [spectrum,ceps_base,base_loc,base_val] = F0_regression(FILENAME);
    Spectrum = [Spectrum,spectrum];
    Ceps_base = [Ceps_base,ceps_base];
    Base_Loc(i,:) = {Filelist(i);base_loc};
    Base_val(i,:) = {Filelist(i);base_val};
%     vowel_resample=resample(sidetest,fs,fs_origin);
%     vowel_filtered=filter([1,-0.99],[1],vowel_resample);
end