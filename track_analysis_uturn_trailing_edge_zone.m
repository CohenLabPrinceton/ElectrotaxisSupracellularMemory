%% code to plot the trajectories and analyze them
set(0,'defaultAxesYGrid','off');
set(0,'defaultAxesXGrid','off');
set(0,'defaultAxesFontName','Myriad Pro');
set(0,'defaultAxesFontSize',26);
set(0,'defaultTextFontName','Myriad Pro');
set(0,'defaultTextFontSize',26);
set(0,'defaultLegendFontName','Myriad Pro');
set(0,'defaultLegendFontSize',26);
set(0,'defaultAxesUnits','normalized');
set(0,'defaultAxesTickDir','out');

%% change this to the dataset you want
%  options: left_tracks, right_tracks, top_tracks, bottom_tracks
load left_tracks

pixelSize= 1.308;
xss=[]; yss=[];
for k=1:length(tracks)
    track = tracks{k};
    trackx = track(1,2);
    tracky = track(1,3);

    xk = track(:,2)-track(1,2);
    xss = [xss xk(1:59)];
        
    yk = track(:,3)-track(1,3);
    yss = [yss yk(1:59)]; 
end

%% hairball
figure('Position',[0 0 1000 1000])
set(gcf,'color','w');

%flip the bad ones
    for k=1:length(xss)
        if (yss(59,k)>0)
            yss(:,k) = -yss(:,k);
        end
    end

cmap = jet(60);
for tk=59:-1:2
    for k=1:length(xss)
        plot(xss(tk-1:tk,k)*pixelSize,-yss(tk-1:tk,k)*pixelSize,'Color',cmap(tk,:),'LineWidth',1); hold on;
    end
end
plot([-250 250],[0 0],'k','LineWidth',1); hold on;
plot([0 0],[-250 250],'k','LineWidth',1);

plot(mean(xss(1:59,:),2)*pixelSize,mean(-yss(1:59,:),2)*pixelSize,'Color',[0 0 0],'LineWidth',3);
plot(mean(xss(7:25,:),2)*pixelSize,mean(-yss(7:25,:),2)*pixelSize,'Color',[1 0 0],'LineWidth',3);

ylabel(['y-displacement (' char(956) 'm)']);
xlabel(['x-displacement (' char(956) 'm)']);

% adjust here the axes
axis([-200 200 -200 200]);
xticks(-400:100:400);
yticks(-400:100:400);
axis square;
box off;

colormap(jet(60))

set(gca,'TickDir','out');
set(gca,'LineWidth',4,'TickLength',[0.025 0.025]);
cbh2 = colorbar('Ticks',linspace(0,1,6),...
               'TickLabels',{'0 h','2 h','4 h','6 h','8 h','10 h'},...
               'FontSize',28,...
               'Location','eastoutside',...
               'TickDirection','out');
