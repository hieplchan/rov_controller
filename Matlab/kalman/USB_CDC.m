clear all
clf

s = serial('COM1');
fopen(s);
j = 1;
gyro = zeros(1,3);
acc = zeros(1,3);
mag = zeros(1,3);
anglex(1) = 0;

pitch = zeros(1,1);
theta = zeros(1,1);
roll = zeros(1,1);

gyroX = zeros(500,1);
gyroY = zeros(500,1);
gyroZ = zeros(500,1);

x0 = zeros(1,1);
vx0 = zeros(1,1);
y0 = zeros(1,1);
vy0 = zeros(1,1);

tic
while (j <= 1000)
    
%Lay du lieu tu STM32
fprintf(s,'G');
data = fscanf(s,'%s %f %f %f %f %f %f %f %f %f',101);
gyro(j,1) = -data(2);
gyro(j,2) = data(3);
gyro(j,3) = data(4);
acc(j,1) = -data(6)-0.0019;
acc(j,2) = -data(5)-0.1601;
acc(j,3) = -data(7)+0.2740;
mag(j,1) = -data(9);
mag(j,2) = -data(8);
mag(j,3) = -data(10);

% %Ve Gyro
% subplot(3,1,1)
% plot(gyro(:,1),'r');
% hold on;
% plot(gyro(:,2),'y');
% hold on;
% plot(gyro(:,3),'g');
% hold off;
% 
% %Ve Acc
% subplot(3,1,2)
plot(acc(:,1),'r');
hold on;
plot(acc(:,2),'y');
hold on;
plot(acc(:,3),'g');
hold off;

% % Ve Mag
% subplot(3,1,3)
% plot(mag(:,1),'r');
% hold on;
% plot(mag(:,2),'y');
% hold on;
% plot(mag(:,3),'g');

%Ve goc quay
% if (toc > 0.02)
%     if (j == 1)
%         gyroX(j,1) = gyro(j,1)*toc;
%         gyroY(j,1) = gyro(j,2)*toc;
%         gyroZ(j,1) = gyro(j,3)*toc;
%     else
%         gyroX(j,1) = gyroX(j-1,1) + gyro(j,1)*toc;
%         gyroY(j,1) = gyroY(j-1,1) + gyro(j,2)*toc;
%         gyroZ(j,1) = gyroZ(j-1,1) + gyro(j,3)*toc; 
%     end
% end
% subplot(2, 1, 1)
% plot(gyroX(:,1),'r');
% hold on
% plot(gyroY(:,1),'y');
% hold on
% plot(gyroZ(:,1),'g');
% hold off

%Ve vi tri
% if (toc > 0.002)
% if (j == 1)
%     x0(j) = 1/2*acc(j,1)*toc*toc;
%     y0(j) = 1/2*acc(j,2)*toc*toc;
%     z0(j) = 1/2*acc(j,3)*toc*toc;
%     vx0(j) = acc(j,1)*toc;
%     vy0(j) = acc(j,2)*toc;
%     vz0(j) = acc(j,3)*toc;
% else
%     x0(j) = x0(j-1) + vx0(j-1)*toc + 1/2*acc(j,1)*toc*toc;
%     y0(j) = y0(j-1) + vx0(j-1)*toc + 1/2*acc(j,2)*toc*toc;
%     z0(j) = z0(j-1) + vz0(j-1)*toc + 1/2*acc(j,3)*toc*toc;
%     vx0(j,1) = vx0(j-1) + acc(j,1)*toc;
%     vy0(j,1) = vy0(j-1) + acc(j,2)*toc;
%     vz0(j,1) = vz0(j-1) + acc(j,3)*toc;
% end
% end
% 
% plot3(x0(:),y0(:),z0(:))
% hold on
% if (j>1)
%     anglex(j) = anglex(j-1) + gyro(j,3)*toc;
% end

% roll(j) = atan(mag(j,2)/mag(j,1))*180/pi;
% plot(roll(:),'r');
% hold on
% yaw(j) = atan(mag(j,2)/mag(j,3))*180/pi;
% plot(yaw(:),'b');
% hold on


tic
j = j + 1;
pause(0.001);
end

fclose(s);
