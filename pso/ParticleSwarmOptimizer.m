classdef ParticleSwarmOptimizer
    %PARTICLESWARMOPTIMIZER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        formatSpecTemplate = 'i=%s, J=%s, phi=(%s)\n';
        iterationTemplate = '%d';
        fitnessTemplate = '%4.4f';
        positionTemplate = '%4.4f';
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
        formatSpec = ParticleSwarmOptimizer.positionTemplate;
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
                obj.swarm{i} = Particle(obj.spaceConstraints, fitnessDelegate, obj.maxVelocity);
                obj.swarm{i} =
            end
            for i=1:length(obj.spaceConstraints)-1
                obj.formatSpec = strcat(obj.formatSpec, ', ', ParticleSwarmOptimizer.positionTemplate);
            end
            obj.formatSpec = sprintf(ParticleSwarmOptimizer.formatSpecTemplate, ParticleSwarmOptimizer.iterationTemplate, ParticleSwarmOptimizer.fitnessTemplate, obj.formatSpec);
            disp(obj.formatSpec);
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
                    end
                    obj.swarm{j} = currentParticle;
                end
                fprintf(obj.formatSpec, iteration, obj.globalBestFitness, obj.globalBestPosition);
                obj.fitnessDelegate.SavePartialResult(obj.globalBestPosition, iteration);
            end
            
            bestPosition = obj.globalBestPosition;
            bestFitness = obj.globalBestFitness;
            
        end
    end
    
end

