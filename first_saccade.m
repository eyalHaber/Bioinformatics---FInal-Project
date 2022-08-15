% can be applied for multiple subject files.
% main purpose of this script is to define the first Sacade location in
% each trial. the output will be scatter plots of all Matrix sizes with
% face Present and face absent respectively

et_process([0 2] ,[1 15 550])

% create a struct for the saccades
f1 = 'obsi'; v1 = {ETRepochs.obsi}';
f2 = 'cond'; v2 = {ETRepochs.cond}'; 
f3 = 'facePre'; v3 = {trials.fname}';
f4 = 'sac'; v4 = {ETRepochs.sac}';
f5 = 'first_sac'; v5 = v4;

S4 = struct(f1, v1, f2, v2, f3, v3, f4, v4, f5, v5);
A = zeros(length(S4),2);

for i = 1:length(S4)
    S4(i).cond = str2num(S4(i).cond);
    if contains(S4(i).facePre,'facePre')
        S4(i).facePre = 1; % face is present in this image
    else
        S4(i).facePre = 0;
    end
    % extract first saccade
    if isempty(S4(i).sac) == 0 % saccades were measured
        rho = abs(S4(i).sac(1).disp); % == S4(i).sac(1).dist
        theta = rad2deg(angle(S4(i).sac(1).disp));
        [x,y] = pol2cart(theta,rho);
        S4(i).first_sac = [x,y];
        A(i,1) = x; A(i,2) = y;
    else
        S4(i).first_sac = [0,0];
    end
end
origin = [0 0];

% avg_sac = [mean(A(:,1)), mean(A(:,2))];
% %hold on; grid on;
% scatter(A(:,1),A(:,2));
% l = line([origin(1) avg_sac(1)], [origin(2) avg_sac(2)]);
% %plot(avg_sac(1), origin(2));
% set(l, 'Color', 'r')
% set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
% set(groot,'defaultLineLineWidth',2.0)

% define counters
counter_16p = 0; counter_16a = 0;
counter_36p = 0; counter_36a = 0;
counter_64p = 0; counter_64a = 0;
for i = 1:length(S4)
    if S4(i).cond == 16
        if S4(i).facePre == 1 % face is present in this image
            counter_16p = counter_16p + 1;
        else 
            counter_16a = counter_16a + 1;      
        end
    end
    if S4(i).cond == 36
        if S4(i).facePre == 1 % face is present in this image
            counter_36p = counter_36p + 1;
        else 
            counter_36a = counter_36a + 1;      
        end   
    end
    if S4(i).cond == 64
        if S4(i).facePre == 1 % face is present in this image
            counter_64p = counter_64p + 1;
        else 
            counter_64a = counter_64a + 1;      
        end  
    end
end

% initilize matrixes
mat16p = zeros(counter_16p,2); mat16a = zeros(counter_16a,2);
mat36p = zeros(counter_36p,2); mat36a = zeros(counter_36a,2);
mat64p = zeros(counter_64p,2); mat64a = zeros(counter_64a,2);

% fill matrixes
loc16p = counter_16p; loc16a = counter_16a;
loc36p = counter_36p; loc36a = counter_36a;
loc64p = counter_64p; loc64a = counter_64a;

for i = 1:length(S4)
    x = S4(i).first_sac(1); y = S4(i).first_sac(2);
    if S4(i).cond == 16
        if S4(i).facePre == 1 % face is present in this image
            mat16p(loc16p,1) = x; mat16p(loc16p,2) = y;
            loc16p = loc16p - 1;
        else 
            mat16a(loc16a,1) = x; mat16a(loc16a,2) = y;
            loc16a = loc16a - 1;      
        end
    end
    if S4(i).cond == 36
        if S4(i).facePre == 1 % face is present in this image
            mat36p(loc36p,1) = x; mat36p(loc36p,2) = y;
            loc36p = loc36p - 1;
        else 
            mat36a(loc36a,1) = x; mat36a(loc36a,2) = y;
            loc36a = loc36a - 1;      
        end
    end
    if S4(i).cond == 64
        if S4(i).facePre == 1 % face is present in this image
            mat64p(loc64p,1) = x; mat64p(loc64p,2) = y;
            loc64p = loc64p - 1;
        else 
            mat64a(loc64a,1) = x; mat64a(loc64a,2) = y;
            loc64a = loc64a - 1;      
        end
    end
end



% divide tp subplots:

% size 16
subplot(2,3,1);
scatter(mat16p(:,1),mat16p(:,2), 'b');
xlim([-15 15]); ylim([-15 15]);
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
title('16 - face present');

subplot(2,3,4);
scatter(mat16a(:,1),mat16a(:,2), 'r');
xlim([-15 15]); ylim([-15 15]);
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
title('16 - face absent');

% % check vector
% count16 = 0;
% sum16x = 0; sum16y = 0;
% for i = 1:length(mat16a)
%     if abs(mat16a(i,1)) > 1 && abs(mat16a(i,2)) > 1
%         count16 = count16 + 1;
%         sum16x = sum16x + mat16a(i,1); sum16y = sum16y + mat16a(i,2);
%     end 
% end
% avg16a = [sum16x/count16 sum16y/count16];
% l = line([origin(1) avg16a(1)], [origin(2) avg16a(2)]);
% set(l, 'Color', 'g')

% size 36
subplot(2,3,2);
scatter(mat36p(:,1),mat36p(:,2), 'b');
xlim([-15 15]); ylim([-15 15]);
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
title('36 - face present');

subplot(2,3,5);
scatter(mat36a(:,1),mat36a(:,2), 'r');
xlim([-15 15]); ylim([-15 15]);
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
title('36 - face absent');

% size 64
subplot(2,3,3);
scatter(mat64p(:,1),mat64p(:,2), 'b');
xlim([-15 15]); ylim([-15 15]);
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
title('64 - face present');

subplot(2,3,6);
scatter(mat64a(:,1),mat64a(:,2), 'r');
xlim([-15 15]); ylim([-15 15]);
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
title('64 - face absent');

% check
% 
% count16 = 0;
% sum16x = 0; sum16y = 0;
% for i = 1:length(mat16a)
%     if abs(mat16a(i,1)) > 0.5 && abs(mat16a(i,2)) > 0.5
%         count16 = count16 + 1;
%         sum16x = sum16x + mat16a(i,1); sum16y = sum16y + mat16a(i,2);
%     end 
% end
% % avg16a = [sum16x/count16 sum16y/count16];
% % l = line([origin(1) avg16a(1)], [origin(2) avg16a(2)]);
% % set(l, 'Color', 'r')

% count saccades in each part of the matrix:

% mat16p
f11 = 'mat16p_UPright'; v11 = length(find(mat16p(:,2)>0));
f12 = 'mat16p_negetive_Y'; v12 = length(find(mat16p(:,2)<0)); 
f13 = 'mat16p_positive_X'; v13 = length(find(mat16p(:,1)>0));
f14 = 'mat16p_negetive_X'; v14 = length(find(mat16p(:,1)<0));
S16p = struct(f11, v11, f12, v12, f13, v13, f14, v14);

% mat16a
f21 = 'mat16a_positive_Y'; v21 = length(find(mat16a(:,2)>0));
f22 = 'mat16a_negetive_Y'; v22 = length(find(mat16a(:,2)<0)); 
f23 = 'mat16a_positive_X'; v23 = length(find(mat16a(:,1)>0));
f24 = 'mat16a_negetive_X'; v24 = length(find(mat16a(:,1)<0));
S16a = struct(f21, v21, f22, v22, f23, v23, f24, v24);

% mat36p
f31 = 'mat36p_positive_Y'; v31 = length(find(mat36p(:,2)>0));
f32 = 'mat36p_negetive_Y'; v32 = length(find(mat36p(:,2)<0)); 
f33 = 'mat36p_positive_X'; v33 = length(find(mat36p(:,1)>0));
f34 = 'mat36p_negetive_X'; v34 = length(find(mat36p(:,1)<0));
S36p = struct(f31, v31, f32, v32, f33, v33, f34, v34);

% mat36a
f41 = 'mat36a_positive_Y'; v41 = length(find(mat36a(:,2)>0));
f42 = 'mat36a_negetive_Y'; v42 = length(find(mat36a(:,2)<0)); 
f43 = 'mat36a_positive_X'; v43 = length(find(mat36a(:,1)>0));
f44 = 'mat36a_negetive_X'; v44 = length(find(mat36a(:,1)<0));
S36a = struct(f41, v41, f42, v42, f43, v43, f44, v44);

% mat64p
f51 = 'mat64p_positive_Y'; v51 = length(find(mat64p(:,2)>0));
f52 = 'mat64p_negetive_Y'; v52 = length(find(mat64p(:,2)<0)); 
f53 = 'mat64p_positive_X'; v53 = length(find(mat64p(:,1)>0));
f54 = 'mat64p_negetive_X'; v54 = length(find(mat64p(:,1)<0));
S64p = struct(f51, v51, f52, v52, f53, v53, f54, v54);

% mat64a
f61 = 'mat64a_positive_Y'; v61 = length(find(mat64a(:,2)>0));
f62 = 'mat64a_negetive_Y'; v62 = length(find(mat64a(:,2)<0)); 
f63 = 'mat64a_positive_X'; v63 = length(find(mat64a(:,1)>0));
f64 = 'mat64a_negetive_X'; v64 = length(find(mat64a(:,1)<0));
S64a = struct(f61, v61, f62, v62, f63, v63, f64, v64);




