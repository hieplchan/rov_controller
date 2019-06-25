clear all
clf

s = serial('COM4','BaudRate',115200);
fopen(s);
j = 1;

gyroX = 0;
gyroY = 0;
gyroZ = 0;
accX = 0;
accY = 0;
accZ = 0;
magX = 0;
magY = 0;
magZ = 0;

roll_acc(1,1) = 0;
roll_gyro(1,1) = 0;
roll_kalman(1,1) = 0;

acc_angleX = 0;
acc_angleY = 0;
mag_angleZ = 0;
gyro_angleX = 0;
gyro_angleY = 0;
gyro_angleZ = 0;

x = zeros(6,1);
P = zeros(6,6);
h = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];
R = h*0.1;

A = [0 0 0];
B = [1 0 0];
C = [0 1 0];
D = [0 0 1];
E = [0 1 1];
F = [1 0 1];
G = [1 1 0];
H = [1 1 1];

D(3)=D(3)*0.3;
F(3)=F(3)*0.3;
E(3)=E(3)*0.3;
H(3)=H(3)*0.3;

A(1)=A(1)+0.2;
D(1)=D(1)+0.2;
F(1)=F(1)-0.2;
B(1)=B(1)-0.2;


Center=H/2;
Displacement=[0 0 1];
time = 0;
sum = 0;
tic
while (j <= 400)
    
%Lay du lieu tu STM32
fprintf(s,'G');
data = fscanf(s,'%s %f %f %f %f %f %f %f %f %f',101);
gyroX = -data(2)*pi/180;
gyroY = data(3)*pi/180;
gyroZ = data(4)*pi/180;
accX = -data(6);
accY = -data(5);
accZ = -data(7);
magX = -data(9)-73.9130;
magY = -data(8)+8.6955;
magZ = -data(10)-2.4390;

% Kalman roll pitch yaw tu Acc, Gyro va Mag
a = [1 0 0 -toc 0 0; 0 1 0 0 -toc 0; 0 0 1 0 0 -toc; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];
b = [toc 0 0; 0 toc 0; 0 0 toc; 0 0 0; 0 0 0; 0 0 0];
Q = [0.1 0 0 0 0 0; 0 0.1 0 0 0 0; 0 0 0.1 0 0 0; 0 0 0 0.3 0 0; 0 0 0 0  0.3 0; 0 0 0 0 0 0.3]*toc;
if (j > 1)
    acc_angleX = -atan(accX / (sqrt(accY^2 + accZ^2))); %Goc X moi tu acc
    acc_angleY = atan(accY / (sqrt(accX^2 + accZ^2))); %Goc Y moi tu acc
    if atan2(magY,magX) < 0
        mag_angleZ = atan2(magY,magX) + 2*pi;
    elseif atan2(magY,magX) > 2*pi
        mag_angleZ = atan2(magY,magX) - 2*pi;
    else
        mag_angleZ = atan2(magY,magX);
    end
    x(:) = a*x(:) + b*[gyroX;gyroY;gyroZ]; %Gia tri du doan moi
    P = a*P*a' + Q; %Tinh phuong sai du doan moi
    y = [acc_angleX; acc_angleY; mag_angleZ; 0; 0; 0] - h*x(:); %Do lech giua quan sat va du doan
    KG = P*h'/(h*P*h' + R); %He so Kalman
    x(:) = x(:) + KG*y; %Cap nhat gia tri moi
    P = (h - KG*h)*P; %Cap nhat phuong sai moi 
end

% Ve do hoa 3d tu roll(x2) pitch(x1) yaw(x3)
dcm = angle2dcm(x(3),x(2),x(1));
HT = [A;B;F;H;G;C;A;D;E;H;F;D;E;C;G;B];
for i=1:length(HT)
    HT(i,:) = HT(i,:) - Center;
end   
HT = HT*dcm;
for i=1:length(HT)
    HT(i,:) = HT(i,:) + Center;
end
subplot(1,2,2)
plot3(HT(:,1),HT(:,2),HT(:,3),'Color','r');
hold off
axis([-2 2 -2 2 -2 2]);
grid on;
view([1, 1, 1]) ;
xlabel('X');
ylabel('Y');
zlabel('Z');

%Ve do thi so sanh
subplot(1,2,1)
roll_acc(1,j) = acc_angleY*180/pi;
if (j > 1)
    roll_gyro(1,j) = roll_gyro(1,j-1) - toc*gyroX*180/pi;
    roll_kalman(1,j) = x(2)*180/pi;
end
plot(roll_acc(1,:),'blue');
hold on
plot(roll_gyro(1,:),'green');
hold on
plot(roll_kalman(1,:),'red');
hold on


toc
tic
j = j + 1;
pause(0.001);
end
fclose(s);
