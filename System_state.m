% H : Transfer function
% phase : Phase margin
% mag : gain
%% FUNCTION FOR SYSTEM STATE DETAILED

function [H, phase, mag] = System_state(A,B,C,D,p_mat)
    % MATRIX ANALYSIS
    % Check if the system is controllable and observable
    Co = ctrb(A,B);
    Ob = obsv(A,C);
    % Check the rank of the matrices
    if det(Co) == 0
        disp('Not controllable.');
    else
        fprintf('The matrix is controllable with determinant: %d and rank: %d \n',det(Co),rank(Co));
    end
    % Observability
    if det(Ob) == 0
        disp('The matrix is not observable.');
    else
        fprintf('The matrix is observable with determinant: %d and rank: %d \n',det(Ob),rank(Ob));
    end
    % Compute dimensions of matrices
    [n, m] = size(A);
    fprintf('The matrix A is of dimension: %d X %d \n',n,m);
    [p, r] = size(B);
    fprintf('The matrix B is of dimension: %d X %d \n',p,r);
    [u, v] = size(C);
    fprintf('The matrix C is of dimension: %d X %d \n',u,v);

    %% STEADY STATE REPRESENTATION
    % Display different Diagonalized
    disp('Diagonalized State Space Representation:');

    % Convert state-space representation to transfer function
    sys_ss = ss(A,B,C,D);
    
    disp('Modal State Space Representation:');
    % compute the modal canonical form of 
    [csys_m,T] = canon(sys_ss, "modal")
    
    % Compute observable canonical form using 'companion' option
    disp('Observable Canonical Form:');
    csys_c = canon(sys_ss,"companion")
    
    %% EIGEN VALUES
    % Compute eigenvalues
    eigenvalues = eig(A);
    % Display results
    disp('Eigenvalues:');
    disp(eigenvalues);
    
     %% TRANSFER FUNCTION
    % Convert state-space representation to transfer function
    [num, den] = ss2tf(A, B, C, D);

    % Display transfer function
    disp('Transfer Function (from State-Space):');
    H = tf(num, den)
    
    % Compute transfer function with equation
    syms s;
    Tf = simplify(C * inv(s * eye(n) - A) * B + D) % being the n from A

    %% Roots
    poles = pole(sys_ss);
    disp('Poles');
    disp(poles);

    %% GAIN AND PHASE MARGINS
    % Compute gain and phase using Bode plot
    [mag, phase, wout] = bode(ss(A, B, C, D));
    mag_db = 20*log10(squeeze(mag));
    cutoff_freq = interp1(mag_db, wout, 0);
    
    % Calculate the Margins
    phase_deg = squeeze(phase);
    phase_margin = 180 + min(phase_deg); % Marge de phase
    gain_margin = 1 / min(mag); % Marge de gain
    
    % Prints
    fprintf('Marge de Phase : %.2f degrés\n', phase_margin);
    fprintf('Marge de Gain : %.2f\n', gain_margin);
    fprintf('Cutoff frequency at 0 dB: %.2f\n', cutoff_freq);
    
    % Calculate DC gain
    dc_gain = dcgain(ss(A, B, C, D));
    disp('DC Gain:');
    disp(dc_gain);

    %% Define the input signal (for example, a step input)
    t = 0:0.01:5;  % Time vector
    u = ones(size(t));  % Step input
    
    % Simulate the system response
    [y, t, x] = lsim(sys_ss, u, t);
    
    % Plot the system response
    plot(t, y);
    title('System Response to Step Input');
    xlabel('Time');
    ylabel('Output');
    grid on;

    %% BODE DIAGRAM
    % Plot Bode plot
    figure;
    bode(sys_ss);
    grid on;
    title('Bode Diagram');

    %% Analyze the open-loop stability and the system performance
    % using the pzmap and step functions
    % Time-domain analysis using the step function
    fprintf('\n Performing time-domain analysis using the step function');
    figure;
    step(sys_ss);
    set(gcf, 'Color', 'w'); % Set the figure background color to white
    title('Step Response', 'FontSize', 14, 'FontWeight', 'bold'); % Increase font size and make the title bold
    xlabel('Time (s)', 'FontSize', 12); % Add units to the x-axis label and increase font size
    ylabel('Response', 'FontSize', 12); % Increase font size for y-axis label
    grid on; % Add grid lines to the plot
    
    % Frequency-domain analysis using the pzmap function
    fprintf('\n Performing frequency-domain analysis using the pzmap function \n');
    figure;
    pzmap(sys_ss);
    set(gcf, 'Color', 'w'); % Set the figure background color to white
    title('Open-Loop Poles and Zeros', 'FontSize', 14, 'FontWeight', 'bold'); % Increase font size and make the title bold
    xlabel('Real Axis', 'FontSize', 12); % Increase font size for x-axis label
    ylabel('Imaginary Axis', 'FontSize', 12); % Increase font size for y-axis label
    grid on; % Add grid lines to the plot


    %% DESIRED POLYNIMIAL
    % Calcul de la matrice de gain K
    K = place(A,B,p_mat);
    disp('Using PLace we have K = ');
    disp(K);

end