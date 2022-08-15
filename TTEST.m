% can be applied for multiple subject L files.
% main purpose of this script is to perform TTEST 
% for the first_sacade.m script
% note: this test will be performed only after running first_saccade.m
% a table of counters for each case (up or down and 16 or 36 or 64)
% TTEST for each matrix size (16,36,64) will be calculated as following
% t(df -> Degrees of freedom of the test) = tstat -> Value of the test statistic

Ttable = zeros(length(observers),6);

for curr_obsi = 1:length(observers) % check for each observer / trial
    for i = 1:length(S4) % we move on S4 only for the current 
        x = S4(i).first_sac(1); y = S4(i).first_sac(2); % [x,y]
        if S4(i).obsi == curr_obsi % check only the lines == curr_obsi
            if S4(i).cond == 16
                if y >= 0 % add 1 "first saccade" to 16up
                    Ttable(curr_obsi, 1) = Ttable(curr_obsi, 1) + 1;
                else % add 1 "first saccade" to 16down
                    Ttable(curr_obsi, 2) = Ttable(curr_obsi, 2) + 1;
                end
            end
            if S4(i).cond == 36
                if y >= 0 % add 1 "first saccade" to 36up
                    Ttable(curr_obsi, 3) = Ttable(curr_obsi, 3) + 1;
                else % add 1 "first saccade" to 36down
                    Ttable(curr_obsi, 4) = Ttable(curr_obsi, 4) + 1;
                end
            end
            if S4(i).cond == 64
                if y >= 0 % add 1 "first saccade" to 64up
                    Ttable(curr_obsi, 5) = Ttable(curr_obsi, 5) + 1;
                else % add 1 "first saccade" to 64down
                    Ttable(curr_obsi, 6) = Ttable(curr_obsi, 6) + 1;
                end
            end
             
        end
    end
end

% 
up16 = Ttable(:,1); down16 = Ttable(:,2);
up36 = Ttable(:,3); down36 = Ttable(:,4);
up64 = Ttable(:,5); down64 = Ttable(:,6);

% print the TTEST results: t(df)=tstat, p
[h_16, p_16, ci_16, stats_16] = ttest(up16,down16) % ttest for 16
[h_36, p_36, ci_36, stats_36] = ttest(up36,down36) % ttest for 36
[h_64, p_64, ci_64, stats_64] = ttest(up64,down64) % ttest for 64


   