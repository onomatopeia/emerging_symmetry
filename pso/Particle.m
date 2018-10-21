classdef Particle
    %PARTICLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        velocityScale = 0.01;
        inertiaWeight = 0.3;
        socialScale = 2.0;
        cognitiveScale = 2.0;
    end
    
    properties
        currentPosition
        currentFitness
        personalBestPosition
        personalBestFitness
        velocities
        dimensions
        maxVelocity
        spaceConstraints
        fitnessDelegate
        upper
        lower
    end
    
    methods
        function obj = Particle(spaceConstraints, fitnessDelegate, maxVelocity, initialPosition)
            obj.fitnessDelegate = fitnessDelegate;  % this guy calculates stuff
            obj.maxVelocity = maxVelocity;  % max velocity in each colour channel
            obj.dimensions = length(spaceConstraints);  % number of colour channels
            obj.currentPosition = initialPosition;  % this is a starting image we are working with
            obj.velocities = zeros(1, obj.dimensions);  % velocities for each colour channel
            obj.upper = zeros(1, obj.dimensions);  % upper bounds for each colour channel
            obj.lower = zeros(1, obj.dimensions);  % lower bounds for each colour channel
            for i=1:obj.dimensions  % for each colour channel
                constraint = spaceConstraints{i};  % read what the space constraints are
                obj.upper(i) = constraint.maximalValue;  % save the upper bound for the channel
                obj.lower(i) = constraint.minimalValue;  % save the lower bound for the channel
            end
            obj.velocities = Particle.velocityScale .* rand(1, obj.dimensions); %for each dimension set velocity
            
            obj.UpdatePositions();  % this adds some modifications to the initial image we submitted to this constructor, as it would be boring if all particles had the same image in the first iteration.
           
            % current best equals current position for this initial iteration
            obj.personalBestPosition = obj.currentPosition;
            obj.personalBestFitness = obj.currentFitness;
            
        end

        function obj = UpdatePositions(obj)
            % for each colour channel generate a random matrix with values within
            obj.currentPosition = obj.ClipPosition(obj.currentPosition + obj.velocities);
            obj.currentFitness = obj.fitnessDelegate.EvaluateFitness(obj.currentPosition);
        end
        
        function position = ClipPosition(obj, position)
            position = min(position, obj.upper);
            position = max(position, obj.lower);
        end
        
        function velocity = ClipVelocity(obj, velocity)
            velocity(velocity > obj.maxVelocity) = obj.maxVelocity;
            velocity(velocity < -obj.maxVelocity) = -obj.maxVelocity;
        end

        function obj = UpdateVelocities(obj, globalBestPosition)
            rand1 = rand(1, obj.dimensions);
            rand2 = rand(1, obj.dimensions);
            % cognitive = c1 * rand() * (pbest[] - present[])
            cognitive = Particle.cognitiveScale .* rand1 .* (obj.personalBestPosition - obj.currentPosition);
            % social = c2 * rand() * (gbest[] - present[])
            social = Particle.socialScale .* rand2 .* (globalBestPosition - obj.currentPosition);
            % (b) v[] = v[] + social + cognitive
            %obj.velocities = obj.ClipVelocity(Particle.inertiaWeight .* obj.velocities + social + cognitive);
            obj.velocities = Particle.inertiaWeight .* obj.velocities + social + cognitive;
        end
    end
end

