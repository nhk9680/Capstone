env = rlPredefinedEnv('BasicGridWorld')
%%
env.ResetFcn = @() 2
%%
rng(0)
%%
qTable = rlTable(getObservationInfo(env),getActionInfo(env))
%%
qRepresentation = rlQValueRepresentation(...
    qTable, getObservationInfo(env),getActionInfo(env))
%%
qRepresentation.Options.LearnRate = 1
%%
agentOpts = rlQAgentOptions
agentOpts.EpsilonGreedyExploration.Epsilon = .04
qAgent = rlQAgent(qRepresentation, agentOpts)
%%
trainOpts = rlTrainingOptions
trainOpts.MaxEpisodes = 50;
trainOpts.MaxStepsPerEpisode = 50;
trainOpts.ScoreAveragingWindowLength = 30;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 11;
%%
doTraining = true;

if doTraining
    trainingStats = train(qAgent, env, trainOpts)
else
    load('basicGWQAgent.mat', 'qAgent')
end
%%
plot(env)
env.Model.Viewer.ShowTrace = true;
env.Model.Viewer.clearTrace;
%%
sim(qAgent,env)