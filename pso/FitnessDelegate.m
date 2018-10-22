classdef FitnessDelegate
    %FITNESSDELEGATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        image 
        resultsFolder
        imageSize
    end
    
    methods
        function obj = FitnessDelegate(image, resultsFolder)
            obj.image = cropToSquare(image);
            obj.imageSize = size(obj.image);
            obj.resultsFolder = resultsFolder;
        end
        
        function fitness = EvaluateFitness(~, position)
            fitness = negentropy(position);
        end
                
        function obj = SavePartialResult(obj, image, iteration)
            imshow(image);
            print(fullfile(obj.resultsFolder, strcat('structure_', sprintf('%02d',iteration), '.png')), '-dpng','-r300');
        end
    end
    
end

