close all;
hold on;
axis equal;
colormap(winter)
data = load('data.txt')

scatter(data(:,1) , data(:,2) , [] , data(:,3))
ylim([40,120])
xlim([160,200])
plot([177],[80],'r*')
% our new datapoint
newdata = [177,80];
% we use the computer to compute all possible distances (euclidean)
% by the formular:
% d_i = sqrt((x(i,1)-177)^2 + (x(i,2) - 80)^2)
% And then we choose the smallest/the 3 smallest/ the 5 smallest

[Sorted,InverseIndex] = sort(pdist2(newdata , data(:,1:2)))

k1 = data(InverseIndex(1) , 1:2);
%first estimate: XL
estimate1 = data(InverseIndex(1),3)

k3 = data(InverseIndex(1:3) , 1:3);
%second estimate: XL
estimate2 = mode(data(InverseIndex(1:3),3))

k5 = data(InverseIndex(1:5) , 1:3);
% third estimate: XL
estimate3 = mode(data(InverseIndex(1:5),3))

% -> we pick size XL
plot(k1(1),k1(2),'*g')