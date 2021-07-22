%% 2D Autocorrelation (FINAL)
%
% Isaac B Breinyn 2021
%
% Spatial autocorrelation on heatmaps of tissues to extract correlation
% length during proliferation, stimulation, and controls.
%
%% Clean Workspace and Import/Format Data

% clean workspace
clear; close all; clc ; 

% load data 
cd('C:\Users\isaac\Documents\Princeton\cohen\etd') ;
data = load('VxTrimmed_2x2mm.mat') ;
% data = load('VxTrimmed_3x3mm.mat') ;
% data = data.data ;
isStuff = load('Matlab_updated_inTHISorderTHESEareCONTROLS&EGTAexpts.mat') ;

% format data
allVx = data.VxTrimmed ;
allVy = data.VyTrimmed ;
isControl = isStuff.inTHISorderTHESEareCONTROLS ;
isEGTA = isStuff.inTHISorderTHESEareEGTAexpts ;
exclusions = data.totalRUNExclusionsThruD25 ;
den_class = data.plotteddensityclassorder ;
den_count = data.plotteddensityCOUNTorder ;

for cc = 1:length(den_count)
    if isempty(den_count{cc})
        den_count{cc} = 0 ;
    end
end

for cc = 1:length(den_class)
    if ~ischar(den_class{cc})
        den_class{cc} = 'NA' ;
    end
    if isControl(cc)
        den_class{cc} = [den_class{cc} 'C'] ;
    end
    if isEGTA(cc)
        den_class{cc} = [den_class{cc} 'EGTA'] ;
    end
end

den_count = cell2mat(den_count) ;

px_sz = 1.308 * 16 ; % define spatial pixel size from PIV and image resolution

%% Perform Autocorrelation (this takes ~15 minutes so run sparingly)

if isfile('2D_corr_lengths.mat') % check if this has already been done and the if the results exist 
    data = load('2D_corr_lengths.mat') ;
    all_corr_lengths = data.all_corr_lengths ;
else
    all_corr_lengths = zeros(2, size(allVx, 2), 130) ; % [x/y, tiss, time]
    for dd = 1:2  % iterate over each direction

        if dd == 1
            allV = allVx ;
        elseif dd == 2
            allV = allVy ;
        end
        
        for tiss = 1:size(allVx, 2) % iterate over each tissue
            if ~exclusions(tiss) % check if this tissue needs to be excluded
                currV = allV{tiss} ;
                for tt = 1:size(currV, 3)
                    disp(['Starting TP' num2str(tt) ' for tiss ' num2str(tiss) ' in direction ' num2str(dd)]) ;
                    
                    % load current TP, interpolate over NaNs, and
                    % subtract mean to obtain residuals
                    data = currV(:,:,tt) ;
                    data = inpaint_nans(data) ;
                    data = data - mean(data, 'all') ;
                    
                    % perform 2D autocorrelation and use a radial scan to
                    % obtain correlation curve
                    autocorr = xcorr2(data) ;
                    radial_scan = rscan(autocorr, 'dispflag',0) ; % set 'dispflag' to true (1) to see how this works in a pretty graphic
                    
                    % interpolate to increase resolution
                    interp_factor = 10 ;
                    xx = linspace(1, length(radial_scan), length(radial_scan)) ;
                    xq = linspace(1, length(radial_scan),  interp_factor*length(radial_scan)) ;
                    
                    radial_scanq = interp1(xx, radial_scan, xq) ; 
                    
                    % Find where the average autocorrelation is closest to 0.1
                    e_diff = abs(radial_scanq - 0.1) ;
                    
                    precision = 1e-2 ;
                    idx = find(e_diff < precision, 1, 'first') ;
                    
                    min_idx = xq(idx) ;
                    
                    all_corr_lengths(dd, tiss, tt) = min_idx*px_sz ;
                end
            end
        end
    end
    all_corr_lengths(all_corr_lengths ==0) = NaN ;    
    save('2D_corr_lengths.mat', 'all_corr_lengths') ;
end

%% Plot Autocorrelation

close all

figure('units','normalized','outerposition',[0 0 .5 .80])
subplot(1, 2, 1)

plot_corr_lengths = squeeze(all_corr_lengths(1,:,:)) ;

time = 10:10:4e3 ;

lo_idx = find(matches(den_class, 'L')) ;
med_idx = find(matches(den_class, 'M')) ;
hi_idx = find(matches(den_class, 'H')) ;
v_idx = find(matches(den_class, 'V')) ;
hi_idx(end) = [] ;

loc_idx = find(matches(den_class, 'LC')) ;
medc_idx = find(matches(den_class, 'MC')) ;
hic_idx = find(matches(den_class, 'HC')) ;
vc_idx = find(matches(den_class, 'VC')) ;
medc_idx(3) = [ ] ;
hic_idx(3) = [] ;

med_corr_lengths = plot_corr_lengths(med_idx, :) ;
hi_corr_lengths = plot_corr_lengths(hi_idx, :) ;

control_corr_lengths = plot_corr_lengths([medc_idx hic_idx], :) ;

control_corr_length = mean(control_corr_lengths, 'omitnan') ;

control_err = std(control_corr_lengths, 'omitnan') ;
hold on

title('2D Autocorrelation for Vx')
ylabel('Correlation Length [\mum]') ;
xlabel('Time [h]') ;
xlim([0 10]) ;
ylim([0 400]) ;

mc = shadedErrorBar(time(1:length(mean(med_corr_lengths, 1)))/60, mean([med_corr_lengths ; hi_corr_lengths], 'omitnan') , std([med_corr_lengths ; hi_corr_lengths], 'omitnan'), 'lineprops', 'b') ;
ec = shadedErrorBar(time(1:length(control_corr_length))/60, control_corr_length, control_err , 'lineprops', '--k') ;

mc.mainLine.LineWidth = 2 ;
ec.mainLine.LineWidth = 2 ;

legend('Stimulated', 'Control', 'AutoUpdate', 'off') ;

xline(1, '--', 'E-Field = On') ;
xline(4, '--', 'Off') ;

subplot(1, 2, 2)

plot_corr_lengths = squeeze(all_corr_lengths(2,:,:)) ;

lo_corr_lengths = plot_corr_lengths(lo_idx, :) ;
med_corr_lengths = plot_corr_lengths(med_idx, :) ;
hi_corr_lengths = plot_corr_lengths(hi_idx, :) ;
v_corr_lengths = plot_corr_lengths(v_idx, :) ;

lo_corr_length = mean(lo_corr_lengths, 'omitnan') ;
med_corr_length = mean(med_corr_lengths, 'omitnan');
hi_corr_length = mean(hi_corr_lengths, 'omitnan') ;
v_corr_length = mean(v_corr_lengths, 'omitnan') ;

lo_err = std(lo_corr_lengths, 'omitnan') ;
med_err = std(med_corr_lengths, 'omitnan') ;
hi_err = std(hi_corr_lengths, 'omitnan') ;
v_err = std(v_corr_lengths, 'omitnan') ;

control_corr_lengths = plot_corr_lengths([medc_idx hic_idx], :) ;

control_corr_length = mean(control_corr_lengths, 'omitnan') ;

control_err = std(control_corr_lengths, 'omitnan') ;

hold on

title('2D Autocorrelation for Vy')
ylabel('Correlation Length [\mum]') ;
xlabel('Time [h]') ;
xlim([0 10]) ;
ylim([0 400]) ;

mc = shadedErrorBar(time(1:length(med_corr_length))/60, mean([med_corr_lengths ; hi_corr_lengths], 'omitnan') , std([med_corr_lengths ; hi_corr_lengths], 'omitnan'), 'lineprops', 'b') ;
ec = shadedErrorBar(time(1:length(control_corr_length))/60, control_corr_length, control_err, 'lineprops', '--k') ;

mc.mainLine.LineWidth = 2 ;
ec.mainLine.LineWidth = 2 ;

legend('Stimulated', 'Control', 'AutoUpdate', 'off') ;

xline(1, '--', 'E-Field = On') ;
xline(4, '--', 'Off') ;

%% Save everything
save('etd_autocorrelation_data_spatial.mat') ;