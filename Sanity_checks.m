% can be applied for multiple subject files.
% main purpose of this script is to perform Sanity checks about the Data
% the two Sanity checks are:
% (1) the connection between the matrix image size (16,36,64) and the
% average eye distance traveled in the vertical and horizontal axes
% (2) the connection between the matrix image size and the average Reaction
% Time (RT) in milliseconds.

% fixing all the origin (0,0) to the center of the screen
f1 = 'obsi'; v1 = {ETRepochs.obsi}';
f2 = 'cond'; v2 = {ETRepochs.cond}'; 
f3 = 'H'; v3 = {ETRepochs.H}';
f4 = 'V'; v4 = {ETRepochs.V}';
f5 = 'ch'; v5 = {ETRepochs.ch}';
f6 = 'cv'; v6 = {ETRepochs.cv}';
f7 = 'deltaH'; v7 = v3; % delta H
for i = 1:length(v3)
    vec = ETRepochs(i).H - ETRepochs(i).ch;
    v7{i} = vec;
end
f8 = 'deltaV'; v8 = v6; % delta V
for i = 1:length(v6)
    vec = ETRepochs(i).cv - ETRepochs(i).V;
    v8{i} = vec;
end

% new fixed origin to (0,0)
S1 = struct(f1, v1, f2, v2, f3, v3, f4, v4, f5, v5, f6, v6, f7, v7, f8, v8);

% find the Max and Min values of his delta to understand the distances
f9 = 'distH'; v9 = v7; % 
for i = 1:length(v9)
    curr_maxH = max(v7{i}); % maximum H value in current delta vector
    curr_minH = min(v7{i}); % minimum H value in current delta vector
    v9{i} = curr_maxH - curr_minH;
end
f10 = 'distV'; v10 = v8; 
for i = 1:length(v10)
    curr_maxV = max(v8{i}); % maximum V value in current delta vector
    curr_minV = min(v8{i}); % minimum V value in current delta vector
    v10{i} = curr_maxV - curr_minV;
end

% each trial consist: obsi, cond, distH, distV
for i = 1:length(v2)
    v2{i} = str2num(v2{i});
end
S2 = struct(f1, v1, f2, v2, f9, v9, f10, v10);

% find the average distH & average distV in every condition (16, 36, 64)

num_of_obs = length(unique(cell2mat(v1))); % how many obs indexes
avg_dist = zeros(num_of_obs, 6); % initilize empty matrix
cond = [16,36,64];
for oi = 1:num_of_obs 
    temp_by_obsi = S2([S2.obsi]== oi);
    for i = 1:3
        avg_dist(oi, i) = mean([temp_by_obsi([temp_by_obsi.cond] == cond(i)).distH]);
        avg_dist(oi, i + 3) = mean([temp_by_obsi([temp_by_obsi.cond] == cond(i)).distV]);
    end
end

% find average (mean) eye distances traveled of each size (16, 36, 64)
a16H = avg_dist(:,1); a16V = avg_dist(:,4); 
a36H = avg_dist(:,2); a36V = avg_dist(:,5);
a64H = avg_dist(:,3); a64V = avg_dist(:,6);

dist_avgs = [mean(a16H) mean(a16V); mean(a36H) mean(a36V); mean(a64H) mean(a64V)];
error = [std(a16H) std(a16V); std(a36H) std(a36V); std(a64H) std(a64V)];

figure(1)
b = bar(dist_avgs);

hold on

[ngroups,nbars] = size(dist_avgs);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',dist_avgs, error,'k','linestyle','none');

xticklabels({'16', '36', '64'});
ylabel('average eye movement distance');
xlabel('Image sizes');
legend({'Horizontal eye movement', 'Vertical eye movement'}, 'Location', 'northwest');

hold off

% compare time with face Present and face Absent

f11 = 'obsi'; v11 = {trials.obsi}';
f12 = 'RT'; v12 = {trials.RT}'; % reaction time for each trial
f13 = 'cond'; v13 = {trials.cmnt}'; % 16, 32, 64
f14 = 'fname'; v14 = {trials.fname}'; % face Present / face Absent
f15 = 'facePre'; 

S3 = struct(f11, v11, f12, v12, f13, v13, f14, v14, f15, v14);

for i = 1:length(S3)
    S3(i).cond = str2num(S3(i).cond);
    if contains(S3(i).fname,'facePre')
        S3(i).facePre = 1; % face is present in this image
    else
        S3(i).facePre = 0;
    end  
end


avg_RT = zeros(num_of_obs, 6); % initilize empty matrix
cond = [16,36,64];
for oi = 1:num_of_obs 
    temp_by_obsi_S3 = S3([S3.obsi]== oi);
    for i = 1:3
        yes_face = temp_by_obsi_S3([temp_by_obsi_S3.facePre]==1);
        avg_RT(oi, i) = mean([yes_face([yes_face.cond] == cond(i)).RT]);
        no_face = temp_by_obsi_S3([temp_by_obsi_S3.facePre]==0);
        avg_RT(oi, i + 3) = mean([no_face([no_face.cond] == cond(i)).RT]);
    end
end


a16_YES = avg_RT(:,1); a16_NO = avg_RT(:,4); 
a36_YES = avg_RT(:,2); a36_NO = avg_RT(:,5);
a64_YES = avg_RT(:,3); a64_NO = avg_RT(:,6);

RT_avgs = [mean(a16_YES) mean(a16_NO); mean(a36_YES) mean(a36_NO); mean(a64_YES) mean(a64_NO)];
error = [std(a16_YES) std(a16_NO); std(a36_YES) std(a36_NO); std(a64_YES) std(a64_NO)];

figure(2)
b2 = bar(RT_avgs);

hold on

[ngroups,nbars] = size(RT_avgs);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b2(i).XEndPoints;
end
errorbar(x',RT_avgs, error,'k','linestyle','none');

xticklabels({'16', '36', '64'});
ylabel('average Reaction Time (RT) in milliseconds');
xlabel('Image sizes');
legend({'face Present', 'face Absent'}, 'Location', 'northwest');

hold off



