function [s11,s12,s21,s22] = smatrix(zp,z0,b,len,handles)

% N Michael Sheridan
% November 2018
% Calculates the S-Parameter matrix for a (lossless) transmission line given
% its propagation constant, length, and charateristic impedance

% Inputs:
% z0 ---> Characteristic Impedance [Ohms]
% a  ---> Complex wavenumber (attenuation constant + j*propagation
% constant)
% len --> Transmission Line Lnegth [mm]
% Handles?

len = len/1000;

R = (zp-z0)/(zp+z0);
Zin = z0*((1+R*exp(-2*j*b*len))/(1-R*exp(-2*j*b*len)));

R12 = (Zin-z0)/(Zin+z0);

s11 = R12*R12*exp(-2*j*b*len);
%s11 = 10*log10(abs(s11))*exp(j*angle(s11));
s12 = exp(-j*b*len)/(1-R12*R12*exp(-j*2*b*len));
%s12 = 10*log10(abs(s12))*exp(j*angle(s12));
s21 = exp(-j*b*len)/(1-R12*R12*exp(-j*2*b*len));
%s21 = 10*log10(abs(s21))*exp(j*angle(s21));
s22 = R12*R12*exp(-2*j*b*len);
%s22 = 10*log10(abs(s22))*exp(j*angle(s22));