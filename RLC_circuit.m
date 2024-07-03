%% TP 1 Automatisme
%% System electrique RLC
% Etat du system
A = [-40 -0.1;10000000 0];
B = [0.1; 0];
C = [0 1];

% Polynome desire
p = [1 1];

% since D won't change it can remain being D
D = [0];

% Calling the function i made to calculate everything
System_state(A,B,C,D,p);
