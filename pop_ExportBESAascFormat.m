% pop_ExportOpenFormat() - Segment continuous data into epochs.
%
% Usage:
%   >>  OUTEEG = pop_ExportOpenFormat( INEEG, EpochPts, OffsetPts );
%
% Inputs:
%   INEEG       - input EEG continuous dataset
%   EpochPts    - NPts per epoch.
%   OffsetPts   - NPts to offset beginning of each epoch.
%    
% Outputs:
%   OUTEEG  - output dataset
%
% See also:
%   SEGMANTATION, EEGLAB 

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

function com = pop_ExportBESAascFormat(EEG, FileName, FilePath, OutputExtension, PreStimPts);

% the command output is a hidden output that does not have to
% be described in the header
com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            

% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_ExportBESAascFormat;
	return;
end;	

% pop up window
% -------------

if nargin < 5
    
    for i=1:size(EEG.comments(:,1));
        if 	EEG.comments(i,1:14)=='Original file:'
            CurrentFile=strtrim(EEG.comments(i,15:length(EEG.comments(i,:))))
        end
    end
    
    BSlash=find(CurrentFile=='/');
    
    CurrentFilePath=CurrentFile(1:BSlash(length(BSlash)));
    CurrentFileName=CurrentFile(BSlash(length(BSlash))+1:length(CurrentFile));
    clear BSlash

    if ~isfield(EEG, 'PreStimPts');
        EEG.PreStimPts=[];
    end
    
    results=inputgui( ...
    {[1] [1] [1] [1] [5 1] [1] [1 1 1] [1 1 1]}, ...
    {...
        {'Style', 'text', 'string', 'Enter export parameters.', 'FontWeight', 'bold'}, ...
        {'Style', 'text', 'string', 'In order for this function to be batch compatible default file name and path must be used.'}, ...
        {}, ...
        {'Style', 'text', 'string', 'File name and path:'}, ...
        {'Style', 'edit', 'tag', 'FileNamePathDisp', 'string', sprintf( '%s%s', char (CurrentFilePath), char(CurrentFileName))}, ...
        {'Style', 'pushbutton', 'string', '...', ...
        'callback', '[FileName, FilePath] = uigetfile(''*.*'','' Select file name and path:'',''*.*''); set(findobj(gcbf,''tag'', ''FileNamePathDisp'', ''string'', sprintf( ''%s%s'', char (FilePath), char(FileName))));'}, ...
        {}, ...
        {'Style', 'text', 'string', 'Appended file extension:'}, ...
        {'Style', 'edit', 'string', 'avr'}, ...
        {}, ...
        {'Style', 'text', 'string', 'Prestimulus points:'}, ...
        {'Style', 'edit', 'string', num2str(EEG.PreStimPts)}, ...
        {}, ...
     }, ...   
     'pophelp(''pop_ExportBESAascFormat'');', 'Select BESA (*.asc) export parameters -- pop_ExportBESAascFormat()' ...
     );

     FilePathFileName=eval([ '[''' results{1} ''']' ]);
     BSlash=find(FilePathFileName=='/');
     FilePath=FilePathFileName(1:BSlash(length(BSlash)));
     FileName=FilePathFileName(BSlash(length(BSlash))+1:length(FilePathFileName));
     
     OutputExtension  = eval( [ '[''' results{2} ''']' ] );
     PreStimPts       = eval( [ '[''' results{3} ''']' ] );% the brackets allow to process matlab arrays
end;

% call function sample either on raw data or ICA data
% ---------------------------------------------------

ExportBESAascFormat(EEG,FileName,FilePath,OutputExtension,PreStimPts);

% return the string command
% -------------------------

com = sprintf('pop_ExportBESAascFormat( %s, ''%s'', ''%s'', ''%s'', %s );', inputname(1), FileName, FilePath, OutputExtension, num2str(PreStimPts))

return;
