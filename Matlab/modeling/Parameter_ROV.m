m = 6.621; %Khoi luong ROV (kg)
g = 9.82; %Gia toc trong truong (m/s2)
rho = 1000; %khoi luong rieng cua nuoc (kg/m3)

%_____________________Goc quay Roll(phi) Pitch(Theta) Yaw(Psi)
phi = pi/4;
theta = pi/3;
psi = pi/2;
%Van toc goc Roll Pitch Yaw (rad/s)
p = 4;
q = 5;
r = 6;
%Luc tac dong Roll Pitch Yaw
K = 0;
M = 0;
N = 0;

%Vi tri XYZ
x = 0;
y = 0;
z = 0;
%Van toc thang XYZ (m/s)
u = 1;
v = 2;
w = 3;

%Luc tac dong XYZ
X = 0;
Y = 0;
Z = 0;

%Vector van toc
vantoc_thang_body = [u,v,w]';
vantoc_goc_body = [p,q,r]';
nu = [vantoc_thang_body; vantoc_goc_body];

%_____________________Moments of inertia using Solidworks
Ixx = 0.14; 
Ixy = 0.00;
Ixz = 0.00;
Iyy = 0.19;
Iyz = 0.01;
Izz = 0.10;
inertia_matrix = [Ixx -Ixy -Ixz;
                  -Ixy Iyy -Iyz;
                  -Ixz -Iyz Izz];
              
%_____________________Hydrostatics
zB = -0.0420; %Distance from CG to CB
r_g = [0, 0, 0]; % location of CG with respect to CO
r_b = [0, 0, zB]; % location of CB with respect to CO
W = m*g; % weight
B = W; % buoyancy = rho*g*rot: rot la the tich nuoc bi ROV chiem cho
              
%_____________________Actuators
lx1 = 0.19;
ly1 = 0.11;
ly2 = 0.11;
lx2 = 0.19;
ly3 = 0.11;
lx5 = 0.17;
ly4 = 0.11;
lz6 = 0;

% matrix describing the geometry of the actuators
% T = [0 0 1 1 0 0;
%      0 0 0 0 0 -1;
%      -1 -1 0 0 -1 0;
%      ly1 -ly2 0 0 0 lz6;
%      lx1 lx2 0 0 -lx5 0;
%      0 0 ly3 -ly4 0 0];

T = [0 0 1 1 0 0;
     0 0 0 0 0 -1;
     -1 -1 0 0 -1 0;
     0.11 -0.11 0 0 0 0;
     0.19 0.19 0 0 -0.17 0;
     0 0 0.11 -0.11 0 0];
 
% m control signal ui to thrust in Newton
f1 = 30;
f2 = 30;
f3 = 30;
f4 = 30;
f5 = 30;
f6 = 30;
f_u = [f1 f2 f3 f4 f5 f6]';
     
%_____________________Hydrodynamic Damping
Xuu = 12.955;
Xu = 1.232;
Yvv = 55.92;
Yv = -16.59;
Zww = 23.255;
Zw = -1.115;
Kpp = 0.137;
Kp = -0.005;
Mqq = 17.692;
Mq = -1.8817;
Nrr = 0.594;
Nr = 0.002;
