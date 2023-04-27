% Copyright 2017 The MathWorks, Inc.

%% Load a pre-trained, deep, convolutional network
alex = alexnet;
layers = alex.Layers
analyzeNetwork(alex)
%% Modify the network to use five categories
layers(23) = fullyConnectedLayer(6);
layers(25) = classificationLayer

%% Set up our training data
allImages = imageDatastore('D:\Matlab2018a\examples\nnet\FileExchangeEntry\Transphoto', 'IncludeSubfolders', true, 'LabelSource', 'foldernames','ReadFcn',@IMAGERESIZE);
T = countEachLabel(allImages);
disp(T);
[trainingImages, testImages] = splitEachLabel(allImages,0.8, 'randomize');

%% Re-train the Network
opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 5,'MiniBatchSize', 50);
myNet = trainNetwork(trainingImages, layers, opts);

%% Measure network accuracy
predictedLabels = classify(myNet, testImages); 
accuracy = mean(predictedLabels == testImages.Labels)

function output = IMAGERESIZE(input)
input = imread(input);
if numel(size(input)) == 2
    input = cat(3,input,input,input);
end
output = imresize(input,[227,227]);
end