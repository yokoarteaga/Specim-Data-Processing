function [CUBE, bands, hcube] = openHSI
% locate cube
f = msgbox('Select the header of the spectral cube');
movegui(f,'northwest')
pause(1)
[headCB,pathCB] = uigetfile(['VNIR' filesep '*.hdr']);
close(f)
% read cube

hcube = hypercube([pathCB headCB]);
CUBE = double(hcube.DataCube);
bands = hcube.Wavelength;