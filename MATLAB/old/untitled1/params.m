%% 변수 설정
M=0;
m=1;
l=0.05;
g=9.8;
b=0;
%% 관성모멘트계산
i=10/3*m*l^2;
%% 식계산
q1=(M+m)*(i+m*l^2)-(m^2*l^2); % degree position(1) %
q2=(M+m)*(i+m*l^2)+(m^2*l^2); % degree position(2) %
%% 전달함수 생성
num1 = [m*l/q1 0];
num2 = [m*l/q2 0];

den1 = [1 b*(i+m*l^2)/q1 -(M+m)*m*g*l/q1 -b*m*g*l/q1]; 
den2 = [1 b*(i+m*l^2)/q2 +(M+m)*m*g*l/q2 +b*m*g*l/q2];

tf(num1,den1)
tf(num2,den2)
