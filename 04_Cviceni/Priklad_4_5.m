clc; clear; close all;

G = 500;            %[N] tiha tramu
Q = 1000;           %[N] tiha bremene
a = 0.5; 
b = 0.7; 
c = 0.6; 
d = 0.2; 
r = 0.05;
alfa = 45*pi/180;   %[Rad] uhel lana
% alfa = deg2rad(45);

% Reseni soustavy linearnich rovnic
A = [ 0  0      -1
      1  -1     0
      b  -(a+b) 0  ];

F = [ -Q*sin(alfa)
      Q*(1+cos(alfa)) + G
      G*c                 ];

x = A\F;

% U dvojic bodu A,B a C,D je nutne testovat, kde dojde k opreni tramu
RAB = x(1);
if RAB > 0
    RA = 0
    RB = RAB
else
    RA = -RAB
    RB = 0
end

RCD = x(2);
if RCD > 0
    RC = RCD
    RD = 0
else
    RC = 0
    RD = -RCD
end
RE = x(3)
