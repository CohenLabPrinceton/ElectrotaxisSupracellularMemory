%% This code was designed to loop over all separate experiments' PIV data from all tissues... Put it in a loop and tweak the below variables to address each tissue.
%% The first section is analysis on specific tissue data. The next section accumulates all data from several tisssues and calculates summary data, like average kymogrpaghs across all tissues of a certain density.
                        for loopovertissuesPIVdata=[1:30]
                            %load in PIV data here!
%% Values to choose specific to this experiment's data:
first_piv_frame_with_elec_stim = first_slice_with_elec_stim-1; %remember--PIV is 1 less than slices really! %code uses this number, this is correct!
    last_piv_frame_with_elec_stim = last_slice_with_elec_stim-1; %remember--PIV is 1 less than slices really! %code uses this number, this is correct!
    %note: code below uses primarily: first_piv_frame_with_elec_stim and last_SLICE_with_elec_stim because the next slice is right AS (0.01 after) the stim turns off, so the PIV to that slice is really quality still for e stim data! calling it earlier is not doing the relaxation stage justice!   
last_frame_end_of_expt = size(u_filtered,1); %54 or 84 etc.
frames = size(u_filtered,1);

%WOULD YOU LIKE LINES FOR TISSUE EDGES, OR JUST MARKERS?
%do_you_want_tissue_edge_lines = 0; for no and = 1 for yes!   
do_you_want_tissue_edge_lines = 0; %1=turn on lines also! 0=only markers!

%WOULD YOU LIKE TO GRAPH THE MEANS ALONG THE Y-POSITION AXIS? i.e. veritcally analyzing   
do_you_want_analysis_ALONG_Y_POSITION = 1; %1=yes, %0=turn off graphing & details (but analysis loop will run regardless)   
%Note: horizontal analysis is more logical because this is how we focus on the tissue: trailing edge, leading edge, etc. ... top and bottom is less crucial & should be symmetrical!   

%these two are not yet implemented below, because it's easier to see 1.308 below if you'd like to check my work!    
convUMppx = 1.308; %1.308 for Zeiss at 5x (because 6.54 um/pixel divided by 5); conv=1.825 for Nikon at 4x because 7.3 MICRONS PER PIXEL FOR THE NIKON, divided by 4 for 4x phase = 1.825;  
convMMppx = convUMppx*1e-3; %or 1.308e-3; %because 1.308e-3 mm/pixel; see above 
PIVminstepsize = 16; %i.e. PIVlab set to 64-32, then 32-16 (integ window-step size), so result vectors are every 16 pixels.
DENScodestepsize = 32; %added v53--density math was done at a box size twice as large as PIV! Need to account for this and replaced for "PIVminstepsize" below where applicable   
framesperhr=6;
    minperframe=60/framesperhr;
    endofcontrolperiod = first_piv_frame_with_elec_stim*minperframe; %60 NOT 70! B/C PIV!; %minutes; take # of last control image * 10 %STANDARD: for 1 hour control + 4 hour stim, then: 70-10 because PIV!=60; 310-10=300!. (Because 7*10; 70+(4*60)-10.)
    endofstimulationperiodintotalminutes = (last_slice_with_elec_stim-0.01)*minperframe; %299.9; %minutes; take # of last image taken during electrical stimultion *10 %STANDARD: 310 if 5 hours in ^. 
                                            %Note used SLICE not piv frame because 29.99--explained above. 
%implement flipping in this section to be sure it's noticed and happens BEFORE ANY analysis is done... this code as of v28 does not use any other matrices and usually has zero others loaded as blanks. If add more, must flip all as added!    
        if isThisExperimentToTheLEFT==1; %chosen above "%choose =1 if taxis was to the left and hence need to *flip it*!"   
            for flipper=1:size(x,1)
                x{flipper}=fliplr(x{flipper});
                y{flipper}=fliplr(y{flipper});
                u_original{flipper}=-fliplr(u_original{flipper}); %note the NEGATIVE SIGN for the u (i.e. x-direction) vectors   
                v_original{flipper}=fliplr(v_original{flipper});
                u_filtered{flipper}=-fliplr(u_filtered{flipper}); %note the NEGATIVE SIGN for the u (i.e. x-direction) vectors  
                v_filtered{flipper}=fliplr(v_filtered{flipper});
                %typevector_original{flipper}=fliplr(typevector_original{flipper});
                %typevector_filtered{flipper}=fliplr(typevector_filtered{flipper});
            end
        end

%% Assign important variables:
%Without replacing the filtered into the original, the graph goes very high at times! using unfiltered (>5 st dev away) PIV vector values     
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
frames=length(vx); %total # of frames %24 %54; %or size(u_filtered,1) %[set to a number ONLY if you want to cut data short!]   
%% MATH FOR ALL 4 TYPES OF CALCULATIONS: [moved up here in v16 update]  
 % 1. meanVX along the x-axis ("normal"/original way):
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
endofyaxisMM = convMMppx*PIVminstepsize*(length(meanVYALONGY)); %NOT CEIL! %V80
endofyaxisMM = ceil(convMMppx*PIVminstepsize*(length(meanVYALONGY))); %V80

%Added in v29: (copied from below! moved up here just in case...to apply all math near start):
for j=1:frames
    first_non_NaN_index_of_this_row_j_mean_for_frames = find(~isnan(meanVX(j,:)), 1); %find left edge of tissue!
      leftsideeachframe(j)=first_non_NaN_index_of_this_row_j_mean_for_frames; %save that just in case
    last_non_NaN_index_of_this_row_j_mean_for_frames = find(~isnan(meanVX(j,:)), 1, 'last'); %find right edge of tissue!
      rightsideeachframe(j)=last_non_NaN_index_of_this_row_j_mean_for_frames; %save that just in case
    middleXofeachframe(j)=round((leftsideeachframe(j)+rightsideeachframe(j))/2); %added V47 for summary kymographs!
    actualXwidthofeachframe(j)=rightsideeachframe(j)-leftsideeachframe(j);
end
for j=1:frames
    first_non_NaN_index_of_this_row_j_mean_for_frames = find(~isnan(meanVXALONGY(j,:)), 1); %find left edge of tissue!
      bottomsideeachframe(j)=first_non_NaN_index_of_this_row_j_mean_for_frames; %save JIC for later %THIS IS BOTTOM! see note two lines below...
    last_non_NaN_index_of_this_row_j_mean_for_frames = find(~isnan(meanVXALONGY(j,:)), 1, 'last'); %find right edge of tissue!
      topsideeachframe(j)=last_non_NaN_index_of_this_row_j_mean_for_frames; %NOTE THIS IS THE TOP! i.e. top is at top of graph... :) double check? Vy should be positive at the top as cells move north
    middleYofeachframe(j)=round((bottomsideeachframe(j)+topsideeachframe(j))/2); %added V47 for summary kymographs!
    actualYwidthofeachframe(j)=rightsideeachframe(j)-leftsideeachframe(j);
end
leftsideeachframeMM = leftsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
rightsideeachframeMM = rightsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
bottomsideeachframeMM = bottomsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
topsideeachframeMM = topsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
middleXofeachframeMM = middleXofeachframe*convMMppx*PIVminstepsize; %added V47 %save this data in MM in case desired or want to plot
middleYofeachframeMM = middleYofeachframe*convMMppx*PIVminstepsize; %added V47 %save this data in MM in case desired or want to plot

%% initialize variables for kymographs --this is a sample for Mean Vx, but this was also done for other variables, e.g. order parameter  
ALLmeanVXcenteredWIDTH=1000;
ALLmeanVXcenteredHEIGHTtime=150; %V75 to accomodate the 127 length of D20!
ALLmeanVXcentered{grosstissuecounter}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %initialize for this tissue
    ALLmeanVYcentered{grosstissuecounter}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %initialize for this tissue
ALLmeanVXcenteredLOWDENSITY{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
ALLmeanVXcenteredMEDIUMDENSITY{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
    ALLmeanVXcenteredMEDIUMDENSITYsubMEDIUM{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
    ALLmeanVXcenteredMEDIUMDENSITYsubHIGH{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
ALLmeanVXcenteredHIGHDENSITY{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
ALLmeanVXcenteredTRANSITIONDENSITY{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
ALLmeanVXcenteredCONTROLS{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
 ALLmeanVXcenteredLOW_CONTROLS{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
 ALLmeanVXcenteredMEDIUM_CONTROLS{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
 ALLmeanVXcenteredHIGH_CONTROLS{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
 ALLmeanVXcenteredTRANSITION_CONTROLS{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH);
    ALLmeanVXcenteredCONTROLSgoodwperfusion{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V75 perfusion add!
        ALLmeanVXcenteredLOW_CONTROLSgoodwperfusion{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V75 perfusion add!
        ALLmeanVXcenteredMEDIUM_CONTROLSgoodwperfusion{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V75 perfusion add!
        ALLmeanVXcenteredHIGH_CONTROLSgoodwperfusion{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V75 perfusion add!
        ALLmeanVXcenteredTRANSITION_CONTROLSgoodwperfusion{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V75 perfusion add!
ALLmeanVXcenteredEGTA{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V76 added for EGTA!
 ALLmeanVXcenteredLOW_EGTA{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V76 added for EGTA!
 ALLmeanVXcenteredMEDIUM_EGTA{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V76 added for EGTA!
 ALLmeanVXcenteredHIGH_EGTA{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V76 added for EGTA!
 ALLmeanVXcenteredTRANSITION_EGTA{1}=NaN(ALLmeanVXcenteredHEIGHTtime,ALLmeanVXcenteredWIDTH); %V76 added for EGTA!
    middleXofFIRSTframe=middleXofeachframe(1); %added V48 %"n" for 500-n:500+m-n
		ALLTissues_middleXofFIRSTframe{grosstissuecounter}=middleXofFIRSTframe; %V80 added this to save it just in case something else needs centering later...
    entireWidthOfmeanVX=size(meanVX,2); %added V48 %"m" for 500-n:500+m-n
    
%% kymograph for single tissue:
fig3=figure;
meanVXforimagescplot(2:(frames+1),:)=meanVX(1:frames,:); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
meanVXforimagescplot(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
C1 = meanVXforimagescplot*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(length(meanVX)));
locatex1 = [0 endofxaxisMM];
locatey1 = [0 frames/framesperhr];
  kymoheatmap2 = imagesc(locatex1,locatey1,C1);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(kymoheatmap2, 'AlphaData', ~isnan(C1)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
    if plotteddensityISTHISACONTROLorder{grosstissuecounter}==0 && hugerlooptotalexperiments~=25 %added V76 EGTA exclusion! %ADDED V75 TO ELIMINATE ESTIM LABEL IF IT IS A CONTROL!
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
    end
xlabel('x-position (mm)','fontsize',18, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',18, 'FontName', 'Arial');
title(strcat('Kymograph Heat Map of Mean Vx along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
cbar2 = colorbar;
cbarevenscale=max(abs(5*floor(meanVX_minimum_value/5)),abs(5*ceil(meanVX_maximum_value/5)));
caxis([-cbarevenscale cbarevenscale]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
caxis([-35 35]) %caxis([-ylimMANUAL2 ylimMANUAL2]) %v40 updated for ETD normalized limits! %>>done V76 actually for this one!!
ylabel(cbar2, 'Mean V_x (\mum/h)','fontsize',20, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        currentposkymo2 = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [860 -135 800 800])

%xlim([xKymoHeatlim1 xKymoHeatlim2]);%added v54
%ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v54
        %SAVE: v17
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig3B-KymoHeat-MeanVXalongX-Parula'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig3B-KymoHeat-MeanVXalongX-Parula'),'png');

  if did_you_add_other_colors_to_save_too_viridis_gray_etc==1     %v17:
    %CHANGE COLORMAP AND SAVE, ROTATE THROUGH OTHER OPTIONS...    
    colormap(gray) %colorblind-friendly and B&W print-friendly
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig3b-KymoHeat-MeanVXalongX-Gray'),'png');
    colormap(parula) %colorblind-friendly and B&W print-friendly
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig3b-KymoHeat-MeanVXalongX-Parula'),'png');
    colormap(viridis) %colorblind-friendly and B&W print-friendly
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig3b-KymoHeat-MeanVXalongX-viridis'),'png');
    colormap(cmapRedBlue) %colorblind-friendly and B&W print-friendly
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-FIG3-KymoHeat-MeanVXalongX-REDBLUE'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-FIG3-KymoHeat-MeanVXalongX-REDBLUE'),'png');
        saveas(gcf,strcat(savePrefixAddCollectiveGraphFolder,'\',expt_descriptor_PIV2{hugeloopTISSUEnum},'-T',num2str(hugeloopTISSUEnum),'-FIG3-KymoHeat-MeanVXalongX-REDBLUE'),'png'); %added V43 to duplicate key graphs in one summary folder!
%     colormap(plasma) %colorblind-friendly and B&W print-friendly %I liked plasma more than inferno and magma, although they're all VERY similar. For some reason though, Plasma isn't working, even after "running" the functions...   
%         saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig3b-KymoHeat-MeanVXalongX-plasma'),'png');
%     colormap(cividis) %colorblind-friendly and B&W print-friendly
%         saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig3b-KymoHeat-MeanVXalongX-cividis'),'png');
    %colormap(parula) %leave in RedBlue colormap as is boss preference when data crosses zero %RESET TO: DEFAULT IN MATLAB AND PROBABLY BEST TO USE...   
  end
    xlim([xKymoHeatlim1 xKymoHeatlim2+0.5]);%added v79 %NmzdSize 
    ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v79 %NmzdSize
     set(gcf, 'Position', [860 -135 830 800])
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-FIG3-KymoHeat-NmzdSize-MeanVXalongX-REDBLUE'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-FIG3-KymoHeat-NmzdSize-MeanVXalongX-REDBLUE'),'png');
        saveas(gcf,strcat(savePrefixAddCollectiveGraphFolder,'\',expt_descriptor_PIV2{hugeloopTISSUEnum},'-T',num2str(hugeloopTISSUEnum),'-FIG3-KymoHeat-NmzdSize-MeanVXalongX-REDBLUE'),'png'); %added V43 to duplicate key graphs in one summary folder!
        
%% Do the math needed for this section--particularly note the math for directionality order parameter!:
%%%%%%%%%%%   24*convMMppx*PIVminstepsize EQUALS 0.5023, SO TAKE 24 NEAREST COLUMNS TO THE FIRST NAN AND USE THAT AS THE LEADING & TRAILING EDGES OF THE TISSUE!              
% leftsideeachframe(j) -- calculated above
% rightsideeachframe(j) -- calculated above
%PUT IN TOP SECTION-- setwidthUMofleadtrailedges = 500; %microns, e.g. want 500 um segment/strip to lump within the "trailing" and "leading" edges...   
%AT TOP: setwidthUMofLeadRightEdge = 500; %MICRONS, e.g. want 500 um (=0.5 mm) segment/strip to lump within the "trailing" and "leading" edges...  
%AT TOP: setwidthUMofTrailLeftEdge = 500; %MICRONS, e.g. want 500 um (=0.5 mm) segment/strip to lump within the "trailing" and "leading" edges...  
widthNROWSofLeadRightEdge = floor(setwidthUMofLeadRightEdge/(1000*convMMppx*PIVminstepsize)); %converting microns to # of rows  
widthNROWSofTrailLeftEdge = floor(setwidthUMofTrailLeftEdge/(1000*convMMppx*PIVminstepsize)); %converting microns to # of rows  
halfwidthNROWSofCenterEG1MMBulk = floor(widthUMofCenterEG1MMBulk/(2*1000*convMMppx*PIVminstepsize)); %converting microns to # of rows %usually double e.g. 1 MM if edges were set to 0.5 mm (or 500 um)
widthNROWStoTrimOffTop = floor(setUMtoTrimOffTopForOrderPAnalysis/(1000*convMMppx*PIVminstepsize)); %converting microns to # of rows  
widthNROWStoTrimOffBottom = floor(setUMtoTrimOffBottomForOrderPAnalysis/(1000*convMMppx*PIVminstepsize)); %converting microns to # of rows  
    %above two rows added on v28; the math will equal zero if set to zero in top section!     
    
for j=1:frames
    vxtrimmedtissue{j} = vxwithNaNs{j}(bottomsideeachframe(j):topsideeachframe(j),leftsideeachframe(j):rightsideeachframe(j)); %cut off rows of *only* NaNs on both sides! So this is now the minimum size that includes all numbers--for each frame is different shape then! (inccorect to do math on this for kymographs or anything...)
    %v28 added in line above: trimmed in y axis also! i.e. changed (:,...) to (bottomsideeachframe(j):topsideeachframe(j),...), and same 12 lines below here for vytrimmedtissue!    
    %and then in ALL assignments below, must change the (:,...) to (bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop)         
        
    vxLEFTtrailingedgematrixof500um{j} = vxwithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),leftsideeachframe(j):(leftsideeachframe(j)+widthNROWSofTrailLeftEdge)); %24 columns=500 microns because 24*convMMppx*PIVminstepsize=0.5023 mm.
    vxRIGHTleadingedgematrixof500um{j} = vxwithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),(rightsideeachframe(j)-widthNROWSofLeadRightEdge):rightsideeachframe(j));
    
    vxeverythingelsebulk{j} = vxwithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),(leftsideeachframe(j)+widthNROWSofTrailLeftEdge):(rightsideeachframe(j)-widthNROWSofLeadRightEdge));
    meanspotbetweenleftandright(j) = round(mean([leftsideeachframe(j) rightsideeachframe(j)])); %center point between leftmost and rightmost edges
    vxbulkofEG1MMatcenterofNaNs{j} = vxwithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),(meanspotbetweenleftandright(j)-halfwidthNROWSofCenterEG1MMBulk):(meanspotbetweenleftandright(j)+halfwidthNROWSofCenterEG1MMBulk)); %47 columns is 0.9836 MM %48 columns is 1.0045 MM
    
 widthofeverythingelsebulk(j) = (rightsideeachframe(j)-widthNROWSofLeadRightEdge) - (leftsideeachframe(j)+widthNROWSofTrailLeftEdge) + 1;
 %NOW FOR vy: (note that I care about x-direction math here, because that's where the leading and trailing edge is!!--but another instance OR it may be more correct to (also?) trimm the tissue vertically! I have a topsideeachframe(j) and bottomsideeachframe(j) anyway... HMMM)   
    vytrimmedtissue{j} = vywithNaNs{j}(bottomsideeachframe(j):topsideeachframe(j),leftsideeachframe(j):rightsideeachframe(j)); %cut off rows of *only* NaNs on both sides! So this is now the minimum size that includes all numbers--for each frame is different shape then! (incorrect to do math on this for kymographs or anything...)
    
    vyLEFTtrailingedgematrixof500um{j} = vywithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),leftsideeachframe(j):(leftsideeachframe(j)+widthNROWSofTrailLeftEdge)); %24 columns=500 microns because 24*convMMppx*PIVminstepsize=0.5023 mm.
    vyRIGHTleadingedgematrixof500um{j} = vywithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),(rightsideeachframe(j)-widthNROWSofLeadRightEdge):rightsideeachframe(j));
    
    vyeverythingelsebulk{j} = vywithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),(leftsideeachframe(j)+widthNROWSofTrailLeftEdge):(rightsideeachframe(j)-widthNROWSofLeadRightEdge));
    meanspotbetweenleftandright(j) = round(mean([leftsideeachframe(j) rightsideeachframe(j)])); %center point between leftmost and rightmost edges
    vybulkofEG1MMatcenterofNaNs{j} = vywithNaNs{j}((bottomsideeachframe(j)+widthNROWStoTrimOffBottom):(topsideeachframe(j)-widthNROWStoTrimOffTop),(meanspotbetweenleftandright(j)-halfwidthNROWSofCenterEG1MMBulk):(meanspotbetweenleftandright(j)+halfwidthNROWSofCenterEG1MMBulk)); %47 columns is 0.9836 MM %48 columns is 1.0045 MM

 %NOW CAN SET any of these matrices into the vxwithNaNs and vywithNaNs in the graphing math below, and we'll get order parameter, etc. for only this segment!      
end
setrotatinglegendtitle='';
 %NOW CAN SET any of these matrices into the vxwithNaNs and vywithNaNs in the graphing math below, and we'll get order parameter, etc. for only this segment!      

%AT TOP     endofcontrolperiod = first_piv_frame_with_elec_stim*(60/framesperhr); %60 NOT 70! B/C PIV!; %minutes; take # of last control image * 10 %STANDARD: for 1 hour control + 4 hour stim, then: 70-10 because PIV!=60; 310-10=300!. (Because 7*10; 70+(4*60)-10.)
%AT TOP     endofstimulationperiodintotalminutes = (last_slice_with_elec_stim-0.01)*(60/framesperhr); %299.9; %minutes; take # of last image taken during electrical stimultion *10 %STANDARD: 310 if 5 hours in ^. 

currentfigurecounter = 1; %currentfigurecounter = currentfigurecounter+1;
linestooverlay = 3; %CHANGE TO 5 TO ADD 2 OTHER LINES IN--ALL PIV, AND ENTIRE BULK...   
 %if changing ^ this line from 3 to 5 or vice versa, and then re-running the below graphs, MUST FIRST CLEAR SOME VARIABLES OR ELSE RESULTS WILL BE SKEWED!:
 clear orderavg speedavg orderstd speedstd ek vx vy x y tk currtheta tempspeed order orderstdev speed speedstdev orderavg orderstd speedavg speedstd legendLazyLHL LH L lowOrderAvgMinusStd highOrderAvgMinusStd lowSpeedAvgMinusStd highSpeedAvgMinusStd graphpatch1 graphpatch2
    orderavg=zeros(linestooverlay,frames);
    speedavg=zeros(linestooverlay,frames);
     orderstd=zeros(linestooverlay,frames);
     orderSEM=zeros(linestooverlay,frames);
     speedstd=zeros(linestooverlay,frames);
     speedSEM=zeros(linestooverlay,frames);
x0 = 1; %can be 30, whenever you want to start the graph >> %%used 1 because this is a cropped region so want all of it!
y0 = 1; 
%chooseSTDas1orSEMas2orOFFas0 is set above in top section!
alphatransparency = 0.15; %how transparent the std error (shaded area) will be
    % calculate thetas
  for ek=1:linestooverlay  %rotate through different versions of vx and vy to plot each overlayed:       
    if ek==1
        vx = vxLEFTtrailingedgematrixof500um;
        vy = vyLEFTtrailingedgematrixof500um;
            setrotatinglegendtitle=['Trailing ',num2str(setwidthUMofTrailLeftEdge,4),' um Edge']; %'Trailing 500 um Edge';    
            color = 'r'; %red
    elseif ek==2
        vx = vxRIGHTleadingedgematrixof500um;
        vy = vyRIGHTleadingedgematrixof500um;
            setrotatinglegendtitle=['Leading ',num2str(setwidthUMofLeadRightEdge,4),' um Edge']; %'Leading 500 um Edge';
            color = 'b'; %blue
    elseif ek==3
        vx = vxbulkofEG1MMatcenterofNaNs;
        vy = vybulkofEG1MMatcenterofNaNs;
            setrotatinglegendtitle=[num2str(widthUMofCenterEG1MMBulk/1000,2),' mm Bulk in Center']; %'1 mm Bulk in Center'
            color = 'k'; %black
    elseif ek==4 %OR STANDARD, WHOLE TISSUE: DOTTED BLACK LINE...
        vx = vxwithNaNs;
        vy = vywithNaNs;
             setrotatinglegendtitle='Entire Masked Tissue';
             color = 'g'; %green  %':k' didn't work--wanted black again for combo line, dotted this time!  
    elseif ek==5 %or all bulk aside from edges:
        vx = vxeverythingelsebulk;
        vy = vyeverythingelsebulk;
            if setwidthUMofLeadRightEdge==setwidthUMofTrailLeftEdge
                setrotatinglegendtitle=['Bulk between ',num2str(setwidthUMofLeadRightEdge,4),' um Edges'];
            else %if the edges set are not equal widths, e.g. both 500 um:
                setrotatinglegendtitle='Bulk between Delineated Edges';
            end
            color = 'm'; %magenta/pink
    end
    
%Now do the math, calculate theta between vx and vy, then do cos(theta) to get projection of that vector with the x-direction:
        currtheta = cell(length(vx),1);
        for tk = 1:length(vx) %tk = frames! so for each tissue segment (ek), go through each frame here...
            for x = x0:size(vx{tk},1) %x0:xf   %UPDATE in v28: CAUGHT BUG--CHANGED vx{1} to vx{tk}--only noticed it because size decreased for one frame tk compared to first frame, but this is actually correct way to do it!    
                for y = y0:size(vx{tk},2) %y0:yf (yf changes, is cut down, so can't use that anymore!)  %UPDATE in v28: CAUGHT BUG--CHANGED vx{1} to vx{tk}--only noticed it because size decreased for one frame tk compared to first frame, but this is actually correct way to do it!     
                        if ~isnan(vx{tk}(x, y)) && ~isnan(vy{tk}(x, y)) %v14
                    currtheta{tk}(x-x0+1,y-y0+1) = atan2(-vy{tk}(x, y),vx{tk}(x, y));
                    tempspeed{tk}(x-x0+1,y-y0+1) = sqrt(vy{tk}(x, y).^2+vx{tk}(x, y).^2)*framesperhr*convUMppx; %UPDATE V21--CHANGE TO ACTUAL SPEED UP HERE, now no "*framesperhr*convUMppx"'s needed below!
                    tempVelocityXthisSection{tk}(x-x0+1,y-y0+1) = vx{tk}(x, y)*framesperhr*convUMppx; %UPDATE v35! Save this here to isolate sections of tissue and then export later!
                        end
                end
            end
            order{ek}(tk) = mean2(cos(nonzeros(currtheta{tk}))); %nonzeros flattens each time point into one column vector (hence mean2() could be changed to nanmean() here now) %YES! %originally was: mean2(cos(currtheta{tk})); but need to exclude what was NaNs, and is now zeros! %OR mean2(cos(nonzeros(currtheta{tk}))) <<<<< %do i need to cut out all the zero's too?? maybe grab from shape of numbers in vx...   
                orderstdev{ek}(tk) = nanstd(cos(nonzeros(currtheta{tk}))); %std dev at each time pt of all cos(angles) i.e. gives std for order parameter values at each time point! %std() should work fine but used nanstd() just in case %v19 added for std dev patch plot shaded error
                orderSEMcells{ek}(tk) = nanstd(cos(nonzeros(currtheta{tk})))/sqrt(numel(nonzeros(currtheta{ek}))); %SEM=STD/sqrt(N), where N here=number of elements EXCLUDING NaN's! (hence used nonzeros() in between!)
            speed{ek}(tk) = nanmean(nanmean(tempspeed{tk})); %v14 changed from = mean2(tempspeed{tk}); to nanmean() twice! (mean2 does all of matrix into one, whereas nanmean and mean do matrix into a row vector of the column means.
                speedstdev{ek}(tk) = nanstd(tempspeed{tk}(:)); %v19 %need std of each frame entirely, so matrix(:) gives column of all elements! %tempspeed{tk} is current velocities at every point in the tissue/matrix/PIV data at time frame tk >> so, the nanmean() is taken twice to get the mean of columns and then mean of rows (could use mean2() which takes the mean of ALL elements of matrix at once, but then we wouldn't have the NaN skipping functionality! so do it in two steps!)
                speedSEMcells{ek}(tk) = nanstd(tempspeed{tk}(:))/sqrt(numel(nonzeros(tempspeed{tk}))); %EXCLUDING NaN's! (hence used nonzeros() in between!) %v22
              VelocityXthisSection{ek}(tk) = nanmean(nanmean(tempVelocityXthisSection{tk})); %UPDATE v35! Save this here to isolate sections of tissue and then export later!
                  VelocityXthisSectionstdev{ek}(tk) = nanstd(tempVelocityXthisSection{tk}(:));   
                  VelocityXthisSectionSEMcells{ek}(tk) = nanstd(tempVelocityXthisSection{tk}(:))/sqrt(numel(nonzeros(tempVelocityXthisSection{tk})));   
        end
        thetas{ek} = currtheta; %has all the theta angles (entire matrix/tissue/strip selected) for each frame in timelapse, of {ek} is each expt/type of PIV selected  
        %add in here a save for order i.e. cos(thetas) in matrix form?? %v24!   
        
  %end
%base math done, now get mean, and then graph it:
  %  for ek=1:linestooverlay
        orderavg(ek,:) = order{ek}; %MAIN VECTORS WITH RESULTS OF MATH!!!    *******************     
        speedavg(ek,:) = speed{ek}; %MAIN VECTORS WITH RESULTS OF MATH!!!    *******************     
            orderstd(ek,:) = orderstdev{ek}; %MAIN OUTPUT
                lowOrderAvgMinusStd = orderavg - orderstd;
                highOrderAvgPlusStd = orderavg + orderstd;
            orderSEM(ek,:) = orderSEMcells{ek}; %MAIN OUTPUT
                lowOrderAvgMinusSEM = orderavg - orderSEM;
                highOrderAvgPlusSEM = orderavg + orderSEM;
            speedstd(ek,:) = speedstdev{ek}; %MAIN OUTPUT
                lowSpeedAvgMinusStd = speedavg - speedstd;
                highSpeedAvgPlusStd = speedavg + speedstd; 
            speedSEM(ek,:) = speedSEMcells{ek}; %MAIN OUTPUT
                lowSpeedAvgMinusSEM = speedavg - speedSEM;
                highSpeedAvgPlusSEM = speedavg + speedSEM;
    %UPDATED: added v35:
        VelocityXthisSectionAVG(ek,:) = VelocityXthisSection{ek}; %MAIN VECTORS WITH RESULTS OF MATH!!!    *******************     
            VelocityXthisSectionstd(ek,:) = VelocityXthisSectionstdev{ek}; %MAIN OUTPUT
                lowVelocityXthisSectionAvgMinusStd = VelocityXthisSectionAVG - VelocityXthisSectionstd;
                highVelocityXthisSectionAvgPlusStd = VelocityXthisSectionAVG + VelocityXthisSectionstd; 
            VelocityXthisSectionSEM(ek,:) = VelocityXthisSectionSEMcells{ek}; %MAIN OUTPUT
                lowVelocityXthisSectionAvgMinusSEM = VelocityXthisSectionAVG - VelocityXthisSectionSEM;
                highVelocityXthisSectionAvgPlusSEM = VelocityXthisSectionAVG + VelocityXthisSectionSEM;
  %  end
    timeMin = (1:length(thetas{ek}))*minperframe; %t to plot on x-axis

fig101=figure(100+currentfigurecounter);
    plot([-1000 1000],[0 0],'k');
    hold on;
        if chooseSTDas1orSEMas2orOFFas0 == 1
          graphpatch1(ek) = patch([timeMin timeMin(end:-1:1) timeMin(1)],[lowOrderAvgMinusStd(ek,:) highOrderAvgPlusStd(ek,end:-1:1) lowOrderAvgMinusStd(ek,1)],color); %v20 %need to circle back when using patch, hence the reversal of the line and going back to t(1)
          set(graphpatch1(ek), 'facecolor', color, 'edgecolor', 'none', 'facealpha', alphatransparency); hold on; %v20
        elseif chooseSTDas1orSEMas2orOFFas0 == 2
          graphpatch1(ek) = patch([timeMin timeMin(end:-1:1) timeMin(1)],[lowOrderAvgMinusSEM(ek,:) highOrderAvgPlusSEM(ek,end:-1:1) lowOrderAvgMinusSEM(ek,1)],color); %v20 %need to circle back when using patch, hence the reversal of the line and going back to t(1)
          set(graphpatch1(ek), 'facecolor', color, 'edgecolor', 'none', 'facealpha', alphatransparency); hold on; %v20
        end
    %updated V75D with the below line for moving median smoothing!--plot(timeMin,orderavg(ek,:),'color',color,'LineWidth',2); %REPLACED THIS LINE, BEST FOR WHEN NEED ERROR AMONG MULTIPLE EXPTS!::: shaded_error(t,nanmean(orderavg),nanstd(orderavg),color,0.2);
    plot(timeMin,smoothdata(orderavg(ek,:),'movmedian',3,'omitnan'),'color',color,'LineWidth',2); %REPLACED THIS LINE, BEST FOR WHEN NEED ERROR AMONG MULTIPLE EXPTS!::: shaded_error(t,nanmean(orderavg),nanstd(orderavg),color,0.2);    
            %Add-on's & rest of the stuff:
              if ek == linestooverlay %i.e. if this is the last time through the loop:   
     xticks(0:60:(ceil(frames/framesperhr)*60))
     xlim([0 max(timeMin)+10]);
     xlim([0 XlimMANUAL2]) %v40 updated for ETD normalized limits!
        xticks(0:60:900) %v40 updated for ETD normalized limits!
%     ylim([-0.4 1.2])
    xlabel('Time (min)');
    ylabel('\phi');
    ytickformat('%.1f');
       %DYNAMIC SET YLIM:
      yLimAuto = get(gca,'YLim');
      %set(gca,'YLim', [yLimAuto(1) 1]); %MAKE THE MAX=1, BUT SET THE MINIMUM BASED ON THIS SPECIFIC CASE... %this really only works if (because) we plot the trailing edge first!!****  
      set(gca,'YLim', [-1 1]); %MAKE THE MAX=1, MIN=-1--CHANGED FROM LINE ABOVE IN v28  
    set(gca,'TickDir','out')
    box off

    % annotations ("Ctrl, Field On, Field Off")
        if plotteddensityISTHISACONTROLorder{grosstissuecounter}==0 && hugerlooptotalexperiments~=25 %added V76 EGTA exclusion! %ADDED V75 TO ELIMINATE ESTIM LABEL IF IT IS A CONTROL!
     line([endofstimulationperiodintotalminutes; endofstimulationperiodintotalminutes],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off')
     line([endofcontrolperiod; endofcontrolperiod],[-100 -100; 100 100],'Color','black','LineStyle','--','YLimInclude','off')
     text([2 endofcontrolperiod endofstimulationperiodintotalminutes],[max(ylim)+range(ylim)*0.06 max(ylim)+range(ylim)*0.06 max(ylim)+range(ylim)*0.06], {'Ctrl', 'EField=ON', 'EField=OFF'},'VerticalAlignment','top');
        end
        %title(strcat('Order Parameter',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(expt_info_major_matrix{expt_info_ROW,6+hugeloopTISSUEnum}),'-',extractBetween(expt_descriptor_PIV{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens')))); %added in v39
        title(strcat('                                                                                                       D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))); %added in v39

%%LAZY legend business
    LH(1) = plot(nan, nan, '-r','LineWidth',2,'MarkerSize',10);
    L{1} = ['Trailing ',num2str(setwidthUMofTrailLeftEdge),' um Edge'];
    LH(2) = plot(nan, nan, '-b','LineWidth',2,'MarkerSize',10);
    L{2} = ['Leading ',num2str(setwidthUMofLeadRightEdge),' um Edge'];
    LH(3) = plot(nan, nan, '-k','LineWidth',2,'MarkerSize',10);
    L{3} = [num2str(widthUMofCenterEG1MMBulk/1000,2),' mm Bulk in Center'];
   if linestooverlay == 5
       LH(4) = plot(nan, nan, '-g','LineWidth',2,'MarkerSize',10);
       L{4} = ['Entire Masked Tissue'];
       LH(5) = plot(nan, nan, '-m','LineWidth',2,'MarkerSize',10);
            if setwidthUMofLeadRightEdge==setwidthUMofTrailLeftEdge
                L{5} = ['Bulk between ',num2str(setwidthUMofLeadRightEdge,4),' um Edges'];
            else %if the edges set are not equal widths, e.g. both 500 um:
                L{5} = ['Bulk between Delineated Edges'];
            end
   end
    legendLazyLHL = legend(LH,L,'Location','best'); %set(legendLazyLHL,'Location','best');

    if linestooverlay==5
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig9-ALL5-OrderPrmtrVsT-PIVsegs'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig9-ALL5-OrderPrmtrVsT-PIVsegs'),'png');
    else %i.e. likely linestooverlay==3
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-Fig9-OrderPrmtrVsT-PIVsegs'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-Fig9-OrderPrmtrVsT-PIVsegs'),'png');
    end
        
        %now save same but wider version:
        currentpos = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [currentpos(1)-250 currentpos(2)-150 950 580])
            title(strcat('                                                                                                                                          D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))); %edit location for the WIDE graph %added in v39
        legendLazyLHL = legend(LH,L,'Location','best'); %before saving in wide format, reset the 'best' location of the legend!
    if linestooverlay==5 saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-FIG9-ALL5-OrderPrmtrVsT-PIVsegs_WIDE'),'png');
                         saveas(gcf,strcat(savePrefixAddCollectiveGraphFolder,'\',expt_descriptor_PIV2{hugeloopTISSUEnum},'-T',num2str(hugeloopTISSUEnum),'-FIG9-ALL5-OrderPrmtrVsT-PIVsegs_WIDE'),'png'); %added V43 to duplicate key graphs in one summary folder!
    else saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-FIG9-OrderPrmtrVsT-PIVsegs_WIDE'),'png'); %likely linestooverlay==3 
         saveas(gcf,strcat(savePrefixAddCollectiveGraphFolder,'\',expt_descriptor_PIV2{hugeloopTISSUEnum},'-T',num2str(hugeloopTISSUEnum),'-FIG9-OrderPrmtrVsT-PIVsegs_WIDE'),'png'); %added V43 to duplicate key graphs in one summary folder!
    end
        %and switch shape back to previous size and spot:
        set(gcf, 'Position', [currentpos(1) currentpos(2) currentpos(3) currentpos(4)])
        title(strcat('                                                                                                       D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))); %added in v39
              end %end mini loop of add-on's when we're in the last round  of the loop!  

  end
  
%% Now to make a kymograph of the order parameter, as analyzed across x as normal method, to show leading & trailing edges... 
%COMMENT OUT after v29--NO NEED TO CLEAR ANYMORE--%clear orderavg speedavg orderstd speedstd ek vx vy x y tk currtheta tempspeed order orderstdev speed speedstdev orderavg orderstd speedavg speedstd legendLazyLHL LH L lowOrderAvgMinusStd highOrderAvgMinusStd lowSpeedAvgMinusStd highSpeedAvgMinusStd graphpatch1 graphpatch2
%STANDARD, WHOLE TISSUE: DOTTED BLACK LINE...
        vx = vxwithNaNs;
        vy = vywithNaNs;
             setrotatinglegendtitle='Entire Masked Tissue';
             color = 'g'; %green  %':k' didn't work--wanted black again for combo line, dotted this time!  
    
%Now do the math, calculate theta between vx and vy, then do cos(theta) to get projection of that vector with the x-direction:
        currthetaKYMO = cell(length(vx),1);
        tempspeedKYMO = cell(length(vx),1);
        currcosthetaKYMO = cell(length(vx),1);
        orderKYMOtissue = zeros(size(meanVX)); %switched for v32 b/c errored on 17 lines below--%was: = zeros(length(vx),length(vx{1})); %or: = zeros(size(meanVX)); %54 down, 236 across
            %length(vx)=54 frames; length(vx{1})=236 width of tissue
x0=1; y0=1;  
        for tk = 1:length(vx) %tk = frames!
            for x = x0:size(vx{1},1) %x0:xf = 1:236, width of tissue
                for y = y0:size(vx{1},2) %y0:yf = 1:236, height of tissue (yf changes, is cut down, so can't use that anymore!)  
%TOOK OUT IF STATEMENT HERE because I now WANT NaN's in there, using nanmean() later on instead of mean2()
% %                       if ~isnan(vx{tk}(x, y)) && ~isnan(vy{tk}(x, y)) %v14
                    currthetaKYMO{tk}(x-x0+1,y-y0+1) = atan2(-vy{tk}(x, y),vx{tk}(x, y));
                    tempspeedKYMO{tk}(x-x0+1,y-y0+1) = sqrt(vy{tk}(x, y).^2+vx{tk}(x, y).^2)*framesperhr*convUMppx; %UPDATE V21--CHANGE TO ACTUAL SPEED UP HERE, now no "*framesperhr*convUMppx"'s needed below!
% %                        end
                end
            end
% %           order{ek}(tk) = nanmean(cos(nonzeros(currtheta{tk}))); %nonzeros flattens each time point into one column vector (hence mean2() could be changed to nanmean() here now) %YES! %originally was: mean2(cos(currtheta{tk})); but need to exclude what was NaNs, and is now zeros! %OR mean2(cos(nonzeros(currtheta{tk}))) <<<<< %do i need to cut out all the zero's too?? maybe grab from shape of numbers in vx...   
            %Instead of this line, we need to break it down into steps:
         %1st, take the cos(currtheta) = cos(all values in this frame), keep tissue shape still    
            currcosthetaKYMO{tk} = cos(currthetaKYMO{tk}); %calculates cos(theta) for every place in tissue in this frame
        orderKYMOtissue(tk,:) = nanmean(cos(currthetaKYMO{tk})); %**STANDALONE CRUCIAL LINE** %gives nanmean of each column, just like original meanVX calculation, gives mean for each column of cells, along x-axis %standalone, doesn't even need currcostheta, but leave it just in case wanted later...
                orderstdevKYMOtissue(tk,:) = nanstd(cos(currthetaKYMO{tk})); %std dev at each time pt of all cos(angles) i.e. gives std for order parameter values at each time point! %std() should work fine but used nanstd() just in case %v19 added for std dev patch plot shaded error
                orderSEMcellsKYMOtissue(tk,:) = nanstd(cos(currthetaKYMO{tk}))/sqrt(nnz(~isnan(currthetaKYMO{tk}))); %nnz() = number of nonzero elements in a matrix ; %SEM=STD/sqrt(N), where N here=number of elements EXCLUDING NaN's! (hence used nonzeros() in between!)
            speedKYMOtissue(tk,:) = nanmean(tempspeedKYMO{tk}); %v14 changed from = mean2(tempspeed{tk}); to nanmean() twice! (mean2 does all of matrix into one, whereas nanmean and mean do matrix into a row vector of the column means.
                speedstdevKYMOtissue(tk,:) = nanstd(tempspeedKYMO{tk}); %v19 %need std of each frame entirely, so matrix(:) gives column of all elements! %tempspeed{tk} is current velocities at every point in the tissue/matrix/PIV data at time frame tk >> so, the nanmean() is taken twice to get the mean of columns and then mean of rows (could use mean2() which takes the mean of ALL elements of matrix at once, but then we wouldn't have the NaN skipping functionality! so do it in two steps!)
                speedSEMcellsKYMOtissue(tk,:) = nanstd(tempspeedKYMO{tk})/sqrt(nnz(~isnan(tempspeedKYMO{tk}))); %EXCLUDING NaN's! (hence used nonzeros() in between!) %v22
        %orderkymotissueAvgVsXpos(tk) = nanmean(cos(currtheta{tk}));
        end
        thetasKYMOtissue = currthetaKYMO; %has all the theta angles (entire matrix/tissue/strip selected) for each frame in timelapse, of {ek} is each expt/type of PIV selected  
      
    orderavgKYMOpercolumnvsX = orderKYMOtissue; %MAIN VECTORS WITH RESULTS OF MATH!!!    *******************     
    speedavgKYMOpercolumnvsX = speedKYMOtissue; %MAIN VECTORS WITH RESULTS OF MATH!!!    *******************     
            %probably won't be used but saving like I did for individual segments above:   
            orderstdKYMOpercolumnvsX = orderstdevKYMOtissue; %MAIN OUTPUT
                lowOrderAvgMinusStdKYMOx = orderavgKYMOpercolumnvsX - orderstdKYMOpercolumnvsX;
                highOrderAvgPlusStdKYMOx = orderavgKYMOpercolumnvsX + orderstdKYMOpercolumnvsX;
            orderSEMKYMOpercolumnvsX = orderSEMcellsKYMOtissue; %MAIN OUTPUT
                lowOrderAvgMinusSEMKYMOx = orderavgKYMOpercolumnvsX - orderSEMKYMOpercolumnvsX;
                highOrderAvgPlusSEMKYMOx = orderavgKYMOpercolumnvsX + orderSEMKYMOpercolumnvsX;
            speedstdKYMOpercolumnvsX = speedstdevKYMOtissue; %MAIN OUTPUT
                lowSpeedAvgMinusStdKYMOx = speedavgKYMOpercolumnvsX - speedstdKYMOpercolumnvsX;
                highSpeedAvgPlusStdKYMOx = speedavgKYMOpercolumnvsX + speedstdKYMOpercolumnvsX; 
            speedSEMKYMOpercolumnvsX = speedSEMcellsKYMOtissue; %MAIN OUTPUT
                lowSpeedAvgMinusSEMKYMOx = speedavgKYMOpercolumnvsX - speedSEMKYMOpercolumnvsX;
                highSpeedAvgPlusSEMKYMOx = speedavgKYMOpercolumnvsX + speedSEMKYMOpercolumnvsX;
%    t = (1:length(thetas{ek}))*minperframe; %t to plot on x-axis


% NOW MATH IS DONE, LET'S PLOT THE KYMOGRAPH OF ORDER PARAMETER!:
    %we want to plot "orderavgKYMOpercolumnvsX" with imagesc (and modifications to lay it out correctly):   
%PARULA (MATLAB'S IMPROVEMENT AND PROBABLY BEST COLORMAP TO USE...)/VIRIDIS COLORMAP NOW %most correct and cleanest/simplest way to show data!:     
fig11=figure; 
OrderAvgvsXforimagescplot(2:(frames+1),:)=orderavgKYMOpercolumnvsX(1:frames,:); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
OrderAvgvsXforimagescplot(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
C11 = OrderAvgvsXforimagescplot;%*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(length(orderavgKYMOpercolumnvsX)));
locatex11 = [0 endofxaxisMM];
locatey11 = [0 frames/framesperhr];
  kymoheatmap11 = imagesc(locatex11,locatey11,C11);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(kymoheatmap11, 'AlphaData', ~isnan(C11)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
    if plotteddensityISTHISACONTROLorder{grosstissuecounter}==0 && hugerlooptotalexperiments~=25 %added V76 EGTA exclusion! %ADDED V75 TO ELIMINATE ESTIM LABEL IF IT IS A CONTROL!
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
    end
xlabel('x-position (mm)','fontsize',18, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',18, 'FontName', 'Arial');
title(strcat('Kymograph Heat Map of Order Parameter along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
cbar11 = colorbar;
caxis([-1 1]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
%'\phi Order Parameter [-1 to 1]':
ylabel(cbar11, '\phi','fontsize',21, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        currentposkymo11 = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [15 -65 800 800])

        %SAVE: v17
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig11b-KymoOrderParameter-alongX-Parula'),'png');
    colormap(cmapRedBlue)
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-Fig11-KymoOrderParameter-alongX-RedBlue'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-FIG11-KymoOrderParameter-alongX-RedBlue'),'png');
        saveas(gcf,strcat(savePrefixAddCollectiveGraphFolder,'\',expt_descriptor_PIV2{hugeloopTISSUEnum},'-T',num2str(hugeloopTISSUEnum),'-FIG11-KymoOrderParameter-alongX-RedBlue'),'png'); %added V43 to duplicate key graphs in one summary folder!
    xlim([xKymoHeatlim1 xKymoHeatlim2+0.5]);%added v79 %NmzdSize 
    ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v79 %NmzdSize
     set(gcf, 'Position', [860 -135 830 800])
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-Fig11-KymoOrderParameter-NmzdSize-alongX-RedBlue'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-FIG11-KymoOrderParameter-NmzdSize-alongX-RedBlue'),'png');
        saveas(gcf,strcat(savePrefixAddCollectiveGraphFolder,'\',expt_descriptor_PIV2{hugeloopTISSUEnum},'-T',num2str(hugeloopTISSUEnum),'-FIG11-KymoOrderParameter-NmzdSize-alongX-RedBlue'),'png'); %added V43 to duplicate key graphs in one summary folder!
        
%% Now ST DEV plot kymographs cuz why not:
        fig14=figure;
OrderStdvsXforimagescplot(2:(frames+1),:)=orderstdKYMOpercolumnvsX(1:frames,:); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
OrderStdvsXforimagescplot(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
C14 = OrderStdvsXforimagescplot;%*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(length(orderstdKYMOpercolumnvsX)));
locatex14 = [0 endofxaxisMM];
locatey14 = [0 frames/framesperhr];
  kymoheatmap14 = imagesc(locatex14,locatey14,C14);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(kymoheatmap14, 'AlphaData', ~isnan(C14)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
    if plotteddensityISTHISACONTROLorder{grosstissuecounter}==0 && hugerlooptotalexperiments~=25 %added V76 EGTA exclusion! %ADDED V75 TO ELIMINATE ESTIM LABEL IF IT IS A CONTROL!
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
    end
xlabel('x-position (mm)','fontsize',18, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',18, 'FontName', 'Arial');
title(strcat('Kymograph Heat Map of Order Parameter ST DEV along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
cbar14 = colorbar;
%caxis([-1 1]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
%'\phi Order Parameter [-1 to 1]':
ylabel(cbar14, '\phi Standard Deviation','fontsize',21, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        currentposkymo11 = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [15 -85 800 800])

        %SAVE: v17
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig14-KymoOrderPSTDEV-alongX-Parula'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig14-KymoOrderPSTDEV-alongX-Parula'),'png');

%%  stack all the tissues into one cell-matrix-variable for each classification case!     
if plotteddensityISTHISACONTROLorder{grosstissuecounter}==1 %V58 %hugerlooptotalexperiments==12 || hugerlooptotalexperiments==18 || hugerlooptotalexperiments==19 || hugerlooptotalexperiments==20 || hugerlooptotalexperiments==21 || hugerlooptotalexperiments==22 || hugerlooptotalexperiments==24
    %controls, so put in different averaging mean VX matrices...
    ALLmeanVXcenteredCONTROLS{end+1}=ALLmeanVXcentered{grosstissuecounter};
            if hugerlooptotalexperiments==12 || hugerlooptotalexperiments==20 || hugerlooptotalexperiments==22 || hugerlooptotalexperiments==24 %V76b added 22 and 24 also! %V75 SEPARATE OUT D12 AND D20
                ALLmeanVXcenteredCONTROLSgoodwperfusion{end+1}=ALLmeanVXcentered{grosstissuecounter}; %V75 SEPARATE OUT D12 AND D20
                    %V75 ADD NESTED if tree FOR CONTROL CATEGORIES within GOOD PERFUSION controls:    
                    if plotteddensityclassorder{grosstissuecounter}=='L'
                        ALLmeanVXcenteredLOW_CONTROLSgoodwperfusion{end+1}=ALLmeanVXcentered{grosstissuecounter};
                    elseif plotteddensityclassorder{grosstissuecounter}=='V'
                        ALLmeanVXcenteredHIGH_CONTROLSgoodwperfusion{end+1}=ALLmeanVXcentered{grosstissuecounter};
                    elseif plotteddensityclassorder{grosstissuecounter}=='M' || plotteddensityclassorder{grosstissuecounter}=='H' %IF MEDIUM OR HIGH! %NEEDED to EXCLUDE 'T' for Transition Regime in the 3700's in D15!
                        ALLmeanVXcenteredMEDIUM_CONTROLSgoodwperfusion{end+1}=ALLmeanVXcentered{grosstissuecounter};
                    elseif plotteddensityclassorder{grosstissuecounter}=='T'
                        ALLmeanVXcenteredTRANSITION_CONTROLSgoodwperfusion{end+1}=ALLmeanVXcentered{grosstissuecounter};
                    end
            end
        %V56 ADD NESTED if tree FOR CONTROL CATEGORIES:
        if plotteddensityclassorder{grosstissuecounter}=='L'
            ALLmeanVXcenteredLOW_CONTROLS{end+1}=ALLmeanVXcentered{grosstissuecounter};
        elseif plotteddensityclassorder{grosstissuecounter}=='V'
            ALLmeanVXcenteredHIGH_CONTROLS{end+1}=ALLmeanVXcentered{grosstissuecounter};
        elseif plotteddensityclassorder{grosstissuecounter}=='M' || plotteddensityclassorder{grosstissuecounter}=='H' %IF MEDIUM OR HIGH! %NEEDED to EXCLUDE 'T' for Transition Regime in the 3700's in D15!
            ALLmeanVXcenteredMEDIUM_CONTROLS{end+1}=ALLmeanVXcentered{grosstissuecounter};
        elseif plotteddensityclassorder{grosstissuecounter}=='T'
            ALLmeanVXcenteredTRANSITION_CONTROLS{end+1}=ALLmeanVXcentered{grosstissuecounter};
        end
elseif hugerlooptotalexperiments==25 %change later--plotteddensityISTHISanEGTAEXPTorder{grosstissuecounter}==1 %V78 update from: elseif hugerlooptotalexperiments==25 %v76 EGTA update
    ALLmeanVXcenteredEGTA{end+1}=ALLmeanVXcentered{grosstissuecounter};
        %V56 ADD NESTED if tree FOR EGTA CATEGORIES:
        if plotteddensityclassorder{grosstissuecounter}=='L'
            ALLmeanVXcenteredLOW_EGTA{end+1}=ALLmeanVXcentered{grosstissuecounter};
        elseif plotteddensityclassorder{grosstissuecounter}=='V'
            ALLmeanVXcenteredHIGH_EGTA{end+1}=ALLmeanVXcentered{grosstissuecounter};
        elseif plotteddensityclassorder{grosstissuecounter}=='M' || plotteddensityclassorder{grosstissuecounter}=='H' %IF MEDIUM OR HIGH! %NEEDED to EXCLUDE 'T' for Transition Regime in the 3700's in D15!
            ALLmeanVXcenteredMEDIUM_EGTA{end+1}=ALLmeanVXcentered{grosstissuecounter};
        elseif plotteddensityclassorder{grosstissuecounter}=='T'
            ALLmeanVXcenteredTRANSITION_EGTA{end+1}=ALLmeanVXcentered{grosstissuecounter};
        end
elseif plotteddensityclassorder{grosstissuecounter}=='L'
    ALLmeanVXcenteredLOWDENSITY{end+1}=ALLmeanVXcentered{grosstissuecounter};
elseif plotteddensityclassorder{grosstissuecounter}=='V'
    ALLmeanVXcenteredHIGHDENSITY{end+1}=ALLmeanVXcentered{grosstissuecounter};
elseif plotteddensityclassorder{grosstissuecounter}=='M' || plotteddensityclassorder{grosstissuecounter}=='H' %IF MEDIUM OR HIGH! %NEEDED to EXCLUDE 'T' for Transition Regime in the 3700's in D15!
    ALLmeanVXcenteredMEDIUMDENSITY{end+1}=ALLmeanVXcentered{grosstissuecounter};
elseif plotteddensityclassorder{grosstissuecounter}=='T'
    ALLmeanVXcenteredTRANSITIONDENSITY{end+1}=ALLmeanVXcentered{grosstissuecounter};
end

%ADDITIONALLY: save a sub-specific to my old "medium" and "high" values:
if plotteddensityclassorder{grosstissuecounter}=='M' && plotteddensityISTHISACONTROLorder{grosstissuecounter}==0 && hugerlooptotalexperiments~=25 %added V76 EGTA exclusion! %V58 %hugerlooptotalexperiments~=12 && hugerlooptotalexperiments~=18 && hugerlooptotalexperiments~=19
    ALLmeanVXcenteredMEDIUMDENSITYsubMEDIUM{end+1}=ALLmeanVXcentered{grosstissuecounter};
elseif plotteddensityclassorder{grosstissuecounter}=='H' && plotteddensityISTHISACONTROLorder{grosstissuecounter}==0 && hugerlooptotalexperiments~=25 %added V76 EGTA exclusion! %V58 %hugerlooptotalexperiments~=12 && hugerlooptotalexperiments~=18 && hugerlooptotalexperiments~=19 %%added V50! later need to also add "&& hugerlooptotalexperiments~=17"
    ALLmeanVXcenteredMEDIUMDENSITYsubHIGH{end+1}=ALLmeanVXcentered{grosstissuecounter};
end

                            end % end loop over tissues & experiments!         
%% calculate average mean Vx values across tissues for kymographs!

for i=1:length(ALLmeanVXcenteredLOWDENSITY)
ALLlow3DmeanVx(:,:,i)=ALLmeanVXcenteredLOWDENSITY{i}(1:ALLmeanVXcenteredHEIGHTtime,:); %updated in V75 just in case an expt runs longer than the height time chosen! also updated this to 150 above to accomodate D20 of t=127...
end
ALLlow3DmeanVx(:,:,1)=nanmean(ALLlow3DmeanVx(:,:,2:length(ALLmeanVXcenteredLOWDENSITY)),3);
ALLmeanVXcenteredLOWDENSITY{1}=ALLlow3DmeanVx(:,:,1);
ALLmeanVXcenteredLOWDENSITYstd{1}=nanstd(ALLlow3DmeanVx(:,:,2:length(ALLmeanVXcenteredLOWDENSITY)),0,3);
%ALLmeanVXcenteredLOWDENSITYstd{1}=nanstd(ALLlow3DmeanVx(1:ALLlastTforaveragedLOW,ALLfirstXforaveragedLOW:ALLlastXforaveragedLOW,2:length(ALLmeanVXcenteredLOWDENSITY)),0,3);
ALLmeanVXcenteredLOWDENSITYstddivmean{1}=ALLmeanVXcenteredLOWDENSITYstd{1}./ALLmeanVXcenteredLOWDENSITY{1};
    %UPDATE V63: MASK THE AVG TO ONLY INCLUDE SPOTS WITH MORE THAN 1 VALUE!--%SINCE THE STD=0 WHEREVER ONLY ONE DATA WAS USED, WE CAN JUST SET THE FINAL PRODUCT AVERAGE TO NaN WHEREVER THE STD==0! PERFECT. DO THIS BELOW UNDER %V63 UPDATE:    
    ALLmeanVXcenteredLOWDENSITYbeforeMASKINGavg=ALLmeanVXcenteredLOWDENSITY; %V63 %save before masking; also have the ALLlow3DmeanVx(:,:,1) too if needed to revert back to an older math-ed version! ALLlow3DmeanVx(:,:,1)=nanmean(ALLlow3DmeanVx(:,:,2:length(ALLmeanVXcenteredLOWDENSITY)),3);      
    ALLmeanVXcenteredLOWDENSITY{1}(ALLmeanVXcenteredLOWDENSITYstd{1}==0)=NaN; %V63 CRUCIAL LINE!     
    ALLmeanVXcenteredLOWDENSITYstd{1}(ALLmeanVXcenteredLOWDENSITYstd{1}==0)=NaN; %V63 next crucial
    ALLmeanVXcenteredLOWDENSITYstddivmean{1}(ALLmeanVXcenteredLOWDENSITYstd{1}==0)=NaN; %V63 next crucial
ALLlastTforaveragedLOW=find(~isnan(ALLmeanVXcenteredLOWDENSITY{1}(:,ALLmeanVXcenteredWIDTH/2)), 1, 'last');
ALLfirstXforaveragedLOW=find(~isnan(ALLmeanVXcenteredLOWDENSITY{1}(ALLlastTforaveragedLOW,:)), 1, 'first');
ALLlastXforaveragedLOW=find(~isnan(ALLmeanVXcenteredLOWDENSITY{1}(ALLlastTforaveragedLOW,:)), 1, 'last');

for i=1:length(ALLmeanVXcenteredMEDIUMDENSITY)
ALLmedium3DmeanVx(:,:,i)=ALLmeanVXcenteredMEDIUMDENSITY{i}(1:ALLmeanVXcenteredHEIGHTtime,:); %updated in V75 just in case an expt runs longer than the height time chosen! also updated this to 150 above to accomodate D20 of t=127...
end
ALLmedium3DmeanVx(:,:,1)=nanmean(ALLmedium3DmeanVx(:,:,2:length(ALLmeanVXcenteredMEDIUMDENSITY)),3);
ALLmeanVXcenteredMEDIUMDENSITY{1}=ALLmedium3DmeanVx(:,:,1);
ALLmeanVXcenteredMEDIUMDENSITYstd{1}=nanstd(ALLmedium3DmeanVx(:,:,2:length(ALLmeanVXcenteredMEDIUMDENSITY)),0,3);
ALLmeanVXcenteredMEDIUMDENSITYstddivmean{1}=ALLmeanVXcenteredMEDIUMDENSITYstd{1}./ALLmeanVXcenteredMEDIUMDENSITY{1};
    %UPDATE V63: MASK THE AVG TO ONLY INCLUDE SPOTS WITH MORE THAN 1 VALUE!--%SINCE THE STD=0 WHEREVER ONLY ONE DATA WAS USED, WE CAN JUST SET THE FINAL PRODUCT AVERAGE TO NaN WHEREVER THE STD==0! PERFECT. DO THIS BELOW UNDER %V63 UPDATE:    
    ALLmeanVXcenteredMEDIUMDENSITYbeforeMASKINGavg=ALLmeanVXcenteredMEDIUMDENSITY; %V63 %save before masking; also have the ALLmedium3DmeanVx(:,:,1) too if needed to revert back to an older math-ed version! ALLlow3DmeanVx(:,:,1)=nanmean(ALLlow3DmeanVx(:,:,2:length(ALLmeanVXcenteredMEDIUMDENSITY)),3);      
    ALLmeanVXcenteredMEDIUMDENSITY{1}(ALLmeanVXcenteredMEDIUMDENSITYstd{1}==0)=NaN; %V63 CRUCIAL LINE!     
    ALLmeanVXcenteredMEDIUMDENSITYstd{1}(ALLmeanVXcenteredMEDIUMDENSITYstd{1}==0)=NaN; %V63 next crucial  
    ALLmeanVXcenteredMEDIUMDENSITYstddivmean{1}(ALLmeanVXcenteredMEDIUMDENSITYstd{1}==0)=NaN; %V63 next crucial  
ALLlastTforaveragedMEDIUM=find(~isnan(ALLmeanVXcenteredMEDIUMDENSITY{1}(:,ALLmeanVXcenteredWIDTH/2)), 1, 'last');
ALLfirstXforaveragedMEDIUM=find(~isnan(ALLmeanVXcenteredMEDIUMDENSITY{1}(ALLlastTforaveragedMEDIUM,:)), 1, 'first');
ALLlastXforaveragedMEDIUM=find(~isnan(ALLmeanVXcenteredMEDIUMDENSITY{1}(ALLlastTforaveragedMEDIUM,:)), 1, 'last');

for i=1:length(ALLmeanVXcenteredHIGHDENSITY)
ALLhigh3DmeanVx(:,:,i)=ALLmeanVXcenteredHIGHDENSITY{i}(1:ALLmeanVXcenteredHEIGHTtime,:); %updated in V75 just in case an expt runs longer than the height time chosen! also updated this to 150 above to accomodate D20 of t=127...
end
ALLhigh3DmeanVx(:,:,1)=nanmean(ALLhigh3DmeanVx(:,:,2:length(ALLmeanVXcenteredHIGHDENSITY)),3);
ALLmeanVXcenteredHIGHDENSITY{1}=ALLhigh3DmeanVx(:,:,1);
ALLmeanVXcenteredHIGHDENSITYstd{1}=nanstd(ALLhigh3DmeanVx(:,:,2:length(ALLmeanVXcenteredHIGHDENSITY)),0,3);
ALLmeanVXcenteredHIGHDENSITYstddivmean{1}=ALLmeanVXcenteredHIGHDENSITYstd{1}./ALLmeanVXcenteredHIGHDENSITY{1};
    %UPDATE V63: MASK THE AVG TO ONLY INCLUDE SPOTS WITH MORE THAN 1 VALUE!--%SINCE THE STD=0 WHEREVER ONLY ONE DATA WAS USED, WE CAN JUST SET THE FINAL PRODUCT AVERAGE TO NaN WHEREVER THE STD==0! PERFECT. DO THIS BELOW UNDER %V63 UPDATE:    
    ALLmeanVXcenteredHIGHDENSITYbeforeMASKINGavg=ALLmeanVXcenteredHIGHDENSITY; %V63 %save before masking; also have the ALLhigh3DmeanVx(:,:,1) too if needed to revert back to an older math-ed version!      
    ALLmeanVXcenteredHIGHDENSITY{1}(ALLmeanVXcenteredHIGHDENSITYstd{1}==0)=NaN; %V63 CRUCIAL LINE!  
    ALLmeanVXcenteredHIGHDENSITYstd{1}(ALLmeanVXcenteredHIGHDENSITYstd{1}==0)=NaN; %V63 next crucial  
    ALLmeanVXcenteredHIGHDENSITYstddivmean{1}(ALLmeanVXcenteredHIGHDENSITYstd{1}==0)=NaN; %V63 next crucial  
ALLlastTforaveragedHIGH=find(~isnan(ALLmeanVXcenteredHIGHDENSITY{1}(:,ALLmeanVXcenteredWIDTH/2)), 1, 'last');
ALLfirstXforaveragedHIGH=find(~isnan(ALLmeanVXcenteredHIGHDENSITY{1}(ALLlastTforaveragedHIGH,:)), 1, 'first');
ALLlastXforaveragedHIGH=find(~isnan(ALLmeanVXcenteredHIGHDENSITY{1}(ALLlastTforaveragedHIGH,:)), 1, 'last');

ALLmaxlastT=max([ALLlastTforaveragedLOW ALLlastTforaveragedMEDIUM ALLlastTforaveragedHIGH]); %used in figures 361, 362, 363! 
ALLminlastT=min([ALLlastTforaveragedLOW ALLlastTforaveragedMEDIUM ALLlastTforaveragedHIGH]); %used in figures 351, 352, 353! 
ALLmaxX=max([ALLlastXforaveragedLOW ALLlastXforaveragedMEDIUM ALLlastXforaveragedHIGH]);
ALLminX=min([ALLfirstXforaveragedLOW ALLfirstXforaveragedMEDIUM ALLfirstXforaveragedHIGH]);
ALLmaxXwidth=ALLmaxX-ALLminX;

%% Graphing the meanVX cumulative kymographs... (as seen in Fig4A-C)

clearvars allmeanVXforimagescplot1LowT
%PARULA (MATLAB'S IMPROVEMENT AND PROBABLY BEST COLORMAP TO USE...)/VIRIDIS COLORMAP NOW %most correct and cleanest/simplest way to show data!:     
fig351=figure(351);
allmeanVXforimagescplot1LowT(2:(ALLmaxlastT+1),1:ALLmaxXwidth+1)=ALLmeanVXcenteredLOWDENSITY{1}(1:ALLmaxlastT,ALLminX:ALLmaxX); %before normalizing--%allmeanVXforimagescplot1(2:(ALLlastTforaveragedLOW+1),1:ALLlastXforaveragedLOW-ALLfirstXforaveragedLOW+1)=ALLmeanVXcenteredLOWDENSITY{1}(1:ALLlastTforaveragedLOW,ALLfirstXforaveragedLOW:ALLlastXforaveragedLOW); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
allmeanVXforimagescplot1LowT(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
allC1lowT = allmeanVXforimagescplot1LowT*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(ALLmaxXwidth)); %before normalizing--%endofxaxisMM = ceil(convMMppx*PIVminstepsize*(length(ALLmeanVXcenteredLOWDENSITY{1})));
alllocatex1lowT = [0 endofxaxisMM];
alllocatey1lowT = [0 ALLmaxlastT/framesperhr]; %before normalizing--%alllocatey1 = [0 ALLlastTforaveragedLOW/framesperhr];
  allkymoheatmap1lowT = imagesc(alllocatex1lowT,alllocatey1lowT,allC1lowT);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(allkymoheatmap1lowT, 'AlphaData', ~isnan(allC1lowT)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
allcbar1 = colorbar;
% % cbarevenscale=max(abs(5*floor(meanVX_minimum_value/5)),abs(5*ceil(meanVX_maximum_value/5)));
% % caxis([-cbarevenscale cbarevenscale]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
caxis([-35 35]) %caxis([-ylimMANUAL2 ylimMANUAL2]) %v40 updated for ETD normalized limits!
ylabel(allcbar1, 'Mean V_x (\mum/h)','fontsize',20, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        allcurrentposkymo1 = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [850 -135 800 800])
    %CHANGE COLORMAP AND SAVE, ROTATE THROUGH OTHER OPTIONS...    
    colormap(cmapRedBlue) %colorblind-friendly and B&W print-friendly
xlim([xKymoHeatlim1 xKymoHeatlim2]);%added v54
ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v54
        set(gca, 'FontSize', 26); xticks(ceil(xKymoHeatlim1):1:floor(xKymoHeatlim2)); yticks(ceil(yKymoHeatlim1):1:floor(yKymoHeatlim2)); %V65
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'epsc');
        set(gca, 'FontSize', 'default') %V65
        %V65 NoTitles changed ABOVE saves and moved axes & titles below   
xlabel('x-position (mm)','fontsize',20, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',20, 'FontName', 'Arial');
%title(strcat('Kymograph Heat Map of Mean Vx along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
exptReplicatesN=length(ALLmeanVXcenteredLOWDENSITY)-1; %V59 UPDATE
title(strcat('Low Density, N=',num2str(exptReplicatesN)),'fontsize',13.5); %title(strcat('Low: Average Kymograph Heat Map of Mean Vx along the x-Axis'));
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
%MOVED V58:
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
         saveas(gcf,strcat(superbasesave2directoryPLUSestimlabel,'CumFig11nzLOWDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
   

clearvars allmeanVXforimagescplot2LowT
%PARULA (MATLAB'S IMPROVEMENT AND PROBABLY BEST COLORMAP TO USE...)/VIRIDIS COLORMAP NOW %most correct and cleanest/simplest way to show data!:     
fig352=figure(352);
allmeanVXforimagescplot2LowT(2:(ALLmaxlastT+1),1:ALLmaxXwidth+1)=ALLmeanVXcenteredMEDIUMDENSITY{1}(1:ALLmaxlastT,ALLminX:ALLmaxX); %before normalizing--%allmeanVXforimagescplot2(2:(ALLlastTforaveragedMEDIUM+1),1:ALLlastXforaveragedMEDIUM-ALLfirstXforaveragedMEDIUM+1)=ALLmeanVXcenteredMEDIUMDENSITY{1}(1:ALLlastTforaveragedMEDIUM,ALLfirstXforaveragedMEDIUM:ALLlastXforaveragedMEDIUM); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
allmeanVXforimagescplot2LowT(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
allC2lowT = allmeanVXforimagescplot2LowT*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(ALLmaxXwidth)); %before normalizing--%endofxaxisMM = ceil(convMMppx*PIVminstepsize*(length(ALLmeanVXcenteredMEDIUMDENSITY{1})));
alllocatex2lowT = [0 endofxaxisMM];
alllocatey2lowT = [0 ALLmaxlastT/framesperhr]; %before normalizing--%alllocatey2 = [0 ALLlastTforaveragedMEDIUM/framesperhr];
  allkymoheatmap2lowT = imagesc(alllocatex2lowT,alllocatey2lowT,allC2lowT);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(allkymoheatmap2lowT, 'AlphaData', ~isnan(allC2lowT)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
allcbar2 = colorbar;
% % cbarevenscale=max(abs(5*floor(meanVX_minimum_value/5)),abs(5*ceil(meanVX_maximum_value/5)));
% % caxis([-cbarevenscale cbarevenscale]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
caxis([-35 35]) %caxis([-ylimMANUAL2 ylimMANUAL2]) %v40 updated for ETD normalized limits!
ylabel(allcbar2, 'Mean V_x (\mum/h)','fontsize',20, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        allcurrentposkymo2 = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [853 -135 800 800])
    %CHANGE COLORMAP AND SAVE, ROTATE THROUGH OTHER OPTIONS...    
    colormap(cmapRedBlue) %colorblind-friendly and B&W print-friendly
xlim([xKymoHeatlim1 xKymoHeatlim2]);%added v54
ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v54
        set(gca, 'FontSize', 26); xticks(ceil(xKymoHeatlim1):1:floor(xKymoHeatlim2)); yticks(ceil(yKymoHeatlim1):1:floor(yKymoHeatlim2)); %V65
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'epsc');
        set(gca, 'FontSize', 'default') %V65
        %V65 NoTitles changed ABOVE saves and moved axes & titles below
xlabel('x-position (mm)','fontsize',18, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',18, 'FontName', 'Arial');
%title(strcat('Kymograph Heat Map of Mean Vx along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
exptReplicatesN=length(ALLmeanVXcenteredMEDIUMDENSITY)-1; %V59 UPDATE
title(strcat('Medium Density, N=',num2str(exptReplicatesN)),'fontsize',13.5); %title(strcat('Medium Density: Average Kymograph Heat Map of Mean Vx along the x-Axis'));
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
%MOVED V58: PLUSestimlabel
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
         saveas(gcf,strcat(superbasesave2directoryPLUSestimlabel,'CumFig11nzMEDIUMDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
         
clearvars allmeanVXforimagescplot3LowT
%PARULA (MATLAB'S IMPROVEMENT AND PROBABLY BEST COLORMAP TO USE...)/VIRIDIS COLORMAP NOW %most correct and cleanest/simplest way to show data!:     
fig353=figure(353);
allmeanVXforimagescplot3LowT(2:(ALLmaxlastT+1),1:ALLmaxXwidth+1)=ALLmeanVXcenteredHIGHDENSITY{1}(1:ALLmaxlastT,ALLminX:ALLmaxX); %before normalizing--%allmeanVXforimagescplot3(2:(ALLlastTforaveragedHIGH+1),1:ALLlastXforaveragedHIGH-ALLfirstXforaveragedHIGH+1)=ALLmeanVXcenteredHIGHDENSITY{1}(1:ALLlastTforaveragedHIGH,ALLfirstXforaveragedHIGH:ALLlastXforaveragedHIGH); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
allmeanVXforimagescplot3LowT(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
allC3lowT = allmeanVXforimagescplot3LowT*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(ALLmaxXwidth)); %before normalizing--%endofxaxisMM = ceil(convMMppx*PIVminstepsize*(length(ALLmeanVXcenteredHIGHDENSITY{1})));
alllocatex3lowT = [0 endofxaxisMM];
alllocatey3lowT = [0 ALLmaxlastT/framesperhr]; %before normalizing--%alllocatey3 = [0 ALLlastTforaveragedHIGH/framesperhr];
  allkymoheatmap3lowT = imagesc(alllocatex3lowT,alllocatey3lowT,allC3lowT);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(allkymoheatmap3lowT, 'AlphaData', ~isnan(allC3lowT)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
allcbar3 = colorbar;
% % cbarevenscale=max(abs(5*floor(meanVX_minimum_value/5)),abs(5*ceil(meanVX_maximum_value/5)));
% % caxis([-cbarevenscale cbarevenscale]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
caxis([-35 35]) %caxis([-ylimMANUAL2 ylimMANUAL2]) %v40 updated for ETD normalized limits!
ylabel(allcbar3, 'Mean V_x (\mum/h)','fontsize',20, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        allcurrentposkymo3 = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [856 -135 800 800])
    %CHANGE COLORMAP AND SAVE, ROTATE THROUGH OTHER OPTIONS...    
    colormap(cmapRedBlue) %colorblind-friendly and B&W print-friendly
xlim([xKymoHeatlim1 xKymoHeatlim2]);%added v54
ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v54
        set(gca, 'FontSize', 26); xticks(ceil(xKymoHeatlim1):1:floor(xKymoHeatlim2)); yticks(ceil(yKymoHeatlim1):1:floor(yKymoHeatlim2)); %V65
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--NoTitles-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'epsc');
        set(gca, 'FontSize', 'default') %V65
        %V65 NoTitles changed ABOVE saves and moved axes & titles below
xlabel('x-position (mm)','fontsize',18, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',18, 'FontName', 'Arial');
%title(strcat('Kymograph Heat Map of Mean Vx along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
exptReplicatesN=length(ALLmeanVXcenteredHIGHDENSITY)-1; %V59 UPDATE
title(strcat('High Density, N=',num2str(exptReplicatesN)),'fontsize',13.5); %title(strcat('High Density: Average Kymograph Heat Map of Mean Vx along the x-Axis'));        
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
%MOVED V58: PLUSestimlabel  
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
         saveas(gcf,strcat(superbasesave2directoryPLUSestimlabel,'CumFig11nzHIGHDens--f20-','-AVERAGEKymoHeat-MeanVXalongX-REDBLUE',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');

%% DISPLAY AVERAGE MeanVx STDEV KYMOGRAPHS

clearvars allmeanVXforimagescplot1LowTstd
%PARULA (MATLAB'S IMPROVEMENT AND PROBABLY BEST COLORMAP TO USE...)/VIRIDIS COLORMAP NOW %most correct and cleanest/simplest way to show data!:     
fig451=figure(451);
allmeanVXforimagescplot1LowTstd(2:(ALLmaxlastT+1),1:ALLmaxXwidth+1)=ALLmeanVXcenteredLOWDENSITYstd{1}(1:ALLmaxlastT,ALLminX:ALLmaxX); %before normalizing--%allmeanVXforimagescplot1(2:(ALLlastTforaveragedLOW+1),1:ALLlastXforaveragedLOW-ALLfirstXforaveragedLOW+1)=ALLmeanVXcenteredLOWDENSITY{1}(1:ALLlastTforaveragedLOW,ALLfirstXforaveragedLOW:ALLlastXforaveragedLOW); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
allmeanVXforimagescplot1LowTstd(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
allC1lowTstd = allmeanVXforimagescplot1LowTstd*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(ALLmaxXwidth)); %before normalizing--%endofxaxisMM = ceil(convMMppx*PIVminstepsize*(length(ALLmeanVXcenteredLOWDENSITY{1})));
alllocatex1lowTstd = [0 endofxaxisMM];
alllocatey1lowTstd = [0 ALLmaxlastT/framesperhr]; %before normalizing--%alllocatey1 = [0 ALLlastTforaveragedLOW/framesperhr];
  allkymoheatmap1lowTstd = imagesc(alllocatex1lowTstd,alllocatey1lowTstd,allC1lowTstd);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(allkymoheatmap1lowTstd, 'AlphaData', ~isnan(allC1lowTstd)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
allcbar1std = colorbar;
% % cbarevenscale=max(abs(5*floor(meanVX_minimum_value/5)),abs(5*ceil(meanVX_maximum_value/5)));
% % caxis([-cbarevenscale cbarevenscale]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
caxis([0 25]) %caxis([-ylimMANUAL2 ylimMANUAL2]) %v40 updated for ETD normalized limits!
ylabel(allcbar1std, 'StDev V_x (\mum/h)','fontsize',20, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        allcurrentposkymo1std = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [850 -135 800 800])
    %CHANGE COLORMAP AND SAVE, ROTATE THROUGH OTHER OPTIONS...    
    %colormap(cmapRedBlue) %colorblind-friendly and B&W print-friendly
xlim([xKymoHeatlim1 xKymoHeatlim2]);%added v54
ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v54
        set(gca, 'FontSize', 26); xticks(ceil(xKymoHeatlim1):1:floor(xKymoHeatlim2)); yticks(ceil(yKymoHeatlim1):1:floor(yKymoHeatlim2)); %V65
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'epsc');
        set(gca, 'FontSize', 'default') %V65
        %V65 NoTitles changed ABOVE saves and moved axes & titles below
xlabel('x-position (mm)','fontsize',18, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',18, 'FontName', 'Arial');
%title(strcat('Kymograph Heat Map of Mean Vx along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
%replaced by below V63--title(strcat('Low Density: Average StDev Kymograph Heat Map of Mean Vx along the x-Axis'));
exptReplicatesN=length(ALLmeanVXcenteredLOWDENSITY)-1; %V59 UPDATE
title(strcat('Low Density, Standard Deviation of Mean Vx, N=',num2str(exptReplicatesN)),'fontsize',13.5); 
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzLOWDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
%MOVED V58: PLUSestimlabel  
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
         saveas(gcf,strcat(superbasesave2directoryPLUSestimlabel,'CumFig11nzLOWDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');  
         
clearvars allmeanVXforimagescplot2LowTstd
%PARULA (MATLAB'S IMPROVEMENT AND PROBABLY BEST COLORMAP TO USE...)/VIRIDIS COLORMAP NOW %most correct and cleanest/simplest way to show data!:     
fig452=figure(452);
allmeanVXforimagescplot2LowTstd(2:(ALLmaxlastT+1),1:ALLmaxXwidth+1)=ALLmeanVXcenteredMEDIUMDENSITYstd{1}(1:ALLmaxlastT,ALLminX:ALLmaxX); %before normalizing--%allmeanVXforimagescplot2(2:(ALLlastTforaveragedMEDIUM+1),1:ALLlastXforaveragedMEDIUM-ALLfirstXforaveragedMEDIUM+1)=ALLmeanVXcenteredMEDIUMDENSITY{1}(1:ALLlastTforaveragedMEDIUM,ALLfirstXforaveragedMEDIUM:ALLlastXforaveragedMEDIUM); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
allmeanVXforimagescplot2LowTstd(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
allC2lowTstd = allmeanVXforimagescplot2LowTstd*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(ALLmaxXwidth)); %before normalizing--%endofxaxisMM = ceil(convMMppx*PIVminstepsize*(length(ALLmeanVXcenteredMEDIUMDENSITY{1})));
alllocatex2lowTstd = [0 endofxaxisMM];
alllocatey2lowTstd = [0 ALLmaxlastT/framesperhr]; %before normalizing--%alllocatey2 = [0 ALLlastTforaveragedMEDIUM/framesperhr];
  allkymoheatmap2lowTstd = imagesc(alllocatex2lowTstd,alllocatey2lowTstd,allC2lowTstd);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(allkymoheatmap2lowTstd, 'AlphaData', ~isnan(allC2lowTstd)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
allcbar2std = colorbar;
% % cbarevenscale=max(abs(5*floor(meanVX_minimum_value/5)),abs(5*ceil(meanVX_maximum_value/5)));
% % caxis([-cbarevenscale cbarevenscale]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
caxis([0 25]) %caxis([-ylimMANUAL2 ylimMANUAL2]) %v40 updated for ETD normalized limits!
ylabel(allcbar2std, 'StDev V_x (\mum/h)','fontsize',20, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        allcurrentposkymo2std = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [853 -135 800 800])
    %CHANGE COLORMAP AND SAVE, ROTATE THROUGH OTHER OPTIONS...    
    %colormap(cmapRedBlue) %colorblind-friendly and B&W print-friendly
xlim([xKymoHeatlim1 xKymoHeatlim2]);%added v54
ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v54
        set(gca, 'FontSize', 26); xticks(ceil(xKymoHeatlim1):1:floor(xKymoHeatlim2)); yticks(ceil(yKymoHeatlim1):1:floor(yKymoHeatlim2)); %V65
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'epsc');
        set(gca, 'FontSize', 'default') %V65
        %V65 NoTitles changed ABOVE saves and moved axes & titles below
xlabel('x-position (mm)','fontsize',18, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',18, 'FontName', 'Arial');
%title(strcat('Kymograph Heat Map of Mean Vx along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
%V63 replaced by 2 lines below--title(strcat('Medium Density: Average StDev Kymograph Heat Map of Mean Vx along the x-Axis'));
exptReplicatesN=length(ALLmeanVXcenteredMEDIUMDENSITY)-1; %V59 UPDATE
title(strcat('Medium Density, Standard Deviation of Mean Vx, N=',num2str(exptReplicatesN)),'fontsize',13.5); 
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzMEDIUMDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
%MOVED V58: PLUSestimlabel  
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
         saveas(gcf,strcat(superbasesave2directoryPLUSestimlabel,'CumFig11nzMEDIUMDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');  

         
clearvars allmeanVXforimagescplot3LowTstd
%PARULA (MATLAB'S IMPROVEMENT AND PROBABLY BEST COLORMAP TO USE...)/VIRIDIS COLORMAP NOW %most correct and cleanest/simplest way to show data!:     
fig453=figure(453);
allmeanVXforimagescplot3LowTstd(2:(ALLmaxlastT+1),1:ALLmaxXwidth+1)=ALLmeanVXcenteredHIGHDENSITYstd{1}(1:ALLmaxlastT,ALLminX:ALLmaxX); %before normalizing--%allmeanVXforimagescplot3(2:(ALLlastTforaveragedHIGH+1),1:ALLlastXforaveragedHIGH-ALLfirstXforaveragedHIGH+1)=ALLmeanVXcenteredHIGHDENSITY{1}(1:ALLlastTforaveragedHIGH,ALLfirstXforaveragedHIGH:ALLlastXforaveragedHIGH); %because PIV frame 1 is slice 1-2, and hence frame 6 is slice 6-7--that is the hour mark! not frame 7!
allmeanVXforimagescplot3LowTstd(1,:)=NaN; %add this in as NaN's to match the others but could have also done 0's
allC3lowTstd = allmeanVXforimagescplot3LowTstd*convUMppx*framesperhr; %plot heat map (with color bar) to be in units: Horizontal Speed (\mum/h)    
endofxaxisMM = (convMMppx*PIVminstepsize*(ALLmaxXwidth)); %before normalizing--%endofxaxisMM = ceil(convMMppx*PIVminstepsize*(length(ALLmeanVXcenteredHIGHDENSITY{1})));
alllocatex3lowTstd = [0 endofxaxisMM];
alllocatey3lowTstd = [0 ALLmaxlastT/framesperhr]; %before normalizing--%alllocatey3 = [0 ALLlastTforaveragedHIGH/framesperhr];
  allkymoheatmap3lowTstd = imagesc(alllocatex3lowTstd,alllocatey3lowTstd,allC3lowTstd);
hold on;
  %DEAL WITH NaN's by setting them to Transparent in AlphaData property:    
  set(allkymoheatmap3lowTstd, 'AlphaData', ~isnan(allC3lowTstd)); %The ‘AlphaData’ is a MxN matrix of the same size as the image with each element in the range [0 1] indicating the “opacity” of a pixel. Each pixel in a Handle Graphics image object can be assigned a different level of transparency using the ‘AlphaData’ property of the image. e.g. https://www.mathworks.com/company/newsletters/articles/image-overlay-using-transparency.html
 colormap(parula) %DEFAULT IN MATLAB AND PROBABLY BEST TO USE... 
plot([-1 endofxaxisMM+1],[(first_piv_frame_with_elec_stim)/framesperhr (first_piv_frame_with_elec_stim)/framesperhr],'k--') %plot([0 5],[6/6 6/6],'k--')
plot([-1 endofxaxisMM+1],[(last_slice_with_elec_stim-0.01)/framesperhr (last_slice_with_elec_stim-0.01)/framesperhr],'k--') %plot([0 5],[29.99/6 29.99/6],'k--')
allcbar3std = colorbar;
% % cbarevenscale=max(abs(5*floor(meanVX_minimum_value/5)),abs(5*ceil(meanVX_maximum_value/5)));
% % caxis([-cbarevenscale cbarevenscale]); %caxis([5*floor(meanVX_minimum_value/5) 5*ceil(meanVX_maximum_value/5)]);  
caxis([0 25]) %caxis([-ylimMANUAL2 ylimMANUAL2]) %v40 updated for ETD normalized limits!
ylabel(allcbar3std, 'StDev V_x (\mum/h)','fontsize',20, 'FontName', 'Arial','fontweight','bold'); %or more formally: set(get(cbar,'label'),'string','Horizontal Speed (\mum/h)');  
%Note also: 0 hrs is at "PIV frame 0" or slice 1 (through 55), which is before PIV frame 1 (through 54), so no "PIV" data exists at time 0... There is no good way to cut this off without slightly affecting the data, and hence where the stim lines are placed on the graph.   
        %now make bigger:
        allcurrentposkymo3std = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        set(gcf, 'Position', [856 -135 800 800])
    %CHANGE COLORMAP AND SAVE, ROTATE THROUGH OTHER OPTIONS...    
    %colormap(cmapRedBlue) %colorblind-friendly and B&W print-friendly
xlim([xKymoHeatlim1 xKymoHeatlim2]);%added v54
ylim([yKymoHeatlim1 yKymoHeatlim2]);%added v54
        set(gca, 'FontSize', 26); xticks(ceil(xKymoHeatlim1):1:floor(xKymoHeatlim2)); yticks(ceil(yKymoHeatlim1):1:floor(yKymoHeatlim2)); %V65
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--NoTitles-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'epsc');
        set(gca, 'FontSize', 'default') %V65
        %V65 NoTitles changed ABOVE saves and moved axes & titles below
xlabel('x-position (mm)','fontsize',18, 'FontName', 'Arial');
ylabel('time (hr)','fontsize',18, 'FontName', 'Arial');
%title(strcat('Kymograph Heat Map of Mean Vx along the x-Axis',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
%V63 replaced by 2 lines below--title(strcat('High Density: Average StDev Kymograph Heat Map of Mean Vx along the x-Axis'));
exptReplicatesN=length(ALLmeanVXcenteredHIGHDENSITY)-1; %V59 UPDATE
title(strcat('High Density, Standard Deviation of Mean Vx, N=',num2str(exptReplicatesN)),'fontsize',13.5); 
         savefig(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))));
         saveas(gcf,strcat(superbasesave2directory,'CumFig11nzHIGHDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');
%MOVED V58: PLUSestimlabel  
estimONlabel='Electric Stimulation: On';
estimOFFlabel='Electric Stimulation: Off';
text(0,first_piv_frame_with_elec_stim/framesperhr+0.1,estimONlabel); %text(0,1.1,estimONlabel);
text(0,(last_slice_with_elec_stim-0.01)/framesperhr+0.1,estimOFFlabel); %text(0,29.99/6+0.1,estimOFFlabel);
         saveas(gcf,strcat(superbasesave2directoryPLUSestimlabel,'CumFig11nzHIGHDens--f20-','-StDevAVERAGEKymoHeat-MeanVXalongX-Parula',num2str(min(grosstissuerangetoPlotCumatend)),'-to-',num2str(max(grosstissuerangetoPlotCumatend))),'png');  

%% SECTION FOR AVERAGED LINE PLOTS: (as seen in Figure 4F)

ALLmeanVXcenteredMEDIUMDENSITY_maximum_value = max(max((ALLmeanVXcenteredMEDIUMDENSITY{1})))*convUMppx*framesperhr;
ALLmeanVXcenteredMEDIUMDENSITY_minimum_value = min(min((ALLmeanVXcenteredMEDIUMDENSITY{1})))*convUMppx*framesperhr;

% % Math and plot for x-speed profile:
fig551818=figure(551818);
 % v16: MATH for ALLmeanVXcenteredMEDIUMDENSITY{1} section: commented out and moved it to the top of code (just above here)!     
% for(i=1:ALLmaxlastT)
%     ALLmeanVXcenteredMEDIUMDENSITY{1}(i,:)=nanmean(vx{i}); %average down the *columns* to get avg X-speed at each X-position %nanmean(matrixX) is a row vector of column means, computed after removing NaN values.  %added ~isnan to ignore NaN values in unfiltered one!: [[used to be ALLmeanVXcenteredMEDIUMDENSITY{1}(i,:)=mean(vx{i});  ]]
% end
% ALLmeanVXcenteredMEDIUMDENSITY_maximum_value = max(max((ALLmeanVXcenteredMEDIUMDENSITY{1})))*convUMppx*framesperhr; %v6 calc for use below in vertical line making  %use ALLmeanVXcenteredMEDIUMDENSITY{1} and not vx because we want mean values -- vx_maximum_value = max(max(cell2mat(vx)));
% ALLmeanVXcenteredMEDIUMDENSITY_minimum_value = min(min((ALLmeanVXcenteredMEDIUMDENSITY{1})))*convUMppx*framesperhr; %v6
chosen_velocity_where_graph_is_empty_for_x_speed = 65;%5*ceil(ALLmeanVXcenteredMEDIUMDENSITY_maximum_value/5) -ceil(ALLmaxlastT*0.15)-1; %added v6! so don't have to choose, just will mark it near the top!  
CM = jet(ALLmaxlastT); CM=flipud(CM); %V79 flipped so that red is start! %changed JET to HSV in v37  % See the help for COLORMAP to see other choices.
%Main Plot!: speed profile!:
for j=1:ALLmaxlastT 
   plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(j,:))),smoothdata(ALLmeanVXcenteredMEDIUMDENSITY{1}(j,:)*convUMppx*framesperhr,'movmedian',6,'omitnan'),'color',CM(j,:),'marker','o','MarkerSize',5); hold on %V79 updated 'MarkerSize' from 5 to 3!
end
%now add a plot for marking the edges of the tissue, in the same coloring! 
for j=1:ALLmaxlastT
    first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT = find(~isnan(ALLmeanVXcenteredMEDIUMDENSITY{1}(j,:)), 1); %find left edge of tissue!
      leftsideeachframe(j)=first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT; %save that just in case
    last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT = find(~isnan(ALLmeanVXcenteredMEDIUMDENSITY{1}(j,:)), 1, 'last'); %find right edge of tissue!
      rightsideeachframe(j)=last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT; %save that just in case
    %plot tissue edge markers
    plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed,'color',CM(j,:),'marker','*','MarkerSize',10); hold on
    plot(convMMppx*PIVminstepsize*(last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed,'color',CM(j,:),'marker','*','MarkerSize',10);
    if do_you_want_tissue_edge_lines==1
        %plot tissue edge vertical lines (also based on "chosen_velocity" etc.)  %v6    
        plot([convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT) convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT)],[5*floor(ALLmeanVXcenteredMEDIUMDENSITY_minimum_value/5) 5*ceil(ALLmeanVXcenteredMEDIUMDENSITY_maximum_value/5)],'color',CM(j,:)); %v6
        plot([convMMppx*PIVminstepsize*(last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT) convMMppx*PIVminstepsize*(last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT)],[5*floor(ALLmeanVXcenteredMEDIUMDENSITY_minimum_value/5) 5*ceil(ALLmeanVXcenteredMEDIUMDENSITY_maximum_value/5)],'color',CM(j,:)); %v6
    end
end
leftsideeachframeMM = leftsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
rightsideeachframeMM = rightsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
xlabel('x-position (mm)')
ylabel('Mean V_x (\mum/h)')
title(strcat('Medium Density Averaged Vx Edge Speed Profile, N=',num2str(exptReplicatesN)),'fontsize',13.5);
cbarA = colorbar; %Add a time colorbar!
colormap(colormap(CM)); %set the colormap to whatever was chosen above, in CM = jet(ALLmaxlastT) or CM = parula(ALLmaxlastT); etc. %simple version: colormap(parula);  
caxis([0 ALLmaxlastT/framesperhr]); 
ylabel(cbarA, 'Time (hr)','fontsize',13, 'FontName', 'Arial');  
% % Take care of the Legends for the x-speed profile plot:
%drawing dummy dots outside the plot for the legend ... moved the dummy dots on top of previous ones so that it doesn't change the xlim and ylim of the plot! also now will overlay on top...  
a1=plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(1,:))),ALLmeanVXcenteredMEDIUMDENSITY{1}(1,:)*convUMppx*framesperhr*NaN,'color',CM(1,:),'marker','o','MarkerSize',8); %RE-PLOT 1st FOR LEGEND! NOTE: IT WILL OVERLAP THE OTHERS NOW... that may be nice, or maybe should do this in an 'if' statement in the main plotting for loop...
b1=plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(first_piv_frame_with_elec_stim,:))),ALLmeanVXcenteredMEDIUMDENSITY{1}(first_piv_frame_with_elec_stim,:)*convUMppx*framesperhr*NaN,'color',CM(first_piv_frame_with_elec_stim,:),'marker','o','MarkerSize',8); %RE-PLOT 1st FOR LEGEND! NOTE: IT WILL OVERLAP THE OTHERS NOW... that may be nice, or maybe should do this in an 'if' statement in the main plotting for loop...
%use below line if stop at 24 ALLmaxlastT within elec stim period:      also, %below, all legends must be same string length
xLimThisAuto123 = get(gca,'XLim');
    Zero_Velocity=plot([xLimThisAuto123(1) xLimThisAuto123(2)],[0 0],'k--'); %added for a border to easily show when V is positive vs. negative
    if do_you_want_tissue_edge_lines==1
        x_markers_legend=plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed*NaN,'color',CM(j,:),'marker','*','MarkerSize',10); %v6 took off "'linestyle','none');" at end! %plot over the last point just to make a marker for the legend! %instead of plot([0 0], [0 0],'marker','*','MarkerSize',10);
    elseif do_you_want_tissue_edge_lines==0
        x_markers_legend=plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed*NaN,'color',CM(j,:),'marker','*','MarkerSize',10,'linestyle','none'); %plot over the last point just to make a marker for the legend! %instead of plot([0 0], [0 0],'marker','*','MarkerSize',10);
    end
    [~, figobj, ~, ~] = legend([a1;b1;Zero_Velocity;x_markers_legend],['Start of control period       ';'Begin electric stimulation    ';'Zero Horizontal Velocity      ';'marks Tissue Edges over time  '],'Location','South');
        fig1line = findobj(figobj,'type','line'); 
        set(fig1line,'LineWidth',1.5);
        %figtype = findobj(figobj,'type','text')
        %set(figtype,'FontSize',12); %if want to change text size in legend     
if ALLmaxlastT~=24 %Put in 'if' statement for 24 cut off,
    c1=plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(last_slice_with_elec_stim,:))),ALLmeanVXcenteredMEDIUMDENSITY{1}(last_slice_with_elec_stim,:)*convUMppx*framesperhr*NaN,'color',CM(last_slice_with_elec_stim,:),'marker','o','MarkerSize',8); %RE-PLOT 1st FOR LEGEND! NOTE: IT WILL OVERLAP THE OTHERS NOW... that may be nice, or maybe should do this in an 'if' statement in the main plotting for loop...
    d1=plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(ALLmaxlastT,:))),ALLmeanVXcenteredMEDIUMDENSITY{1}(ALLmaxlastT,:)*convUMppx*framesperhr*NaN,'color',CM(ALLmaxlastT,:),'marker','o','MarkerSize',8); %RE-PLOT 1st FOR LEGEND! NOTE: IT WILL OVERLAP THE OTHERS NOW... that may be nice, or maybe should do this in an 'if' statement in the main plotting for loop...
    Zero_Velocity=plot([xLimThisAuto123(1) xLimThisAuto123(2)],[0 0],'k--'); %added for a border to easily show when V is positive vs. negative
    if do_you_want_tissue_edge_lines==1
        x_markers_legend=plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed,'color',CM(j,:),'marker','*','MarkerSize',10); %v6 took off "'linestyle','none');" at end! %plot over the last point just to make a marker for the legend! %instead of plot([0 0], [0 0],'marker','*','MarkerSize',10); %Added linestyle in this line, but equally could set the line off in legend by: set(x_markers_legend,'linestyle','none')
    elseif do_you_want_tissue_edge_lines==0
        x_markers_legend=plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed,'color',CM(j,:),'marker','*','MarkerSize',10,'linestyle','none'); %plot over the last point just to make a marker for the legend! %instead of plot([0 0], [0 0],'marker','*','MarkerSize',10);
    end
    [~, figobj, ~, ~] = legend([a1;b1;c1;d1;Zero_Velocity;x_markers_legend],['Start of control period       ';'Begin electric stimulation    ';'End of electric stimulation   ';'End of concluding relax period';'Zero Horizontal Velocity      ';'marks Tissue Edges over time  '],'Location','South');
        fig1line = findobj(figobj,'type','line');
        set(fig1line,'LineWidth',1.5);
        %figtype = findobj(figobj,'type','text')
        %set(figtype,'FontSize',12); %if want to change text size in legend     
end
%set ylim based on max and min values!--round to the nearest 5 above and below, respectively!   
%ylim([5*floor(ALLmeanVXcenteredMEDIUMDENSITY_minimum_value/5) 5*ceil(ALLmeanVXcenteredMEDIUMDENSITY_maximum_value/5)]) %BEAUT! %v6
ylim([-65 65]) %v40 updated for ETD normalized limits!
%ylim([ALLmeanVXcenteredMEDIUMDENSITY_minimum_value-5 ALLmeanVXcenteredMEDIUMDENSITY_maximum_value+5])
        %now make figure box wider:
        currentpos = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        width = currentpos(3);
        height = currentpos(4);
        set(gcf, 'Position', [currentpos(1)-250 currentpos(2)-150 950 580])

        %SAVE: v17
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig551-ALLMediumVxSpeedProfileAlongX-Smoothed6'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameOTHER,'-T',num2str(hugeloopTISSUEnum),'-Fig551-ALLMediumVxSpeedProfileAlongX-Smoothed6'),'png');
        
% % v77 re-do same graph with only time AFTER stimulation ends!---Math and plot for x-speed profile:
fig551819=figure(551819);
 % v16: MATH for ALLmeanVXcenteredMEDIUMDENSITY{1} section: commented out and moved it to the top of code (just above here)!     
% for(i=1:ALLmaxlastT)
%     ALLmeanVXcenteredMEDIUMDENSITY{1}(i,:)=nanmean(vx{i}); %average down the *columns* to get avg X-speed at each X-position %nanmean(matrixX) is a row vector of column means, computed after removing NaN values.  %added ~isnan to ignore NaN values in unfiltered one!: [[used to be ALLmeanVXcenteredMEDIUMDENSITY{1}(i,:)=mean(vx{i});  ]]
% end
% ALLmeanVXcenteredMEDIUMDENSITY_maximum_value = max(max((ALLmeanVXcenteredMEDIUMDENSITY{1})))*convUMppx*framesperhr; %v6 calc for use below in vertical line making  %use ALLmeanVXcenteredMEDIUMDENSITY{1} and not vx because we want mean values -- vx_maximum_value = max(max(cell2mat(vx)));
% ALLmeanVXcenteredMEDIUMDENSITY_minimum_value = min(min((ALLmeanVXcenteredMEDIUMDENSITY{1})))*convUMppx*framesperhr; %v6
chosen_velocity_where_graph_is_empty_for_x_speed = 5*ceil(ALLmeanVXcenteredMEDIUMDENSITY_maximum_value/5) -ceil(ALLmaxlastT*0.15)-1; %added v6! so don't have to choose, just will mark it near the top!  
%some good V79 updates here!
largerofALLmaxlastTor10hrs=max(ALLmaxlastT,60); %V79 to accomodate experiments larger than 60 ALLmaxlastT!!!
smallerofALLmaxlastTor10hrs=min(ALLmaxlastT,60); %V79 to accomodate experiments larger than 60 ALLmaxlastT!!!
%CM = jet(60); CM = flipud(CM); %V79 normalized to 4 to 10 hrs!--%CM = jet(ALLmaxlastT); %changed JET to HSV in v37  % See the help for COLORMAP to see other choices.
CMrelax = jet(largerofALLmaxlastTor10hrs-24+1); CMrelax(largerofALLmaxlastTor10hrs-22:largerofALLmaxlastTor10hrs,1:3) = 1; CMrelax = flipud(CMrelax); %dynamic to ensure first 23 cells have all white! %V79 normalized to 4 to 10 hrs!--%CM = jet(ALLmaxlastT); %changed JET to HSV in v37  % See the help for COLORMAP to see other choices.
    %V79 UPDATED CMrelax ABOVE TO BE WHITE 0-4 HRS, THEN GO FROM RED HOT IN JET TO COLD BLUE AS IT RELAXES!     
%Main Plot!: speed profile!:
for j=last_slice_with_elec_stim:smallerofALLmaxlastTor10hrs %V79 update to end at 60 (or ALLmaxlastT, whichever is bigger--errors out lower down if I end earlier!) %V77--changed from 1 to last_slice_with_elec_stim!!
   plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(j,:))),smoothdata(ALLmeanVXcenteredMEDIUMDENSITY{1}(j,:)*convUMppx*framesperhr,'movmedian',6,'omitnan'),'color',CMrelax(j,:),'marker','o','MarkerSize',5); hold on %V79 updated 'MarkerSize' from 5 to 3!
end
%now add a plot for marking the edges of the tissue, in the same coloring! 
for j=last_slice_with_elec_stim:smallerofALLmaxlastTor10hrs %V79 update to end at 60 (or ALLmaxlastT, whichever is bigger--errors out lower down if I end earlier!) %V77--changed from 1 to last_slice_with_elec_stim!!
    first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT = find(~isnan(ALLmeanVXcenteredMEDIUMDENSITY{1}(j,:)), 1); %find left edge of tissue!
      leftsideeachframe(j)=first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT; %save that just in case
    last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT = find(~isnan(ALLmeanVXcenteredMEDIUMDENSITY{1}(j,:)), 1, 'last'); %find right edge of tissue!
      rightsideeachframe(j)=last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT; %save that just in case
    %plot tissue edge markers
    plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed,'color',CMrelax(j,:),'marker','*','MarkerSize',10); hold on
    plot(convMMppx*PIVminstepsize*(last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed,'color',CMrelax(j,:),'marker','*','MarkerSize',10);
    if do_you_want_tissue_edge_lines==1
        %plot tissue edge vertical lines (also based on "chosen_velocity" etc.)  %v6    
        plot([convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT) convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT)],[5*floor(ALLmeanVXcenteredMEDIUMDENSITY_minimum_value/5) 5*ceil(ALLmeanVXcenteredMEDIUMDENSITY_maximum_value/5)],'color',CMrelax(j,:)); %v6
        plot([convMMppx*PIVminstepsize*(last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT) convMMppx*PIVminstepsize*(last_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT)],[5*floor(ALLmeanVXcenteredMEDIUMDENSITY_minimum_value/5) 5*ceil(ALLmeanVXcenteredMEDIUMDENSITY_maximum_value/5)],'color',CMrelax(j,:)); %v6
    end
end
leftsideeachframeMM = leftsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
rightsideeachframeMM = rightsideeachframe*convMMppx*PIVminstepsize; %save this data in MM in case desired or want to plot
xlabel('x-position (mm)')
ylabel('Mean V_x (\mum/h)')
title(strcat('Relaxation of the Vx Edge Speed Profile',' ...',strcat(' D',num2str(ETDnumexpt),'-T',num2str(hugeloopTISSUEnum),'-',num2str(thisTissueCellCountPerSqmm),'-',extractBetween(expt_descriptor_PIV2{hugeloopTISSUEnum},strcat(num2str(ETDnumexpt),'-'),'Dens'))));
cbarA = colorbar; %Add a time colorbar!
colormap(colormap(CMrelax)); %set the colormap to whatever was chosen above, in CM = jet(ALLmaxlastT) or CM = parula(ALLmaxlastT); etc. %simple version: colormap(parula);  
caxis([0 largerofALLmaxlastTor10hrs/framesperhr]); %V79 normalized to 4 to 10 hrs!--%caxis([0 ALLmaxlastT/framesperhr]);  %%V77--should i change this from 0 to 4
ylabel(cbarA, 'Time (hr)','fontsize',13, 'FontName', 'Arial');  
% % Take care of the Legends for the x-speed profile plot:
%drawing dummy dots outside the plot for the legend ... moved the dummy dots on top of previous ones so that it doesn't change the xlim and ylim of the plot! also now will overlay on top...  
 %%V77--a1=plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(1,:))),ALLmeanVXcenteredMEDIUMDENSITY{1}(1,:)*convUMppx*framesperhr*NaN,'color',CM(1,:),'marker','o','MarkerSize',8); %RE-PLOT 1st FOR LEGEND! NOTE: IT WILL OVERLAP THE OTHERS NOW... that may be nice, or maybe should do this in an 'if' statement in the main plotting for loop...
 %%V77--b1=plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(first_piv_frame_with_elec_stim,:))),NaN*ALLmeanVXcenteredMEDIUMDENSITY{1}(first_piv_frame_with_elec_stim,:)*convUMppx*framesperhr,'color',CM(first_piv_frame_with_elec_stim,:),'marker','o','MarkerSize',8); %RE-PLOT 1st FOR LEGEND! NOTE: IT WILL OVERLAP THE OTHERS NOW... that may be nice, or maybe should do this in an 'if' statement in the main plotting for loop...
%use below line if stop at 24 ALLmaxlastT within elec stim period:      also, %below, all legends must be same string length
    Zero_Velocity=plot([xLimThisAuto123(1) xLimThisAuto123(2)],[0 0],'k--'); %added for a border to easily show when V is positive vs. negative
    if do_you_want_tissue_edge_lines==1
        x_markers_legend=plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed*NaN,'color',CMrelax(j,:),'marker','*','MarkerSize',10); %v6 took off "'linestyle','none');" at end! %plot over the last point just to make a marker for the legend! %instead of plot([0 0], [0 0],'marker','*','MarkerSize',10);
    elseif do_you_want_tissue_edge_lines==0
        x_markers_legend=plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed*NaN,'color',CMrelax(j,:),'marker','*','MarkerSize',10,'linestyle','none'); %plot over the last point just to make a marker for the legend! %instead of plot([0 0], [0 0],'marker','*','MarkerSize',10);
    end
    %V79 found legend mistake--replaced below--%%V77--[~, figobj, ~, ~] = legend([a1;b1;Zero_Velocity;x_markers_legend],['Start of control period       ';'Begin electric stimulation    ';'Zero Horizontal Velocity      ';'marks Tissue Edges over time  '],'Location','South');
    [~, figobj, ~, ~] = legend([Zero_Velocity;x_markers_legend],['Zero Horizontal Velocity      ';'marks Tissue Edges over time  '],'Location','South');
        fig1line = findobj(figobj,'type','line'); 
        set(fig1line,'LineWidth',1.5);
        %figtype = findobj(figobj,'type','text')
        %set(figtype,'FontSize',12); %if want to change text size in legend     
if ALLmaxlastT~=24 %Put in 'if' statement for 24 cut off,
    c1=plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(last_slice_with_elec_stim,:))),NaN*smoothdata(ALLmeanVXcenteredMEDIUMDENSITY{1}(last_slice_with_elec_stim,:)*convUMppx*framesperhr,'movmedian',6,'omitnan'),'color',CMrelax(last_slice_with_elec_stim,:),'marker','o','MarkerSize',8); %RE-PLOT 1st FOR LEGEND! NOTE: IT WILL OVERLAP THE OTHERS NOW... that may be nice, or maybe should do this in an 'if' statement in the main plotting for loop...
    d1=plot(convMMppx*PIVminstepsize*(1:length(ALLmeanVXcenteredMEDIUMDENSITY{1}(ALLmaxlastT,:))),NaN*smoothdata(ALLmeanVXcenteredMEDIUMDENSITY{1}(ALLmaxlastT,:)*convUMppx*framesperhr,'movmedian',6,'omitnan'),'color',CMrelax(ALLmaxlastT,:),'marker','o','MarkerSize',8); %RE-PLOT 1st FOR LEGEND! NOTE: IT WILL OVERLAP THE OTHERS NOW... that may be nice, or maybe should do this in an 'if' statement in the main plotting for loop...
    Zero_Velocity=plot([xLimThisAuto123(1) xLimThisAuto123(2)],[0 0],'k--'); %added for a border to easily show when V is positive vs. negative
    if do_you_want_tissue_edge_lines==1
        x_markers_legend=plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),NaN*j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed,'color',CMrelax(j,:),'marker','*','MarkerSize',10); %v6 took off "'linestyle','none');" at end! %plot over the last point just to make a marker for the legend! %instead of plot([0 0], [0 0],'marker','*','MarkerSize',10); %Added linestyle in this line, but equally could set the line off in legend by: set(x_markers_legend,'linestyle','none')
    elseif do_you_want_tissue_edge_lines==0
        x_markers_legend=plot(convMMppx*PIVminstepsize*(first_non_NaN_index_of_this_row_j_mean_for_ALLmaxlastT),NaN*j*0.15+chosen_velocity_where_graph_is_empty_for_x_speed,'color',CMrelax(j,:),'marker','*','MarkerSize',10,'linestyle','none'); %plot over the last point just to make a marker for the legend! %instead of plot([0 0], [0 0],'marker','*','MarkerSize',10);
    end
    %V79 found legend mistake--replaced below--%%V77--[~, figobj, ~, ~] = legend([a1;b1;c1;d1;Zero_Velocity;x_markers_legend],['Start of control period       ';'Begin electric stimulation    ';'End of electric stimulation   ';'End of concluding relax period';'Zero Horizontal Velocity      ';'marks Tissue Edges over time  '],'Location','South');
    [~, figobj, ~, ~] = legend([c1;d1;Zero_Velocity;x_markers_legend],['End of electric stimulation   ';'End of concluding relax period';'Zero Horizontal Velocity      ';'marks Tissue Edges over time  '],'Location','South');
        fig1line = findobj(figobj,'type','line');
        set(fig1line,'LineWidth',1.5);
        %figtype = findobj(figobj,'type','text')
        %set(figtype,'FontSize',12); %if want to change text size in legend     
end
%set ylim based on max and min values!--round to the nearest 5 above and below, respectively!   
%ylim([5*floor(ALLmeanVXcenteredMEDIUMDENSITY_minimum_value/5) 5*ceil(ALLmeanVXcenteredMEDIUMDENSITY_maximum_value/5)]) %BEAUT! %v6
ylim([-65 65]) %v40 updated for ETD normalized limits!
%ylim([ALLmeanVXcenteredMEDIUMDENSITY_minimum_value-5 ALLmeanVXcenteredMEDIUMDENSITY_maximum_value+5])
        %now make figure box wider:
        currentpos = get(gcf, 'Position'); %// gives x left, y bottom, width, height
        width = currentpos(3);
        height = currentpos(4);
        set(gcf, 'Position', [currentpos(1)-250 currentpos(2)-150 950 580])

        %SAVE: v17
        savefig(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-Fig551-RelaxationNzmd-ALLMediumVxSpeedProfileAlongX-Smoothed6'));
        saveas(gcf,strcat(superbasesave2directory,savePrefixAddNameIMP,'-T',num2str(hugeloopTISSUEnum),'-Fig551-RelaxationNzmd-ALLMediumVxSpeedProfileAlongX-Smoothed6'),'png');
      saveas(gcf,strcat(savePrefixAddCollectiveGraphFolder,'\',expt_descriptor_PIV2{hugeloopTISSUEnum},'-T',num2str(hugeloopTISSUEnum),'-Fig551-RelaxationNzmd-ALLMediumVxSpeedProfileAlongX-Smoothed6'),'png'); %added V43 to duplicate key graphs in one summary folder!

%% end!