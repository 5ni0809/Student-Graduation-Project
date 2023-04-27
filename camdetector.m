function I = camdetector(myNet)
cam = webcam;

while true 
picture = cam.snapshot; 
data = load('FCWDemoMonoCameraSensor.mat', 'sensor');
sensor = data.sensor;
stop = audioread('D:\University\Äµ³øÁn1.wav');
vehicleWidth = [1.5, 3.5]
detector = vehicleDetectorACF();
detector = configureDetectorMonoCamera(detector, sensor, vehicleWidth);
[bboxes, ~] = detect(detector, picture);

midPtsImg = [bboxes(:,1)+bboxes(:,3)/2  bboxes(:,2)+bboxes(:,4)./2];
midPtsWorld = imageToVehicle(sensor, midPtsImg);
x = midPtsWorld(:,1);
y = midPtsWorld(:,2);
distance  =  ((sqrt(x.^2 + y.^2))/30);
distanceStr = cellstr([num2str(distance) repmat(' m',[length(distance) 1])]);
if (distance)<2
   Iout = insertObjectAnnotation(picture, 'rectangle', bboxes, distanceStr,'Color','r');
   sound(stop, 44100);
else
   Iout = insertObjectAnnotation(picture, 'rectangle', bboxes, distanceStr);
end
picture = imresize (picture,[227,227]); 
label = classify(myNet, picture);
image(Iout)
title(char(label), 'fontsize', 24); 

end 
end