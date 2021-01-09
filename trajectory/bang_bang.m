% Bang Bang Trajectory (Minimum time)

function bang_bang()
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
    else 
        % does not reach max velocity
        timeAtMax = 0;
        % this one only for any start vel, end vel = 0
        % vel_peak = sqrt((total_distance*max_accel+0.5*vel_start^2));
        v_p = [1 -2*vel_end (total_distance*max_accel+0.5*(vel_start^2+vel_end^2))];
        r = roots(v_p);
        vel_peak = abs(r(1));
        timeToMax = (vel_peak-vel_start)/max_accel;
        timeFromMax = (vel_end-vel_peak)/(-max_accel);
    end

    % total time 
    total_time = timeToMax + timeAtMax + timeFromMax;
    
    fprintf("Total time taken: %f\n\n", total_time);

end

% ui function
function outputs = getParams()
    prompt = {'Total distance (m)', 'Start velocity (m/s)', 'End velocity (m/s)', ... 
        'Max velocity (m/s)', 'Max acceleration (m/s^2)'}; % prompts for parameters
    dims = [1 50];
    definput = {'1000', '0', '80', '80', '8'}; % default values
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