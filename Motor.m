%% TP 1 Automatisme
%% Systeme Moteur CC
% Etat du system
A = [-260.87 -24.4565;409.091 -0.272727];
B = [54.35; 0];

C = [0 1];

% Polynome desire
p = [1 1];

% since D won't change it can remain being D
D = [0];

% Calling the function i made to calculate everything
System_state(A,B,C,D,p);