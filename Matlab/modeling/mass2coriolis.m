function C = mass2coriolis(M,nu)
nu1 = nu(1:3);
nu2 = nu(4:6);
Msym = 0.5*(M+M');
M = Msym;

M11 = M(1:3,1:3);
M12 = M(1:3,4:6);
M21 = M12';
M22 = M(4:6,4:6);

dt_dnu1 = M11*nu1 + M12*nu2;
dt_dnu2 = M21*nu1 + M22*nu2;

C = [  zeros(3,3)      -cross_product(dt_dnu1)
      -cross_product(dt_dnu1)  -cross_product(dt_dnu2) ];