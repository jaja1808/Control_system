%% TP 1 Automatisme
%% Systeme Mecanique
% Etat du system
A = [0 1;-2/3 -8/3];
B = [0; 1/3];

C = [1 0];

% Polynome desire
p = [1 1];

% since D won't change it can remain being D
D = [0];

% Calling the function i made to calculate everything
System_state(A,B,C,D,p);