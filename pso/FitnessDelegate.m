classdef FitnessDelegate
    %FITNESSDELEGATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        image 
        resultsFolder
        imageSize
        %transformations
    end
    
    methods
        function obj = FitnessDelegate(image, resultsFolder)
            obj.image = cropToSquare(image);
            obj.imageSize = size(obj.image);
            %obj.transformations = transformations;
            obj.resultsFolder = resultsFolder;
        end
        
        function fitness = EvaluateFitness(obj, position)
            % position is an 2D image
            summedImage = obj.CalculateImage(position); 
            %fitnesses = zeros(1, size(summedImages, 3));
            %for i=1:size(summedImages, 3)
            %    fitnesses(i) = negentropy(summedImages(:,:,i));
            %end
            fitness = negentropy(summedImage);
            % since here we have single objective optimization, if we want
            % to optimize for multiple objectives we could use a product
            % if there is only one transformation then there is only one
            % element in fitnesses vector and the product of the vector is
            % equal to the element's value.
            %fitness = prod(fitnesses);
        end
        
        function summedImage = CalculateImage(~, I)
            % T1 = reshape(T, s(1), s(2), 1)
%             summedImages = zeros(size(I, 1), size(I, 2), size(obj.transformations, 3));
%             for i=1:size(obj.transformations, 3)
%                 T = obj.transformations(:,:,i);  % that transformation should be already affine2d or similar
%                 J = imwarp(I,T);
%                 summedImages(:,:,i) = imdivide(imadd(I, J), 2);
%             end
           J = flip(I, 2);
           summedImage = imdivide(imadd(I, J), 2);
        end
        
        function obj = SavePartialResult(obj, image, iteration)
            imshow(image);
            print(fullfile(obj.resultsFolder, strcat('globalBest_', num2str(iteration), '.png')), '-dpng','-r300');
        end
    end
    
end

