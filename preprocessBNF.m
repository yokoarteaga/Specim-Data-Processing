% pre-process BNF data
clear all, close all, clc
%% open cube, flat field white, dark 
[CUBE_1 bands hcube] = openHSI;
[wtCUBE bands hcube] = openHSI;
[dkCUBE bands hcube] = openHSI;
[dkwtCUBE bands hcube] = openHSI;
%[wtsCUBE bands hcube] = openHSI; % open camera white reference
dims = size(CUBE_1);
%load rad_whitecc_avg.mat % only load if calculating w
load w_92.mat

%% subtract dark noise
dkFRAME = repmat(mean(dkCUBE,1),dims(1),1,1);
dkwtFRAME = repmat(mean(dkwtCUBE,1),dims(1),1,1);

pixel_im = CUBE_1 - dkFRAME;
pixel_white = wtCUBE - dkwtFRAME;

%% Y luminance as the peak of the green channel of the white patch 
% average bands 62 to 80 of white patch

Y = mean(rad_whitecc_avg(:,62:80));

w = Y * (mean(mean(mean(CUBE_1(342:350,209:218,62:80))))./mean(mean(mean(wtCUBE(342:350,209:218,62:80)))));
%% flatfield correction
pixel_im_ff = (w / 1000) * pixel_im ./ pixel_white;

%% sRGB image generation
dims = size(CUBE_1);
    %illuminant = cat(2,lam,spec');
    ref_ff = reshape(pixel_im_ff, [dims(1)*dims(2) dims(3)]);
    ref_interp = interp1(bands,ref_ff',410:5:700)';
    system = 1931;
    out_space = 'XYZ';
    wlength = [410 5 700];
    illuminant = 'D65';
    out = t_spd2sth(ref_interp',wlength,illuminant,system,out_space);
    out_sRGB = xyz2rgb(out'./100, 'whitepoint', 'd65');
    sRGB_IMG = reshape(out_sRGB,[dims(1) dims(2) 3]);

  figure,imshow(sRGB_IMG, [], 'InitialMagnification', 'fit');


