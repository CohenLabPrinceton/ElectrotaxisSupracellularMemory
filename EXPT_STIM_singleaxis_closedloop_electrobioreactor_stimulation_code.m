close all
clear all

dategrab = datestr(clock,'YYYY-mm-dd'); %use this in output text file names 
    RecorderFile1Name = strcat( 'MatlabCodeTimeRecorderForExpt', dategrab, '.txt' );
    RecorderFile2Name = strcat( 'MatlabPrintDATARecorderForExpt', dategrab, '.txt' );
timeRecorderfileID = fopen(RecorderFile1Name,'w+');
fprintf(timeRecorderfileID, 'The run start time of Avi GelTaxis Code is at date & time: %s\r\n', datestr(now,'YYYY/mm/dd HH:MM:SS.FFF'));
fclose(timeRecorderfileID); 

%% must turn on or off fclose(instrfind) two sections below
%% must change times below in postcontrolrelaxtime = 4*3600 and electricstimulationtime = 4*3600; or something similar!
%% and must change this PAUSE time below
precontroltime = 1*3600; %control period before elec stimulation %or do 4800 for 1hr20min, etc.
pause('on');
pause(precontroltime);

%% this closes the serial connections so that they may be reestablished
fclose(instrfind); %NOTE: this needs to be commented out if this is the first time running this from starting up matlab. However, ...   
% ^ leave this IN after you test stimulation and confirm circuit is good, then don't need to fclose manually, just run this code and will close when it turns on stim!    

%%
timeRecorderfileID = fopen(RecorderFile1Name,'a+');
fprintf(timeRecorderfileID, 'Begin to establish Keithley connection in Avi GelTaxis Code at: %s\r\n', datestr(now,'YYYY/mm/dd HH:MM:SS.FFF'));
fclose(timeRecorderfileID);

% Establish Keithley 2450 connection (USB)
keith=visa('ni','USB0::0x05E6::0x2450::04365292::INSTR'); %(found in Keithley reference manual) 
fopen(keith);

% Set up the basic functions on the Keithley
fprintf(keith,'*RST');                    % reset the screen
fprintf(keith,':SOUR:FUNC CURR');         % select current source
fprintf(keith,':SOUR:CURR:RANGE 20e-3');  % set current range
fprintf(keith,':SOUR:CURR:VLIMIT 100');   % set voltage limit
fprintf(keith,':SENS:FUNC "VOLT"');       % select voltage measurement
fprintf(keith,':SENS:VOLT:RANG 40');      % set measurement voltage range

% Establish connection to Digilent USB scope
s = daq.createSession('digilent');
ch1 = addAnalogInputChannel(s,'AD1',1,'Voltage');
s.Rate = 100;               % set Digilent sample rate to 100 Hz
s.DurationInSeconds = 0.5;  % set Digilent recording window to 0.5 seconds

%timegrab = datestr(clock,'YYYY/mm/dd HH:MM:SS:FFF');
timeRecorderfileID = fopen(RecorderFile1Name,'a+');
fprintf(timeRecorderfileID, 'Done establishing Keithley connection in Avi GelTaxis Code at: %s\r\n', datestr(now,'YYYY/mm/dd HH:MM:SS.FFF'));
fclose(timeRecorderfileID);

%% Program VX (voltage as a function of time)
electricstimulationtime = 3*3600; %ELECTRIC STIMULATION TIME! 
postcontrolrelaxtime = 4*3600; %time after elec stimulation to continue watching voltage 
time = electricstimulationtime + postcontrolrelaxtime; 
t    = 0:1:time; 
VX   = 1.5*3*[ones(1,electricstimulationtime) zeros(1,postcontrolrelaxtime) 0]; %3 V/cm times 2.6 cm DISTANCE BW PROBES! even though 2.4 cm or 24 mm channel
%3 Volts/cm across 1.5 cm distance between electrodes in this single-axis device
%(SCHEEPDOG device is 2.5 cm between Ti probes.)
    %in line above, if positive, cells will move to right in images = left for scope/real world, toward the black cable (which will be the cathode, at a lower voltage than the red)  
    %in line above, if negative, cells will move to left in images = right for scope/real world, toward the RED cable (which will now be the cathode, at a lower voltage than the black because negative sign)  
currx = 1e-3;   % initial current supplied


%% Main stimulation loop
vkeith1 = [];   % keithley voltage
vx=[];          % channel voltage
ix=[];          % keithley current
tt=[];          % timestamp
verrx=[];       % error in channel voltage (vx - Vtarget)

t0 = datetime('now');  % establish start time as t0
t1 = datetime('now');  % establish 'current time' as t1

timelapse = t1 - t0;   % t1-t0 will give the total elapsed time


while seconds(timelapse) < time
    % set the target voltage based on the total elapsed time
    tk = seconds(timelapse);  % tk = the number of seconds elapsed
    ttemp = t(t<=tk);         % vector of time indices lower than elapsed time
    k = ttemp(end);           % k is the closest time point index to the present time
    vtarget_x = VX(t==k);     % use this index to set the target for this moment in time

    % Tell Keithley what to do
    if vtarget_x == 0  % Simply turn off the Keithley output if you want stimulation to turn off
        fprintf(keith,':OUTP OFF');
    else               
        fprintf(keith,sprintf(':SOUR:CURR:LEV %f',currx)); % Set current
        fprintf(keith,':OUTP ON');                         % Turn on output
        fprintf(keith,':READ?');                           % Take a reading at Keithley
        vkeith1 = [vkeith1; str2double(fscanf(keith))];    % Append this value on the vkeith vector, scanned as string, then converted to double                                               
    end
    
    data = startForeground(s);  % Start data collection at the Digilent to get channel voltage
    v1 = mean(data);            % Once the data burst is recorded, take the mean
    vx = [vx; v1];              % Append this voltage to the channel voltage vector vx
    ix = [ix; currx];           % Append the present current level to current vector ix 
    tt = [tt; tk];              % Append the timestamp to time vector tt
    
    ex = v1-vtarget_x;          % Calculate the error in channel voltage
    verrx = [verrx; ex];        % Append the voltage error to vector verrx

    % Print a status update to the console
    fprintf('\nTime: %.2f sec of %.2f sec', seconds(timelapse), time)
    fprintf('\nix: %e A',currx);
    fprintf('\nvx: %.2f V',v1);
    fprintf('\nVs: %.2f V',vkeith1(end));
    fprintf('\nex: %.2f V\n',ex);
    
    % Print the same status update to a file
    DataRecorderfileID = fopen(RecorderFile2Name,'a+');
    fprintf(DataRecorderfileID, '\r\nThe current time during Avi GelTaxis Code is at date & time: %s', datestr(now,'YYYY/mm/dd HH:MM:SS.FFF'));
        fprintf(DataRecorderfileID, '\r\nTime: %.2f sec of %.2f sec', seconds(timelapse), time);
        fprintf(DataRecorderfileID, '\r\nix: %e A',currx);
        fprintf(DataRecorderfileID, '\r\nvx: %.2f V',v1);
        fprintf(DataRecorderfileID, '\r\nVs: %.2f V',vkeith1(end));
        fprintf(DataRecorderfileID, '\r\nex: %.2f V\r\n',ex);
    fclose(DataRecorderfileID);
    
    % *** UPDATE THE CURRENT LEVEL ***
    currx = currx-0.0001*ex;
    
    % Display recording so far, do it every 10 seconds to avoid slowdown
    if (floor(mod(tk,10))<=1)
        subplot(211)
        plot(tt./3600,vx,'r');
        xlim([0 max(tt)./3600+.001]);
        ylabel('channel voltage (V)');
        subplot(212)
        plot(tt./3600,ix,'r');
        xlim([0 max(tt)./3600+.001]);
        ylabel('channel current (A)');
        xlabel('T (h)');
    end
    pause(0.25); % <---- breakpoint HERE if needed!
                 % Without pause, keithley can miss readings
                 
    t1 = datetime('now');   % Update the current time t1 and the elapsed time timelapse
    timelapse = t1 - t0;
end            
fprintf(keith,':OUTP OFF'); % Turn the Keithley output off at the end no matter what
fclose(instrfind);

%% Write end of file and save current set up

%timegrab = datestr(clock,'YYYY/mm/dd HH:MM:SS:FFF');
timeRecorderfileID = fopen(RecorderFile1Name,'a+');
fprintf(timeRecorderfileID, '\r\nDone with entire script in Avi GelTaxis Code at: %s\r\n', datestr(now,'YYYY/mm/dd HH:MM:SS.FFF'));
fclose(timeRecorderfileID);

%save open matlab figure:
SaveFigFileName = strcat(dategrab,'-ENTIRE-stimulation-voltage-and-current-figure');
saveas(gcf,SaveFigFileName,'fig');
saveas(gcf,SaveFigFileName,'jpeg');

%save matlab current variables as mat file:
SaveMatFileName = strcat(dategrab, '-expt-END-code-matfile.mat');
save(SaveMatFileName);

