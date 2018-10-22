classdef ParticleSwarmOptimizer
    %PARTICLESWARMOPTIMIZER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        formatSpecTemplate = 'i=%d, J=%4.8f, [%0.4f, %0.4f]\n';
    end
    
    properties
        swarm
        spaceConstraints
        iterations
        objective
        maxExecutionTime
        fitnessDelegate
        globalBestPosition
        globalBestFitness
        swarmSize
        maxVelocity
        optimizationParams
        formatSpec = ParticleSwarmOptimizer.formatSpecTemplate;
    end
    
    methods
        function obj = ParticleSwarmOptimizer(optimizationParams, fitnessDelegate, initialPosition)
            obj.optimizationParams = optimizationParams;
            obj.swarmSize = optimizationParams.swarmSize;
            obj.swarm = cell(1, obj.swarmSize);
            obj.spaceConstraints = optimizationParams.spaceConstraints;
            obj.iterations = optimizationParams.iterations;
            obj.objective = optimizationParams.objective;
            obj.maxExecutionTime = optimizationParams.maxExecutionTime;
            obj.fitnessDelegate = fitnessDelegate;
            obj.maxVelocity = optimizationParams.maxVelocity;
            for i=1:obj.swarmSize
                obj.swarm{i} = Particle(obj.spaceConstraints, fitnessDelegate, obj.maxVelocity, initialPosition);
            end
        end

        function better = IsBetter(obj, fitnessAfter, fitnessBefore)
            if Objective.Maximize == obj.objective
                better = fitnessAfter > fitnessBefore;
            else
                better = fitnessAfter < fitnessBefore;
            end
        end
        
        function [bestPosition, bestFitness] = Optimize(obj)
            obj.globalBestPosition = obj.swarm{1}.personalBestPosition;
            obj.globalBestFitness = obj.swarm{1}.personalBestFitness;
            for iteration=1:obj.iterations
                isBetter = false;
                % Based on global best, update each particle
                for j=1:obj.swarmSize

                    currentParticle = obj.swarm{j};

                    if iteration > 1
                        % Update position of each paricle
                        currentParticle = currentParticle.UpdateVelocities(obj.globalBestPosition);
                        currentParticle = currentParticle.UpdatePositions();
                        % Update a personal best positions
                        if (obj.IsBetter(currentParticle.currentFitness, currentParticle.personalBestFitness))
                            currentParticle.personalBestPosition = currentParticle.currentPosition;
                            currentParticle.personalBestFitness = currentParticle.currentFitness;
                        end
                    end
                    % Choose the particle with the best fitness value of all the particles as the globalBest
                    if (obj.IsBetter(currentParticle.personalBestFitness, obj.globalBestFitness))
                        obj.globalBestPosition = currentParticle.personalBestPosition;
                        obj.globalBestFitness = currentParticle.personalBestFitness;
                        isBetter = true;
                    end
                    obj.swarm{j} = currentParticle;
                end
                if isBetter
                    m1 = min(min(currentParticle.personalBestPosition));
                    m2 = max(max(currentParticle.personalBestPosition));
                    fprintf(ParticleSwarmOptimizer.formatSpecTemplate, iteration, obj.globalBestFitness, m1, m2);
                    obj.fitnessDelegate.SavePartialResult(obj.globalBestPosition, iteration);
                end
            end
            
            bestPosition = obj.globalBestPosition;
            bestFitness = obj.globalBestFitness;
            
        end
    end
    
end

