%% parameters for an optimization
%sc = cell(1,3);
%sc{1} = SpaceConstraint(0.0, 1.0, 0.01);  % red space
%sc{2} = SpaceConstraint(0.0, 1.0, 0.01);  % green space 
%sc{3} = SpaceConstraint(0.0, 1.0, 0.01);  % blue space
sc = cell(1,1);
sc{1} = SpaceConstraint(0.0, 1.0, 0.01);  % gray space
params = OptimizationParams(sc, 0.25);
% our objective is to minimize entropy difference
params.objective = Objective.Maximize;
%params.iterations = 10;
%params.swarmSize = 2;

%% get an image that we want to optimize
im_w = 32;
im_h = im_w;
channels = 1;
image = 0.5 + 0.3 .* randn(im_w, im_h, channels);
image(image>1.0) = 1.0;
image(image<0.0) = 0.0;
imshow(image);

image = im2double(imread(fullfile(pwd, 'input', 'dog.png')));
imshow(image);

%% fitness delegate - i.e. the class that actually does all the job
% fd = FitnessDelegate(image, fullfile(pwd, 'results'));

%% optimizer
% pso = ParticleSwarmOptimizer(params, fd, image);
% [newimage,fitness] = pso.Optimize();
% imshow(newimage);
% disp(fitness);

%% second optimizer
params.objective = Objective.Minimize;
params.iterations = 400;
params.swarmSize = 100;
fd = JDiffFitnessDelegate(image, fullfile(pwd, 'results'));
pso = ParticleSwarmOptimizer(params, fd, image);
[finalimage, finalfitness] = pso.Optimize();
imshow(finalimage);
disp(finalfitness);
