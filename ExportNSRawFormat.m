% ExportNSRawFormat() - description of the function
%
% Usage:
%   >>  out = ExportNSRawFormat( in1, in2, in3 );
% Inputs:
%   in1     - Continuous data vector.
%   in2     - Epoch length NPts.
%   in3     - Overlap offset.
%    
% Outputs:
%   file written to hard drive.
%
% See also: 
%   EEGLAB 

% Copyright (C) <2006>  <James Desjardins>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function ExportNSRawFormat(EEG,FileName,FilePath,OutputExtension)

if nargin < 3
	help ExportNSRawFormat;
	return;
end


% Sort event information.

if ~isempty(EEG.event);
    EvCell={EEG.event.type};
    EvUCell=unique(EvCell);

    for i=1:length(EvUCell);
        EvCount(i)=0;
    end

    for i=1:length(EEG.event);
        for ii=1:length(EvUCell);
            if strcmp(EEG.event(i).type, EvUCell(ii));
                EvCount(ii)=EvCount(ii)+1;
                EvLat{ii}(EvCount(ii))=EEG.event(i).latency;
            end
        end
    end
end

%FOPEN
% Net Station Raw format file
eval(['fidNSR=fopen(''' char (FilePath) '\'  char(FileName) '.' char(OutputExtension) ''',''w'',''b'')']);


if EEG.trials==1 % if data is continuous.
    
    %CREATE header_array for continuous data.

    header_array(1) =4;                              % Version number.
    header_array(2) =2007;                           % year
    header_array(3) =1;                              % month
    header_array(4) =16;                             % day
    header_array(5) =12;                             % hour
    header_array(6) =30;                             % minute
    header_array(7) =30;                             % second
    header_array(8) =500;                            % millisecond
    header_array(9) =EEG.srate;                      % sampling rate
    header_array(10)=EEG.nbchan;                     % number of channels
    header_array(11)=1;                              % board gain
    header_array(12)=16;                             % number of conversion bits
    header_array(13)=2500;                           % full-scale range of amp in µV
    header_array(14)=EEG.pnts;                       % number of samples
    if isempty(EEG.event)
        header_array(15)=0;                          % number of unique event codes
    else
        header_array(15)=length(EvUCell);            % number of unique event codes
    end


    %FWRITE

    %%%FOLLOWING CODE ADAPTED FROM....

    %function [SUCCESS] = UGLYFileWriter(outFileName, trialData, eventData, header_array)
    %  [SUCCESS] = UGLYFileWriter(outFileName, trialData, eventData, header_array)
    % 		This file will write a Net Station Raw file (version 2 only) from Matlab.
    %
    %		Data will be assumed vertex referenced
    %
    % 		Copyright:		1999 Electrical Geodesics, Inc.  ALL RIGHT RESERVED
    % 		Property of:	Electrical Geodesics, Inc.
    % 						Eugene, OR 97401
    %
    % 		Programmer:		Kent Karnofski
    % 		Date:			December 1999
    % 		Update:			3 March 2000, corrected/switched size of second, millisecond (header_array(7-8))
    %
    % 		Known Bugs:		none
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %SUCCESS = 1;	% true

    % [fid, message] = fopen(outFileName, 'wt', 'b');
    %[fid, message] = fopen(outFileName, 'wb')
    %if ( fid  == -1 )
    %	fprintf(message);
    %	fprintf('\n\n');
    %	SUCCESS	= 0;
    %	return
    %end

    % whos

    fseek(fidNSR,0,'bof');
    fwrite(fidNSR, header_array(1),'long','b');
    fseek(fidNSR,4,'bof');
    fwrite(fidNSR, header_array(2),'short','b');
    fseek(fidNSR,6,'bof');
    fwrite(fidNSR, header_array(3),'short','b');
    fseek(fidNSR,8,'bof');
    fwrite(fidNSR, header_array(4),'short','b');
    fseek(fidNSR,10,'bof');
    fwrite(fidNSR, header_array(5),'short','b');
    fseek(fidNSR,12,'bof');
    fwrite(fidNSR, header_array(6),'short','b');
    fseek(fidNSR,14,'bof');
    fwrite(fidNSR, header_array(7),'short','b');
    fseek(fidNSR,16,'bof');
    fwrite(fidNSR, header_array(8),'long','b');
    fseek(fidNSR,20,'bof');
    fwrite(fidNSR, header_array(9),'short','b');
    fseek(fidNSR,22,'bof');
    fwrite(fidNSR, header_array(10),'short','b');
    fseek(fidNSR,24,'bof');
    fwrite(fidNSR, header_array(11),'short','b');
    fseek(fidNSR,26,'bof');
    fwrite(fidNSR, header_array(12),'short','b');
    fseek(fidNSR,28,'bof');
    fwrite(fidNSR, header_array(13),'short','b');
    fseek(fidNSR,30,'bof');
    fwrite(fidNSR, header_array(14),'long','b');
    fseek(fidNSR,34,'bof');
    fwrite(fidNSR, header_array(15),'short','b');

    if ~isempty(EEG.event);
        for i=1:length(EvUCell);
            fwrite(fidNSR, EvUCell{i},'char','b');
        end
    end

    NChans	= header_array(10);
    Bits	= header_array(12);
    Range	= header_array(13);
    NSamps	= header_array(14);
    NEvents	= header_array(15);
    scale	= Range/(2^Bits);

    %trialData=EEG.data;

    %fseek(fidNSR,36,'bof');

    %if (NEvents == 0)
    %writeThisDataMatrix = zeros(NChans, NSamps);
    %writeThisDataMatrix = trialData(1:NChans, :);
    writeThisDataMatrix = EEG.data./scale;
    %else
    %	writeThisDataMatrix	= zeros(NChans+NEvents, NSamps);
    %	for i = 1:NSamps
    %		writeThisDataMatrix(:,i) = [trialData(1:NChans, i) eventData(:,i)];
    %	end
    %	writeThisDataMatrix = writeThisDataMatrix./scale;
    %end

    if ~isempty(EEG.event);
        for i=1:length(EvUCell);
            writeThisDataMatrix(EEG.nbchan+i,:)=zeros(1,EEG.pnts);
            writeThisDataMatrix(EEG.nbchan+i,EvLat{i})=1;
        end
    end

else

    
    %CREATE header_array for segmented data.

    header_array{1} =5;                              % Version number.
    header_array{2} =2007;                           % year
    header_array{3} =1;                              % month
    header_array{4} =16;                             % day
    header_array{5} =12;                             % hour
    header_array{6} =30;                             % minute
    header_array{7} =30;                             % second
    header_array{8} =500;                            % millisecond
    header_array{9} =EEG.srate;                      % sampling rate
    header_array{10}=EEG.nbchan;                     % number of channels
    header_array{11}=1;                              % board gain
    header_array{12}=16;                             % number of conversion bits
    header_array{13}=2500;                           % full-scale range of amp in µV
    
    header_array{14}=1;                              % number of category names.
    header_array{15}=3;                              % pstring array length.
    header_array{16}='seg';                          % segment category name.
    header_array{17}=EEG.trials;                     % number of segments.
    
    header_array{18}=EEG.pnts;                       % number of samples per segment.
    header_array{19}=length(EvUCell);                % number of unique event codes


    %FWRITE

    %%%FOLLOWING CODE ADAPTED FROM....

    %function [SUCCESS] = UGLYFileWriter(outFileName, trialData, eventData, header_array)
    %  [SUCCESS] = UGLYFileWriter(outFileName, trialData, eventData, header_array)
    % 		This file will write a Net Station Raw file (version 2 only) from Matlab.
    %
    %		Data will be assumed vertex referenced
    %
    % 		Copyright:		1999 Electrical Geodesics, Inc.  ALL RIGHT RESERVED
    % 		Property of:	Electrical Geodesics, Inc.
    % 						Eugene, OR 97401
    %
    % 		Programmer:		Kent Karnofski
    % 		Date:			December 1999
    % 		Update:			3 March 2000, corrected/switched size of second, millisecond (header_array(7-8))
    %
    % 		Known Bugs:		none
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %SUCCESS = 1;	% true

    % [fid, message] = fopen(outFileName, 'wt', 'b');
    %[fid, message] = fopen(outFileName, 'wb')
    %if ( fid  == -1 )
    %	fprintf(message);
    %	fprintf('\n\n');
    %	SUCCESS	= 0;
    %	return
    %end

    % whos

    fseek(fidNSR,0,'bof');
    fwrite(fidNSR, header_array{1},'long','b');
    fseek(fidNSR,4,'bof');
    fwrite(fidNSR, header_array{2},'short','b');
    fseek(fidNSR,6,'bof');
    fwrite(fidNSR, header_array{3},'short','b');
    fseek(fidNSR,8,'bof');
    fwrite(fidNSR, header_array{4},'short','b');
    fseek(fidNSR,10,'bof');
    fwrite(fidNSR, header_array{5},'short','b');
    fseek(fidNSR,12,'bof');
    fwrite(fidNSR, header_array{6},'short','b');
    fseek(fidNSR,14,'bof');
    fwrite(fidNSR, header_array{7},'short','b');
    fseek(fidNSR,16,'bof');
    fwrite(fidNSR, header_array{8},'long','b');
    fseek(fidNSR,20,'bof');
    fwrite(fidNSR, header_array{9},'short','b');
    fseek(fidNSR,22,'bof');
    fwrite(fidNSR, header_array{10},'short','b');
    fseek(fidNSR,24,'bof');
    fwrite(fidNSR, header_array{11},'short','b');
    fseek(fidNSR,26,'bof');
    fwrite(fidNSR, header_array{12},'short','b');
    fseek(fidNSR,28,'bof');
    fwrite(fidNSR, header_array{13},'short','b');

    fseek(fidNSR,30,'bof');
    fwrite(fidNSR, header_array{14},'short','b');
    fseek(fidNSR,32,'bof');
    fwrite(fidNSR, header_array{15},'int8','b');
    fwrite(fidNSR, header_array{16},'char','b');
    fwrite(fidNSR, header_array{17},'short','b');
    fwrite(fidNSR, header_array{18},'long','b');
    fwrite(fidNSR, header_array{19},'short','b');
    
    if ~isempty(EvUCell);
        for i=1:length(EvUCell);
            fwrite(fidNSR, EvUCell{i},'char','b');
        end
    end

    %NChans	= header_array{10};
    Bits	= header_array{12};
    Range	= header_array{13};
    %NSamps	= header_array{18};
    %NEvents	= header_array{19};
    scale	= Range/(2^Bits);
    
    for S=1:EEG.trials;

        fwrite(fidNSR,1,'int16');
        if isfield(EEG, 'TStamps');
            TStamp=EEG.TStamps(S);
        else
            TStamp=((S*EEG.pnts)-(EEG.pnts-1))*(1000/EEG.srate);
        end
        
        fwrite(fidNSR,TStamp,'long');

        writeThisDataMatrix=[];
        writeThisDataMatrix = EEG.data(:,:,S)./scale;
        writeThisDataMatrix(EEG.nbchan+1:EEG.nbchan+length(EvUCell),:,1) = zeros(length(EvUCell),EEG.pnts,1);

        EvEpoch=[];
        if iscell(EEG.epoch(S).eventtype)
            for i=1:length(EEG.epoch(S).eventtype);

                EvEpoch(i).index=strmatch(EEG.epoch(S).eventtype{i},EvUCell);
                EvEpoch(i).latency=(EEG.epoch(S).eventlatency{i}*(EEG.srate/1000))+(EEG.xmin*-1000)*(EEG.srate/1000);
                if EvEpoch(i).latency==0;
                    EvEpoch(i).latency=1;
                end
                
            end
        else
            
            EvEpoch(i).index=strmatch(EEG.epoch(S).eventtype,EvUCell);
            EvEpoch(i).latency=(EEG.epoch(S).eventlatency*(EEG.srate/1000))+(EEG.xmin*-1000)*(EEG.srate/1000);
            if EvEpoch(i).latency==0;
                EvEpoch(i).latency=1;
            end

        end

        

        for i=1:length(EvEpoch);
            writeThisDataMatrix(EEG.nbchan+EvEpoch(i).index,EvEpoch(i).latency,1)=1;
        end

        fwrite(fidNSR, writeThisDataMatrix, 'float','b');

    end
end



fwrite(fidNSR, writeThisDataMatrix, 'float','b');

%fprintf('\ninside UGLYFileWriter.m, count = %g\n\n', count);


%%%%% Close files
fclose(fidNSR);





