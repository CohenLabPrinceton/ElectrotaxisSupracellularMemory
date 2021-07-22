%% Kymo Traveling Wave Analysis
%
% Isaac Breinyn 2021
%
% For fitting the traveling waves in kymographs of speed in proliferating,
% stimulated, and control tissues.

%% Clean Workspace and Format Data

close all; clc ; clear;
cd('C:\Users\isaac\Documents\Princeton\cohen\etd') ;

px_sz = 1.308 * 16 ; % set pixel size based on PIV and resolution

% Load and rename data
load('kymos.mat') ;
fig4 = load('fig4_data.mat') ;
parsed_data = load('kymo_parsed.mat') ;

low_stim = parsed_data. ALLorderPARAMETERcenteredLOWDENSITY ;
low_ctrl = parsed_data.ALLorderPARAMETERcenteredLOW_CONTROLS ;
low_EGTA = parsed_data.ALLorderPARAMETERcenteredLOW_EGTA ;
med_stim = parsed_data.ALLorderPARAMETERcenteredMEDIUMDENSITY ;
med_ctrl = parsed_data.ALLorderPARAMETERcenteredMEDIUM_CONTROLS ;

%% Fit kymographs

all_avgs = {low_stim{1} low_EGTA{1} med_stim{1}} ;

all_avg_speeds = zeros(size(all_avgs, 2), 2, 2) ; % [tissue, trailing/leading, mean/std]

all_fits = zeros(size(all_avgs, 2), 2, 31) ; % [tissue, trailing/leading, data]
all_edges = zeros(size(all_avgs, 2), 2, 31) ; % [tissue, trailing/leading, data]


for tt =1:size(all_avgs, 2) % iterature over tissues
    
    tiss = all_avgs{tt} ; % load tissue
    tiss = tiss(24:60,380:620) ; % trim kymograph to only consider TPs after stimulation ends and the bulk of the tissue
    tiss = abs(tiss) ;
    
    % binarize tissue using the average pixel value as a threshold
    thresh = (mean(tiss(:), 'omitnan')) ;
    tiss(tiss < thresh) = 0 ;
    tiss(tiss > thresh) = 1 ;
    tiss(isnan(tiss)) = 0 ;
    
    % perform a watershed of the binary image
    wshed = bwdist(~tiss) ;
    wshed(wshed < .21*max(wshed(:))) = 0 ;
    tiss = tiss.*wshed ;
    
    % remove any gaps in the watershed image
    se = strel('disk',1);
    tiss = imclose(tiss, se) ;
    
    % find the perimeters of any objects in the image
    edges = bwperim(tiss) ;
    
    first_half = edges(:, 1:50) ;
    second_half = edges(:, 200:end);
    
    left_edge = zeros(1, size(first_half, 1)) ;
    right_edge = zeros(1, size(second_half, 1)) ;
    
    for rr = 1:size(tiss, 1) % iterate over each row in the kymograph
        
        % for each half of the tissue, find the boundary by searching for a
        % non-zero pixel value. Store the index of that pixel to build up
        % the boundary that represents a traveling wave.
        left_row = first_half(rr, :) ;
        left_idx = find(left_row > 0) ;
        if size(left_idx, 2) > 0 && (max(left_idx) < 35)
            left_edge(rr) = max(left_idx) ;
        else
            left_edge(rr) = NaN ;
        end
        right_row = second_half(rr, :) ;
        right_idx = find(right_row > 0) ;
        if size(right_idx, 2) > 0 && (min(right_idx) > 10)
            right_edge(rr) = min(right_idx) ;
        else
            right_edge(rr) = NaN ;
        end
    end
    
    % define a linear model and fit the boundary to that model
    modelfun = @(b,x) b(1) * x(:,1) + b(2) ;
    
    time = linspace(1, size(tiss, 1), size(tiss,1)) ;
    time(isnan(left_edge)) = [] ;
    ll_time = time ;
    left_edge(isnan(left_edge)) = [] ;
    ll_tbl = table(ll_time', left_edge') ;
    ll_mdl = fitnlm(ll_tbl, modelfun, [mean(gradient(left_edge)), left_edge(1)]) ;
    ll_coefficients = ll_mdl.Coefficients{:, 'Estimate'} ;
    ll_SE = ll_mdl.Coefficients{:, 'SE'} ;
    ll_yFitted = ll_coefficients(1) * ll_time + ll_coefficients(2) ;
        
    % the fits as well as the fit coefficients are stored for plotting
    all_avg_speeds(tt, 1, 1) = ll_coefficients(1) ; 
    all_avg_speeds(tt, 1, 2) = ll_SE(1) ;
    
    all_fits(tt, 1, 1:length(ll_yFitted)) = ll_yFitted ;
    all_edges(tt, 1, 1:length(left_edge)) = left_edge ;
    
    time = linspace(1, size(tiss, 1), size(tiss,1)) ;
    right_edge(right_edge == 0) = NaN ;
    time(isnan(right_edge)) = [] ;
    rr_time = time ;
    right_edge(isnan(right_edge)) = [] ;
    right_edge = right_edge + 200 ;
    rr_tbl = table(rr_time', right_edge') ;
    rr_mdl = fitnlm(rr_tbl, modelfun, [mean(gradient(right_edge)), right_edge(1)]) ;
    rr_coefficients = rr_mdl.Coefficients{:, 'Estimate'} ;
    rr_SE = rr_mdl.Coefficients{:, 'SE'} ;
    rr_yFitted = rr_coefficients(1) * rr_time + rr_coefficients(2) ;
    
    % the fits as well as the fit coefficients are stored for plotting
    all_avg_speeds(tt, 2, 1) = rr_coefficients(1) ;
    all_avg_speeds(tt, 2, 2) = rr_SE(1) ;
    
    all_fits(tt, 2, 1:length(rr_yFitted)) = rr_yFitted ;
    all_edges(tt, 2, 1:length(right_edge)) = right_edge ;
    
end

%% Plot fits for EGTA, Control, and Stimulated Tissues

% End points from Fiji for control waves
% Leading Edge
% 0.7mm --> 0.1mm in 5 hrs
% Trailing Edge 
% -0.4 mm --> 0.05 mm in 5 hrs

control_lslope = -0.6/5 ; % mm/hr
control_tslope = 0.45/5 ; %mm/hr

time = linspace(1, 50, 50) ;
time = time/6 ;

ctime = linspace(1, 5, 5) ;
ctime = [0.1 ctime] ;
control_l = (0.7 + 2.5) + control_lslope*time;
control_t = (-0.4 + 2.5) + control_tslope*time ;

all_fits = all_fits * px_sz/1000 ;
all_fits(all_fits == 0) = NaN ;
all_edges = all_edges * px_sz/1000 ;
all_edges(all_edges == 0) = NaN ;

close all
figure
hold on
title('Edge Wave Position') ;
ylabel('Position [mm]') ;
xlabel('Time after Stim (h)') ;

m_sz = 4 ;

plot(time(1:length(squeeze(all_edges(3, 1, :)))), squeeze(all_edges(3, 1, :)), 'xk', 'MarkerSize', 2*m_sz, 'MarkerFaceColor', 'black') ;
plot(time(1:length(squeeze(all_edges(2, 1, :)))), squeeze(all_edges(2, 1, :)), 'om', 'MarkerSize', m_sz, 'MarkerFaceColor', 'magenta') ;

plot(time(1:length(squeeze(all_edges(3, 2, :)))), squeeze(all_edges(3, 2, :)), 'xk', 'MarkerSize', 2*m_sz, 'MarkerFaceColor', 'black') ;
plot(time(1:length(squeeze(all_edges(2, 2, :)))), squeeze(all_edges(2, 2, :)), 'om', 'MarkerSize', m_sz, 'MarkerFaceColor', 'magenta') ;

plot(time(1:length(squeeze(all_fits(3, 1, :)))), squeeze(all_fits(3, 1, :)), '-k', 'LineWidth', 2) ;
plot(time(1:length(squeeze(all_fits(3, 2, :)))), squeeze(all_fits(3, 2, :)), '-k', 'LineWidth', 2) ;

plot(time(1:length(squeeze(all_fits(2, 1, :)))), squeeze(all_fits(2, 1, :)), '-m', 'LineWidth', 2) ;
plot(time(1:length(squeeze(all_fits(2, 2, :)))), squeeze(all_fits(2, 2, :)), '-m', 'LineWidth', 2) ;

% plot(ctime, control_l, '--k', 'LineWidth', 2) ;
% plot(ctime, control_t, '--k', 'LineWidth', 2) ;

ylim([0 5]) ;
breakyaxis([0.8 4.2]) ;
