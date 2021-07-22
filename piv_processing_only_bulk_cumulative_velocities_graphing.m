%General PIV/LIC Processor for PIVLab output MAT files
clear all
%close all
type1tosaveSummaryVariables=1;

%% set default figure configurations
% set(0,'defaultAxesYGrid','off');
% set(0,'defaultAxesXGrid','off');
% set(0,'defaultAxesFontName','Arial');
% set(0,'defaultAxesFontSize',18);
% set(0,'defaultTextFontName','Arial');
% set(0,'defaultTextFontSize',18);
% set(0,'defaultLegendFontName','Arial');
% set(0,'defaultLegendFontSize',18);
% set(0,'defaultAxesUnits','normalized');
% set(0,'defaultAxesTickDir','out');

set(0,'defaultAxesFontSize',36); %at bottom, run: set(0,'defaultAxesFontSize','remove');

%box off
%set(gca, 'FontSize', 36);
%set(gca,'TickDir','out');
%set(gca,'LineWidth',3,'TickLength',[0.0125 0.0125]);
    % allcbar1.TickDirection = 'out';
    % allcbar1.LineWidth = 2;

set(0,'defaultAxesYGrid','off');
set(0,'defaultAxesXGrid','off');
set(0,'defaultAxesFontName','Arial');
set(0,'defaultAxesFontSize',40);
set(0,'defaultTextFontName','Arial');
set(0,'defaultTextFontSize',20); %%26 or 36?
set(0,'defaultLegendFontName','Arial');
set(0,'defaultLegendFontSize',28);
set(0,'defaultAxesUnits','normalized');
set(0,'defaultAxesTickDir','out');
    set(0,'defaultAxesLineWidth',2);
  set(0, 'DefaultFigureColor', 'white');
  %set(0,'defaultAxesXColor','black'); %Otherwise, auto is: ax.XColor=[0.15 0.15 0.15]  
  %set(0,'defaultAxesYColor','black'); %leave as auto, dark gray!
  %set(0,'defaultAxesZColor','black'); %leave as auto, dark gray!

% set(0,'defaultAxesFontSize','remove');
% set(0,'defaultTextFontSize','remove');
% set(0,'defaultLegendFontSize','remove');
%      set(0,'defaultAxesLineWidth','remove');
     
%% CHANGE THESE STARTING VARIABLES based on below desire of what to graph...   
                plotThe3700sSeparate=0; 
                plotTheEGTAalso=0; 
             lastVoltageToPlot=5; 

%to load the PIV data and save output figures:
processfolder=strcat(pwd,'\');
  mkdir(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\');
  
% Tissues to use: (Don't need to edit this now!)
    D21_tissues = {'PIVoutAUTO_ImgSeq T1_Density21_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density21_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density21_VectorsWorkSpace'};
    EGTA_tissues = {'PIVoutAUTO_ImgSeq T1_Density25_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density25_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density25_VectorsWorkSpace'};
  
  v6_exps = EGTA_tissues;
%plots v7 too + control v8: 
v8_exps = {'PIVoutAUTO_ImgSeq T12_Density18_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density19_VectorsWorkSpace','PIVoutAUTO_ImgSeq T5_Density19_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density24_VectorsWorkSpace'}; 
v7_exps = {'PIVoutAUTO_ImgSeq T1_Density15-VeryHighDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density15-VeryHighDens2_VectorsWorkSpace'}; 

    %CONTROLS for 3=Med, 4=High, 5=Low <==> DOTTED LINES, colored same as the main categories now [used to be: Magenta, Dark Blue, Cyan/Light Blue]  
 v5_exps = {'PIVoutAUTO_ImgSeq T3_Density12-LowDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density20_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density22_VectorsWorkSpace',}; 
v4_exps = {'PIVoutAUTO_ImgSeq T1_Density24_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density24_VectorsWorkSpace','PIVoutAUTO_ImgSeq T1_Density18_VectorsWorkSpace','PIVoutAUTO_ImgSeq T9_Density18_VectorsWorkSpace','PIVoutAUTO_ImgSeq T1_Density19_VectorsWorkSpace'};
%medium density controls:
 v3_exps = {'PIVoutAUTO_ImgSeq T1_Density12-MedDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density12-HighDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T1_Density20_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density20_VectorsWorkSpace','PIVoutAUTO_ImgSeq T1_Density21_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density21_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density21_VectorsWorkSpace','PIVoutAUTO_ImgSeq T1_Density22_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density22_VectorsWorkSpace'}; 
 
%Low (green):               
v2_exps = {'PIVoutAUTO_ImgSeq T1_Density9-LowDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density10-MedDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density11-LowDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density15-MedDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T1_Density11-MedDens1_VectorsWorkSpace'}; %CUT OUT 'PIVoutAUTO_ImgSeq T3_Density10-LowDens1_VectorsWorkSpace' because 2074 TOO LOW!!! Velocity Profile shows outlier!  %moved 'PIVoutAUTO_ImgSeq T2_Density10-MedDens1_VectorsWorkSpace' from medium to low, per updated JV cell counts and borders at 2500/2750! %added D11-T1 from medium to here low now because switched densLowBar to 2350!!!
%High: (red): 
v1_exps = {'PIVoutAUTO_ImgSeq T1_Density17-VeryHighDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density17-VeryHighDens2_VectorsWorkSpace','PIVoutAUTO_ImgSeq T1_Density16-VeryHighDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density16-VeryHighDens2_VectorsWorkSpace'}; 
%Med: (black): == MED + OLD "HIGH"
v0_exps = {'PIVoutAUTO_ImgSeq T1_Density7-MedDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density7-MedDens2_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density7-MedDens3_VectorsWorkSpace','PIVoutAUTO_ImgSeq T2_Density9-HighDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density9-MedDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T1_Density10-HighDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density11-HighDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density16-MedDens1_VectorsWorkSpace','PIVoutAUTO_ImgSeq T3_Density17-HighDens1_VectorsWorkSpace'}; 

setexptgraphinglength = 60;
xlimendgraphs = 10*setexptgraphinglength/60; 
    xlimendFRAMES = setexptgraphinglength;

minperframe = 10;
thetas = {};

%% add some variables for the new section to crop for bulk:
    setwidthUMofTrailLeftEdge = 100; %MICRONS, e.g. want 500 um (=0.5 mm) segment/strip to lump within the "trailing" and "leading" edges...  
    widthUMofCenterEG1MMBulk = 2000; %can do: if hugeloop==5 || hugeloop==1; %set bulk center larger if this is a 5 MM Sized Tissue! %5 MM SQ AT 1.308 AND 16 PIXEL PIV WINDOW GIVES AROUND 340X334 %3 MM SQ AT 1.308 AND 16 PIXEL PIV WINDOW GIVES AROUND 233X233     
    setwidthUMofLeadRightEdge = 100; %MICRONS, e.g. want 500 um (=0.5 mm) segment/strip to lump within the "trailing" and "leading" edges...  
    setUMtoTrimOffTopForOrderPAnalysis = 1500; %MICRONS, USED IN ORDER PARAMETER analysis if you want! SET TO ZERO IF DON'T WANT ANY TRIMMED.  
    setUMtoTrimOffBottomForOrderPAnalysis = 1500; %MICRONS, USED IN ORDER PARAMETER analysis if you want! SET TO ZERO IF DON'T WANT ANY TRIMMED.  
convUMppx = 1.308; %1.308 for Zeiss at 5x (because 6.54 um/pixel divided by 5); conv=1.825 for Nikon at 4x because 7.3 MICRONS PER PIXEL FOR THE NIKON, divided by 4 for 4x phase = 1.825;  
convMMppx = convUMppx*1e-3; %or 1.308e-3; %because 1.308e-3 mm/pixel; see above 
PIVminstepsize = 16; %i.e. PIVlab set to 64-32, then 32-16 (integ window-step size), so result vectors are every 16 pixels.
framesperhr=6; minperframe=60/framesperhr;
frames = setexptgraphinglength;

%% Now work with the data magic!

    %initialize some variables to use later
    orderALLavg=nan(lastVoltageToPlot+1,150);  %needed the voltages+1 because voltages starts counting at zero!
    orderALLstd=nan(lastVoltageToPlot+1,150); 
      orderYALLavg=nan(lastVoltageToPlot+1,150);
      orderYALLstd=nan(lastVoltageToPlot+1,150);
        orderY2ALLavg=nan(lastVoltageToPlot+1,150);  %needed the voltages+1 because voltages starts counting at zero!
        orderY2ALLstd=nan(lastVoltageToPlot+1,150); 
        %%%order2ALLavg=nan(lastVoltageToPlot+1,150); order2ALLstd=nan(lastVoltageToPlot+1,150); orderALL_ABSyForOrderXavg=nan(lastVoltageToPlot+1,150); orderALL_ABSyForOrderXstd=nan(lastVoltageToPlot+1,150); orderALL_ABSxForOrderYavg=nan(lastVoltageToPlot+1,150); orderALL_ABSxForOrderYstd=nan(lastVoltageToPlot+1,150); 
            SmoothMovMed3_orderALLavg=nan(lastVoltageToPlot+1,150);  %needed the voltages+1 because voltages starts counting at zero!
            SmoothMovMed3_orderALLstd=nan(lastVoltageToPlot+1,150); 
              SmoothMovMed3_orderYALLavg=nan(lastVoltageToPlot+1,150);
              SmoothMovMed3_orderYALLstd=nan(lastVoltageToPlot+1,150);
                SmoothMovMed3_orderY2ALLavg=nan(lastVoltageToPlot+1,150);  %needed the voltages+1 because voltages starts counting at zero!
                SmoothMovMed3_orderY2ALLstd=nan(lastVoltageToPlot+1,150); 

    speedALLavg=nan(lastVoltageToPlot+1,150); 
    speedALLstd=nan(lastVoltageToPlot+1,150); 
        SmoothMovMed3_speedALLavg=nan(lastVoltageToPlot+1,150);
        SmoothMovMed3_speedALLstd=nan(lastVoltageToPlot+1,150);
    vxmeanALLavg=nan(lastVoltageToPlot+1,150); 
    vxmeanALLstd=nan(lastVoltageToPlot+1,150); 
        SmoothMovMed3_vxmeanALLavg=nan(lastVoltageToPlot+1,150); 
        SmoothMovMed3_vxmeanALLstd=nan(lastVoltageToPlot+1,150);     
    vymeanALLavg=nan(lastVoltageToPlot+1,150); 
    vymeanALLstd=nan(lastVoltageToPlot+1,150); 
        SmoothMovMed3_vymeanALLavg=nan(lastVoltageToPlot+1,150);
        SmoothMovMed3_vymeanALLstd=nan(lastVoltageToPlot+1,150);    
    vxABSmeanALLavg=nan(lastVoltageToPlot+1,150); 
    vxABSmeanALLstd=nan(lastVoltageToPlot+1,150); 
        SmoothMovMed3_vxABSmeanALLavg=nan(lastVoltageToPlot+1,150); 
        SmoothMovMed3_vxABSmeanALLstd=nan(lastVoltageToPlot+1,150); 
    vyABSmeanALLavg=nan(lastVoltageToPlot+1,150); 
    vyABSmeanALLstd=nan(lastVoltageToPlot+1,150); 
        SmoothMovMed3_vyABSmeanALLavg=nan(lastVoltageToPlot+1,150);
        SmoothMovMed3_vyABSmeanALLstd=nan(lastVoltageToPlot+1,150);
colorpurple = [0.5 0 0.5]; %To save color purple handy! 
colororange = [1 0.5 0]; %To save color orange handy! 
%% back to original math:
for voltages=0:lastVoltageToPlot %SET TO 5 IF WANT TO INCLUDE CONTROLS
    if voltages==0
        exps = v0_exps;
        color = 'b'; %ColorScheme Update!  'k';
        linestyle = '-'; %added into shaded_error_wLineStyle_Width3.m function! %'LineStyle' options are: '-' | '--' | ':' | '-.' | 'none'.
        alphavalue = 0.2; %shading in shaded_error function
    elseif voltages==1
        exps = v1_exps;
         color = [0.5 0 0.5]; %Purple! %ColorScheme Update!  'r';
        linestyle = '-';
        alphavalue = 0.2; %shading in shaded_error function
    elseif voltages==2
        exps = v2_exps;
        color = 'g';
        linestyle = '-';
        alphavalue = 0.2; %shading in shaded_error function
    elseif voltages==3
        exps = v3_exps;
        color = 'b'; %ColorScheme Update! 'k'; %'m';
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
    elseif voltages==4
        exps = v4_exps;
        color = [0.5 0 0.5]; %Purple! %ColorScheme Update!  'r'; %'b';
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
    elseif voltages==5
        exps = v5_exps;
        color = 'g';%'r'; %'g'; %'c';   %[0.6350, 0.0780, 0.1840] is a dark red... but may be too close to red  
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
   elseif voltages==6 %&& plotTheEGTAalso==1
        exps = v6_exps;
        color = 'r'; %ColorScheme Update!  'b';    %'r'; %'g'; %'c';   %[0.6350, 0.0780, 0.1840] is a dark red... but may be too close to red  
        linestyle = '-'; %dashed for controls!
        alphavalue = 0.2; %shading slightly lighter for the controls! %shading in shaded_error function 
  elseif voltages==7 %MAGENTA TRANSITION DENSITY EXPTS:
        exps = v7_exps;
        color = 'm';%'r'; %'g'; %'c';   %[0.6350, 0.0780, 0.1840] is a dark red... but may be too close to red  
        linestyle = '-'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
  elseif voltages==8 %MAGENTA TRANSITION DENSITY CONTROLS:
        exps = v8_exps;
        color = 'm';%'r'; %'g'; %'c';   %[0.6350, 0.0780, 0.1840] is a dark red... but may be too close to red  
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
%             if plotThe3700sSeparate==1
%                 linestyle = '-'; %solid for the magenta 3700s addition!
%             end
    end
    currentexptlengthtracker=[];
    % calculate thetas
    for ekplotter=1:length(exps)
        load([processfolder exps{ekplotter}]);
        % hard-coded exclusion for 1-5v1at1_piv at t=100 min, index=9
        currtheta = cell(length(u_filtered),1); %cell(setexptgraphinglength,1);
        currtheta2 = cell(length(v_filtered),1); %cell(setexptgraphinglength,1);
        %%%currthetaABSyForOrderX = cell(length(u_filtered),1); currtheta2ABSxForOrderY = cell(length(v_filtered),1);
        
        %ONLY BULK UPDATES:
            %% Do the math needed for this section add-on:
            %%%%%%%%%%%   24*convMMppx*PIVminstepsize EQUALS 0.5023, SO TAKE 24 NEAREST COLUMNS TO THE FIRST NAN AND USE THAT AS THE LEADING & TRAILING EDGES OF THE TISSUE!              
            frames=length(u_original);
            vxwithNaNs = u_original;
            vywithNaNs = v_original;
            for(i=1:frames) %this loop and the above two lines were added to grab all parts of the u_filtered cell vectors and put them into the u_original whenever u_original is not NaN! This is to grab the stdev filter from PIV and any other filters done, without removing the NaN's so that we know where the tissue ends!
               vxwithNaNs{i}(~isnan(u_original{i})) = u_filtered{i}(~isnan(u_original{i})); %inputs the u_filtered values into the u_original formatting with NaN's!
               vywithNaNs{i}(~isnan(v_original{i})) = v_filtered{i}(~isnan(v_original{i})); %inputs the v_filtered values into the v_original formatting (without removing the NaN's)!--depending on the filtering done in PIVlab, this may only be a few values, but will change several and should be included!
            end
            vx = vxwithNaNs; %u_filtered; or u_original %switched to vxwithNaNs or u_original to include the NaN's to see where the tissue ends!! :)
            vy = vywithNaNs; %v_filtered; or v_original %switched to vywithNaNs or v_original to include the NaN's to see where the tissue ends!! :) %SEE ABOVE FOR LOOP
            X=numel(vx{1}); %number of elements 
            Y=numel(vy{1}); %number of elements 
            %frames=length(vx);
        %%MATH FOR ALL 4 TYPES OF CALCULATIONS: [moved up here in v16 update]  
         % 1. meanVX along the x-axis ("normal"/original way):
                clear meanVX meanVY meanVXALONGY meanVYALONGY
        for(i=1:frames)
            meanVX(i,:)=nanmean(vx{i}); %average down the *columns* to get avg X-speed at each X-position %nanmean(matrixX) is a row vector of column means, computed after removing NaN values.  %added ~isnan to ignore NaN values in unfiltered one!: [[used to be meanVX(i,:)=mean(vx{i});  ]]
        end
        meanVX_maximum_value = max(max((meanVX)))*convUMppx*framesperhr; %v6 calc for use below in vertical line making  %use meanVX and not vx because we want mean values -- vx_maximum_value = max(max(cell2mat(vx)));
        meanVX_minimum_value = min(min((meanVX)))*convUMppx*framesperhr; %v6
         % 2. meanVY along the x-axis ("normal"/original way):
        for(i=1:frames) %NOTE: this is still along the x-axis, which is ideal because that's how we view tissue--trailing and leading edges... but added graphs below for along y-position/y-axis! 
            meanVY(i,:)=nanmean(vy{i}); %average down the *columns* to get avg X-speed at each X-position %nanmean(matrixX) is a row vector of column means, computed after removing NaN values.  %added ~isnan to ignore NaN values in unfiltered one!: [[used to be meanVY(i,:)=mean(vy{i});  ]]
        end
        meanVY_maximum_value = max(max((meanVY)))*convUMppx*framesperhr; %v6 calc for use below in vertical line making  %use meanVY and not vy because we want mean values -- vy_maximum_value = max(max(cell2mat(vy)));
        meanVY_minimum_value = min(min((meanVY)))*convUMppx*framesperhr; %v6
         % 3. meanVX calculated along the **Y-axis**:
        for(iALONGY=1:frames)
            meanVXALONGY(iALONGY,:)=nanmean(transpose(vx{iALONGY})); %average down the **ROWS* OF VX (columns of transposed vx)* to get avg X-speed at each X-position %nanmean(matrixX) is a row vector of column means, computed after removing NaN values.  %added ~isnan to ignore NaN values in unfiltered one!: [[used to be meanVX(i,:)=mean(vx{i});  ]]
        end
        meanVXALONGY_maximum_value = max(max((meanVXALONGY)))*convUMppx*framesperhr; %v6 calc for use below in vertical line making  %use meanVXALONGY and not vx because we want mean values -- vx_maximum_value = max(max(cell2mat(vx)));
        meanVXALONGY_minimum_value = min(min((meanVXALONGY)))*convUMppx*framesperhr; %v6
         % 4. meanVX calculated along the **Y-axis**:
        for(iALONGY=1:frames)
            meanVYALONGY(iALONGY,:)=nanmean(transpose(vy{iALONGY})); %average down the **ROWS* OF VX (columns of transposed vx)* to get avg X-speed at each X-position %nanmean(matrixX) is a row vector of column means, computed after removing NaN values.  %added ~isnan to ignore NaN values in unfiltered one!: [[used to be meanVYALONGY(i,:)=mean(vy{i});  ]]
        end
        meanVYALONGY_maximum_value = max(max((meanVYALONGY)))*convUMppx*framesperhr; %v6 calc for use below in vertical line making  %use meanVYALONGY and not vy because we want mean values -- vy_maximum_value = max(max(cell2mat(vy)));
        meanVYALONGY_minimum_value = min(min((meanVYALONGY)))*convUMppx*framesperhr; %v6

        endofxaxisMM = ceil(convMMppx*PIVminstepsize*(length(meanVX))); %so now can use [0 endofxaxisMM] instead of [0 5]   
        endofyaxisMM = ceil(convMMppx*PIVminstepsize*(length(meanVY))); %so now can use [0 endofxaxisMM] instead of [0 5]   

            for j=1:frames
                first_non_NaN_index_of_this_row_j_mean_for_frames = find(~isnan(meanVX(j,:)), 1); %find left edge of tissue!
                  leftsideeachframe(j)=first_non_NaN_index_of_this_row_j_mean_for_frames; %save that just in case
                last_non_NaN_index_of_this_row_j_mean_for_frames = find(~isnan(meanVX(j,:)), 1, 'last'); %find right edge of tissue!
                  rightsideeachframe(j)=last_non_NaN_index_of_this_row_j_mean_for_frames; %save that just in case
            end
            for j=1:frames
                first_non_NaN_index_of_this_row_j_mean_for_frames = find(~isnan(meanVXALONGY(j,:)), 1); %find left edge of tissue!
                  bottomsideeachframe(j)=first_non_NaN_index_of_this_row_j_mean_for_frames; %save JIC for later %THIS IS BOTTOM! see note two lines below...
                last_non_NaN_index_of_this_row_j_mean_for_frames = find(~isnan(meanVXALONGY(j,:)), 1, 'last'); %find right edge of tissue!
                  topsideeachframe(j)=last_non_NaN_index_of_this_row_j_mean_for_frames; %NOTE THIS IS THE TOP! i.e. top is at top of graph... :) double check? Vy should be positive at the top as cells move north
            end
            leftsideeachframeMM = leftsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
            rightsideeachframeMM = rightsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
            bottomsideeachframeMM = bottomsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
            topsideeachframeMM = topsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
            % leftsideeachframe(j) -- calculated above
            % rightsideeachframe(j) -- calculated above
            %PUT IN TOP SECTION-- setwidthUMofleadtrailedges = 500; %microns, e.g. want 500 um segment/strip to lump within the "trailing" and "leading" edges...   
            %AT TOP: setwidthUMofLeadRightEdge = 500; %MICRONS, e.g. want 500 um (=0.5 mm) segment/strip to lump within the "trailing" and "leading" edges...  
            %AT TOP: setwidthUMofTrailLeftEdge = 500; %MICRONS, e.g. want 500 um (=0.5 mm) segment/strip to lump within the "trailing" and "leading" edges...  
            halfwidthNROWSofCenterEG1MMBulk = floor(widthUMofCenterEG1MMBulk/(2*1000*convMMppx*PIVminstepsize)); %converting microns to # of rows %usually double e.g. 1 MM if edges were set to 0.5 mm (or 500 um)
            widthNROWStoTrimOffTop = floor(setUMtoTrimOffTopForOrderPAnalysis/(1000*convMMppx*PIVminstepsize)); %converting microns to # of rows  
            widthNROWStoTrimOffBottom = floor(setUMtoTrimOffBottomForOrderPAnalysis/(1000*convMMppx*PIVminstepsize)); %converting microns to # of rows  
                %above two rows added on v28; the math will equal zero if set to zero in top section!     
            for j=1:frames
                vxtrimmedtissue{j} = vxwithNaNs{j}(bottomsideeachframe(j):topsideeachframe(j),leftsideeachframe(j):rightsideeachframe(j)); %cut off rows of *only* NaNs on both sides! So this is now the minimum size that includes all numbers--for each frame is different shape then! (inccorect to do math on this for kymographs or anything...)
                meanspotbetweenleftandright(j) = round(mean([leftsideeachframe(j) rightsideeachframe(j)])); %center point between leftmost and rightmost edges
                vxbulkofEG1MMatcenterofNaNs{j} = vxwithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),(meanspotbetweenleftandright(j)-halfwidthNROWSofCenterEG1MMBulk):(meanspotbetweenleftandright(j)+halfwidthNROWSofCenterEG1MMBulk)); %47 columns is 0.9836 MM %48 columns is 1.0045 MM
             %NOW FOR vy: (note that I care about x-direction math here, because that's where the leading and trailing edge is!!--but another instance OR it may be more correct to (also?) trimm the tissue vertically! I have a topsideeachframe(j) and bottomsideeachframe(j) anyway... HMMM)   
                vytrimmedtissue{j} = vywithNaNs{j}(bottomsideeachframe(j):topsideeachframe(j),leftsideeachframe(j):rightsideeachframe(j)); %cut off rows of *only* NaNs on both sides! So this is now the minimum size that includes all numbers--for each frame is different shape then! (incorrect to do math on this for kymographs or anything...)
                meanspotbetweenleftandright(j) = round(mean([leftsideeachframe(j) rightsideeachframe(j)])); %center point between leftmost and rightmost edges
                vybulkofEG1MMatcenterofNaNs{j} = vywithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),(meanspotbetweenleftandright(j)-halfwidthNROWSofCenterEG1MMBulk):(meanspotbetweenleftandright(j)+halfwidthNROWSofCenterEG1MMBulk)); %47 columns is 0.9836 MM %48 columns is 1.0045 MM
             %NOW CAN SET any of these matrices into the vxwithNaNs and vywithNaNs in the graphing math below, and we'll get order parameter, etc. for only this segment!      
            end
u_filtered = vxbulkofEG1MMatcenterofNaNs;
v_filtered = vybulkofEG1MMatcenterofNaNs;
        %% Continue onward original math:
        for tkplotter = 1:length(u_filtered) %setexptgraphinglength   
            currtheta{tkplotter} = atan2(-v_filtered{tkplotter},u_filtered{tkplotter}); %v_filtered is actually going down on your computer screen if positive! so ideally flip this for orderY! but shouldn't change order in x... hmmm...
             currtheta2{tkplotter} = atan2(v_filtered{tkplotter},u_filtered{tkplotter});
            %%%currthetaABSyForOrderX{tkplotter} = atan2(abs(v_filtered{tkplotter}),u_filtered{tkplotter}); %v_filtered is actually going down on your computer screen if positive! so ideally flip this for orderY! but shouldn't change order in x... hmmm...
             %%%currtheta2ABSxForOrderY{tkplotter} = atan2(v_filtered{tkplotter},abs(u_filtered{tkplotter}));
            order{ekplotter}(tkplotter) = nanmean(nanmean(cos(currtheta{tkplotter}))); %UPDATED from MEAN2() TO NANMEAN(NANMEAN()) -- USED TO BE: mean2(cos(currtheta{tkplotter}));
             %%%order2{ekplotter}(tkplotter) = nanmean(nanmean(cos(currtheta2{tkplotter}))); %UPDATED from MEAN2() TO NANMEAN(NANMEAN()) -- USED TO BE: mean2(cos(currtheta{tkplotter}));
              orderY{ekplotter}(tkplotter) = nanmean(nanmean(sin(currtheta{tkplotter}))); %UPDATED from MEAN2() TO NANMEAN(NANMEAN()) -- USED TO BE: mean2(cos(currtheta{tkplotter}));
              orderY2{ekplotter}(tkplotter) = nanmean(nanmean(sin(currtheta2{tkplotter}))); %UPDATED from MEAN2() TO NANMEAN(NANMEAN()) -- USED TO BE: mean2(cos(currtheta{tkplotter}));
            %%%orderABSyForOrderX{ekplotter}(tkplotter) = nanmean(nanmean(cos(currthetaABSyForOrderX{tkplotter}))); %UPDATED from MEAN2() TO NANMEAN(NANMEAN()) -- USED TO BE: mean2(cos(currtheta{tkplotter}));
              %%%orderABSxForOrderY{ekplotter}(tkplotter) = nanmean(nanmean(sin(currtheta2ABSxForOrderY{tkplotter}))); %UPDATED from MEAN2() TO NANMEAN(NANMEAN()) -- USED TO BE: mean2(cos(currtheta{tkplotter}));
            speed{ekplotter}(tkplotter) = nanmean(nanmean((sqrt(v_filtered{tkplotter}.^2+u_filtered{tkplotter}.^2))));  %UPDATED from MEAN2() TO NANMEAN(NANMEAN()) -- USED TO BE:  mean2(sqrt(v_filtered{tkplotter}.^2+u_filtered{tkplotter}.^2));   
            vxmean{ekplotter}(tkplotter) = nanmean(nanmean(u_filtered{tkplotter}));
            vymean{ekplotter}(tkplotter) = nanmean(nanmean(v_filtered{tkplotter}));
            vxABSmean{ekplotter}(tkplotter) = nanmean(nanmean(abs(u_filtered{tkplotter})));
            vyABSmean{ekplotter}(tkplotter) = nanmean(nanmean(abs(v_filtered{tkplotter})));
            currentexptlengthtracker(end+1)=length(u_filtered);
        end
        thetas{ekplotter} = currtheta;
        thetas2{ekplotter} = currtheta2;
        %%%thetasABSyForOrderX = currthetaABSyForOrderX; thetas2ABSxForOrderY = currtheta2ABSxForOrderY;
%         % hard-coded exclusion for 1-5v1at1_piv at t=100 min, index=9
%         if strcmp(exps{ekplotter}, '5v4at1_piv')
%             order{ekplotter} = -order{ekplotter};
%         end
%         if strcmp(exps{ekplotter}, '5v4at2_piv')
%             order{ekplotter} = -order{ekplotter};
%         end
%         if strcmp(exps{ekplotter},'1-5v1at1_piv')
%             order{ekplotter}(10) = nan;
%             speed{ekplotter}(10) = nan;
%         end
%         if strcmp(exps{ekplotter},'1v1at2_piv')
%             order{ekplotter}(25) = nan;
%             speed{ekplotter}(25) = nan;
%         end
%         if strcmp(exps{ekplotter},'1v1at2_piv')
%             order{ekplotter}(41) = nan;
%             speed{ekplotter}(41) = nan;
%         end
    end

    fig3001=figure(3001);
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         shaded_error(t,order{ek},order_err{ek},'blue',0.4); hold on;
%     end

    % attempt to get the mean out
        currentmaxexptlength=max(currentexptlengthtracker);
    orderavg=nan(length(exps),currentmaxexptlength);%[];
     orderYavg=nan(length(exps),currentmaxexptlength);%[];
    %%%order2avg=nan(length(exps),currentmaxexptlength);%[];
     orderY2avg=nan(length(exps),currentmaxexptlength);%[];
    %%%orderABSyForOrderXavg=nan(length(exps),currentmaxexptlength);%[];
     %%%orderABSxForOrderYavg=nan(length(exps),currentmaxexptlength);%[];
    speedavg=nan(length(exps),currentmaxexptlength);%[];
    vxmeanavg=nan(length(exps),currentmaxexptlength);%[];
    vymeanavg=nan(length(exps),currentmaxexptlength);%[];
    vxABSmeanavg=nan(length(exps),currentmaxexptlength);%[];
    vyABSmeanavg=nan(length(exps),currentmaxexptlength);%[];
    for ekplotter=1:length(exps)
        orderavg(ekplotter,1:length(order{ekplotter})) = order{ekplotter}; %important to note: only through ekplotter is the variable valid! further than that are old values!!   
         orderYavg(ekplotter,1:length(orderY{ekplotter})) = orderY{ekplotter}; %important to note: only through ekplotter is the variable valid! further than that are old values!!   
        %%%order2avg(ekplotter,1:length(order2{ekplotter})) = order2{ekplotter}; %important to note: only through ekplotter is the variable valid! further than that are old values!!   
         orderY2avg(ekplotter,1:length(orderY2{ekplotter})) = orderY2{ekplotter}; %important to note: only through ekplotter is the variable valid! further than that are old values!!   
        %%%orderABSyForOrderXavg(ekplotter,1:length(orderABSyForOrderX{ekplotter})) = orderABSyForOrderX{ekplotter};
         %%%orderABSxForOrderYavg(ekplotter,1:length(orderABSxForOrderY{ekplotter})) = orderABSxForOrderY{ekplotter};
        speedavg(ekplotter,1:length(order{ekplotter})) = speed{ekplotter};
        vxmeanavg(ekplotter,1:length(order{ekplotter})) = vxmean{ekplotter};
        vymeanavg(ekplotter,1:length(order{ekplotter})) = vymean{ekplotter};
        vxABSmeanavg(ekplotter,1:length(order{ekplotter})) = vxABSmean{ekplotter};
        vyABSmeanavg(ekplotter,1:length(order{ekplotter})) = vyABSmean{ekplotter};
    end
    timeplotter = (1:length(thetas{ekplotter}))*minperframe/60; %update from minutes to hours!

    plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(orderavg),'movmedian',3,'omitnan'),smoothdata(nanstd(orderavg),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
        %was--without smoothdata--shaded_error_wLineStyle_Width3(timeplotter,nanmean(orderavg),nanstd(orderavg),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting

if voltages==lastVoltageToPlot %only plot this once!
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[-0.9 -0.9], {'Field On', 'Field Off'},'VerticalAlignment','top'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');
end
    % %legend business
    % LH(1) = plot(nan, nan, '*-r','LineWidth',3,'MarkerSize',10);
    % L{1} = 'Order Parameter, \phi';
    % legend(LH,L)

%% ZOOMED-IN ORDER PARAMETER GRAPH, without stdev shading and without controls!
if voltages<3
    fig13001=figure(13001); hold on;
    %slightly diff than smoothdata for the ENTIRE vector together!--ah!--update with 2 lines below-->shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),smoothdata(nanmean(orderavg(:,24:setexptgraphinglength)),'movmedian',3,'omitnan'),0,color,alphavalue,linestyle);
        tempsmoothdataplotter=smoothdata(nanmean(orderavg(:,:)),'movmedian',3,'omitnan'); %now can use only tempsmoothdataplotter(:,24:setexptgraphinglength) of this vector...
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),tempsmoothdataplotter(:,24:setexptgraphinglength),0,color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-0.2 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
        currentaxesSmallerPanel=gca; currentaxesSmallerPanel.FontSize=32; %update font sizes for graph panels!--smaller plots needed smaller font here!
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
    %plot([-1000 1000],[0 0],'k');
    %xline(0,'k-');
    yline(0,':','LineWidth',1.5,'Color','k'); %yline(0,'-','LineWidth',1.5,'Color',color); %yline(0,'k:');   
            currentylim=ylim;
    if voltages==2 %only plot this once!
        % annotations
        line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        text([62/60 242/60],[currentylim(1) currentylim(1)], {'Field On', 'Field Off'},'VerticalAlignment','bottom'); %text([62/60 242/60],[1 1], {'Field On', 'Field Off'},'VerticalAlignment','top'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');
    end  
  xlim([238/60 xlimendgraphs]); %xlim([240 xlimendgraphs]);
  
      fig13002=figure(13002); hold on; %Replaced the below line with 0 in for the stdev!!
    %slightly diff than smoothdata for the ENTIRE vector together!--ah!--update with 2 lines below-->shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),smoothdata(nanmean(vxABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan'),0,color,alphavalue,linestyle);
        clearvars tempsmoothdataplotter
        tempsmoothdataplotter=smoothdata(nanmean(vxABSmeanavg(:,:))*6*1.308,'movmedian',3,'omitnan'); %now can use only tempsmoothdataplotter(:,24:setexptgraphinglength) of this vector...
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),tempsmoothdataplotter(:,24:setexptgraphinglength),0,color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
     ylim([0 40]) %ylim([0 33]) %set ylim to match the data best here! make panels pretty! 
    xlabel('Time (h)');
    ylabel('Mean |Vx| (\mum/h)') %(\mumh^{-1})
        currentaxesSmallerPanel=gca; currentaxesSmallerPanel.FontSize=32; %update font sizes for graph panels!--smaller plots needed smaller font here!
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==2
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(1) currentylim(1)], {'Field On', 'Field Off'},'VerticalAlignment','bottom');
end
  xlim([238/60 xlimendgraphs]); %xlim([240 xlimendgraphs]);

    fig13003=figure(13003); hold on; %Replaced the below line with 0 in for the stdev!!
    %slightly diff than smoothdata for the ENTIRE vector together!--ah!--update with 2 lines below-->shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan'),0,color,alphavalue,linestyle);
        clearvars tempsmoothdataplotter
        tempsmoothdataplotter=smoothdata(nanmean(vyABSmeanavg(:,:))*6*1.308,'movmedian',3,'omitnan'); %now can use only tempsmoothdataplotter(:,24:setexptgraphinglength) of this vector...
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),tempsmoothdataplotter(:,24:setexptgraphinglength),0,color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
     ylim([3 10]) %set ylim to match the data best here! make panels pretty!
    xlabel('Time (h)');
    ylabel('Mean |Vy| (\mum/h)') %(\mumh^{-1})
        currentaxesSmallerPanel=gca; currentaxesSmallerPanel.FontSize=32; %update font sizes for graph panels!--smaller plots needed smaller font here!
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
    if voltages==2
        % annotations
        line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        text([62/60 242/60],[currentylim(1) currentylim(1)], {'Field On', 'Field Off'},'VerticalAlignment','bottom');
    end
  xlim([238/60 xlimendgraphs]); %xlim([240 xlimendgraphs]);

   fig13004=figure(13004); hold on; %Replaced the below line with 0 in for the stdev!!
    %slightly diff than smoothdata for the ENTIRE vector together!--ah!--update with 2 lines below-->shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan'),0,color,alphavalue,linestyle);
        clearvars tempsmoothdataplotter
        tempsmoothdataplotter=smoothdata(nanmean(speedavg(:,:))*6*1.308,'movmedian',3,'omitnan'); %now can use only tempsmoothdataplotter(:,24:setexptgraphinglength) of this vector...
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),tempsmoothdataplotter(:,24:setexptgraphinglength),0,color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
     ylim([0 40]) %set ylim to match the data best here! make panels pretty!
    xlabel('Time (h)');
    ylabel('Mean Speed (\mum/h)') %(\mumh^{-1})
        currentaxesSmallerPanel=gca; currentaxesSmallerPanel.FontSize=32; %update font sizes for graph panels!--smaller plots needed smaller font here!
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
    if voltages==2
        % annotations
        line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        text([62/60 242/60],[currentylim(1) currentylim(1)], {'Field On', 'Field Off'},'VerticalAlignment','bottom');
    end
  xlim([238/60 xlimendgraphs]); %xlim([240 xlimendgraphs]);
  set(gcf, 'Position', [10 50 825 575]); %added for SMALLER figure panels!
  
end

%%
        if voltages==0
                        currentcolorbeforeswapping = color; %save it, to switch back
fig10001=figure(10001); hold on;
yyaxis left
  currdoubaxis = gca;
  %currdoubaxis.YAxis(1).Color = color;
  %currdoubaxis.YAxis(2).Color = color;
                        color = 'b'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(1).Color = color;
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(orderavg),'movmedian',3,'omitnan'),smoothdata(nanstd(orderavg),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
        %was--without smoothdata--shaded_error_wLineStyle_Width3(timeplotter,nanmean(orderavg),nanstd(orderavg),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-0.2 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
  %plot([-1000 1000],[0 0],'k');
  
        %xline(0,'k-');
        yline(0,':','LineWidth',1.5,'Color','k'); %yline(0,'-','LineWidth',1.5,'Color',color);
      currentylim2axes=ylim;
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim2axes(1) currentylim2axes(1)], {'Field On', 'Field Off'},'VerticalAlignment','Bottom'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');
    
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(2).Color = color;
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vxABSmeanavg)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vxABSmeanavg)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    ylabel('Mean |Vx| (\mum/h)')
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        end
        
        if voltages==3
                        currentcolorbeforeswapping = color; %save it, to switch back
figure(fig10001);
yyaxis left
                        color = 'b'; %ColorScheme Update!  'k';
                        color = [0 0 0.8]; %update for a more gray-like blue! darker/duller 
                      currdoubaxis.YAxis(1).Color = [0 0 0.9];
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(orderavg),'movmedian',3,'omitnan'),smoothdata(nanstd(orderavg),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
                        color = [0.15 0.15 0.15]; %update for more gray instead of black!
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vxABSmeanavg)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vxABSmeanavg)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        end
    
%%
%   fig4001=figure(4001); hold on;
%     plot([-1000 1000],[0 0],'k');
%     shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(order2avg),'movmedian',3,'omitnan'),smoothdata(nanstd(order2avg),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
%     xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
%     xlim([0 xlimendgraphs]);
%     ylim([-1.0 1.0])
%     xlabel('Time (h)');
%     ylabel('Order Parameter for *Positive* v_filtered, \phi')
%     ytickformat('%.1f');
%     set(gca,'TickDir','out')
%     box on %box off %changed for better EPS exporting
% 
% if voltages==lastVoltageToPlot %only plot this once!
%     % annotations
%     line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
%     line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
%     text([62/60 242/60],[-0.9 -0.9], {'Field On', 'Field Off'},'VerticalAlignment','top'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');
% end


  fig4002=figure(4002); hold on;
    plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(orderYavg),'movmedian',3,'omitnan'),smoothdata(nanstd(orderYavg),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Upward Order Parameter, \phi_{y}')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting

if voltages==lastVoltageToPlot %only plot this once!
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[-0.9 -0.9], {'Field On', 'Field Off'},'VerticalAlignment','top'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


  fig4003=figure(4003); hold on;
    plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(orderY2avg),'movmedian',3,'omitnan'),smoothdata(nanstd(orderY2avg),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Downward Order Parameter, \phi_{y}')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting

if voltages==lastVoltageToPlot %only plot this once!
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[-0.9 -0.9], {'Field On', 'Field Off'},'VerticalAlignment','top'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


%   fig4004=figure(4004); hold on;
%     plot([-1000 1000],[0 0],'k');
%     shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(orderABSyForOrderXavg),'movmedian',3,'omitnan'),smoothdata(nanstd(orderABSyForOrderXavg),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
%     xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
%     xlim([0 xlimendgraphs]);
%     ylim([-1.0 1.0])
%     xlabel('Time (h)');
%      ylabel('Order Parameter in X using "abs(Vy)", \phi_{y}')
%     ytickformat('%.1f');
%     set(gca,'TickDir','out')
%     box on %box off %changed for better EPS exporting
% 
% if voltages==lastVoltageToPlot %only plot this once!
%     % annotations
%     line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
%     line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
%     text([62/60 242/60],[-0.9 -0.9], {'Field On', 'Field Off'},'VerticalAlignment','top'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');
% end


%   fig4005=figure(4005); hold on;
%     plot([-1000 1000],[0 0],'k');
%     shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(orderABSxForOrderYavg),'movmedian',3,'omitnan'),smoothdata(nanstd(orderABSxForOrderYavg),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
%     xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
%     xlim([0 xlimendgraphs]);
%     ylim([-1.0 1.0])
%     xlabel('Time (h)');
%      ylabel('Order Parameter in Y using "abs(Vx)" & "+Vy", \phi_{y}')
%     ytickformat('%.1f');
%     set(gca,'TickDir','out')
%     box on %box off %changed for better EPS exporting
% 
% if voltages==lastVoltageToPlot %only plot this once!
%     % annotations
%     line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
%     line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
%     text([62/60 242/60],[-0.9 -0.9], {'Field On', 'Field Off'},'VerticalAlignment','top'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');
% end

    
    fig3002=figure(3002); hold on;
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(speedavg)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(speedavg)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('|v| (\mum/h)') %ylabel('|v| (\mumh^{-1})')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


    fig3003=figure(3003); hold on;
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vxmeanavg)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vxmeanavg)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean Vx (\mum/h)') %(\mumh^{-1})
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


    fig3004=figure(3004); hold on;
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
          %line below HERE assumes CONTROL period ends at 6 (as do the lines marking 'Field On')                
          controlNormalizeValueSpeedAVG = nanmean(speedavg(:,6));  if (isnan(controlNormalizeValueSpeedAVG))     controlNormalizeValueSpeedAVG=0;    end
        %change to ratio below!--%  controlNormalizeValueSpeedSTD = nanstd(speedavg(:,6));  if (controlNormalizeValueSpeedSTD==NaN)     controlNormalizeValueSpeedSTD=0;    end    %this is not really needed because shaded error will just plot NaN as zero kinda, but this is most correct mathematically.
    %shaded_error_wLineStyle_Width3(timeplotter,nanmean(speedavg)/controlNormalizeValueSpeedAVG,nanstd(speedavg).*(controlNormalizeValueSpeedAVG./nanmean(speedavg)),color,alphavalue,linestyle);
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(speedavg)/controlNormalizeValueSpeedAVG,'movmedian',3,'omitnan'),smoothdata(nanstd(speedavg/controlNormalizeValueSpeedAVG),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('|v| / |v_{Ctrl}|') %ylabel('|v| / |v_{E-Stim-On}|')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end

    fig3005=figure(3005); hold on;
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
          %line below HERE assumes CONTROL period ends at 6 (as do the lines marking 'Field On')                
          controlNormalizeValueSpeed1to6AVG = nanmean(nanmean(speedavg(:,1:6)));  if (isnan(controlNormalizeValueSpeed1to6AVG))     controlNormalizeValueSpeed1to6AVG=0;    end
        %change to ratio below!--%  controlNormalizeValueSpeedSTD = nanstd(speedavg(:,6));  if (controlNormalizeValueSpeedSTD==NaN)     controlNormalizeValueSpeedSTD=0;    end    %this is not really needed because shaded error will just plot NaN as zero kinda, but this is most correct mathematically.
    %shaded_error_wLineStyle_Width3(timeplotter,nanmean(speedavg)/controlNormalizeValueSpeed1to6AVG,nanstd(speedavg).*(controlNormalizeValueSpeed1to6AVG./nanmean(speedavg)),color,alphavalue,linestyle);
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(speedavg)/controlNormalizeValueSpeed1to6AVG,'movmedian',3,'omitnan'),smoothdata(nanstd(speedavg/controlNormalizeValueSpeed1to6AVG),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('|v| / |v_{AvgCtrl}|') %ylabel('|v| / |v_{E-Stim-On}|')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


    fig3006=figure(3006); hold on;
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
          %line below HERE assumes CONTROL period ends at 6 (as do the lines marking 'Field On')                
          controlNormalizeValueVxMeanAVG = controlNormalizeValueSpeedAVG;%USE SPEED INSTEAD B/C MORE FAIR?--abs(nanmean(vxmeanavg(:,6)));  if (controlNormalizeValueVxMeanAVG==NaN)     controlNormalizeValueVxMeanAVG=0;    end
        %change to ratio below!--%  controlNormalizeValueVxMeanSTD = controlNormalizeValueSpeedSTD;%%USE SPEED INSTEAD B/C MORE FAIR?--abs(nanstd(vxmeanavg(:,6)));  if (controlNormalizeValueVxMeanSTD==NaN)     controlNormalizeValueVxMeanSTD=0;    end    %this is not really needed because shaded error will just plot NaN as zero kinda, but this is most correct mathematically.
    %shaded_error_wLineStyle_Width3(timeplotter,nanmean(vxmeanavg)/controlNormalizeValueVxMeanAVG,nanstd(vxmeanavg).*(controlNormalizeValueVxMeanAVG./nanmean(vxmeanavg)),color,alphavalue,linestyle);
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vxmeanavg)/controlNormalizeValueVxMeanAVG,'movmedian',3,'omitnan'),smoothdata(nanstd(vxmeanavg/controlNormalizeValueVxMeanAVG),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean Vx / |V_{Ctrl}|')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


    fig3007=figure(3007); hold on;
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
          %line below HERE assumes CONTROL period ends at 6 (as do the lines marking 'Field On')                
          controlNormalizeValueVxMean1to6AVG = controlNormalizeValueSpeed1to6AVG;%USE SPEED INSTEAD B/C MORE FAIR?--abs(nanmean(vxmeanavg(:,1:6)));  if (controlNormalizeValueVxMean1to6AVG==NaN)     controlNormalizeValueVxMean1to6AVG=0;    end
        %change to ratio below!--%  controlNormalizeValueVxMeanSTD = controlNormalizeValueSpeedSTD;%%USE SPEED INSTEAD B/C MORE FAIR?--abs(nanstd(vxmeanavg(:,6)));  if (controlNormalizeValueVxMeanSTD==NaN)     controlNormalizeValueVxMeanSTD=0;    end    %this is not really needed because shaded error will just plot NaN as zero kinda, but this is most correct mathematically.
    %shaded_error_wLineStyle_Width3(timeplotter,nanmean(vxmeanavg)/controlNormalizeValueVxMean1to6AVG,nanstd(vxmeanavg).*(controlNormalizeValueVxMean1to6AVG./nanmean(vxmeanavg)),color,alphavalue,linestyle);
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vxmeanavg)/controlNormalizeValueVxMean1to6AVG,'movmedian',3,'omitnan'),smoothdata(nanstd(vxmeanavg/controlNormalizeValueVxMean1to6AVG),'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean Vx / |V_{AvgCtrl}|')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


    fig3011=figure(3011);
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vymeanavg)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vymeanavg)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean Vy (\mum/h)') %(\mumh^{-1})
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


    fig3012=figure(3012);
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vxABSmeanavg)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vxABSmeanavg)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean |Vx| (\mum/h)') %(\mumh^{-1})
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end

    fig3013=figure(3013);
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vyABSmeanavg)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vyABSmeanavg)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean |Vy| (\mum/h)') %(\mumh^{-1})
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end

%%Normalizations for Mean ABS Vx and Mean ABS Vy:
        %ADD NORMALIZATION NOW THAT IT HAS A NON-ZERO VALUE because of the ABS!    
        controlNormalizeValueMeanABSVX1to6AVG = nanmean(nanmean(vxABSmeanavg(:,1:6)));  if (isnan(controlNormalizeValueMeanABSVX1to6AVG))     controlNormalizeValueMeanABSVX1to6AVG=0;    end
        %ADD NORMALIZATION NOW THAT IT HAS A NON-ZERO VALUE because of the ABS!    
        controlNormalizeValueMeanABSVX6AVG = nanmean(nanmean(vxABSmeanavg(:,6)));  if (isnan(controlNormalizeValueMeanABSVX6AVG))     controlNormalizeValueMeanABSVX6AVG=0;    end
        %ADD NORMALIZATION NOW THAT IT HAS A NON-ZERO VALUE because of the ABS!    
        controlNormalizeValueMeanABSVy1to6AVG = nanmean(nanmean(vyABSmeanavg(:,1:6)));  if (isnan(controlNormalizeValueMeanABSVy1to6AVG))     controlNormalizeValueMeanABSVy1to6AVG=0;    end
        %ADD NORMALIZATION NOW THAT IT HAS A NON-ZERO VALUE because of the ABS!    
        controlNormalizeValueMeanABSVy6AVG = nanmean(nanmean(vyABSmeanavg(:,6)));  if (isnan(controlNormalizeValueMeanABSVy6AVG))     controlNormalizeValueMeanABSVy6AVG=0;    end

   fig5012=figure(5012);
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vxABSmeanavg/controlNormalizeValueMeanABSVX1to6AVG)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vxABSmeanavg/controlNormalizeValueMeanABSVX1to6AVG)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean |Vx| / |Vx_{AvgCtrl}|')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations figure
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end

    fig5013=figure(5013);
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vyABSmeanavg/controlNormalizeValueMeanABSVy1to6AVG)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vyABSmeanavg/controlNormalizeValueMeanABSVy1to6AVG)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean |Vy| / |Vy_{AvgCtrl}|')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end


   fig6012=figure(6012);
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vxABSmeanavg/controlNormalizeValueMeanABSVX6AVG)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vxABSmeanavg/controlNormalizeValueMeanABSVX6AVG)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean |Vx| / |Vx_{Ctrl}|')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end

    fig6013=figure(6013);
%     for ek=1:length(exps)
%         t = (1:length(thetas{ek}))*minperframe;
%         plot(t,speed{ek}*6*1.308,'bx'); hold on;
%     end
    % plot([-1000 1000],[0 0],'k');
    shaded_error_wLineStyle_Width3(timeplotter,smoothdata(nanmean(vyABSmeanavg/controlNormalizeValueMeanABSVy6AVG)*6*1.308,'movmedian',3,'omitnan'),smoothdata(nanstd(vyABSmeanavg/controlNormalizeValueMeanABSVy6AVG)*6*1.308,'movmedian',3,'omitnan'),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    % ylim([-.4 1.2])
    xlabel('Time (h)');
    ylabel('Mean |Vy| / |Vy_{Ctrl}|')
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
if voltages==lastVoltageToPlot
    % annotations
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim(2) currentylim(2)], {'Field On', 'Field Off'},'VerticalAlignment','top');
end

%% add: save each individual tissue for analysis after if desired!

   if voltages==0 %Medium Stim
       STIMexpts_MediumDens_orderavg=orderavg;
       STIMexpts_MediumDens_speedavg=speedavg*6*1.308;
       STIMexpts_MediumDens_vxmeanavg=vxmeanavg*6*1.308;
       STIMexpts_MediumDens_vymeanavg=vymeanavg*6*1.308;
       STIMexpts_MediumDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       STIMexpts_MediumDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        STIMexpts_MediumDens_orderYavg=orderYavg;
        STIMexpts_MediumDens_orderY2avg=orderY2avg;
        %writetable(Table,filename);
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensityEachAvgSTIMExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_MediumDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_MediumDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_MediumDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_MediumDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_MediumDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_MediumDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
    elseif voltages==1 %HIGH
       STIMexpts_HighDens_orderavg=orderavg;
       STIMexpts_HighDens_speedavg=speedavg*6*1.308;
       STIMexpts_HighDens_vxmeanavg=vxmeanavg*6*1.308;
       STIMexpts_HighDens_vymeanavg=vymeanavg*6*1.308;
       STIMexpts_HighDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       STIMexpts_HighDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        STIMexpts_HighDens_orderYavg=orderYavg;
        STIMexpts_HighDens_orderY2avg=orderY2avg;
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','HighDensityEachAvgSTIMExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_HighDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_HighDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_HighDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_HighDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_HighDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_HighDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
    elseif voltages==2 %LOW
       STIMexpts_LowDens_orderavg=orderavg;
       STIMexpts_LowDens_speedavg=speedavg*6*1.308;
       STIMexpts_LowDens_vxmeanavg=vxmeanavg*6*1.308;
       STIMexpts_LowDens_vymeanavg=vymeanavg*6*1.308;
       STIMexpts_LowDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       STIMexpts_LowDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        STIMexpts_LowDens_orderYavg=orderYavg;
        STIMexpts_LowDens_orderY2avg=orderY2avg;
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','LowDensityEachAvgSTIMExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_LowDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_LowDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_LowDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_LowDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_LowDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_LowDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
    elseif voltages==3 %Medium controls
       CTRLs_MediumDens_orderavg=orderavg;
       CTRLs_MediumDens_speedavg=speedavg*6*1.308;
       CTRLs_MediumDens_vxmeanavg=vxmeanavg*6*1.308;
       CTRLs_MediumDens_vymeanavg=vymeanavg*6*1.308;
       CTRLs_MediumDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       CTRLs_MediumDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        CTRLs_MediumDens_orderYavg=orderYavg;
        CTRLs_MediumDens_orderY2avg=orderY2avg;
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensityEachAvgCONTROLExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_MediumDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_MediumDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_MediumDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_MediumDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_MediumDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_MediumDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
    elseif voltages==4 %High Controls
       CTRLs_HighDens_orderavg=orderavg;
       CTRLs_HighDens_speedavg=speedavg*6*1.308;
       CTRLs_HighDens_vxmeanavg=vxmeanavg*6*1.308;
       CTRLs_HighDens_vymeanavg=vymeanavg*6*1.308;
       CTRLs_HighDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       CTRLs_HighDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        CTRLs_HighDens_orderYavg=orderYavg;
        CTRLs_HighDens_orderY2avg=orderY2avg;
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','HighDensityEachAvgCONTROLExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_HighDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_HighDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_HighDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_HighDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_HighDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_HighDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
    elseif voltages==5 %Low Controls
       CTRLs_LowDens_orderavg=orderavg;
       CTRLs_LowDens_speedavg=speedavg*6*1.308;
       CTRLs_LowDens_vxmeanavg=vxmeanavg*6*1.308;
       CTRLs_LowDens_vymeanavg=vymeanavg*6*1.308;
       CTRLs_LowDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       CTRLs_LowDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        CTRLs_LowDens_orderYavg=orderYavg;
        CTRLs_LowDens_orderY2avg=orderY2avg;
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','LowDensityEachAvgCONTROLExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_LowDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_LowDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_LowDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_LowDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_LowDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_LowDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
   elseif voltages==6 %&& plotTheEGTAalso==1
       EGTAexpts_KindaLowDens_orderavg=orderavg;
       EGTAexpts_KindaLowDens_speedavg=speedavg*6*1.308;
       EGTAexpts_KindaLowDens_vxmeanavg=vxmeanavg*6*1.308;
       EGTAexpts_KindaLowDens_vymeanavg=vymeanavg*6*1.308;
       EGTAexpts_KindaLowDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       EGTAexpts_KindaLowDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        EGTAexpts_KindaLowDens_orderYavg=orderYavg;
        EGTAexpts_KindaLowDens_orderY2avg=orderY2avg;
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','EGTAEachAvgEGTAExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,EGTAexpts_KindaLowDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,EGTAexpts_KindaLowDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,EGTAexpts_KindaLowDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,EGTAexpts_KindaLowDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,EGTAexpts_KindaLowDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,EGTAexpts_KindaLowDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
  elseif voltages==7 %MAGENTA TRANSITION DENSITY EXPTS:
       STIMexpts_TransitionDens_orderavg=orderavg;
       STIMexpts_TransitionDens_speedavg=speedavg*6*1.308;
       STIMexpts_TransitionDens_vxmeanavg=vxmeanavg*6*1.308;
       STIMexpts_TransitionDens_vymeanavg=vymeanavg*6*1.308;
       STIMexpts_TransitionDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       STIMexpts_TransitionDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        STIMexpts_TransitionDens_orderYavg=orderYavg;
        STIMexpts_TransitionDens_orderY2avg=orderY2avg;
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','TransitionDensityEachAvgSTIMExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_TransitionDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_TransitionDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_TransitionDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_TransitionDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_TransitionDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,STIMexpts_TransitionDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
  elseif voltages==8 %MAGENTA TRANSITION DENSITY CONTROLS:
       CTRLs_TransitionDens_orderavg=orderavg;
       CTRLs_TransitionDens_speedavg=speedavg*6*1.308;
       CTRLs_TransitionDens_vxmeanavg=vxmeanavg*6*1.308;
       CTRLs_TransitionDens_vymeanavg=vymeanavg*6*1.308;
       CTRLs_TransitionDens_vxABSmeanavg=vxABSmeanavg*6*1.308;
       CTRLs_TransitionDens_vyABSmeanavg=vyABSmeanavg*6*1.308;
        CTRLs_TransitionDens_orderYavg=orderYavg;
        CTRLs_TransitionDens_orderY2avg=orderY2avg;
            %xlswrite(filename,A,sheet,xlRange) writes to the specified worksheet and range.
            xlsSAVEsummaryfilenameEachNData=strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','TransitionDensityEachAvgCONTROLExpt--run--',date,'.xlsx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_TransitionDens_orderavg,'Order Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_TransitionDens_speedavg,'Speed Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_TransitionDens_vxmeanavg,'Mean Vx');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_TransitionDens_vymeanavg,'Mean Vy');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_TransitionDens_vxABSmeanavg,'ABS Vx Avg');
            xlswrite(xlsSAVEsummaryfilenameEachNData,CTRLs_TransitionDens_vyABSmeanavg,'ABS Vy Avg');
             %add info on the first tab, at the end of all the above, so that this tab is the last to be touched and hence the first one sees when opening the file!    
             xlswrite(xlsSAVEsummaryfilenameEachNData,{'Read me tab…'; 'Each tab has a different variable.'; 'Each row represents a different experiment.'; 'The data goes across time, to the right. It starts at 10 minutes and runs through the end of each experiment. Exported NaNs show up as blanks.'},'Sheet1');
    end

%% add small section to save the values for each plotted graph:
orderALLavg(voltages+1,1:size(orderavg,2)) = nanmean(orderavg); %needed the voltages+1 because voltages starts counting at zero!
orderALLstd(voltages+1,1:size(orderavg,2)) = nanstd(orderavg);
    %%%order2ALLavg(voltages+1,1:size(order2avg,2)) = nanmean(order2avg); %needed the voltages+1 because voltages starts counting at zero!
    %%%order2ALLstd(voltages+1,1:size(order2avg,2)) = nanstd(order2avg);
  orderYALLavg(voltages+1,1:size(orderYavg,2)) = nanmean(orderYavg); %needed the voltages+1 because voltages starts counting at zero!
  orderYALLstd(voltages+1,1:size(orderYavg,2)) = nanstd(orderYavg);
      orderY2ALLavg(voltages+1,1:size(orderY2avg,2)) = nanmean(orderY2avg); %needed the voltages+1 because voltages starts counting at zero!
      orderY2ALLstd(voltages+1,1:size(orderY2avg,2)) = nanstd(orderY2avg);
 %%%orderALL_ABSyForOrderXavg(voltages+1,1:size(orderABSyForOrderXavg,2)) = nanmean(orderABSyForOrderXavg); %needed the voltages+1 because voltages starts counting at zero!
 %%%orderALL_ABSyForOrderXstd(voltages+1,1:size(orderABSyForOrderXavg,2)) = nanstd(orderABSyForOrderXavg);
       %%%orderALL_ABSxForOrderYavg(voltages+1,1:size(orderABSxForOrderYavg,2)) = nanmean(orderABSxForOrderYavg); %needed the voltages+1 because voltages starts counting at zero!
       %%%orderALL_ABSxForOrderYstd(voltages+1,1:size(orderABSxForOrderYavg,2)) = nanstd(orderABSxForOrderYavg);

speedALLavg(voltages+1,1:size(speedavg,2)) = nanmean(speedavg)*6*1.308;
speedALLstd(voltages+1,1:size(speedavg,2)) = nanstd(speedavg)*6*1.308;

vxmeanALLavg(voltages+1,1:size(vxmeanavg,2)) = nanmean(vxmeanavg)*6*1.308;
vxmeanALLstd(voltages+1,1:size(vxmeanavg,2)) = nanstd(vxmeanavg)*6*1.308;

vymeanALLavg(voltages+1,1:size(vymeanavg,2)) = nanmean(vymeanavg)*6*1.308;
vymeanALLstd(voltages+1,1:size(vymeanavg,2)) = nanstd(vymeanavg)*6*1.308;

vxABSmeanALLavg(voltages+1,1:size(vxABSmeanavg,2)) = nanmean(vxABSmeanavg)*6*1.308;
vxABSmeanALLstd(voltages+1,1:size(vxABSmeanavg,2)) = nanstd(vxABSmeanavg)*6*1.308;

vyABSmeanALLavg(voltages+1,1:size(vyABSmeanavg,2)) = nanmean(vyABSmeanavg)*6*1.308;
vyABSmeanALLstd(voltages+1,1:size(vyABSmeanavg,2)) = nanstd(vyABSmeanavg)*6*1.308;
 %and the smoothed versions of all those:
 %smoothdata(   ,'movmedian',3,'omitnan')
SmoothMovMed3_orderALLavg(voltages+1,1:size(orderavg,2)) = smoothdata(nanmean(orderavg),'movmedian',3,'omitnan'); %needed the voltages+1 because voltages starts counting at zero!
SmoothMovMed3_orderALLstd(voltages+1,1:size(orderavg,2)) = smoothdata(nanstd(orderavg),'movmedian',3,'omitnan');
    %%%SmoothMovMed3_order2ALLavg(voltages+1,1:size(order2avg,2)) = smoothdata(nanmean(order2avg),'movmedian',3,'omitnan'); %needed the voltages+1 because voltages starts counting at zero!
    %%%SmoothMovMed3_order2ALLstd(voltages+1,1:size(order2avg,2)) = smoothdata(nanstd(order2avg),'movmedian',3,'omitnan');
  SmoothMovMed3_orderYALLavg(voltages+1,1:size(orderYavg,2)) = smoothdata(nanmean(orderYavg),'movmedian',3,'omitnan'); %needed the voltages+1 because voltages starts counting at zero!
  SmoothMovMed3_orderYALLstd(voltages+1,1:size(orderYavg,2)) = smoothdata(nanstd(orderYavg),'movmedian',3,'omitnan');
      SmoothMovMed3_orderY2ALLavg(voltages+1,1:size(orderY2avg,2)) = smoothdata(nanmean(orderY2avg),'movmedian',3,'omitnan'); %needed the voltages+1 because voltages starts counting at zero!
      SmoothMovMed3_orderY2ALLstd(voltages+1,1:size(orderY2avg,2)) = smoothdata(nanstd(orderY2avg),'movmedian',3,'omitnan'); 
    %%%SmoothMovMed3_orderALL_ABSyForOrderXavg(voltages+1,1:size(orderABSyForOrderXavg,2)) = smoothdata(nanmean(orderABSyForOrderXavg),'movmedian',3,'omitnan'); %needed the voltages+1 because voltages starts counting at zero!
    %%%SmoothMovMed3_orderALL_ABSyForOrderXstd(voltages+1,1:size(orderABSyForOrderXavg,2)) = smoothdata(nanstd(orderABSyForOrderXavg),'movmedian',3,'omitnan');
          %%%SmoothMovMed3_orderALL_ABSxForOrderYavg(voltages+1,1:size(orderABSxForOrderYavg,2)) = smoothdata(nanmean(orderABSxForOrderYavg),'movmedian',3,'omitnan'); %needed the voltages+1 because voltages starts counting at zero!
          %%%SmoothMovMed3_orderALL_ABSxForOrderYstd(voltages+1,1:size(orderABSxForOrderYavg,2)) = smoothdata(nanstd(orderABSxForOrderYavg),'movmedian',3,'omitnan');
      
SmoothMovMed3_speedALLavg(voltages+1,1:size(speedavg,2)) = smoothdata(nanmean(speedavg)*6*1.308,'movmedian',3,'omitnan');
SmoothMovMed3_speedALLstd(voltages+1,1:size(speedavg,2)) = smoothdata(nanstd(speedavg)*6*1.308,'movmedian',3,'omitnan');

SmoothMovMed3_vxmeanALLavg(voltages+1,1:size(vxmeanavg,2)) = smoothdata(nanmean(vxmeanavg)*6*1.308,'movmedian',3,'omitnan');
SmoothMovMed3_vxmeanALLstd(voltages+1,1:size(vxmeanavg,2)) = smoothdata(nanstd(vxmeanavg)*6*1.308,'movmedian',3,'omitnan');

SmoothMovMed3_vymeanALLavg(voltages+1,1:size(vymeanavg,2)) = smoothdata(nanmean(vymeanavg)*6*1.308,'movmedian',3,'omitnan');
SmoothMovMed3_vymeanALLstd(voltages+1,1:size(vymeanavg,2)) = smoothdata(nanstd(vymeanavg)*6*1.308,'movmedian',3,'omitnan');

SmoothMovMed3_vxABSmeanALLavg(voltages+1,1:size(vxABSmeanavg,2)) = smoothdata(nanmean(vxABSmeanavg)*6*1.308,'movmedian',3,'omitnan');
SmoothMovMed3_vxABSmeanALLstd(voltages+1,1:size(vxABSmeanavg,2)) = smoothdata(nanstd(vxABSmeanavg)*6*1.308,'movmedian',3,'omitnan');

SmoothMovMed3_vyABSmeanALLavg(voltages+1,1:size(vyABSmeanavg,2)) = smoothdata(nanmean(vyABSmeanavg)*6*1.308,'movmedian',3,'omitnan');
SmoothMovMed3_vyABSmeanALLstd(voltages+1,1:size(vyABSmeanavg,2)) = smoothdata(nanstd(vyABSmeanavg)*6*1.308,'movmedian',3,'omitnan');

% clearvars -except orderALLavg orderALLstd speedALLavg speedALLstd vxmeanALLavg vxmeanALLstd
end
%% SAVE SUMMARY VARIABLES
if type1tosaveSummaryVariables==1
    save Matlab_BULKSUMMARYVARS_after_ONLY_BULK_CODE_withEACHExptDataSummary--run6-01-2021.mat CTRLs_HighDens_orderavg CTRLs_HighDens_orderY2avg CTRLs_HighDens_orderYavg CTRLs_HighDens_speedavg CTRLs_HighDens_vxABSmeanavg CTRLs_HighDens_vxmeanavg CTRLs_HighDens_vyABSmeanavg CTRLs_HighDens_vymeanavg CTRLs_LowDens_orderavg CTRLs_LowDens_orderY2avg CTRLs_LowDens_orderYavg CTRLs_LowDens_speedavg CTRLs_LowDens_vxABSmeanavg CTRLs_LowDens_vxmeanavg CTRLs_LowDens_vyABSmeanavg CTRLs_LowDens_vymeanavg CTRLs_MediumDens_orderavg CTRLs_MediumDens_orderY2avg CTRLs_MediumDens_orderYavg CTRLs_MediumDens_speedavg CTRLs_MediumDens_vxABSmeanavg CTRLs_MediumDens_vxmeanavg CTRLs_MediumDens_vyABSmeanavg CTRLs_MediumDens_vymeanavg SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLavg SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLstd SmoothMovMed3_orderALLavg SmoothMovMed3_orderALLstd SmoothMovMed3_orderY2ALLavg SmoothMovMed3_orderY2ALLstd SmoothMovMed3_orderYALLavg SmoothMovMed3_orderYALLstd SmoothMovMed3_speedALLavg SmoothMovMed3_speedALLstd SmoothMovMed3_vxABSmeanALLavg SmoothMovMed3_vxmeanALLavg SmoothMovMed3_vxmeanALLstd SmoothMovMed3_vxABSmeanALLstd SmoothMovMed3_vyABSmeanALLavg SmoothMovMed3_vyABSmeanALLstd SmoothMovMed3_vymeanALLavg SmoothMovMed3_vymeanALLstd STIMexpts_MediumDens_vymeanavg STIMexpts_MediumDens_vyABSmeanavg STIMexpts_MediumDens_vxmeanavg STIMexpts_MediumDens_vxABSmeanavg STIMexpts_MediumDens_orderYavg STIMexpts_LowDens_vxmeanavg STIMexpts_LowDens_speedavg STIMexpts_HighDens_vymeanavg STIMexpts_HighDens_vyABSmeanavg STIMexpts_HighDens_vxABSmeanavg STIMexpts_HighDens_vxmeanavg STIMexpts_LowDens_orderavg STIMexpts_LowDens_orderYavg STIMexpts_LowDens_orderY2avg STIMexpts_LowDens_vxABSmeanavg STIMexpts_LowDens_vymeanavg STIMexpts_MediumDens_orderavg STIMexpts_MediumDens_orderY2avg STIMexpts_MediumDens_speedavg STIMexpts_LowDens_vyABSmeanavg STIMexpts_HighDens_speedavg STIMexpts_HighDens_orderYavg STIMexpts_HighDens_orderavg STIMexpts_HighDens_orderY2avg orderYALLstd orderYALLavg orderY2ALLstd orderY2ALLavg orderALLstd orderALLavg speedALLavg speedALLstd vxABSmeanALLavg vxABSmeanALLstd vxmeanALLstd vxmeanALLavg vyABSmeanALLavg vyABSmeanALLstd vymeanALLavg vymeanALLstd
end
%% plotting the response times
%{
figure (3)
E     =[0.5 0.5 0.5 0.5; ...
        1.0 1.0 1.0 1.0; ...
        1.5 1.5 1.5 1.5; ...
        3.0 3.0 3.0 3.0; ...
        5.0 5.0 5.0 5.0];
tau_85=[117.5   116.5   nan  nan; ...
        73.9    89.8    nan  nan; ...
        41.5	24.5	34.3 nan; ...
        18.6	20.0	21.5 nan; ...
        23.6    24.3    24.0 nan];
% 11scatter(E,tau_85,'filled');
devs = nanstd(tau_85');
avgs = nanmean(tau_85');
bar([0.5 1.0 1.5 3.0 5.0],avgs); hold on;
er=errorbar([0.5 1.0 1.5 3.0 5.0],avgs,devs,devs,'LineWidth',3);
er.Color = [0 0 0];
xticks([0.5 1.0 1.5 3.0 5.0])
set(gca,'xticklabel',{'0.5','1.0','1.5','3.0','5.0'z})
er.LineStyle = 'none';
ylabel('Response Time (h)')
xlabel('|E| (V/cm)')
scatter(E(:),tau_85(:),'filled','jitter', 'on', 'jitterAmount', 0.1)
%}
%% finally some rosettes?
% fig3021=figure(3021);
% controls = {};
% stims = {};
% for k=1:2
%     controls{end+1} = thetas{k}{6}(:);
%     stims{end+1} = thetas{k}{20}(:);
% end
% nBins=25;
% h1=polarhistogram([vertcat(controls{:}); (0:pi/nBins:(2*pi))'],'BinLimits',[-pi,pi],'NumBins',nBins, 'Normalization','probability','LineStyle','none'); hold on;
% h2=polarhistogram( [  vertcat(stims{:}); (0:pi/nBins:(2*pi))'],'BinLimits',[-pi,pi],'NumBins',nBins,'Normalization','probability','LineStyle','none');
% pax = gca;
% pax.FontSize = 20;
% %rlim([0 .5]);

%%
savedatetimenow=datetime('now','Format','d-MMM-y--HH-mm');

%clearvars legendLazyLHL
figure(fig3001);
%above order: k,r,g,m,b,c
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
   if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
    if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
   set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationlowercornerwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','SouthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameter--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameter--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameter--run',string(savedatetimenow),'groupedStDev-small'),'svg');

%% Added with zoomed-in plots!
%clearvars legendLazyLHL
figure(fig13001);
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
   legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
   %if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
    %if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
   set(gcf, 'Position', [10 50 825 575]); %added for SMALLER figure panels!
   %legendLazyLHL13001 = legend(LH(1:3),L{1:3},'Position',legendlocationlowercornerwest); 
   %legendLazyLHL13001 = legend(LH(1:3),L{1:3},'Location','best');
   legendLazyLHL13001 = legend(LH(1:3),L{1:3},'Location','NorthEast');
   legendLazyLHL13001.FontSize=24; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-small'),'svg');
xlim([238.5/60 480/60]); %xlim([240 480]);
%legendLazyLHL13001 = legend(LH(1:3),L{1:3},'Location','best');
%legendLazyLHL13001 = legend(LH(1:3),L{1:3},'Location','NorthEast');
legendLazyLHL13001.Location='NorthEast';
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-time4to8hrs'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-time4to8hrs'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-time4to8hrs'),'svg');
xlim([238.5/60 450/60]); %xlim([240 480]);
%legendLazyLHL13001 = legend(LH(1:3),L{1:3},'Location','best');
%legendLazyLHL13001 = legend(LH(1:3),L{1:3},'Location','NorthEast');
legendLazyLHL13001.Location='NorthEast';
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-time4to7p5hrs'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-time4to7p5hrs'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-OrderParameter--run',string(savedatetimenow),'-time4to7p5hrs'),'svg');

figure(fig13002);
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; end %set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 825 575]); %added for SMALLER figure panels!
   %legendLazyLHL13002 = legend(LH(1:3),L{1:3},'Position',legendlocationupperwest); 
   %legendLazyLHL13002 = legend(LH(1:3),L{1:3},'Location','best');
    legendLazyLHL13002 = legend(LH(1:3),L{1:3},'Location','NorthEast');
    legendLazyLHL13002.FontSize=24; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVx--run',string(savedatetimenow),'-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVx--run',string(savedatetimenow),'-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVx--run',string(savedatetimenow),'-small'),'svg');
xlim([238.5/60 480/60]); %xlim([240 480]);
%legendLazyLHL13002 = legend(LH(1:3),L{1:3},'Location','best');
%legendLazyLHL13002 = legend(LH(1:3),L{1:3},'Location','NorthEast');
legendLazyLHL13002.Location='NorthEast';
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVx--run',string(savedatetimenow),'-time4to8hrs'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVx--run',string(savedatetimenow),'-time4to8hrs'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVx--run',string(savedatetimenow),'-time4to8hrs'),'svg');

figure(fig13003); 
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
    legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; end %set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 825 575]); %added for SMALLER figure panels!
   %legendLazyLHL13003 = legend(LH(1:3),L{1:3},'Position',legendlocationupperwest); 
   %legendLazyLHL13003 = legend(LH(1:3),L{1:3},'Location','best');
   legendLazyLHL13003 = legend(LH(1:3),L{1:3},'Location','NorthEast');
  legendLazyLHL13003.FontSize=24; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVy--run',string(savedatetimenow),'-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVy--run',string(savedatetimenow),'-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVy--run',string(savedatetimenow),'-small'),'svg');
xlim([238.5/60 480/60]); %xlim([240 480]);
%legendLazyLHL13003 = legend(LH(1:3),L{1:3},'Location','best');
%legendLazyLHL13003 = legend(LH(1:3),L{1:3},'Location','NorthEast');
legendLazyLHL13003.Location='NorthEast';
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVy--run',string(savedatetimenow),'-time4to8hrs'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVy--run',string(savedatetimenow),'-time4to8hrs'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MeanABSVy--run',string(savedatetimenow),'-time4to8hrs'),'svg');

figure(fig13004); 
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
    legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; end %set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 825 575]); %added for SMALLER figure panels!
   %legendLazyLHL13004 = legend(LH(1:3),L{1:3},'Position',legendlocationupperwest); 
   %legendLazyLHL13004 = legend(LH(1:3),L{1:3},'Location','best');
   legendLazyLHL13004 = legend(LH(1:3),L{1:3},'Location','NorthEast');
  legendLazyLHL13004.FontSize=24; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-Speed--run',string(savedatetimenow),'-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-Speed--run',string(savedatetimenow),'-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-Speed--run',string(savedatetimenow),'-small'),'svg');
xlim([238.5/60 480/60]); %xlim([240 480]);
%legendLazyLHL13004 = legend(LH(1:3),L{1:3},'Location','best');
%legendLazyLHL13004 = legend(LH(1:3),L{1:3},'Location','NorthEast');
legendLazyLHL13004.Location='NorthEast';
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-Speed--run',string(savedatetimenow),'-time4to8hrs'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-Speed--run',string(savedatetimenow),'-time4to8hrs'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-Speed--run',string(savedatetimenow),'-time4to8hrs'),'svg');

%%
% figure(fig4001);
% %above order: k,r,g,m,b,c
%     LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
%     L{1} = ['High Density'];
%     LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
%     L{2} = ['Medium Density'];
%     LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
%     L{3} = ['Low Density'];
%         if voltages>=3
%                 LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
%                 L{4} = ['Controls'];
%         end
%         if plotTheEGTAalso==1
%                 LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
%                 L{5} = ['EGTA-Treated Tissues'];
%         end
%         if plotThe3700sSeparate==1
%                 LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
%                 L{6} = ['Transition Density'];
%         end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
%      set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
%    legendLazyLHL = legend(LH,L,'Position',legendlocationlowercornerwest); %legendLazyLHL = legend(LH,L,'Location','best');
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUsing+Vfilt--run',string(savedatetimenow),'groupedStDev-small'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUsing+Vfilt--run',string(savedatetimenow),'groupedStDev-small'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUsing+Vfilt--run',string(savedatetimenow),'groupedStDev-small'),'svg');

figure(fig4002);
%above order: k,r,g,m,b,c
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];
   if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
    if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationlowercornerwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','SouthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUpward--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUpward--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUpward--run',string(savedatetimenow),'groupedStDev-small'),'svg');

figure(fig4003);
%above order: k,r,g,m,b,c
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
   if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
    if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationlowercornerwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','SouthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterDownward--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterDownward--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterDownward--run',string(savedatetimenow),'groupedStDev-small'),'svg');

% figure(fig4004);
% %above order: k,r,g,m,b,c
%     LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
%     L{1} = ['High Density'];
%     LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
%     L{2} = ['Medium Density'];
%     LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
%     L{3} = ['Low Density'];
%         if voltages>=3
%                 LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
%                 L{4} = ['Controls'];
%         end
%         if plotTheEGTAalso==1
%                 LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
%                 L{5} = ['EGTA-Treated Tissues'];
%         end
%         if plotThe3700sSeparate==1
%                 LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
%                 L{6} = ['Transition Density'];
%         end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
%  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
%    legendLazyLHL = legend(LH,L,'Position',legendlocationlowercornerwest); %legendLazyLHL = legend(LH,L,'Location','best');
%   legendLazyLHL.FontSize=28; %added for figure panels!
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterInXUsingABSy--run',string(savedatetimenow),'groupedStDev-small'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterInXUsingABSy--run',string(savedatetimenow),'groupedStDev-small'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterInXUsingABSy--run',string(savedatetimenow),'groupedStDev-small'),'svg');

% figure(fig4005);
% %above order: k,r,g,m,b,c
%     LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
%     L{1} = ['High Density'];
%     LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
%     L{2} = ['Medium Density'];
%     LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
%     L{3} = ['Low Density'];
%         if voltages>=3
%                 LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
%                 L{4} = ['Controls'];
%         end
%         if plotTheEGTAalso==1
%                 LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
%                 L{5} = ['EGTA-Treated Tissues'];
%         end
%         if plotThe3700sSeparate==1
%                 LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
%                 L{6} = ['Transition Density'];
%         end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
%  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
%    legendLazyLHL = legend(LH,L,'Position',legendlocationlowercornerwest); %legendLazyLHL = legend(LH,L,'Location','best');
%   legendLazyLHL.FontSize=28; %added for figure panels!
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUpwardUsingABSx--run',string(savedatetimenow),'groupedStDev-small'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUpwardUsingABSx--run',string(savedatetimenow),'groupedStDev-small'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','OrderParameterUpwardUsingABSx--run',string(savedatetimenow),'groupedStDev-small'),'svg');

figure(fig3002);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','west');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed--run',string(savedatetimenow),'groupedStDev-small'),'svg');

figure(fig3003);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx--run',string(savedatetimenow),'groupedStDev-small'),'svg');
ylim([-5 65]);
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx--run',string(savedatetimenow),'groupedStDev-scaledto70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx--run',string(savedatetimenow),'groupedStDev-scaledto70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx--run',string(savedatetimenow),'groupedStDev-scaledto70'),'svg');

figure(fig3004);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed-normzldtoT6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed-normzldtoT6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed-normzldtoT6--run',string(savedatetimenow),'groupedStDev-small'),'svg');

figure(fig3005);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed-normzldtoT1to6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed-normzldtoT1to6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','Speed-normzldtoT1to6--run',string(savedatetimenow),'groupedStDev-small'),'svg');

  figure(fig3006);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx-normzldtoT6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx-normzldtoT6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx-normzldtoT6--run',string(savedatetimenow),'groupedStDev-small'),'svg');

  figure(fig3007);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx-normzldtoT1to6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx-normzldtoT1to6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVx-normzldtoT1to6--run',string(savedatetimenow),'groupedStDev-small'),'svg');


figure(fig3011);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVy--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVy--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVy--run',string(savedatetimenow),'groupedStDev-small'),'svg');
ylim([-5 65]);
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVy--run',string(savedatetimenow),'groupedStDev-scaledto70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVy--run',string(savedatetimenow),'groupedStDev-scaledto70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanVy--run',string(savedatetimenow),'groupedStDev-scaledto70'),'svg');


figure(fig3012);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx--run',string(savedatetimenow),'groupedStDev-small'),'svg');
ylim([0 70]);
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx--run',string(savedatetimenow),'groupedStDev-scaledto70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx--run',string(savedatetimenow),'groupedStDev-scaledto70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx--run',string(savedatetimenow),'groupedStDev-scaledto70'),'svg');

figure(fig3013);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
    legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy--run',string(savedatetimenow),'groupedStDev-small'),'svg');
ylim([-5 65]);
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy--run',string(savedatetimenow),'groupedStDev-scaledto70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy--run',string(savedatetimenow),'groupedStDev-scaledto70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy--run',string(savedatetimenow),'groupedStDev-scaledto70'),'svg');

figure(fig5012);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT1to6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT1to6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT1to6--run',string(savedatetimenow),'groupedStDev-small'),'svg');
% ylim([0 70]);
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT1to6--run',string(savedatetimenow),'groupedStDev-scaledto70'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT1to6--run',string(savedatetimenow),'groupedStDev-scaledto70'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT1to6--run',string(savedatetimenow),'groupedStDev-scaledto70'),'svg');

figure(fig5013);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
    legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT1to6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT1to6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT1to6--run',string(savedatetimenow),'groupedStDev-small'),'svg');
% ylim([-5 65]);
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT1to6--run',string(savedatetimenow),'groupedStDev-scaledto70'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT1to6--run',string(savedatetimenow),'groupedStDev-scaledto70'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT1to6--run',string(savedatetimenow),'groupedStDev-scaledto70'),'svg');

figure(fig6012);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT6--run',string(savedatetimenow),'groupedStDev-small'),'svg');
% ylim([0 70]);
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT6--run',string(savedatetimenow),'groupedStDev-scaledto70'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT6--run',string(savedatetimenow),'groupedStDev-scaledto70'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVx-normzldtoAbsVxT6--run',string(savedatetimenow),'groupedStDev-scaledto70'),'svg');

figure(fig6013);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    L{1} = ['High Density'];
    LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
    L{2} = ['Medium Density'];
    LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
    L{3} = ['Low Density'];
        if voltages>=3
                LH(4) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--'); %display controls legend in light gray
                L{4} = ['Controls'];
        end
        if plotTheEGTAalso==1
                LH(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
                L{5} = ['EGTA-Treated Tissues'];
        end
        if plotThe3700sSeparate==1
                LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
                L{6} = ['Transition Density'];
        end
    legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Position',legendlocationupperwest); %legendLazyLHL = legend(LH,L,'Location','best');
   legendLazyLHL = legend(LH,L,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT6--run',string(savedatetimenow),'groupedStDev-small'),'svg');
% ylim([-5 65]);
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT6--run',string(savedatetimenow),'groupedStDev-scaledto70'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT6--run',string(savedatetimenow),'groupedStDev-scaledto70'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MeanABSVy-normzldtoAbsVyT6--run',string(savedatetimenow),'groupedStDev-scaledto70'),'svg');

%%
figure(fig10001);
%above order: k,r,g,m,b,c   >> later, changed second half to controls, with same colors, but dashed lines!   
    %LHmedium(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
    %Lmedium{1} = ['High Density'];
    LHmedium(1) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium{1} = ['Order Parameter'];
    LHmedium(2) = plot(nan, nan, '-k','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium{2} = ['Mean |Vx|'];
                LHmedium(3) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                Lmedium{3} = ['Controls'];
                 LHmedium(3) = plot(nan, nan,'color',[0 0 0.8],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                 Lmedium{3} = ['Order Parameter Control'];
                 LHmedium(4) = plot(nan, nan,'color',[0.15 0.15 0.15],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                 Lmedium{4} = ['Mean |Vx| Control'];
        %if plotTheEGTAalso==1
        %        LHmedium(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
        %        Lmedium{5} = ['EGTA-Treated Tissues'];
        %end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
   %legendLazyLHL = legend(LHmedium,Lmedium,'Position',legendlocationupperwest);%legendlocationlowercornerwest); 
   %legendLazyLHL = legend(LHmedium,Lmedium,'Location','best');
   legendLazyLHL = legend(LHmedium,Lmedium,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
   %legendLazyLHL = legend(LH,L,'Location','NorthEast');
 yyaxis right
 ylim([-14 70]);
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaledN14to70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'svg');
 yyaxis right
 ylim([-12.4 62]);
 legendLazyLHL.Location='NorthEast';%legendLazyLHL = legend(LH,L,'Location','NorthEast');
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'svg');
%  yyaxis right
%  ylim([0 62]);
%  yyaxis left
%  ylim([0 1]); %scale order parameter instead to 0 to 1!
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-1--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'),'svg');

%% Add onto end some 2-Y Axis plots for medium density only!
%%TRY NOW MEAN Vx (instead of Mean |Vx|!)
timeplotter = (1:size(SmoothMovMed3_orderALLavg,2))*minperframe/60; %update from minutes to hours!
    %lastNonNaNtoPlot=find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last');
    %lastNonNaNtoPlot=find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last');
    %^ not needed because integrated instead in the shaded_error_wLineStyle_Width3 coding line!   
%     SmoothMovMed3_orderALLavg;
%     SmoothMovMed3_orderALLstd;
%     SmoothMovMed3_vxABSmeanALLavg;
%     SmoothMovMed3_vxABSmeanALLstd;

  voltages=0+1;
        linestyle = '-'; %added into shaded_error_wLineStyle_Width3.m function! %'LineStyle' options are: '-' | '--' | ':' | '-.' | 'none'.
        alphavalue = 0.2; %shading in shaded_error function
                        currentcolorbeforeswapping = color; %save it, to switch back
fig100022=figure(100022); hold on;
yyaxis left
  currdoubaxis = gca;
  %currdoubaxis.YAxis(1).Color = color;
  %currdoubaxis.YAxis(2).Color = color;
                        color = 'b'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(1).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
        
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-0.2 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
  %plot([-1000 1000],[0 0],'k');
        %xline(0,'k-');
        yline(0,':','LineWidth',1.5,'Color','k'); %yline(0,'-','LineWidth',1.5,'Color',color);
  
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(2).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);

    ylabel('Mean Vx (\mum/h)')
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        
  voltages=3+1; %PLOT CONTROL NOW
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
                        currentcolorbeforeswapping = color; %save it, to switch back

yyaxis left
                        color = 'b'; %ColorScheme Update!  'k';
                        color = [0 0 0.8]; %update for a more gray-like blue! darker/duller 
                      currdoubaxis.YAxis(1).Color = [0 0 0.9];
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
                        color = [0.15 0.15 0.15]; %update for more gray instead of black!
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!

%ANCHOR THESE TEXT TO ORDER PARAMETER AXIS WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis left
      currentylim2axes=ylim;
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim2axes(1) currentylim2axes(1)], {'Field On', 'Field Off'},'VerticalAlignment','Bottom'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');

    LHmedium2(1) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{1} = ['Order Parameter'];
    LHmedium2(2) = plot(nan, nan, '-k','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{2} = ['Mean Vx'];
                LHmedium2(3) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                Lmedium2{3} = ['Controls'];
%                  LHmedium(3) = plot(nan, nan,'color',[0 0 0.8],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{3} = ['Order Parameter Control'];
%                  LHmedium(4) = plot(nan, nan,'color',[0.15 0.15 0.15],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{4} = ['Mean Vx Control'];
        %if plotTheEGTAalso==1
        %        LHmedium(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
        %        Lmedium{5} = ['EGTA-Treated Tissues'];
        %end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Position',legendlocationupperwest); %%legendLazyLHL = legend(LHmedium,Lmedium,'Location','best');
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','best');
   legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
 yyaxis right
 ylim([-14 70]); %scaledN14to70
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-scaledN14to70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'svg');
 yyaxis right
 ylim([-12.4 62]);%scaledN12p4to62
 legendLazyLHL.Location='NorthEast';%legendLazyLHL = legend(LH,L,'Location','NorthEast');
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'svg');
    yyaxis right
    ylabel('Mean Vx (\mum/h)','FontSize',54);
    yyaxis left
    ylabel('Order Parameter','FontSize',54)
     savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'));
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'png');
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'svg');
 yyaxis right
 ylim([-6.2 62]); %scaled0to1AND0to62
 yyaxis left  %scaled0to1AND0to62
 ylim([-0.1 1]); %scale order parameter instead to 0 to 1!
     savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN0p1to1ANDto62'));
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN0p1to1ANDto62'),'png');
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN0p1to1ANDto62'),'svg');
%gross so bring it back--
 yyaxis right
 ylim([-12.4 62]); %scaled0to1AND0to62
 yyaxis left  %scaled0to1AND0to62
 ylim([-0.2 1]); %scale order parameter instead to 0 to 1!
 
     savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62+changeaxis'));
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62+changeaxis'),'png');
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62+changeaxis'),'svg');

     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62+changeaxis'),'pdf');
 
 
 
 
 
 
 %and now regraph with Order -0.1 to 1 instead...
  voltages=0+1;
        linestyle = '-'; %added into shaded_error_wLineStyle_Width3.m function! %'LineStyle' options are: '-' | '--' | ':' | '-.' | 'none'.
        alphavalue = 0.2; %shading in shaded_error function
                        currentcolorbeforeswapping = color; %save it, to switch back
fig100023=figure(100023); hold on;
yyaxis left
  currdoubaxis = gca;
  %currdoubaxis.YAxis(1).Color = color;
  %currdoubaxis.YAxis(2).Color = color;
                        color = 'b'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(1).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
        
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-0.1 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
  %plot([-1000 1000],[0 0],'k');
        %xline(0,'k-');
        yline(0,':','LineWidth',1.5,'Color','k'); %yline(0,'-','LineWidth',1.5,'Color',color);
  
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(2).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);

    ylabel('Mean Vx (\mum/h)')
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        
  voltages=3+1; %PLOT CONTROL NOW
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
                        currentcolorbeforeswapping = color; %save it, to switch back

yyaxis left
                        color = 'b'; %ColorScheme Update!  'k';
                        color = [0 0 0.8]; %update for a more gray-like blue! darker/duller 
                      currdoubaxis.YAxis(1).Color = [0 0 0.9];
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
                        color = [0.15 0.15 0.15]; %update for more gray instead of black!
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!

%ANCHOR THESE TEXT TO ORDER PARAMETER AXIS WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis left
      currentylim2axes=ylim;
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim2axes(1) currentylim2axes(1)], {'Field On', 'Field Off'},'VerticalAlignment','Bottom'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');

    LHmedium2(1) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{1} = ['Order Parameter'];
    LHmedium2(2) = plot(nan, nan, '-k','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{2} = ['Mean Vx'];
                LHmedium2(3) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                Lmedium2{3} = ['Controls'];
%                  LHmedium(3) = plot(nan, nan,'color',[0 0 0.8],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{3} = ['Order Parameter Control'];
%                  LHmedium(4) = plot(nan, nan,'color',[0.15 0.15 0.15],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{4} = ['Mean Vx Control'];
        %if plotTheEGTAalso==1
        %        LHmedium(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
        %        Lmedium{5} = ['EGTA-Treated Tissues'];
        %end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Position',legendlocationupperwest); %%legendLazyLHL = legend(LHmedium,Lmedium,'Location','best');
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','best');
   legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
 yyaxis right
 ylim([-7 70]); %scaledN14to70
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN14to70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN14to70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN14to70'),'svg');
 yyaxis right
 ylim([-6.2 62]);%scaledN12p4to62
 legendLazyLHL.Location='NorthEast';%legendLazyLHL = legend(LH,L,'Location','NorthEast');
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'),'svg');
    yyaxis right
    ylabel('Mean Vx (\mum/h)','FontSize',54);
    yyaxis left
    ylabel('Order Parameter','FontSize',54)
     savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'));
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'),'png');
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+PUREmeanVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'),'svg');
%gross so bring it back--
 yyaxis right
 ylim([-6.2 62]); %scaled0to1AND0to62
 yyaxis left  %scaled0to1AND0to62
 ylim([-0.1 1]); %scale order parameter instead to 0 to 1!
 
 
 
 
 
 
%% Add onto end some 2-Y Axis plots for medium density only!
timeplotter = (1:size(SmoothMovMed3_orderALLavg,2))*minperframe/60; %update from minutes to hours!
    %lastNonNaNtoPlot=find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last');
    %lastNonNaNtoPlot=find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last');
    %^ not needed because integrated instead in the shaded_error_wLineStyle_Width3 coding line!   
%     SmoothMovMed3_orderALLavg;
%     SmoothMovMed3_orderALLstd;
%     SmoothMovMed3_vxABSmeanALLavg;
%     SmoothMovMed3_vxABSmeanALLstd;

  voltages=0+1;
        linestyle = '-'; %added into shaded_error_wLineStyle_Width3.m function! %'LineStyle' options are: '-' | '--' | ':' | '-.' | 'none'.
        alphavalue = 0.2; %shading in shaded_error function
                        currentcolorbeforeswapping = color; %save it, to switch back
fig10002=figure(10002); hold on;
yyaxis left
  currdoubaxis = gca;
  %currdoubaxis.YAxis(1).Color = color;
  %currdoubaxis.YAxis(2).Color = color;
                        color = 'b'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(1).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
        
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-0.2 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
  %plot([-1000 1000],[0 0],'k');
        %xline(0,'k-');
        yline(0,':','LineWidth',1.5,'Color','k'); %yline(0,'-','LineWidth',1.5,'Color',color);
  
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(2).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);

    ylabel('Mean |Vx| (\mum/h)')
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        
  voltages=3+1; %PLOT CONTROL NOW
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
                        currentcolorbeforeswapping = color; %save it, to switch back

yyaxis left
                        color = 'b'; %ColorScheme Update!  'k';
                        color = [0 0 0.8]; %update for a more gray-like blue! darker/duller 
                      currdoubaxis.YAxis(1).Color = [0 0 0.9];
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
                        color = [0.15 0.15 0.15]; %update for more gray instead of black!
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!

%ANCHOR THESE TEXT TO ORDER PARAMETER AXIS WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis left
      currentylim2axes=ylim;
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim2axes(1) currentylim2axes(1)], {'Field On', 'Field Off'},'VerticalAlignment','Bottom'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');

    LHmedium2(1) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{1} = ['Order Parameter'];
    LHmedium2(2) = plot(nan, nan, '-k','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{2} = ['Mean |Vx|'];
                LHmedium2(3) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                Lmedium2{3} = ['Controls'];
%                  LHmedium(3) = plot(nan, nan,'color',[0 0 0.8],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{3} = ['Order Parameter Control'];
%                  LHmedium(4) = plot(nan, nan,'color',[0.15 0.15 0.15],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{4} = ['Mean |Vx| Control'];
        %if plotTheEGTAalso==1
        %        LHmedium(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
        %        Lmedium{5} = ['EGTA-Treated Tissues'];
        %end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Position',legendlocationupperwest); %%legendLazyLHL = legend(LHmedium,Lmedium,'Location','best');
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','best');
   legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
 yyaxis right
 ylim([-14 70]); %scaledN14to70
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2--run',string(savedatetimenow),'groupedStDev-scaledN14to70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'svg');
 yyaxis right
 ylim([-12.4 62]);%scaledN12p4to62
 legendLazyLHL.Location='NorthEast';%legendLazyLHL = legend(LH,L,'Location','NorthEast');
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'svg');
    yyaxis right
    ylabel('Mean |Vx| (\mum/h)','FontSize',46);
    yyaxis left
    ylabel('Order Parameter','FontSize',46)
     savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'));
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'png');
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'svg');
 yyaxis right
 ylim([-6.2 62]); %scaled0to1AND0to62
 yyaxis left  %scaled0to1AND0to62
 ylim([-0.1 1]); %scale order parameter instead to 0 to 1!
     savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'));
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'),'png');
     saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2+LargerYLabelFonts--run',string(savedatetimenow),'groupedStDev-OPtoNeg0p1-scaledN12p4to62'),'svg');


%% Add onto end some 2-Y Axis plots for medium density only! NOW SWITCH SIDES!
%     SmoothMovMed3_orderALLavg;
%     SmoothMovMed3_orderALLstd;
%     SmoothMovMed3_vxABSmeanALLavg;
%     SmoothMovMed3_vxABSmeanALLstd;

  voltages=0+1;
        linestyle = '-'; %added into shaded_error_wLineStyle_Width3.m function! %'LineStyle' options are: '-' | '--' | ':' | '-.' | 'none'.
        alphavalue = 0.2; %shading in shaded_error function
                        currentcolorbeforeswapping = color; %save it, to switch back
fig10003=figure(10003); hold on;
yyaxis right
  currdoubaxis = gca;
  %currdoubaxis.YAxis(1).Color = color;
  %currdoubaxis.YAxis(2).Color = color;
                        color = 'b'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(2).Color = color;
     %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
     shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-0.2 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
  %plot([-1000 1000],[0 0],'k');
        %xline(0,'k-');
        yline(0,':','LineWidth',1.5,'Color','k'); %yline(0,'-','LineWidth',1.5,'Color',color);

yyaxis left
                        color = 'k'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(1).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    ylabel('Mean |Vx| (\mum/h)')
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        
  voltages=3+1; %PLOT CONTROL NOW
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
                        currentcolorbeforeswapping = color; %save it, to switch back

yyaxis right
                        color = 'b'; %ColorScheme Update!  'k';
                        color = [0 0 0.8]; %update for a more gray-like blue! darker/duller 
                      currdoubaxis.YAxis(2).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
yyaxis left
                        color = 'k'; %ColorScheme Update!  'k';
                        color = [0.15 0.15 0.15]; %update for more gray instead of black!
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);

                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!

%ANCHOR THESE TEXT TO ORDER PARAMETER AXIS WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis right
      currentylim2axes=ylim;
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim2axes(1) currentylim2axes(1)], {'Field On', 'Field Off'},'VerticalAlignment','Bottom'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');

    LHmedium2(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{2} = ['Order Parameter'];
    LHmedium2(1) = plot(nan, nan, '-k','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{1} = ['Mean |Vx|'];
                LHmedium2(3) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                Lmedium2{3} = ['Controls'];
%                  LHmedium(3) = plot(nan, nan,'color',[0 0 0.8],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{3} = ['Order Parameter Control'];
%                  LHmedium(4) = plot(nan, nan,'color',[0.15 0.15 0.15],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{4} = ['Mean |Vx| Control'];
        %if plotTheEGTAalso==1
        %        LHmedium(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
        %        Lmedium{5} = ['EGTA-Treated Tissues'];
        %end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Position',legendlocationupperwest);%legendlocationlowercornerwest); 
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','best');
   legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
 yyaxis left
 ylim([-14 70]); %scaledN14to70
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaledN14to70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'svg');
 yyaxis left
 ylim([-12.4 62]);%scaledN12p4to62
 legendLazyLHL.Location='NorthEast';%legendLazyLHL = legend(LH,L,'Location','NorthEast');
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'svg');
%  yyaxis left
%  ylim([0 62]); %scaled0to1AND0to62
%  yyaxis right  %scaled0to1AND0to62
%  ylim([0 1]); %scale order parameter instead to 0 to 1!
% savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'));
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'),'png');
% saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'),'svg');
 
%% Add onto end some 2-Y Axis plots for medium density only! NO CONTROLS NOW!
timeplotter = (1:size(SmoothMovMed3_orderALLavg,2))*minperframe/60; %update from minutes to hours!
    %lastNonNaNtoPlot=find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last');
    %lastNonNaNtoPlot=find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last');
    %^ not needed because integrated instead in the shaded_error_wLineStyle_Width3 coding line!   
%     SmoothMovMed3_orderALLavg;
%     SmoothMovMed3_orderALLstd;
%     SmoothMovMed3_vxABSmeanALLavg;
%     SmoothMovMed3_vxABSmeanALLstd;

  voltages=0+1;
        linestyle = '-'; %added into shaded_error_wLineStyle_Width3.m function! %'LineStyle' options are: '-' | '--' | ':' | '-.' | 'none'.
        alphavalue = 0.2; %shading in shaded_error function
                        currentcolorbeforeswapping = color; %save it, to switch back
fig10004=figure(10004); hold on;
yyaxis left
  currdoubaxis = gca;
  %currdoubaxis.YAxis(1).Color = color;
  %currdoubaxis.YAxis(2).Color = color;
                        color = 'b'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(1).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
        
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-0.2 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
  %plot([-1000 1000],[0 0],'k');
        %xline(0,'k-');
        yline(0,':','LineWidth',1.5,'Color','k'); %yline(0,'-','LineWidth',1.5,'Color',color);
        
yyaxis right
                        color = 'k'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(2).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);

    ylabel('Mean |Vx| (\mum/h)')
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        

%ANCHOR THESE TEXT TO ORDER PARAMETER AXIS WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis left
      currentylim2axes=ylim;
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim2axes(1) currentylim2axes(1)], {'Field On', 'Field Off'},'VerticalAlignment','Bottom'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');

    LHmedium2(1) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{1} = ['Order Parameter'];
    LHmedium2(2) = plot(nan, nan, '-k','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{2} = ['Mean |Vx|'];
                LHmedium2(3) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                Lmedium2{3} = ['Controls'];
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LHmedium2(1:2),Lmedium2{1:2},'Position',legendlocationupperwest); %%legendLazyLHL = legend(LHmedium,Lmedium,'Location','best');
   %legendLazyLHL = legend(LHmedium2(1:2),Lmedium2{1:2},'Location','best');
   legendLazyLHL = legend(LHmedium2(1:2),Lmedium2{1:2},'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
 yyaxis right
 ylim([-14 70]); %scaledN14to70
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN14to70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'svg');
 yyaxis right
 ylim([-12.4 62]);%scaledN12p4to62
 legendLazyLHL.Location='NorthEast';%legendLazyLHL = legend(LH,L,'Location','NorthEast');
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'svg');
 yyaxis right
 ylim([0 62]); %scaled0to1AND0to62
 yyaxis left  %scaled0to1AND0to62
 ylim([0 1]); %scale order parameter instead to 0 to 1!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-2NoCtrls--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'),'svg');
 
%% Add onto end some 2-Y Axis plots for medium density only! NOW SWITCH SIDES!  NO CONTROLS NOW!
%     SmoothMovMed3_orderALLavg;
%     SmoothMovMed3_orderALLstd;
%     SmoothMovMed3_vxABSmeanALLavg;
%     SmoothMovMed3_vxABSmeanALLstd;

  voltages=0+1;
        linestyle = '-'; %added into shaded_error_wLineStyle_Width3.m function! %'LineStyle' options are: '-' | '--' | ':' | '-.' | 'none'.
        alphavalue = 0.2; %shading in shaded_error function
                        currentcolorbeforeswapping = color; %save it, to switch back
fig10005=figure(10005); hold on;
yyaxis right
  currdoubaxis = gca;
  %currdoubaxis.YAxis(1).Color = color;
  %currdoubaxis.YAxis(2).Color = color;
                        color = 'b'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(2).Color = color;
     %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
     shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLavg(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_orderALLstd(voltages,1:find(~isnan(SmoothMovMed3_orderALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    ylim([-0.2 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Order Parameter'); %ylabel('Order Parameter, \phi')
    ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
  %plot([-1000 1000],[0 0],'k');
        %xline(0,'k-');
        yline(0,':','LineWidth',1.5,'Color','k'); %yline(0,'-','LineWidth',1.5,'Color',color);
        
yyaxis left
                        color = 'k'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(1).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    ylabel('Mean |Vx| (\mum/h)')
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        
%ANCHOR THESE TEXT TO ORDER PARAMETER AXIS WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis right
      currentylim2axes=ylim;
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim2axes(1) currentylim2axes(1)], {'Field On', 'Field Off'},'VerticalAlignment','Bottom'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');

    LHmedium2(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{2} = ['Order Parameter'];
    LHmedium2(1) = plot(nan, nan, '-k','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{1} = ['Mean |Vx|'];
                LHmedium2(3) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                Lmedium2{3} = ['Controls'];
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
   %legendLazyLHL = legend(LHmedium2(1:2),Lmedium2{1:2},'Position',legendlocationupperwest); %%legendLazyLHL = legend(LHmedium,Lmedium,'Location','best');
   %legendLazyLHL = legend(LHmedium2(1:2),Lmedium2{1:2},'Location','best');
   legendLazyLHL = legend(LHmedium2(1:2),Lmedium2{1:2},'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
 yyaxis left
 ylim([-14 70]); %scaledN14to70 
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN14to70'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN14to70'),'svg');
 yyaxis left
 ylim([-12.4 62]);%scaledN12p4to62
 legendLazyLHL.Location='NorthEast';%legendLazyLHL = legend(LH,L,'Location','NorthEast');
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaledN12p4to62'),'svg');
 yyaxis left
 ylim([0 62]); %scaled0to1AND0to62
 yyaxis right  %scaled0to1AND0to62
 ylim([0 1]); %scale order parameter instead to 0 to 1!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-Order+MeanABSVx-3NoCtrls--run',string(savedatetimenow),'groupedStDev-scaled0to1AND0to62'),'svg');


%% Now do it woith Mean |Vx| and Mean |Vy| instead!--Add onto end some 2-Y Axis plots for medium density only! NOW SWITCH SIDES!
%     SmoothMovMed3_orderALLavg;
%     SmoothMovMed3_orderALLstd;
%     SmoothMovMed3_vxABSmeanALLavg;
%     SmoothMovMed3_vxABSmeanALLstd;

  voltages=0+1;
        linestyle = '-'; %added into shaded_error_wLineStyle_Width3.m function! %'LineStyle' options are: '-' | '--' | ':' | '-.' | 'none'.
        alphavalue = 0.2; %shading in shaded_error function
                        currentcolorbeforeswapping = color; %save it, to switch back
fig10006=figure(10006); hold on;
yyaxis right
  currdoubaxis = gca;
  %currdoubaxis.YAxis(1).Color = color;
  %currdoubaxis.YAxis(2).Color = color;
                        color = 'b'; %ColorScheme Update!  'k';
                        color=colororange; %UPDATE FOR THE Mean |Vy| graphs on double y-axes!
  currdoubaxis.YAxis(2).Color = color;
     %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_orderALLavg(voltages,:),SmoothMovMed3_orderALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
     shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vyABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vyABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vyABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vyABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vyABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    %ylim([-0.2 1.0]) %ylim([-1.0 1.0])
    xlabel('Time (h)');
    ylabel('Mean |Vy| (\mum/h)'); %ylabel('Order Parameter, \phi')
    %ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
  %plot([-1000 1000],[0 0],'k');
        %xline(0,'k-');
        %yline(0,'-','LineWidth',1.5,'Color',color);
        
yyaxis left
                        color = 'k'; %ColorScheme Update!  'k';
  currdoubaxis.YAxis(1).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
    ylabel('Mean |Vx| (\mum/h)')
                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!
        
  voltages=3+1; %PLOT CONTROL NOW
        linestyle = '--'; %dashed for controls!
        alphavalue = 0.1; %shading slightly lighter for the controls! %shading in shaded_error function 
                        currentcolorbeforeswapping = color; %save it, to switch back

yyaxis right
                        color = 'b'; %ColorScheme Update!  'k';
                        color = [0 0 0.8]; %update for a more gray-like blue! darker/duller 
                        color = [0.9 0.45 0]; %update to a more gray-like orange! instead of [1 0.5 0]
                      currdoubaxis.YAxis(2).Color = color;
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vyABSmeanALLavg(voltages,:),SmoothMovMed3_vyABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vyABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vyABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vyABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vyABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vyABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);
yyaxis left
                        color = 'k'; %ColorScheme Update!  'k';
                        color = [0.15 0.15 0.15]; %update for more gray instead of black!
    %shaded_error_wLineStyle_Width3(timeplotter,SmoothMovMed3_vxABSmeanALLavg(voltages,:),SmoothMovMed3_vxABSmeanALLstd(voltages,:),color,alphavalue,linestyle);
        %with catering to NaN adjusting length:
    shaded_error_wLineStyle_Width3(timeplotter(1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLavg(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),SmoothMovMed3_vxABSmeanALLstd(voltages,1:find(~isnan(SmoothMovMed3_vxABSmeanALLavg(voltages,:)), 1, 'last')),color,alphavalue,linestyle);

                        color = currentcolorbeforeswapping; %switch back to whatever it was for the other graphs!

%ANCHOR THESE TEXT TO *LEFT Mean Vx* AXIS this time WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis left
      currentylim2axes=ylim;
    line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
    text([62/60 242/60],[currentylim2axes(1) currentylim2axes(1)], {'Field On', 'Field Off'},'VerticalAlignment','Bottom'); %text([62/60 242/60],[1.0 1.0], {'Field On', 'Field Off'},'VerticalAlignment','top');

    LHmedium2(2) = plot(nan, nan, '-','Color',[0.9 0.45 0],'LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{2} = ['Mean |Vy|'];
    LHmedium2(1) = plot(nan, nan, '-k','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lmedium2{1} = ['Mean |Vx|'];
                LHmedium2(3) = plot(nan, nan,'color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
                Lmedium2{3} = ['Controls'];
%                  LHmedium(3) = plot(nan, nan,'color',[0 0 0.8],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{3} = ['Order Parameter Control'];
%                  LHmedium(4) = plot(nan, nan,'color',[0.15 0.15 0.15],'LineWidth',3,'MarkerSize',10,'LineStyle','--','Marker','none'); %display controls legend in light gray
%                  Lmedium{4} = ['Mean |Vx| Control'];
        %if plotTheEGTAalso==1
        %        LHmedium(5) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
        %        Lmedium{5} = ['EGTA-Treated Tissues'];
        %end
   legendlocationupperwest=[0.23,0.72,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationupperwest=[0.2,0.65,0.1,0.1];     
    legendlocationupperEAST=[0.65,0.72,0.1,0.1];
    if(setexptgraphinglength>30) legendlocationupperwest=legendlocationupperEAST; set(gcf, 'Position', [100 200 730 420]); end
%    legendlocationlowercornerwest=[0.23,0.2,0.1,0.1]; %updated after adding "density" word in legend--from--%legendlocationlowercornerwest=[0.19,0.19,0.1,0.1];     
%    if plotTheEGTAalso==1 legendlocationlowercornerwest=[0.23,0.2,0.1,0.15]; end
%     if(setexptgraphinglength>30) set(gcf, 'Position', [100 200 730 420]); end
  set(gcf, 'Position', [10 50 1800 950]); %added for figure panels!
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Position',legendlocationupperwest);%legendlocationlowercornerwest); 
   %legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','best');
   legendLazyLHL = legend(LHmedium2,Lmedium2,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-MeanABSVx+MeanABSVy-6--run',string(savedatetimenow),'groupedStDev-small'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-MeanABSVx+MeanABSVy-6--run',string(savedatetimenow),'groupedStDev-small'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-MeanABSVx+MeanABSVy-6--run',string(savedatetimenow),'groupedStDev-small'),'svg');
 yyaxis left
 ylim([0 62]);
 legendLazyLHL.Location='NorthEast'; %legendLazyLHL = legend(LH,L,'Location','NorthEast');
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-MeanABSVx+MeanABSVy-6--run',string(savedatetimenow),'groupedStDev-scaledto62'));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-MeanABSVx+MeanABSVy-6--run',string(savedatetimenow),'groupedStDev-scaledto62'),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','MediumDensOnly-MeanABSVx+MeanABSVy-6--run',string(savedatetimenow),'groupedStDev-scaledto62'),'svg');

%% Adding some plots at the end for zoomed-in alternatives:!
  
  %now try to put Mean |Vx| and Mean |Vy| for only medium on same mini-plot for decay only!:   
    fig13005=figure(13005); %Replaced the below line with 0 in for the stdev!!
      voltages=0+1; linestyle = '-';
      color='r'; %for Vx cuz leading/trailing colormap cmapRedBlue
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vxABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle);
      color=colorpurple; %for Vx cuz vertical colormap cmapOrangePurple
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vyABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle); %took out this--if had been in-line above, then needed: smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan')
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
     ylim([0 40]) %set ylim to match the data best here! make panels pretty!
    xlabel('Time (h)');
    ylabel('x-, y-Speed (\mum/h)'); %ylabel('Mean |Vx|, |Vy| (\mum/h)','FontSize',32) %(\mumh^{-1})
        currentaxesSmallerPanel=gca; currentaxesSmallerPanel.FontSize=32; %update font sizes for graph panels!--smaller plots needed smaller font here!
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
            currentylim=ylim;
        % annotations
        line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        text([62/60 242/60],[currentylim(1) currentylim(1)], {'Field On', 'Field Off'},'VerticalAlignment','bottom');
  xlim([238/60 xlimendgraphs]); %xlim([240 xlimendgraphs]);
  
  set(gcf, 'Position', [10 60 825 575]); %added for SMALLER figure panels!

  %legend stuff:
    LHzoomedmedium2(2) = plot(nan, nan, '-','Color',colorpurple,'LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{2} = ['Mean |Vy|'];
    LHzoomedmedium2(1) = plot(nan, nan, '-','Color','r','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{1} = ['Mean |Vx|'];
   legendLazyLHL = legend(LHzoomedmedium2(1:2),Lzoomedmedium2{1:2},'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOneAxis-MeanABSVx+ABSVy--run',string(savedatetimenow)));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOneAxis-MeanABSVx+ABSVy--run',string(savedatetimenow)),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOneAxis-MeanABSVx+ABSVy--run',string(savedatetimenow)),'svg');


%add CONTROLS now...
voltages=0+4;
linestyle='--';

      color='r'; %for Vx cuz leading/trailing colormap cmapRedBlue
      alphavalue=0.1;
  linestyle='--';
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vxABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle);
    
      color=colorpurple; %colororange; %for Vy cuz vertical colormap cmapOrangePurple
      alphavalue=0.08;
  linestyle='--';
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vyABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle); %took out this--if had been in-line above, then needed: smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan')

    LHzoomedmedium2(3) = plot(nan, nan, '--','Color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{3} = ['Mean Controls'];
   legendLazyLHL = legend(LHzoomedmedium2,Lzoomedmedium2,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!

savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOneAxis+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOneAxis+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOneAxis+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'svg');


%% Diff y axes now to better overlay and show they're similar decays...
  %same, with TWO axes--now try to put Mean |Vx| and Mean |Vy| for only medium on same mini-plot for decay only!:   
   fig13006=figure(13006); %Replaced the below line with 0 in for the stdev!!
      voltages=0+1; linestyle = '-';
   yyaxis left
      color='r'; %for Vx cuz leading/trailing colormap cmapRedBlue
      currdoubaxis = gca;
      currdoubaxis.YAxis(1).Color = color;
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vxABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle);
     ylim([0 40]) %set ylim to match the data best here! make panels pretty!
    ylabel('Mean |Vx| (\mum/h)'); %ylabel('Mean |Vx|, |Vy| (\mum/h)','FontSize',32) %(\mumh^{-1})
    
   yyaxis right
      color=colorpurple; %colororange; %for Vy cuz vertical colormap cmapOrangePurple
      currdoubaxis = gca;
      currdoubaxis.YAxis(2).Color = color;
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vyABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle); %took out this--if had been in-line above, then needed: smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan')
     ylim([4.5 10]) %set ylim to match the data best here! make panels pretty!
    xlabel('Time (h)');
    ylabel('Mean |Vy| (\mum/h)'); %ylabel('Mean |Vx|, |Vy| (\mum/h)','FontSize',32) %(\mumh^{-1})
   
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    
        currentaxesSmallerPanel=gca; currentaxesSmallerPanel.FontSize=32; %update font sizes for graph panels!--smaller plots needed smaller font here!
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting
    
%ANCHOR THESE TEXT TO *LEFT Mean Vx* AXIS this time WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis left
            currentylim=ylim;
        % annotations
        line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        text([62/60 242/60],[currentylim(1) currentylim(1)], {'Field On', 'Field Off'},'VerticalAlignment','bottom');
  xlim([238/60 xlimendgraphs]); %xlim([240 xlimendgraphs]);
  
  set(gcf, 'Position', [10 60 825 575]); %added for SMALLER figure panels!

  %legend stuff:
    LHzoomedmedium2(2) = plot(nan, nan, '-','Color',colorpurple,'LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{2} = ['Mean |Vy|'];
    LHzoomedmedium2(1) = plot(nan, nan, '-','Color','r','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{1} = ['Mean |Vx|'];
   legendLazyLHL = legend(LHzoomedmedium2(1:2),Lzoomedmedium2{1:2},'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes-MeanABSVx+MeanABSVy--run',string(savedatetimenow)));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'svg');

%Add in CONTROL LINES:!!! ... but still without STD shading... weird but ok     
voltages=0+4;
linestyle='--';

%    yyaxis left
%       color='r'; %for Vx cuz leading/trailing colormap cmapRedBlue
%       alphavalue=0.1;
%   linestyle='--';
%     shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vxABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle);
%     
%    yyaxis right
%       color=colorpurple; %colororange; %for Vy cuz vertical colormap cmapOrangePurple
%       alphavalue=0.08;
%   linestyle='--';
%     shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vyABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle); %took out this--if had been in-line above, then needed: smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan')
%>>>Need to INSTEAD graph ONE control line that is average of the two! and plot it against the LEFT axis so it stays in the view!    
color=[0.6 0.6 0.6];
  for voltages=4:6
    SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLavg(voltages,:)=nanmean([SmoothMovMed3_vxABSmeanALLavg(voltages,:);SmoothMovMed3_vyABSmeanALLavg(voltages,:)]);
    SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLstd(voltages,:)=nanmean([SmoothMovMed3_vxABSmeanALLstd(voltages,:);SmoothMovMed3_vyABSmeanALLstd(voltages,:)]);
  end
  
  voltages=0+4;
  linestyle='--';
yyaxis left
shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLavg(voltages,24:setexptgraphinglength),0,color,alphavalue,linestyle); %took out this--if had been in-line above, then needed: smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan')

    LHzoomedmedium2(3) = plot(nan, nan, '--','Color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{3} = ['Mean Control'];
   legendLazyLHL = legend(LHzoomedmedium2,Lzoomedmedium2,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!

%not entirely fair because control hits purple line Mean |Vy| and it's actually above! SO NEED to adjust where it lands--below looks better!!    
yyaxis right
ylim([4.5 15]);
yyaxis left
ylim([0 37])

savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'svg');

%% ADD STDEV shading--Diff y axes now to better overlay and show they're similar decays...
alphavalue=0.2;
  %same, with TWO axes--now try to put Mean |Vx| and Mean |Vy| for only medium on same mini-plot for decay only!:   
   fig13007=figure(13007); %Replaced the below line with 0 in for the stdev!!
      voltages=0+1; linestyle = '-';
   yyaxis left
      color='r'; %for Vx cuz leading/trailing colormap cmapRedBlue
      currdoubaxis = gca;
      currdoubaxis.YAxis(1).Color = color;
      alphavalue=0.2;
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vxABSmeanALLavg(voltages,24:setexptgraphinglength),SmoothMovMed3_vxABSmeanALLstd(voltages,24:setexptgraphinglength),color,alphavalue,linestyle);
     ylim([0 40]) %set ylim to match the data best here! make panels pretty!
    ylabel('Mean |Vx| (\mum/h)'); %ylabel('Mean |Vx|, |Vy| (\mum/h)','FontSize',32) %(\mumh^{-1})
    
   yyaxis right
      color=colorpurple; %colororange; %for Vy cuz vertical colormap cmapOrangePurple
      currdoubaxis = gca;
      currdoubaxis.YAxis(2).Color = color;
      alphavalue=0.15;
    shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vyABSmeanALLavg(voltages,24:setexptgraphinglength),SmoothMovMed3_vyABSmeanALLstd(voltages,24:setexptgraphinglength),color,alphavalue,linestyle); %took out this--if had been in-line above, then needed: smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan')
     ylim([4.5 10]) %set ylim to match the data best here! make panels pretty!
    xlabel('Time (h)');
    ylabel('Mean |Vy| (\mum/h)'); %ylabel('Mean |Vx|, |Vy| (\mum/h)','FontSize',32) %(\mumh^{-1})
   
    xticks(0:1:xlimendgraphs) %update from minutes to hours!, so changed this from xticks(0:60:xlimendgraphs) when xlimendgraphs=600!
    xlim([0 xlimendgraphs]);
    
        currentaxesSmallerPanel=gca; currentaxesSmallerPanel.FontSize=32; %update font sizes for graph panels!--smaller plots needed smaller font here!
    % ytickformat('%.1f');
    set(gca,'TickDir','out')
    box on %box off %changed for better EPS exporting

%ANCHOR THESE TEXT TO *LEFT Mean Vx* AXIS this time WHICH I AM CHANGING LESS, IF AT ALL...       
yyaxis left
            currentylim=ylim;
        % annotations
        line([240/60; 240/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        line([60/60; 60/60],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off','LineWidth',1.5)
        text([62/60 242/60],[currentylim(1) currentylim(1)], {'Field On', 'Field Off'},'VerticalAlignment','bottom');
  xlim([238/60 xlimendgraphs]); %xlim([240 xlimendgraphs]);
  
  set(gcf, 'Position', [10 60 825 575]); %added for SMALLER figure panels!

  %legend stuff:
    LHzoomedmedium2(2) = plot(nan, nan, '-','Color',colorpurple,'LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{2} = ['Mean |Vy|'];
    LHzoomedmedium2(1) = plot(nan, nan, '-','Color','r','LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{1} = ['Mean |Vx|'];
   legendLazyLHL = legend(LHzoomedmedium2(1:2),Lzoomedmedium2{1:2},'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!
savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+Std-MeanABSVx+MeanABSVy--run',string(savedatetimenow)));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+Std-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+Std-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'svg');

%Add in CONTROL LINES:!!!
voltages=0+4;
linestyle='--';

%    yyaxis left
%       color='r'; %for Vx cuz leading/trailing colormap cmapRedBlue
%       alphavalue=0.1;
%   linestyle='--';
%     shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vxABSmeanALLavg(voltages,24:setexptgraphinglength),SmoothMovMed3_vxABSmeanALLstd(voltages,24:setexptgraphinglength),color,alphavalue,linestyle);
%     
%    yyaxis right
%       color=colorpurple; %colororange; %for Vy cuz vertical colormap cmapOrangePurple
%       alphavalue=0.08;
%   linestyle='--';
%     shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_vyABSmeanALLavg(voltages,24:setexptgraphinglength),SmoothMovMed3_vyABSmeanALLstd(voltages,24:setexptgraphinglength),color,alphavalue,linestyle); %took out this--if had been in-line above, then needed: smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan')
color=[0.6 0.6 0.6];
  for voltages=4:6
    SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLavg(voltages,:)=nanmean([SmoothMovMed3_vxABSmeanALLavg(voltages,:);SmoothMovMed3_vyABSmeanALLavg(voltages,:)]);
    SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLstd(voltages,:)=nanmean([SmoothMovMed3_vxABSmeanALLstd(voltages,:);SmoothMovMed3_vyABSmeanALLstd(voltages,:)]);
  end
  
  voltages=0+4;
  linestyle='--';
yyaxis left
shaded_error_wLineStyle_Width3(timeplotter(24:setexptgraphinglength),SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLavg(voltages,24:setexptgraphinglength),SmoothMovMed3_CTRLavgOfVxANDVyABSmeanALLstd(voltages,24:setexptgraphinglength),color,alphavalue,linestyle); %took out this--if had been in-line above, then needed: smoothdata(nanmean(vyABSmeanavg(:,24:setexptgraphinglength))*6*1.308,'movmedian',3,'omitnan')

    LHzoomedmedium2(3) = plot(nan, nan, '--','Color',[0.6 0.6 0.6],'LineWidth',3,'MarkerSize',10,'Marker','none');
    Lzoomedmedium2{3} = ['Mean Control'];
   legendLazyLHL = legend(LHzoomedmedium2,Lzoomedmedium2,'Location','NorthEast');
   legendLazyLHL.FontSize=28; %added for figure panels!

%not entirely fair because control hits purple line Mean |Vy| and it's actually above! SO NEED to adjust where it lands--below looks better!!    
yyaxis right
ylim([4.5 15]);
yyaxis left
ylim([0 37])

savefig(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+Std+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)));
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+Std+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'png');
saveas(gcf,strcat(processfolder,'CumFigs--piv-processing-ONLY-BULK--OverlayWStDev\','ZoomedInDecay-MediumDensOnly2Axes+Std+CTRLS-MeanABSVx+MeanABSVy--run',string(savedatetimenow)),'svg');



%% if adding magenta for different category:
%         LH(5) = plot(nan, nan, 'm','LineWidth',3,'MarkerSize',10);
%         L{5} = ['Transition Density'];
%   legendLazyLHL = legend(LH,L,'Location','best');


%        LH(4) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
%        L{4} = ['Control: High Density'];
%        LH(5) = plot(nan, nan, '-c','LineWidth',3,'MarkerSize',10);
%        L{5} = ['Control: Medium Density'];
%        LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
%        L{6} = ['Control: Low Density'];
%    legendLazyLHL = legend(LH,L,'Location','best');
%   legendLazyLHL.FontSize=28; %added for figure panels!

%SEPARATE GRAPHING legend plotting density counts? ...
%     LH(1) = plot(nan, nan, '-','Color','[0.5 0 0.5]','LineWidth',3,'MarkerSize',10);
%     L{1} = ['High Density'];
%     LH(2) = plot(nan, nan, '-b','LineWidth',3,'MarkerSize',10);
%     L{2} = ['Medium Density'];
%     LH(3) = plot(nan, nan, '-g','LineWidth',3,'MarkerSize',10);
%     L{3} = ['Low Density'];
%    legendLazyLHL = legend(LH,L,'Location','best');
%        LH(4) = plot(nan, nan, '-r','LineWidth',3,'MarkerSize',10);
%        L{4} = ['Control: High Density'];
%        LH(5) = plot(nan, nan, '-c','LineWidth',3,'MarkerSize',10);
%        L{5} = ['Control: Medium Density'];
%        LH(6) = plot(nan, nan, '-m','LineWidth',3,'MarkerSize',10);
%        L{6} = ['Control: Low Density'];
%    legendLazyLHL = legend(LH,L,'Location','best');
%   legendLazyLHL.FontSize=28; %added for figure panels!

%% Some other plot fit stuff I used...
% % [MEDSPEEDfitobj24to36, MEDSPEEDgoodness24to36, MEDSPEEDoutput24to36, MEDSPEEDconvmsg24to36] = fit(timeplotter(24:36)',log(SmoothMovMed3_speedALLavg(1,24:36))','poly1')

% % [MEDORDERfitobj24to36, MEDORDERgoodness24to36, MEDORDERoutput24to36, MEDORDERconvmsg24to36] = fit(timeplotter(24:36)',log(SmoothMovMed3_orderALLavg(1,24:36))','poly1')
% % [MEDORDERfitobj25to36, MEDORDERgoodness25to36, MEDORDERoutput25to36, MEDORDERconvmsg25to36] = fit(timeplotter(25:36)',log(SmoothMovMed3_orderALLavg(1,25:36))','poly1')
% % 
% % [MEDORDERfitobj24to60, MEDORDERgoodness24to60, MEDORDERoutput24to60, MEDORDERconvmsg24to60] = fit(timeplotter(24:60)',log(SmoothMovMed3_orderALLavg(1,24:60))','poly1')
% % [MEDORDERfitobj25to60, MEDORDERgoodness25to60, MEDORDERoutput25to60, MEDORDERconvmsg25to60] = fit(timeplotter(25:60)',log(SmoothMovMed3_orderALLavg(1,25:60))','poly1')

%% Save summary vars and save workspace?
%save Matlab_SUMMARYvariables_after_ONLY_BULK_CODE_withABSVxVy_1MED_2HIGH_3LOW_Ctrls4M5H6L--run5-22-2021.mat vymeanALLstd orderALLavg orderALLstd orderY2ALLavg orderY2ALLstd orderYALLavg orderYALLstd SmoothMovMed3_orderALLavg SmoothMovMed3_orderALLstd SmoothMovMed3_orderY2ALLavg SmoothMovMed3_orderY2ALLstd SmoothMovMed3_orderYALLavg SmoothMovMed3_orderYALLstd SmoothMovMed3_speedALLavg SmoothMovMed3_speedALLstd SmoothMovMed3_vxABSmeanALLavg SmoothMovMed3_vxABSmeanALLstd SmoothMovMed3_vxmeanALLavg SmoothMovMed3_vxmeanALLstd SmoothMovMed3_vyABSmeanALLavg SmoothMovMed3_vyABSmeanALLstd SmoothMovMed3_vymeanALLavg SmoothMovMed3_vymeanALLstd speedALLavg speedALLstd vxABSmeanALLavg vxABSmeanALLstd vxmeanALLavg vxmeanALLstd vyABSmeanALLavg vyABSmeanALLstd vymeanALLavg
%will include figures--save Matlab_Workspace_after_ONLY_BULK_CODE_withABSVxVy_1MED_2HIGH_3LOW_Ctrls4M5H6L--run5-22-2021.mat
%save Matlab_Workspace_after_ONLY_BULK_CODE_withABSVxVy_thruD24_1MED_2HIGH_3LOW_Ctrls4M5H6L--run5-22-2021.mat alphavalue bottomsideeachframe bottomsideeachframeMM color controlNormalizeValueMeanABSVX1to6AVG controlNormalizeValueMeanABSVX6AVG controlNormalizeValueMeanABSVy1to6AVG controlNormalizeValueMeanABSVy6AVG controlNormalizeValueSpeed1to6AVG controlNormalizeValueSpeedAVG controlNormalizeValueVxMean1to6AVG controlNormalizeValueVxMeanAVG convMMppx convUMppx currdoubaxis currentcolorbeforeswapping currentexptlengthtracker currentmaxexptlength currentylim currtheta currtheta2 D21_tissues date_and_descriptor EGTA_tissues ekplotter endofxaxisMM endofyaxisMM exps fig10001 fig10002 fig10003 fig10004 fig10005 fig3001 fig3002 fig3003 fig3004 fig3005 fig3006 fig3007 fig3011 fig3012 fig3013 fig4002 fig4003 fig5012 fig5013 fig6012 fig6013 first_non_NaN_index_of_this_row_j_mean_for_frames folder frames framesperhr grandParentdirectory halfwidthNROWSofCenterEG1MMBulk i iALONGY inFilePath j L last_non_NaN_index_of_this_row_j_mean_for_frames lastVoltageToPlot leftsideeachframe leftsideeachframeMM legendLazyLHL legendlocationlowercornerwest legendlocationupperEAST legendlocationupperwest LH LHmedium LHmedium2 linestyle listFolder Lmedium Lmedium2 maskFolder maskImage meanspotbetweenleftandright meanVX meanVX_maximum_value meanVX_minimum_value meanVXALONGY meanVXALONGY_maximum_value meanVXALONGY_minimum_value meanVY meanVY_maximum_value meanVY_minimum_value meanVYALONGY meanVYALONGY_maximum_value meanVYALONGY_minimum_value minperframe num_of_tissues_in_this_expt numFiles order orderALLavg orderALLstd orderavg orderY orderY2 orderY2ALLavg orderY2ALLstd orderY2avg orderYALLavg orderYALLstd orderYavg outPivStruct parentDirectory parentDirectoryAdd PIVminstepsize plotThe3700sSeparate plotTheEGTAalso processfolder rightsideeachframe rightsideeachframeMM savedatetimenow setexptgraphinglength setUMtoTrimOffBottomForOrderPAnalysis setUMtoTrimOffTopForOrderPAnalysis setwidthUMofLeadRightEdge setwidthUMofTrailLeftEdge SmoothMovMed3_orderALLavg SmoothMovMed3_orderALLstd SmoothMovMed3_orderY2ALLavg SmoothMovMed3_orderY2ALLstd SmoothMovMed3_orderYALLavg SmoothMovMed3_orderYALLstd SmoothMovMed3_speedALLavg SmoothMovMed3_speedALLstd SmoothMovMed3_vxABSmeanALLavg SmoothMovMed3_vxABSmeanALLstd SmoothMovMed3_vxmeanALLavg SmoothMovMed3_vxmeanALLstd SmoothMovMed3_vyABSmeanALLavg SmoothMovMed3_vyABSmeanALLstd SmoothMovMed3_vymeanALLavg SmoothMovMed3_vymeanALLstd speed speedALLavg speedALLstd speedavg thetas thetas2 timePassed timeplotter tissue tissue_to_start_loops_at tkplotter topsideeachframe topsideeachframeMM u_filtered u_original v0_exps v1_exps v2_exps v3_exps v4_exps v5_exps v6_exps v7_exps v8_exps v_filtered v_original voltages vx vxABSmean vxABSmeanALLavg vxABSmeanALLstd vxABSmeanavg vxbulkofEG1MMatcenterofNaNs vxmean vxmeanALLavg vxmeanALLstd vxmeanavg vxtrimmedtissue vxwithNaNs vy vyABSmean vyABSmeanALLavg vyABSmeanALLstd vyABSmeanavg vybulkofEG1MMatcenterofNaNs vymean vymeanALLavg vymeanALLstd vymeanavg vytrimmedtissue vywithNaNs widthNROWStoTrimOffBottom widthNROWStoTrimOffTop widthUMofCenterEG1MMBulk x X xlimendgraphs y Y 
