% pop_ExportNSRawFormat() - Export current dataset to Net Station Raw format.
%
% Usage:
%   >>  OUTEEG = pop_ExportNSRawFormat( EEG );
%
% Inputs:
%   INEEG       - input EEG continuous dataset
%    
% Outputs:
%   OUTEEG  - output dataset
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

function com = pop_ExportNSRawFormat(EEG, FileName, FilePath, OutputExtension);

% the command output is a hidden output that does not have to
% be described in the header
com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            

% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_ExportERPscoreFormat;
	return;
end;	

for i=1:size(EEG.comments(:,1));
    if 	EEG.comments(i,1:14)=='Original file:'
        CurrentFile=strtrim(EEG.comments(i,15:length(EEG.comments(i,:))))
    end
end

BSlash=find(CurrentFile=='\');

if ~isempty(BSlash);
    CurrentFilePath=CurrentFile(1:BSlash(length(BSlash))-1);
    CurrentFileName=CurrentFile(BSlash(length(BSlash))+1:length(CurrentFile));
    clear BSlash
else
    CurrentFilePath=cd;
    CurrentFileName=CurrentFile;
end
    

% pop up window
% -------------

if nargin < 3
    
    results=inputgui( ...
    {[1] [1] [1] [1] [5 1] [1] [1 1 1]}, ...
    {...
        {'Style', 'text', 'string', 'Enter export parameters.', 'FontWeight', 'bold'}, ...
        {'Style', 'text', 'string', 'In order for this function to be batch compatible default file name and path must be used.'}, ...
        {}, ...
        {'Style', 'text', 'string', 'File name and path:'}, ...
        {'Style', 'edit', 'tag', 'FileNamePathDisp', 'string', sprintf( '%s%s%s', char (CurrentFilePath), '\', char(CurrentFileName))}, ...
        {'Style', 'pushbutton', 'string', '...', ...
        'callback', '[FileName, FilePath] = uigetfile(''*.*'','' Select file name and path:'',''*.*''); set(findobj(gcbf,''tag'', ''FileNamePathDisp'', ''string'', sprintf( ''%s%s'', char (FilePath), char(FileName))));'}, ...
        {}, ...
        {'Style', 'text', 'string', 'Appended file extension:'}, ...
        {'Style', 'edit', 'string', 'raw'}, ...
        {}, ...
     }, ...   
     'pophelp(''pop_ExportERPscoreFormat'');', 'Select ERPscore export parameters -- pop_ExportERPscore()' ...
     );

     FilePathFileName=eval([ '[''' results{1} ''']' ]);
     BSlash=find(FilePathFileName=='\');
     FilePath=FilePathFileName(1:BSlash(length(BSlash))-1);
     FileName=FilePathFileName(BSlash(length(BSlash))+1:length(FilePathFileName));
     
     OutputExtension  = eval( [ '[''' results{2} ''']' ] );
end;

% call function sample either on raw data or ICA data
% ---------------------------------------------------

ExportNSRawFormat(EEG,FileName,FilePath,OutputExtension);

% return the string command
% -------------------------

com = sprintf('pop_ExportNSRawFormat( %s, ''%s'', ''%s'', ''%s'' );', inputname(1), FileName, FilePath, OutputExtension)

return;
