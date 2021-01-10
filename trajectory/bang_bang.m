% Bang Bang Trajectory (Minimum time)

function bang_bang()
    clear; clc; clf;

    % call ui function
    params = getParams();
    
    % set parameter values
    total_distance = params(1);
    vel_start = params(2); vel_end = params(3);
    max_vel = params(4); max_accel = params(5);

    % time taken from start vel to max vel at max accel
    timeToMax = (max_vel-vel_start)/max_accel;
    % distance travelled at max accel, from start vel to max vel
    distToMax = vel_start*timeToMax + 1/2*(max_accel)*timeToMax^2;

    % time taken from max velocity to end vel at max accel (decel)
    timeFromMax = (vel_end-max_vel)/(-max_accel);
    % distance travelled at max accel (decel), from max vel to end vel
    distFromMax = max_vel*timeFromMax + 1/2*(-max_accel)*timeFromMax^2;

    % distance possible at max velocity
    distAtMax = total_distance - distToMax - distFromMax;
    % check if the distance possible at max velocity < 0
    if distAtMax >= 0 
        % time taken to travel distance possible at max velocity
        timeAtMax = distAtMax/max_vel;
        fprintf("Reaches max velocity... time travelled at max velocity: %f seconds\n", timeAtMax);
    else 
        % does not reach max velocity
        timeAtMax = 0;
        v_p = [1 -2*vel_end (total_distance*max_accel+0.5*(vel_start^2+vel_end^2))];
        r = roots(v_p);
        vel_peak = abs(r(1));
        timeToMax = (vel_peak-vel_start)/max_accel;
        timeFromMax = (vel_end-vel_peak)/(-max_accel);
        fprintf("Does not reach max velocity\n");
    end

    % total time 
    total_time = timeToMax + timeAtMax + timeFromMax;
    fprintf("Total time taken: %f\n\n", total_time);
    
    % time, position, velocity, acceleration arrays
    t_arr = linspace(0,total_time);
    x_arr = zeros(1, length(t_arr));
    v_arr = zeros(1, length(t_arr));
    a_arr = zeros(1, length(t_arr));
    
    % iterate through time array 
    for i = 1:length(t_arr)
        % flag for max velocity - default false
        v_flag = 0;
        
        if t_arr(i) <= timeToMax
            a_arr(i) = max_accel;
        elseif t_arr(i) <= (timeToMax+timeAtMax)
            a_arr(i) = 0;
            v_flag = 1;
        else
            a_arr(i) = -max_accel;
        end
        
        % find prev_vel and dt
        if i == 1
            prev_vel = vel_start;
            prev_pos = 0;
            dt = t_arr(i);
        else
            prev_vel = v_arr(i-1);
            prev_pos = x_arr(i-1);
            dt = t_arr(i) - t_arr(i-1);
        end
        
        % if not at v_max, update velocity
        if v_flag == 0
            v_arr(i) = velocity(prev_vel, max_vel, a_arr(i), dt);
        else
            v_arr(i) = max_vel;
        end
        
        % update position
        x_arr(i) = position(prev_pos, v_arr(i), dt);
    end
    
    % max values of v and its position
    [v_max, v_max_idx] = max(v_arr);

    % array for displaying data points
    vt = v_max; vt_t = t_arr(v_max_idx);
    vt_str = {'\leftarrow v_{max}'};

    % print statements
    fprintf("Max velocity: %f\n\n", v_max);
    if v_max == max_vel
        fprintf("Max velocity was reached after %fs\n\n", t_arr(v_max_idx));
    else
        fprintf("Max velocity was not reached\n\n");
    end
    
    fprintf("Generating plot...\nPosition values on the left y-axis\nVelocity and acceleration values on the right y-axis\n");
    
    % show
    figure(1)
    yyaxis left
    plot(t_arr, x_arr)
    hold on
    yyaxis right
    plot(t_arr, v_arr, t_arr, a_arr)
    grid on
    title('Position, velocity and acceleration against time')
    xlabel('Time (seconds)')
    text(vt_t, vt, vt_str)
    legend('x(t)', 'v(t)', 'a(t)', 'Location', 'northwest')
end

% ui function
function outputs = getParams()
    prompt = {'Total distance (m)', 'Start velocity (m/s)', 'End velocity (m/s)', ... 
        'Max velocity (m/s)', 'Max acceleration (m/s^2)'}; % prompts for parameters
    dims = [1 50];
    definput = {'1000', '0', '0', '40', '8'}; % default values
    dlgtitle = 'Parameters';
    dlg = inputdlg(prompt, dlgtitle, dims, definput); % open input prompt
    
    % output array
    outputs = zeros(1, length(prompt));
    % [total_distance, vel_start, vel_end, max_vel, max_accel]
    
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

    % if end_vel > max_vel, then set end_vel to default
    if outputs(3) > outputs(4)
        def = str2double(definput(3));
        fprintf("End velocity greater than max velocity --- setting to default = %d\n", ...
            def);
        outputs(3) = def;
    end

end

% function to calculate next velocity value
function v_next = velocity(prev_vel, max_vel, accel, dt)
    % formula for velocity
    v_next = prev_vel + accel * dt;
    if v_next > max_vel 
        v_next = max_vel;
    end
end

% function to calculate next position value
function x_next = position(prev_pos, vel, dt)
    % formula for position
    x_next = prev_pos + vel * dt;
end