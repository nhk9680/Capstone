function action1 = evaluatePolicy(observation1)
%#codegen

% Reinforcement Learning Toolbox
% Generated on: 22-May-2020 08:41:41

actionSet = [1;2;3;4];
numActions = numel(actionSet);
q = zeros(1,numActions);
for i = 1:numActions
	q(i) = localEvaluate(observation1,actionSet(i));
end
[~,actionIndex] = max(q);
action1 = actionSet(actionIndex);
end
%% Local Functions
function q = localEvaluate(observation1,action)
persistent policy
if isempty(policy)
	s = coder.load('agentData.mat','policy');
	policy = s.policy;
end
actionSet = [1;2;3;4];
observationSet = [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25];
actionIndex = rl.codegen.getElementIndex(actionSet,action);
observationIndex = rl.codegen.getElementIndex(observationSet,observation1);
q = policy(observationIndex,actionIndex);
end