% generate factor w for flatfielding
clear all, close all, clc
%% open cube, flat field white, dark 
[CUBE_1 bands hcube] = openHSI;
[wtCUBE bands hcube] = openHSI;
[dkCUBE bands hcube] = openHSI;
[dkwtCUBE bands hcube] = openHSI;
%[wtsCUBE bands hcube] = openHSI; % open camera white reference
dims = size(CUBE_1);
load rad_whitecc_avg.mat % load white reference radiance


%% subtract dark noise
dkFRAME = repmat(mean(dkCUBE,1),dims(1),1,1);
dkwtFRAME = repmat(mean(dkwtCUBE,1),dims(1),1,1);

pixel_im = CUBE_1 - dkFRAME;
pixel_white = wtCUBE - dkwtFRAME;

% Y luminance as the peak of the green channel of the white patch 
% average bands 62 to 80 of white patch

Y = mean(rad_whitecc_avg(:,62:80));

% select average area of white patch
w = Y * (mean(mean(mean(CUBE_1(342:350,209:218,62:80))))./mean(mean(mean(wtCUBE(342:350,209:218,62:80)))));

    sRGB_IMG = reshape(out_sRGB,[dims(1) dims(2) 3]);

  figure,imshow(sRGB_IMG, [], 'InitialMagnification', 'fit');


