%plot speaker Data in a polar plot

arr198 = 'B5:G10';
normal = 'B14:G19';
soundlazer = 'B23:G28';
data_normal = xlsread('speakerData_jul9.xlsx', normal);
data_arr198 = xlsread('speakerData_jul9.xlsx', arr198);

deg30 = pi/6; deg60 = pi/3;
theta = [0 0 deg30 deg30 deg60 deg60];

%get average of low and high
mean_data_normal = mean(data_normal);
me_normal = zeros(1, 3);
j = 1;
for i = 1:2:5
    me_normal(j) = mean([mean_data_normal(i); mean_data_normal(i+1)]);
    j = j+1;
end
me_normal = me_normal/max(me_normal);

mean_data_arr198 = mean(data_arr198);
me_arr198 = zeros(1, 3);
j = 1;
for i = 1:2:5
    me_arr198(j) = mean([mean_data_arr198(i); mean_data_arr198(i+1)]);
    j = j+1;
end
me_arr198 = me_arr198/max(me_arr198);

fig  = figure;
subplot(1, 2, 1);
rho_normal = [me_normal(1) 0  me_normal(2) 0 me_normal(3) 0];
polar(theta, rho_normal, 'b');
view(-270, -90);
title('Regular Speakers', 'FontSize', 15);

subplot(1, 2, 2);
rho_arr198 = [me_arr198(1) 0  me_arr198(2) 0 me_arr198(3) 0];
polar(theta, rho_arr198, 'r');
view(-270, -90);
title('Ultrasonic Speakers', 'FontSize', 15);
text(10, 10, 'Rel. Signal Strength by Angle', 'FontSize', 20);

