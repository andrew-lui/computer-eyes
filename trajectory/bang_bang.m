% Bang Bang Trajectory (Minimum time)

% total distance
total_distance = 1000;
% velocity - start, end
vel_start = 50;
vel_end = 0;
% max - velocity, acceleration
max_vel = 100;
max_accel = 50;

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
total_time = timeToMax + timeAtMax + timeFromMax