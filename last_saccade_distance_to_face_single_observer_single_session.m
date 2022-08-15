% can be applied for single subject file.
% main purpose of this script is to check the distance between the the face
% and last sacade before noticing the face in each trial (with face only) 
% for single observer (in a single session). the output of this script will
% be two figures: figure 1 will be a general scatter of matrix size in 
% relation to the last sacade to face distances. 
% figure 2 will be a bar plot of the average disatnces measured in figure 1

et_process([0 2] ,[1 15 550])

% load the face location table size 64:
face_location_table_64 = readtable('face_location_table_64.csv');
face_location_table_64.Properties.VariableNames = {'location', 'x', 'y'}; 
% load the face location table size 36:
face_location_table_36 = readtable('face_location_table_36.csv');
face_location_table_36.Properties.VariableNames = {'location', 'x', 'y'}; 
% load the face location table size 16:
face_location_table_16 = readtable('face_location_table_16.csv');
face_location_table_16.Properties.VariableNames = {'location', 'x', 'y'}; 


% fix to ETR.H and ETR.V to center of the screen (0,0):

f1 = 'obs_name'; v1 = {ETR.obs}';
f2 = 'fname'; v2 = {ETR.fname}';

f3 = 'fixed_H'; v3 = {ETR.H}'; % delta H
for i = 1:length(v3)
    vec = ETR(i).H - ETR(i).ch;
    v3{i} = vec;
end
f4 = 'fixed_V'; v4 = {ETR.V}'; % delta V
for i = 1:length(v4)
    vec = ETR(i).cv - ETR(i).V;
    v4{i} = vec;
end
f5 = 'MS'; v5 = {ETR.MS}';

f6 = 'MS_new'; v6 = v5;

ETR_new = struct(f1, v1, f2, v2, f3, v3, f4, v4, f5, v5, f6, v6);

countMS = 0; % count how many dist >= 1 there are:
for i = 1:length(ETR.MS) % all rows
    if ETR.MS(i).dist >= 1
        countMS = countMS + 1;
    end
end

% create the MS_new field struct:
for i = 1:length(ETR_new.MS)-countMS % all rows
    ETR_new.MS_new(i) = [];
end
% create the MS_new field struct:
j = 1;
for i = 1:length(ETR_new.MS)  % all rows
    if ETR_new.MS(i).dist >= 1
        ETR_new.MS_new(j) = ETR_new.MS(i);
        j = j + 1;
    end
end

% new trials struct:
f_1 = 'time'; v_1 = {trials.time}';
f_2 = 'RT'; v_2 = {trials.RT}';
f_3 = 'total_time'; v_3 = {trials.RT}';
f_4 = 'fname'; v_4 = {trials.fname}'; 
f_5 = 'cmnt'; v_5 = {trials.cmnt}'; 
f_6 = 'obsi'; v_6 = {trials.obsi}'; 
trials_new = struct(f_1, v_1, f_2, v_2, f_3, v_3, f_4, v_4, f_5, v_5, f_6, v_6);


% create new struct of trials when face present:
counter = 0; % count the number of trials where face is present in order to build the new struct
for i = 1:length(trials_new) % all rows
     if contains(trials_new(i).fname,'facePre')
         counter = counter + 1;
     end
end 
% create the struct using the counter as the number of rows
trials_facePre = struct('obsi',cell(counter,1),'total_time',cell(counter,1),...
    'sample_number', cell(counter,1), 'matrix_size', cell(counter,1),...
    'fname',cell(counter,1), 'face_x', cell(counter,1), 'face_y', cell(counter,1),...
    'lastSac_x',cell(counter,1), 'lastSac_y',cell(counter,1), 'dist',cell(counter,1));
     

index = 1;
for i = 1:length(trials_new) % all rows
    if contains(trials_new(i).fname,'facePre')
        trials_facePre(index).obsi = trials_new(i).obsi;
        trials_facePre(index).total_time = 1000*trials_new(i).time + trials_new(i).RT;
        trials_facePre(index).sample_number = floor(trials_facePre(index).total_time / 2);
        trials_facePre(index).matrix_size = str2num(trials_new(i).cmnt);
        trials_facePre(index).fname = trials_new(i).fname; % face location on face table
        index = index + 1;
    end
end

for i = 1:length(trials_facePre) % all rows
    trials_facePre(i).fname = extractAfter(trials_facePre(i).fname,"loc");
    trials_facePre(i).fname = extractBefore(trials_facePre(i).fname,"_");
    trials_facePre(i).fname = str2num(trials_facePre(i).fname);
    % add face coordinate:
    if  trials_facePre(i).matrix_size == 16
        trials_facePre(i).face_x = face_location_table_16.x(trials_facePre(i).fname);
        trials_facePre(i).face_y = face_location_table_16.y(trials_facePre(i).fname);
    
    elseif trials_facePre(i).matrix_size == 36
        trials_facePre(i).face_x = face_location_table_36.x(trials_facePre(i).fname);
        trials_facePre(i).face_y = face_location_table_36.y(trials_facePre(i).fname);
    
    elseif trials_facePre(i).matrix_size == 64
        trials_facePre(i).face_x = face_location_table_64.x(trials_facePre(i).fname);
        trials_facePre(i).face_y = face_location_table_64.y(trials_facePre(i).fname); 
    end
end


% find lastSac coordinates:

for i = 1:length(trials_facePre)
    current_sample_stamp = trials_facePre(i).sample_number;
    % find the first:last range in ETR_new.MS_new:
    for j = 1:length(ETR_new.MS_new)
        if ETR_new.MS_new(j).first > current_sample_stamp
           curr_end_first =  ETR_new.MS_new(j).first; % CHECK IF THIS INDEX IS TRUE!!!
           curr_start_last = ETR_new.MS_new(j-1).last;
           % find avg fixed_H:
           sum = curr_end_first - curr_start_last;
           curr_avg_x = nanmean(ETR_new.fixed_H(curr_end_first:curr_end_first));
           curr_avg_y = nanmean(ETR_new.fixed_V(curr_end_first:curr_end_first));
           % insert the calculated average values to trials_facePre
           trials_facePre(i).lastSac_x = curr_avg_x;
           trials_facePre(i).lastSac_y = curr_avg_y;
           % calculate the distance (dist) between the (lastSac_x, lastSac_y) to (face_x, face_y):
           curr_face_x = trials_facePre(i).face_x;
           curr_face_y = trials_facePre(i).face_y;
           curr_lastSace_x = trials_facePre(i).lastSac_x;
           curr_lastSace_y = trials_facePre(i).lastSac_y;
           % calaculate the distance and assign to the current index
           trials_facePre(i).dist = norm([curr_face_x curr_face_y]-[curr_lastSace_x curr_lastSace_y]);
           break
        end  
    end
end

% display the data on 2 figures:
h1 = figure;
h2 = figure;

% first figure we display it in a general scatter:
figure(h1)
scatter([trials_facePre.matrix_size], [trials_facePre.dist], 'filled')
title('general scatter');
xlabel('matrix size');
ylabel('all distances between last sacade and face');

% second figure will be a bar plot compariosn between the matrix sizes:
figure(h2)
% we'll distinguish between 16,36,64 distances:
% let's build specific distance array for each matrix size
dist_16 = []; dist_36 = []; dist_64 = [];
indx16 = 1; indx36 = 1; indx64 = 1;
for i = 1:length(trials_facePre)
    if trials_facePre(i).matrix_size == 16
        dist_16(indx16) = trials_facePre(i).dist;
        indx16 = indx16 + 1;
    end
    if trials_facePre(i).matrix_size == 36
        dist_36(indx36) = trials_facePre(i).dist;
        indx36 = indx36 + 1;
    end
    if trials_facePre(i).matrix_size == 64
        dist_64(indx64) = trials_facePre(i).dist;
        indx64 = indx64 + 1;
    end
end

x = [16 36 64];
y = [mean(dist_16) mean(dist_36) mean(dist_64)];
error = [std(dist_16) std(dist_36) std(dist_64)];


clr = [223 145 167; 178 198 65; 134 156 211] / 255; % define colors
b = bar(x, y, 'facecolor', 'flat');
b.CData = clr;
hold on
er = errorbar(x, y,error);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

title('average distance in realtion to matrix (image) size');
xlabel('matrix size');
ylabel('average distance between last sacade and face');




