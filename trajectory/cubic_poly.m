% Cubic Polynomial Trajectory
% position: x(t) = a0 + a1*t + a2*t^2 + a3*t^3;
% velocity: v(t) = a1 + 2*a2*t + 3*a3*t^2;
% acceleration: a(t) = 2*a2 + 6*a3*t;

% Finds the values of x, v, and a at any user defined
% time t_value which satisfies t_start <= t_value <= t_end
% The user may define the starting and end positions, and the
% starting and end velocities - otherwise it is set to default values
% This function plots x, v, and a as a function of time, and labels
% key data points. 

function cubic_poly()
    clear; clc; clf;
    syms a0 a1 a2 a3

    % call ui function to get parameters
    params = getParams();
    
    % set parameter values
    t_start = params(1); t_end = params(2); t_value = params(3);
    pos_start = params(4); pos_end = params(5);
    vel_start = params(6); vel_end = params(7);

    % time array (default = 100 time points between t_start and t_end)
    t_arr = linspace(t_start, t_end);
    x_arr = zeros(1, length(t_arr));
    v_arr = zeros(1, length(t_arr));
    a_arr = zeros(1, length(t_arr));

    % cubic polynomial trajectory equations and solutions for x, v, a
    eqn1 = a0 + a1*t_start + a2*t_start^2 + a3*t_start^3 == pos_start;
    eqn2 = a0 + a1*t_end + a2*t_end^2 + a3*t_end^3 == pos_end;
    eqn3 = a1 + 2*a2*t_start + 3*a3*t_start^2 == vel_start;
    eqn4 = a1 + 2*a2*t_end + 3*a3*t_end^2 == vel_end;

    sol = solve([eqn1 eqn2 eqn3 eqn4],[a0,a1,a2,a3]);
    a0Sol = sol.a0;
    a1Sol = sol.a1;
    a2Sol = sol.a2;
    a3Sol = sol.a3;

    position = [a0Sol a1Sol a2Sol a3Sol];
    velocity = [a1Sol 2*a2Sol 3*a3Sol];
    acceleration = [2*a2Sol 6*a3Sol];

    % formula for x, v, a
    x_value = position(1) + position(2)*t_value + position(3)*t_value^2 + position(4)*t_value^3;
    v_value = velocity(1) + velocity(2)*t_value + velocity(3)*t_value^2;
    a_value = acceleration(1) + acceleration(2)*t_value;

    for i = 1:length(t_arr)
        x_arr(i) = position(1) + position(2)*t_arr(i) + position(3)*t_arr(i)^2 + position(4)*t_arr(i)^3;
        v_arr(i) = velocity(1) + velocity(2)*t_arr(i) + velocity(3)*t_arr(i)^2;
        a_arr(i) = acceleration(1) + acceleration(2)*t_arr(i);
    end

    % min and max values of v and a, and their positions
    [v_max, v_max_idx] = max(v_arr); [v_min, v_min_idx] = min(v_arr);
    [a_max, a_max_idx] = max(a_arr); [a_min, a_min_idx] = min(a_arr);

    % arrays for displaying data points
    vt = [v_min v_max v_value]; vt_t = [t_arr(v_min_idx) t_arr(v_max_idx) t_value];
    vt_str = {'\leftarrow v_{min}', '\leftarrow v_{max}', '\leftarrow v_{value}'};
    at = [a_min a_max a_value]; at_t = [t_arr(a_min_idx) t_arr(a_max_idx) t_value];
    at_str = {'\leftarrow a_{min}', '\leftarrow a_{max}', '\leftarrow a_{value}'};

    % print statements
    fprintf("Max velocity: %f\nMax acceleration: %f\n\n", v_max, a_max);
    fprintf("At time %d seconds:\nPosition: %f\nVelocity: %f\nAcceleration: %f\n\n", ...
        t_value,x_value, v_value, a_value);
    
    fprintf("Plotting data...\nPosition and velocity values on the left y-axis\nAcceleration values on the right y-axis\n");
    
    % show
    figure(1)
    yyaxis left
    plot(t_arr, x_arr, t_arr, v_arr)
    hold on
    text(t_value, x_value, '\leftarrow x_{value}')
    text(vt_t, vt, vt_str)
    yyaxis right
    plot(t_arr, a_arr)
    grid on
    title('Position, velocity and acceleration against time')
    xlabel('Time (seconds)')
    text(at_t, at, at_str)
    xline(t_value, '--r')
    legend('p(t)', 'v(t)', 'a(t)', 't_v_a_l_u_e', 'Location', 'east')
end

% ui function
function outputs = getParams()
    prompt = {'Start time (s)', 'End time (s)', 'Time value of interest (s)', ... 
        'Start position (m)', 'End position (m)', 'Start velocity (m/s)', ... 
        'End velocity (m/s)'}; % prompts for parameters
    dims = [1 50];
    definput = {'0', '60', '20', '0', '100', '0', '0'}; % default values
    dlgtitle = 'Parameters';
    dlg = inputdlg(prompt, dlgtitle, dims, definput); % open input prompt
    
    % output array
    outputs = zeros(1, length(prompt));
    % [t_start, t_end, t_value, pos_start, pos_end, vel_start, vel_end]
    
    % extract inputs
    for i = 1:length(prompt)
        val = str2double(dlg(i)); % convert input value to double 
        def = str2double(definput(i)); % convert default value to double
        if isnan(val) % catch - NaN input
            fprintf("Non numeric input (%d) detected --- setting to default = %d\n", ...
                i, def);
            outputs(i) = def; % set to default value
        else
            outputs(i) = val; % set to input value
        end
    end

end