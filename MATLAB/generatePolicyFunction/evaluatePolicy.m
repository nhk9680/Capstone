function action1 = evaluatePolicy(observation1)
%#codegen

% Reinforcement Learning Toolbox
% Generated on: 25-May-2020 19:20:32

action1 = localEvaluate(observation1);
end
%% Local Functions
function action1 = localEvaluate(observation1)
persistent policy
if isempty(policy)
	policy = coder.loadDeepLearningNetwork('agentData.mat','policy');
end
action1 = predict(policy,observation1);
end