function [spectrum_pool,ceps_base_pool] = CEPS_baseline(FILENAME,first_order)

% [sidetest,fs_origin] = audioread(FILENAME);
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_450.wav');
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.99],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 480;
Nfft = 2048;
nstart = 10000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

ceps_base_pool = [];
spectrum_pool = [];

figure(1)
%file iternation%
for m=1:1:30

    %spectrum calculating%
    spectrum_slice = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart+m*3000);
    spectrum_show = spectrum_slice(1:axis_length)';
    spectrum_pool(:,m) = spectrum_show;
    Nfft=max(size(spectrum_slice));
    
    %% filter settings
    
    remove_lifter_order = 35;
    nr = 2*remove_lifter_order-4; % almost 1 period left and right
    if floor(nr/2) == nr/2, nr=nr-1; end; % make it odd
    remove_lifter_window = window(@blackman,nr)';
%     remove_lifter_window = boxcar(nr)';
    wzp_harmonic_remover = [remove_lifter_window(((nr+1)/2):nr),zeros(1,Nfft-nr),...
        remove_lifter_window(1:(nr-1)/2)];
    
    env_lifter_order = 100;
    ne = 2*env_lifter_order-4; % almost 1 period left and right
    if floor(ne/2) == ne/2, ne=ne-1; end; % make it odd\
    env_lifter_window = window(@blackman,ne)';
    % env_lifter_window = boxcar(ne)';
    wzp_env_getter = [env_lifter_window(((ne+1)/2):ne),zeros(1,Nfft-ne),...
        env_lifter_window(1:(ne-1)/2)];
    
    cep_hr_liftered = wzp_harmonic_remover.*real(ifft(spectrum_slice'));
    V=real(fft(cep_hr_liftered))';%µ¹Æ×
    
    %% Iteration
    nIter = 4;
    
    % figure(2);
    % plot(friency_axis,spectrum_show,'color',[96 96 96]/255);
    % hold on
    % plot(friency_axis,V(1:axis_length),'k','LineWidth',2.0);
    for i=1:nIter
        for j=1:Nfft
            if V(j)>spectrum_slice(j)
                E(j)=spectrum_slice(j);
            else
                E(j)=V(j);
            end
        end
        base_observer = E(1:axis_length);
        if i==nIter
            c=wzp_env_getter.*real(ifft(E));
        else
            Iter_order = remove_lifter_order+i*50;
            ni = 2*Iter_order-4; % almost 1 period left and right
            if floor(ni/2) == ni/2, ni=ni-1; end; % make it odd
            remove_lifter_window = window(@blackman,ni)';
            wzp_Iter = [remove_lifter_window(((ni+1)/2):ni),zeros(1,Nfft-ni),...
                remove_lifter_window(1:(ni-1)/2)];
            c=wzp_Iter.*real(ifft(E));
            Y = real(fft(c));
            %         plot(friency_axis,Y(1:axis_length),'LineWidth',2.0);
        end
        V=real(fft(c));
    end
    ceps_base_slice = V(:);
    ceps_base_show = ceps_base_slice(1:axis_length)';
    ceps_base_pool(:,m) = ceps_base_show;
    
%     plot(friency_axis,spectrum_pool(:,m),'k');
    hold on 
    plot(friency_axis,ceps_base_show);
end

%% result calculation
spectrum = mean(spectrum_pool,2);
ceps_base = mean(ceps_base_pool,2);
[base_loc,base_val] = findpeaks(ceps_base);
base_val = base_val(:)*(fs/Nfft);

inverse_ceps_base = -ceps_base;
[i_base_loc,i_base_val] = findpeaks(inverse_ceps_base);
i_base_val = i_base_val(:)*(fs/Nfft);
i_base_loc = -i_base_loc;


%% Ploting 
% plot(cepstrum(1:Nfft/10),'color',[96 96 96]/255);
% hold on
% plot(friency_axis,envelope_show,'k','LineWidth',2.0);
% plot(friency_axis,env_peak(1:axis_length),'k','LineWidth',2.0);
% plot(friency_axis,ceps_base_show,'r','LineWidth',2.0);
% scatter(base_val,base_loc,'k');
% % plot(y1,'r','LineWidth',2.0);
% ylabel('amplitude(db)');xlabel('Frequency(Hz)');
% hold off
% 
figure(9)
plot(friency_axis,spectrum);
hold on
plot(friency_axis,ceps_base,'LineWidth',2.0);
scatter(base_val,base_loc,'k');
% scatter(i_base_val,i_base_loc,'b');
% % plot(friency_axis,envelope_show,'k','LineWidth',2.0);
hold off



end