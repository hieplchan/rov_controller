clear all
clf

s = serial('COM3');
fopen(s);
j = 1;

accX(j) = 0;
accY(j) = 0;
accZ(j) = 0;

accnoise = 0.003;
meanoise = 0.001;
R = meanoise^2;

x = zeros(6,1);
xhat = x;
c = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];
P = zeros(6,6);


tic
while (j <= 200)
    
%Lay du lieu tu STM32
fprintf(s,'G');
data = fscanf(s,'%s %f %f %f %f %f %f %f %f %f',101);
accX(j) = data(5)+0.1772;
accY(j) = data(6)+0.1772;
accZ(j) = data(7)+0.1772;

%Kalman
a = [1 0 0 toc 0 0; 0 1 0 0 toc 0; 0 0 1 0 0 toc; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];
b = [toc^2/2 0 0; 0 toc^2/2 0; 0 0 toc^2/2; toc 0 0; 0 toc 0; 0 0 toc];
Q = [toc^4/4 0 0 toc^3/2 0 0; 0 toc^4/4 0 0 toc^3/2 0; 0 0 toc^4/4 0 0 toc^3/2; toc^3/2 0 0 toc^2 0 0; 0 toc^3/2 0 0 toc^2 0; 0 0 toc^3/2 0 0 toc^2];
if (j > 1)
    x(:,j) = a*x(:,j-1) + b*[accX(j);accY(j);accZ(j)] + accnoise*randn*[toc^2/2; toc^2/2; toc^2/2; toc; toc; toc]; %Mo ta he thong
    z = c*x(:,j) + meanoise*randn; %Gia tri do moi  
    xhat(:,j) = a*xhat(:,j-1) + b*[accX(j);accY(j);accZ(j)];
    P = a*P*a' + Q; %Tinh phuong sai du doan moi
    y = z - c*xhat(:,j); %Do lech giua quan sat va du doan
    KG = a*P*c'/(a*P*c' + R); %He so Kalman
    xhat(:,j) = xhat(:,j) + KG*y; %Cap nhat gia tri moi
    P = a*P*a' - KG*a*P*c' + accnoise^2*Q; %Cap nhat phuong sai moi
end

subplot(3,1,1)
plot(accX(:),'g');
hold on
plot(x(1,:),'r');
hold on
plot(xhat(1,:),'b');
hold on

subplot(3,1,2)
plot(accY(:),'g');
hold on
plot(x(2,:),'r');
hold on
plot(xhat(2,:),'b');
hold on

subplot(3,1,3)
plot(accZ(:),'g');
hold on
plot(x(3,:),'r');
hold on
plot(xhat(3,:),'b');
hold on

tic
j = j + 1;
pause(0.001);
end
fclose(s);
