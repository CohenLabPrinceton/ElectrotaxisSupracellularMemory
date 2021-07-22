%% Charactersitic Time Scale of Order and Speed Decay
%
% Isaac Breinyn 2021
%
% To fit exponential curves to data of order and speed before, during, and
% after electric stimulation. These curves will be used to calculate
% characteristic time scales of the decay.

%% Clean Workspace and Format Data

close all; clc ; clear;

cd('C:\Users\isaac\Documents\Princeton\cohen\etd') ;
load('C:\Users\isaac\Documents\Princeton\cohen\etd\MATLAB_summary--speed_Vx_Order--BULK2x2mm_SmoothedData_For_Taus--1-MED_2-HIGH_3-LOW--4-MedCtrl_5-HighCtrl_6-LowCtrl') ;
load('absVx.mat') ;
load('Matlab_Workspace_BULKSUMMARYVARS_after_ONLY_BULK_CODE_withEACHExptDataSummary_closedFigs_withABSVxVy_thruD24_1MED_2HIGH_3LOW_Ctrls4M5H6L--run5-31-2021.mat') ;

% rename data
lo_order = SmoothMovMed3_orderALLavg(3,1:60) ;
med_order = SmoothMovMed3_orderALLavg(1,1:60) ;
hi_order = SmoothMovMed3_orderALLavg(2,1:60) ;

lo_order_std = SmoothMovMed3_orderALLstd(3,1:60) ;
med_order_std = SmoothMovMed3_orderALLstd(1,1:60) ;
hi_order_std = SmoothMovMed3_orderALLstd(2,1:60) ;

lo_speed = SmoothMovMed3_speedALLavg(3,1:60) ;
med_speed = SmoothMovMed3_speedALLavg(1,1:60) ;
hi_speed = SmoothMovMed3_speedALLavg(2,1:60) ;

lo_speed_std = SmoothMovMed3_speedALLstd(3,1:60) ;
med_speed_std = SmoothMovMed3_speedALLstd(1,1:60) ;
hi_speed_std = SmoothMovMed3_speedALLstd(2,1:60) ;

lo_Vx = SmoothMovMed3_vxmeanALLavg(3,1:60) ;
med_Vx = SmoothMovMed3_vxmeanALLavg(1,1:60) ;
hi_Vx = SmoothMovMed3_vxmeanALLavg(2,1:60) ;

lo_Vx_std = SmoothMovMed3_vxmeanALLstd(3,1:60) ;
med_Vx_std = SmoothMovMed3_vxmeanALLstd(1,1:60) ;
hi_Vx_std = SmoothMovMed3_vxmeanALLstd(2,1:60) ;

lo_absVx = SmoothMovMed3_vxABSmeanALLavg(3,1:60) ;
med_absVx = SmoothMovMed3_vxABSmeanALLavg(1,1:60) ;
hi_absVx = SmoothMovMed3_vxABSmeanALLavg(2,1:60) ;

lo_absVy = SmoothMovMed3_vyABSmeanALLavg(3,1:60) ;
med_absVy = SmoothMovMed3_vyABSmeanALLavg(1,1:60) ;
hi_absVy = SmoothMovMed3_vyABSmeanALLavg(2,1:60) ;

%% Plot Raw Data and Fits for Order (After Stim)

start_fit = 24 ; % where to start the fit
end_fit = 60 ; % where to end the fit
close all

tt = linspace(10,600,length(lo_order)) /60 ;

figure('units','normalized','outerposition',[0 0 1 1]) ;
yline(0,':','LineWidth',1.5,'Color','k');

hold on;

title('Order') ;
ylabel('Order Parameter') ;
xlabel('Time (h)') ;
ylim([-0.25 1]) ;
xlim([4 8]) ;

sz = 100 ;
line_sz = 5 ;

lo_color = [0 1 0] ;
med_color = [0 0 1] ;
hi_color = [0.5 0 0.5] ;

scatter(tt(24:48), lo_order(24:48), sz,'MarkerFaceColor', lo_color, 'MarkerEdgeColor', 'black') ;
scatter(tt(24:48), med_order(24:48), sz,'MarkerFaceColor', med_color, 'MarkerEdgeColor', 'black') ;
scatter(tt(24:48), hi_order(24:48), sz,'MarkerFaceColor', hi_color, 'MarkerEdgeColor', 'black') ;

xline(4,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');

modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', lo_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [lo_order(start_fit), 10]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(24:end), yFitted, 'Color', lo_color, 'LineWidth', line_sz, 'MarkerEdgeColor', 'black') ;

modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', med_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [med_order(start_fit), 10]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(24:end), yFitted,  'Color',med_color, 'LineWidth', line_sz, 'MarkerEdgeColor', 'black') ;

modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', hi_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [hi_order(start_fit), 10]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(24:end), yFitted,  'Color',hi_color, 'LineWidth', line_sz, 'MarkerEdgeColor', 'black') ;

%% Plot Raw Data and Fits for absVx (After Stim)

start_fit = 24 ; % where to start the fit
end_fit = 60 ; % where to end the fit
close all

tt = linspace(10,600,length(lo_absVx)) /60 ;

figure('units','normalized','outerposition',[0 0 1 1]) ;

hold on;
yline(0,':','LineWidth',1.5,'Color','k');

title('Mean |Vx|') ;
ylabel('Mean |Vx| (\mum/h)') ;
xlabel('Time (h)') ;
ylim([-0.25 40]) ;
xlim([4 8]) ;

sz = 100 ;
line_sz = 5 ;

lo_color = [0 1 0] ;
med_color = [0 0 1] ;
hi_color = [0.5 0 0.5] ;

scatter(tt(24:48), lo_absVx(24:48), sz,'MarkerFaceColor', lo_color, 'MarkerEdgeColor', 'black', 'Marker', 's') ;
scatter(tt(24:48), med_absVx(24:48), sz,'MarkerFaceColor', med_color, 'MarkerEdgeColor', 'black', 'Marker', 's') ;
scatter(tt(24:48), hi_absVx(24:48), sz,'MarkerFaceColor', hi_color, 'MarkerEdgeColor', 'black', 'Marker', 's') ;

xline(4,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');

modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', lo_absVx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [lo_absVx(start_fit), 100, 1]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(24:end), yFitted, 'Color', lo_color, 'LineWidth', line_sz, 'MarkerEdgeColor', 'black') ;
hold on

modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)',  med_absVx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [med_absVx(start_fit), 80, 1]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(24:end), yFitted,  'Color',med_color, 'LineWidth', line_sz, 'MarkerEdgeColor', 'black') ;

modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', hi_absVx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [hi_absVx(start_fit), 80, 1]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(24:end), yFitted,  'Color',hi_color, 'LineWidth', line_sz, 'MarkerEdgeColor', 'black') ;

%% Plot and Fit Order

start_fit = 24 ; % where to start the fit
end_fit = 60 ; % where to end the fit
close all

tt = linspace(10,600,length(lo_order)) ;

figure('units','normalized','outerposition',[0 0 1 1]) ;

subplot(3,3, [1 3]) ;
hold on;

title('Order') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
ylim([-0.25 1]) ;

plot(tt, lo_order, '-g', 'LineWidth', 2) ;
plot(tt, med_order, '-k', 'LineWidth', 2) ;
plot(tt, hi_order, '-r', 'LineWidth', 2) ;

xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
legend('Low Density', 'Medium Density', 'High Density', 'Location', 'NorthWest') ;

subplot(3,3,4) ;
hold on;
modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', lo_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(start_fit:end_fit), lo_order(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:, 'SE'} ;
title({['Low Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(2), 3)) '\pm' num2str(SEs(2))] ,  ['fit =' num2str(round(coefficients(1), 3)) 'e^{(-t/' num2str(round(coefficients(2), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-0.25 1]) ;


subplot(3,3,5) ;
hold on;
modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', med_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
SEs = mdl.Coefficients{:, 'SE'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(start_fit:end_fit), med_order(start_fit:end_fit), '.k') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
title({['Med Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(2), 3)) '\pm' num2str(SEs(2))] ,  ['fit =' num2str(round(coefficients(1), 3)) 'e^{(-t/' num2str(round(coefficients(2), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-0.25 1]) ;

subplot(3,3,6) ;
hold on;
modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', hi_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
SEs = mdl.Coefficients{:, 'SE'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(start_fit:end_fit), hi_order(start_fit:end_fit), '.r') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
title({['High Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(2), 3)) '\pm' num2str(SEs(2))] ,  ['fit =' num2str(round(coefficients(1), 3)) 'e^{(-t/' num2str(round(coefficients(2), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-0.25 1]) ;


start_fit = 6 ; % where to start the fit
end_fit = 24 ; % where to end the fit

subplot(3,3,7) ;
hold on;
modelfun = @(b,x) b(1) - b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', lo_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [1, 1, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
SEs = mdl.Coefficients{:, 'SE'} ;
yFitted = coefficients(1) - coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), lo_order(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
title({['Low Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-0.25 1]) ;


subplot(3,3,8) ;
hold on;
modelfun = @(b,x) b(1) - b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', med_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [1, 1, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
SEs = mdl.Coefficients{:, 'SE'} ;
yFitted = coefficients(1) - coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), med_order(start_fit:end_fit), '.k') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
title({['Med Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-0.25 1]) ;


subplot(3, 3, 9) ;
hold on;
modelfun = @(b,x) b(1) - b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', hi_order(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [1, 1,100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) - coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), hi_order(start_fit:end_fit), '.r') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['High Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-0.25 1]) ;

saveas(gcf, 'order\order_min.png') ;

%% Plot and Fit Speed

close all

start_fit = 24 ;
end_fit = 60 ; % where to end the fit

tt = linspace(10,600,length(lo_order)) ;

figure('units','normalized','outerposition',[0 0 1 1]) ;

subplot(3,3, [1 3]) ;
hold on;

title('Speed') ;
ylabel('|V|') ;
xlabel('Time (min)') ;
ylim([-10 60]) ;

plot(tt, lo_speed, '-g', 'LineWidth', 2) ;
plot(tt, med_speed, '-k', 'LineWidth', 2) ;
plot(tt, hi_speed, '-r', 'LineWidth', 2) ;

xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
legend('Low Density', 'Medium Density', 'High Density', 'Location', 'NorthWest') ;

subplot(3,3,4) ;
hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', lo_speed(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [10, 80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), lo_speed(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['Low Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

subplot(3,3,5) ;
hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', med_speed(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [10, 80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), med_speed(start_fit:end_fit), '.k') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['Med Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

subplot(3,3,6) ;
hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', hi_speed(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [10, 80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), hi_speed(start_fit:end_fit), '.r') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['High Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

start_fit = 1 ; % where to start the fit

subplot(3,3,7) ;
hold on;
[~, idx] = max(lo_speed) ;
end_fit = idx -1  ;
modelfun = @(b,x) b(1) + b(2) * exp(x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', lo_speed(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [lo_speed(1), 1, 10]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), lo_speed(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('|V|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['Low Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '+' num2str(round(coefficients(2), 3)) 'e^{(t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

subplot(3,3,8) ;
hold on;
[~, idx] = max(med_speed) ;
end_fit = idx-1 ;
modelfun = @(b,x) b(1) + b(2) * exp(x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', med_speed(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [med_speed(1), 1, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), med_speed(start_fit:end_fit), '.k') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('|V|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['Med Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '+' num2str(round(coefficients(2), 3)) 'e^{(t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

subplot(3,3,9) ;
hold on;
end_fit = 20 ;
modelfun = @(b,x) b(1) + b(2) * exp(x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', hi_speed(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [10, 10, 10]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), hi_speed(start_fit:end_fit), '.r') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('|V|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['High Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '+' num2str(round(coefficients(2), 3)) 'e^{(t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

saveas(gcf, 'speed\speed_min.png') ;

%% Plot and Fit Vx

close all

end_fit = 60 ; % where to end the fit
start_fit = 24 ;

tt = linspace(10,600,length(lo_order)) ;

figure('units','normalized','outerposition',[0 0 1 1]) ;

subplot(3,3, [1 3]) ;
hold on;

title('V_x') ;
ylabel('V_x') ;
xlabel('Time (min)') ;
ylim([-10 60]) ;

plot(tt, lo_Vx, '-g', 'LineWidth', 2) ;
plot(tt, med_Vx, '-k', 'LineWidth', 2) ;
plot(tt, hi_Vx, '-r', 'LineWidth', 2) ;
legend('Low Density', 'Medium Density', 'High Density', 'Location', 'NorthWest', 'AutoUpdate', 'off') ;

xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');

subplot(3,3,4) ;
hold on;
modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', lo_Vx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(start_fit:end_fit), lo_Vx(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:, 'SE'} ;
title({['Low Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(2), 3)) '\pm' num2str(SEs(2))] ,  ['fit =' num2str(round(coefficients(1), 3)) 'e^{(-t/' num2str(round(coefficients(2), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;


subplot(3,3,5) ;
hold on;
modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', med_Vx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
SEs = mdl.Coefficients{:, 'SE'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(start_fit:end_fit), med_Vx(start_fit:end_fit), '.k') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
title({['Med Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(2), 3)) '\pm' num2str(SEs(2))] ,  ['fit =' num2str(round(coefficients(1), 3)) 'e^{(-t/' num2str(round(coefficients(2), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

subplot(3,3,6) ;
hold on;
modelfun = @(b,x) b(1) * exp(-x(:,1)/b(2));
tbl = table(tt(start_fit:end_fit)', hi_Vx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [80, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
SEs = mdl.Coefficients{:, 'SE'} ;
yFitted = coefficients(1) * exp(-tt(start_fit:end_fit)/coefficients(2));
plot(tt(start_fit:end_fit), hi_Vx(start_fit:end_fit), '.r') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
title({['High Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(2), 3)) '\pm' num2str(SEs(2))] ,  ['fit =' num2str(round(coefficients(1), 3)) 'e^{(-t/' num2str(round(coefficients(2), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

start_fit = 6 ;

subplot(3,3,7) ;
hold on;
[~, idx] = max(lo_Vx) ;
end_fit = idx-1 ;
modelfun = @(b,x) b(1) - b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', lo_Vx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [max(lo_Vx), 1, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
SEs = mdl.Coefficients{:, 'SE'} ;
yFitted = coefficients(1) - coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), lo_Vx(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
title({['Low Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

subplot(3,3,8) ;
hold on;
[~, idx] = max(med_Vx) ;
end_fit = idx-1 ;
modelfun = @(b,x) b(1) - b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', med_Vx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [max(med_Vx), 1, 100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
SEs = mdl.Coefficients{:, 'SE'} ;
yFitted = coefficients(1) - coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), med_Vx(start_fit:end_fit), '.k') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
title({['Med Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

subplot(3, 3, 9) ;
hold on;
[~, idx] = max(hi_Vx) ;
end_fit = idx-1 ;
modelfun = @(b,x) b(1) - b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', hi_Vx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [max(hi_Vx), 1,100]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) - coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), hi_Vx(start_fit:end_fit), '.r') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve','AutoUpdate','off') ;
ylabel('\phi') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['High Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 60]) ;

saveas(gcf, 'Vx\Vx_min.png') ;

%% Plot and Fit absVx

close all

start_fit = 24 ;
end_fit = 60 ; % where to end the fit

tt = linspace(10,600,length(lo_absVx)) ;

figure('units','normalized','outerposition',[0 0 1 1]) ;

subplot(2,3, [1 3]) ;
hold on;

title('|V_x|') ;
ylabel('|V_x|') ;
xlabel('Time (min)') ;
ylim([-10 60]) ;

plot(tt, lo_absVx, '-g', 'LineWidth', 2) ;
plot(tt, med_absVx, '-k', 'LineWidth', 2) ;
plot(tt, hi_absVx, '-r', 'LineWidth', 2) ;

xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
legend('Low Density', 'Medium Density', 'High Density', 'Location', 'NorthWest') ;

subplot(2,3,4) ;
hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', lo_absVx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [lo_absVx(50), lo_absVx(24), 200]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), lo_absVx(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V_x|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['Low Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 45]) ;

subplot(2,3,5) ;
hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', med_absVx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [med_absVx(50), med_absVx(24), 200]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), med_absVx(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V_x|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['Med Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] , ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 45]) ;

subplot(2,3,6) ;

hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', hi_absVx(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [hi_absVx(50), hi_absVx(24), 200]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2)* exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), hi_absVx(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V_x|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['High Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 45]) ;

saveas(gcf, 'absVx\absVx_min.png') ;

%% Plot and Fit absVy

close all

start_fit = 26 ;
end_fit = 48 ; % where to end the fit

tt = linspace(10,600,length(lo_absVy)) ;

figure('units','normalized','outerposition',[0 0 1 1]) ;

subplot(2,3, [1 3]) ;
hold on;

title('|V_y|') ;
ylabel('|V_y|') ;
xlabel('Time (min)') ;
ylim([-10 60]) ;

plot(tt, lo_absVy, '-g', 'LineWidth', 2) ;
plot(tt, med_absVy, '-k', 'LineWidth', 2) ;
plot(tt, hi_absVy, '-r', 'LineWidth', 2) ;

xline(60,'--k.','E-Field = ON', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
legend('Low Density', 'Medium Density', 'High Density', 'Location', 'NorthWest') ;

subplot(2,3,4) ;
hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', lo_absVy(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [lo_absVy(50), lo_absVy(24), 200]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), lo_absVy(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V_y|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['Low Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 45]) ;

subplot(2,3,5) ;
hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', med_absVy(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [med_absVy(50), med_absVy(24), 200]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2) * exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), med_absVy(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V_y|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['Med Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] , ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 45]) ;

subplot(2,3,6) ;

hold on;
modelfun = @(b,x) b(1) + b(2) * exp(-x(:,1)/b(3));
tbl = table(tt(start_fit:end_fit)', hi_absVy(start_fit:end_fit)') ;
mdl = fitnlm(tbl, modelfun, [hi_absVy(50), hi_absVy(24), 200]) ;
coefficients = mdl.Coefficients{:, 'Estimate'} ;
yFitted = coefficients(1) + coefficients(2)* exp(-tt(start_fit:end_fit)/coefficients(3));
plot(tt(start_fit:end_fit), hi_absVy(start_fit:end_fit), '.g') ;
plot(tt(start_fit:end_fit), yFitted, '-m') ;
legend('data', 'fitted curve') ;
ylabel('|V_y|') ;
xlabel('Time (min)') ;
SEs = mdl.Coefficients{:,'SE'} ;
title({['High Fit, R^2=' num2str( round(mdl.Rsquared.Ordinary, 3)) ', \tau= ' num2str(round(coefficients(3), 3)) '\pm' num2str(SEs(3))] ,  ['fit = ' num2str(round(coefficients(1), 3)) '-' num2str(round(coefficients(2), 3)) 'e^{(-t/' num2str(round(coefficients(3), 3)) ')}']}) ;
xline(240,'--k.','E-Field = OFF', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
ylim([-10 45]) ;

saveas(gcf, 'absVy\absVy_min.png') ;
