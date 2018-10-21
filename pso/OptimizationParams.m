classdef OptimizationParams
    %OPTIMIZATIONPARAMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        iterations = 60;
        swarmSize = 20;
        objective = Objective.Maximize;
        maxExecutionTime = 0;
        maxVelocity
        spaceConstraints
    end
    
    methods
        function obj = OptimizationParams(spaceConstraints, maxVelocityRatio)
            if nargin < 2
                maxVelocityRatio = 0.25;
            else
                assert(maxVelocityRatio >= 0.0 & maxVelocityRatio <= 1.0, "maxVelocityRatio is a value between 0 and 1")
            end
            
            obj.spaceConstraints = spaceConstraints;
            obj.maxVelocity = zeros(1, length(obj.spaceConstraints));
            for i=1:length(obj.spaceConstraints)
                constraint = obj.spaceConstraints{i};
                obj.maxVelocity(i) = maxVelocityRatio * constraint.range;
            end
        end
    end
    
end

