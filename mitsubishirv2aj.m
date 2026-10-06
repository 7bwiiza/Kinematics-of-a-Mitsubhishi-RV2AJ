% Load Robotics System Toolbox
clc; clear;

% Convert degrees to radians for joint angles
theta_deg = [0, 45, -90, 45, 0];
theta = deg2rad(theta_deg);

% DH Parameters: [theta d a alpha] for each joint
% Note: theta values here are variable; rest are constants from your table
DH_params = [
    theta(1),  0,   0.05,   -90;   % Joint 1
    theta(2),  0.3, 0.3,    0;   % Joint 2
    theta(3),  0.25, 0.25,    0;   % Joint 3
    theta(4),  0,     0,  -90;   % Joint 4
    theta(5),  0,     0,    0];  % Joint 5

% Create links using standard DH
L(1) = robotics.RigidBodyTree;
robot = robotics.RigidBodyTree('DataFormat','column','MaxNumBodies',5);

for i = 1:5
    % Create a rigid body
    body = robotics.RigidBody(['body' num2str(i)]);
    
    % Define the joint with DH parameters
    joint = robotics.Joint(['joint' num2str(i)], 'revolute');
    setFixedTransform(joint, DH_params(i,:), 'dh');
    body.Joint = joint;

    % Add a visual shape (e.g., a cylinder for the link)
    % Adjust the dimensions for each link if needed
    linkLength = 0.2; % uniform dummy length for visibility
    [~, d, a, ~] = deal(DH_params(i, 1), DH_params(i, 2), DH_params(i, 3), DH_params(i, 4));
    if a > 0
        addVisual(body, "Cylinder", [0.01, a]); % [radius, length]
    elseif d > 0
        addVisual(body, "Cylinder", [0.01, d]); % vertical link
    else
        addVisual(body, "Sphere", 0.02); % tiny joint
    end

    % Attach the body
    if i == 1
        addBody(robot, body, robot.BaseName);
    else
        addBody(robot, body, ['body' num2str(i-1)]);
    end
end


% Show the robot pose
figure;
show(robot, theta', 'Frames','on', 'PreservePlot', false);
title('5-DOF Robot Arm Pose with visuals');
view(135, 25);
axis equal;
pause(0.1);  % Give MATLAB time to render the figure
