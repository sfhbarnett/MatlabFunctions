% Find the average radial profile of an image from a center location specified by the user.
% Using accumarray would be a faster method though.
format long g;
format compact;
fontSize = 20;
averageRadialProfile = [];
for i = 1:size(meanim,3)

grayImage = meanim(:,:,i);
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.

% Display the original image.
subplot(2, 2, 1);
imshow(grayImage, []);
axis on;
[rows, columns, numberOfColorChannels] = size(grayImage);


[x,y] = ginput(1);
% x = round(centre(i,1)/8);
% y = round(centre(i,2)/8);

% Find out what the max distance will be by computing the distance to each corner.
distanceToUL = sqrt((1-y)^2 + (1-x)^2);
distanceToUR = sqrt((1-y)^2 + (columns-x)^2);
distanceToLL = sqrt((rows-y)^2 + (1-x)^2);
distanceToLR= sqrt((rows-y)^2 + (columns-x)^2);
maxDistance = ceil(max([distanceToUL, distanceToUR, distanceToLL, distanceToLR]));

% Make another display and put a cross at the center and concentric circles around it.
% Display the original image.
subplot(2, 2, 2);
imshow(grayImage, []);
axis on;
title('With circles along radius gridlines from plot below', 'FontSize', fontSize);
hold on;
line([x, x], [1, rows], 'Color', 'r', 'LineWidth', 2);
line([1, columns], [y, y], 'Color', 'r', 'LineWidth', 2);

% Let's compute and display the histogram.  Just for fun - it's not necessary though.
[pixelCount, grayLevels] = imhist(grayImage);
subplot(2, 2, 3); 
bar(grayLevels, pixelCount);
grid on;
title('Histogram of Original Image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
drawnow; % Force it to paint the screen.

% Allocate an array for the profile
profileSums = zeros(1, maxDistance);
profileCounts = zeros(1, maxDistance);
% Scan the original image getting gray level, and scan edtImage getting distance.
% Then add those values to the profile.
for column = 1 : columns
	for row = 1 : rows
		thisDistance = round(sqrt((row-y)^2 + (column-x)^2));
		if thisDistance <= 0
			continue;
		end
		profileSums(thisDistance) = profileSums(thisDistance) + double(grayImage(row, column));
		profileCounts(thisDistance) = profileCounts(thisDistance) + 1;
	end
end
% Divide the sums by the counts at each distance to get the average profile
if size(profileSums,2) < size(averageRadialProfile,1)
    padding = zeros(size(averageRadialProfile,1),1);
    padding(1:size(profileSums,2)) = profileSums ./ profileCounts;
    averageRadialProfile(:,i) = padding;
else
    averageRadialProfile(:,i) = profileSums ./ profileCounts;
end
% Plot it.
subplot(2, 2, 4); 
plot(1:length(averageRadialProfile), averageRadialProfile, 'b-', 'LineWidth', 3);
grid on;
title('Average Radial Profile', 'FontSize', fontSize);
xlabel('Distance from center', 'FontSize', fontSize);
ylabel('Average Gray Level', 'FontSize', fontSize);

% We want to have the circles over the image be at the same distances as the grid lines along the x axis.
% Get the tick marks along the x axis
ax = gca;
xTickNumbers = ax.XTick;
xTickNumbers(xTickNumbers == 0) = [];  % Zero is probably in there, so get rid of it.
radii = xTickNumbers;
centers = repmat([x, y], length(radii), 1);
subplot(2, 2, 2);  % Switch to upper right image.
hold on;
viscircles(centers,radii); % Plot the circles over the image.

end