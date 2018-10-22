classdef JDiffFitnessDelegate
    %JDIFFFITNESSDELEGATE Summary of this class goes here
    
    properties
        image 
        resultsFolder
        imageSize
    end
    
    methods
        function obj = JDiffFitnessDelegate(image, resultsFolder)
            obj.image = cropToSquare(image);
            obj.imageSize = size(obj.image);
            obj.resultsFolder = resultsFolder;
        end
        
        function fitness = EvaluateFitness(obj, position)
            summedImage = obj.CalculateImage(position); 
            % fitness = abs(negentropy(position) - negentropy(summedImage));
            fitness = abs(entropy(position) - entropy(summedImage));
        end
        
        function summedImage = CalculateImage(~, I)
           J = flip(I, 2);
           summedImage = imdivide(imadd(I, J), 2);
        end
        
        function obj = SavePartialResult(obj, image, iteration)
            imwrite(image, fullfile(obj.resultsFolder, strcat('symmetry_', sprintf('%02d',iteration), '.png')));
        end
    end
    
end

