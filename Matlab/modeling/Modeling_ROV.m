%_____________________MA TRAN CHUYEN TOA DO_______________________
%Ma tran chuyen van toc thang he truc body sang truc global
R_b2g = [cos(psi)*cos(theta), -sin(psi)*cos(phi)+cos(psi)*sin(theta)*sin(phi), sin(psi)*sin(phi)+cos(psi)*cos(phi)*sin(theta);
         sin(psi)*cos(theta), cos(psi)*cos(phi)+sin(phi)*sin(theta)*sin(psi), -cos(psi)*sin(phi)+sin(theta)*sin(psi)*cos(phi);
         -sin(theta), cos(theta)*sin(phi), cos(theta)*cos(phi)];
%Ma tran chuyen van toc goc he truc body sang truc global
T_b2g = [1 sin(phi)*tan(theta) cos(phi)*tan(theta);
         0 cos(phi) -sin(phi);
         0 sin(phi)/cos(theta) cos(phi)/cos(theta)];
%Ma tran chuyen van toc toan cuc he truc body sang truc global
J_b2g = [R_b2g zeros(3,3);
         zeros(3,3) T_b2g];
%Phuong trinh thu nhat cua Fossen Robot-Like Model    
eta_diff = J_b2g*nu;
   
%Chuyen euler ve quaternion
quaternion = angle2quat(psi,theta,phi);
q = quaternion(1,1);
e1 = quaternion(1,2);
e2 = quaternion(1,3);
e3 = quaternion(1,4);
%Chuyen quaternion ve euler
[yaw, pitch, roll] = quat2angle(quaternion);

%Ma tran quaternion chuyen van toc thang he truc body sang truc global
R_b2g_qua = [1-2*(e2*e2+e3*e3), 2*(e1*e2-e3*q), 2*(e1*e3+e2*q);
             2*(e1*e2+e3*q), 1-2*(e1*e1+e3*e3), 2*(e2*e3-e1*q);
             2*(e1*e3-e2*q), 2*(e2*e3+e1*q), 1-2*(e1*e1+e2*e2)];
%Ma tran quaternion chuyen van toc goc he truc body sang truc global
T_b2g_qua = 1/2*[-e1 -e2 -e3;
                 q -e3 e2;
                 e3 q -e1;
                 -e2 e1 q];
%Ma tran quaternion chuyen van toc toan cuc he truc body sang truc global
J_b2g_qua = [R_b2g_qua zeros(3,3);
            zeros(4,3) T_b2g_qua];
     
%Phuong trinh quaternion thu nhat cua Fossen Robot-Like Model
eta_diff_qua = J_b2g_qua*nu;
             
%_____________________THONG SO MO HINH HOA ROV_______________________
%Ma tran quan tinh cua ROV
M_rb = [m*eye(3), zeros(3);
         zeros(3), inertia_matrix];
%Ma tran luc coriolis cua ROV
C_rb = mass2coriolis(M_rb,nu);

%Ma tran trong luc va luc noi
g = restoring_forces(W,B,theta,phi,r_g,r_b);
