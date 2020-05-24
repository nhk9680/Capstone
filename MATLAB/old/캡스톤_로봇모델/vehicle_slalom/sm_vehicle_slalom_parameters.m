%% Vehicle Slalom Parameters Initialization

% Copyright 2016 The MathWorks, Inc.

%% Material Properties %%

color = simmechanics.demohelpers.colors;

%% Tall Cone %%

tallCone.height                = 1;   % m
tallCone.baseThickness         = 0.1; % m
tallCone.baseDiameter          = 0.6; % m
tallCone.coneBaseDiameter      = 0.4; % m
tallCone.coneTopDiameter       = 0.1; % m
tallCone.reflectiveStripHeight = 0.5; % m
tallCone.coneColor             = color.orange;
tallCone.reflectiveStripColor  = color.lgrey;

%% Short Cone %%

shortCone.height                = 0.5;  % m
shortCone.baseThickness         = 0.05; % m
shortCone.baseDiameter          = 0.3;  % m
shortCone.coneBaseDiameter      = 0.2;  % m
shortCone.coneTopDiameter       = 0.05; % m
shortCone.reflectiveStripHeight = 0.25; % m
shortCone.coneColor             = tallCone.coneColor;
shortCone.reflectiveStripColor  = tallCone.reflectiveStripColor;

%% Road %%

road.markings.segmentLength = 3;     % m
road.markings.segmentWidth  = 0.15;  % m
road.markings.segmentDepth  = 0.005; % m
road.markings.spacing       = 9;     % m
road.markings.numMarkings   = 24;
road.markings.color = color.white;

road.length = road.markings.segmentLength + ...
  (road.markings.numMarkings - 1) * (road.markings.segmentLength + road.markings.spacing);
road.width  = 7.2; % m
road.depth  = 0.1; % m
road.dim    = [road.length road.width road.depth];
road.color  = color.grey;

road.markings.extrusion = roadMarkingsExtrusion(road);

%% Grass Verge %%

verge.length = road.length;
verge.width  = 5;                 % m
verge.depth  = road.depth - 0.05; % m
verge.dim    = [verge.length verge.width verge.depth];
verge.color  = [0.8 1.0 0.8];

%% Start Line %%

startline.length = 1; % m
startline.width  = road.width;
startline.depth  = road.markings.segmentDepth;
startline.dim    = [startline.length startline.width startline.depth];
startline.offset = 5; % m
startline.color  = color.green;

%% Finish Line %%

finishline.length = startline.length;
finishline.width  = road.width;
finishline.depth  = road.markings.segmentDepth;
finishline.dim    = [finishline.length finishline.width finishline.depth];
finishline.offset = road.length - 20; % m
finishline.color  = color.red;
finishline.cones.numCones = 7;
finishline.cones.offset   = road.length - 0.5 * tallCone.baseDiameter;
finishline.cones.spacing  = (finishline.width - tallCone.baseDiameter) / ...
                              (finishline.cones.numCones - 1);
                            
%% Slalom Cones %%

slalom.gate.cone_offset  = road.width / 4;
slalom.startgate_offset = 57; % m
slalom.coneSpacing      = 30; % m
slalom.numCones         = 5;
slalom.firstConeFromStartgate = 26; % m
slalom.finishgateFromEndCone  = 36; % m
slalom.firstCone_offset = slalom.startgate_offset + slalom.firstConeFromStartgate;
slalom.endCone_offset   = slalom.firstCone_offset + ...
                            (slalom.numCones - 1) * slalom.coneSpacing;
slalom.finishgate_offset = slalom.endCone_offset + slalom.finishgateFromEndCone;

%% Vehicle %%

vehicle.wheelAssmRadius   = 0.355;  % m
vehicle.width             = 1.97;   % m
vehicle.frontAxle_offsetX = 1.51;   % m
vehicle.rearAxle_offsetX  = -1.49;  % m
vehicle.wheel_offsetY     = 0.81;   % m
vehicle.axle_offsetZ      = -0.26;  % m
vehicle.ground_offsetZ    = -0.603; % m
vehicle.body_offset = [ 2.75  0.5 * vehicle.width -0.85]; % m
vehicle.LR_offset = [vehicle.rearAxle_offsetX   vehicle.wheel_offsetY vehicle.axle_offsetZ];
vehicle.RR_offset = [vehicle.rearAxle_offsetX  -vehicle.wheel_offsetY vehicle.axle_offsetZ];
vehicle.LF_offset = [vehicle.frontAxle_offsetX  vehicle.wheel_offsetY vehicle.axle_offsetZ];
vehicle.RF_offset = [vehicle.frontAxle_offsetX -vehicle.wheel_offsetY vehicle.axle_offsetZ];
vehicle.bodyColor = color.blue;

vehicle.posX_0 = startline.offset - vehicle.LF_offset(1);
vehicle.velX   = vehicleXVelocity(vehicle.posX_0,...
                                  finishline.offset,...
                                  finishline.cones.offset - vehicle.body_offset(1));
vehicle.posY.A = vehicle.width - 0.5; % m

%% Cameras %%

cameras.frontView_offset   = [-2  0  8]; % m
cameras.sideView_offset    = [-2 -7 -5]; % m
cameras.driversView_offset = [ 0  0  1]; % m

%% Signals

filter.t_c = 0.01; % s

%% Vehicle X-Velocity Helper Function %%

function velX = vehicleXVelocity(start, brake, stop)

t0 = 0;     % s
p0 = start; % m

t1 = 2;  % s
p1 = p0; % m

vMax = 15; % m/s
t2 = 7;    % s
p2 = 0.5 * vMax * (t2 - t1) + p1;

p3 = brake; % m
t3 = t2 + (p3 - p2) / vMax;

p4 = stop; % m
t4 = t3 + 2 * (p4 - p3) / vMax;

t5 = t4 + 2; % s

velX.time = [t0 t1 t2 t3 t4 t5]';
velX.signals.values = [0 0 vMax vMax 0 0]';

end

%% Road Markings Extrusion Helper Function %%

function extrusion = roadMarkingsExtrusion(road)

extrusion = [0 0; road.length 0; road.length road.depth + road.markings.segmentDepth];

nextMarking_y1 = road.depth + road.markings.segmentDepth;
nextMarking_y2 = 0.5 * road.depth;
nextMarking_y3 = nextMarking_y2;
nextMarking_y4 = nextMarking_y1;

for i = 1:road.markings.numMarkings-1
  nextMarking_x1 = extrusion(end, 1) - road.markings.segmentLength;
  nextMarking_x2 = nextMarking_x1;
  nextMarking_x3 = extrusion(end, 1) - road.markings.segmentLength - road.markings.spacing;
  nextMarking_x4 = nextMarking_x3;
  nextMarking = [nextMarking_x1, nextMarking_y1; 
                 nextMarking_x2, nextMarking_y2;
                 nextMarking_x3, nextMarking_y3; 
                 nextMarking_x4, nextMarking_y4];
  extrusion = [extrusion; nextMarking]; %#ok<AGROW>
end

extrusion(end + 1, 1) = 0;
extrusion(end, 2) = road.depth + road.markings.segmentDepth;

end

