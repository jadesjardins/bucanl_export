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

function com = pop_ExportInstCFormat(EEG, FileName, FilePath, OutputExtension);

% the command output is a hidden output that does not have to
% be described in the header
com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            

% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_ExportInstCFormat;
	return;
end;	

CurrentFile=char(EEG.comments(16:length(EEG.comments)));
BSlash=find(CurrentFile=='\');

CurrentFilePath=CurrentFile(1:BSlash(length(BSlash)));
CurrentFileName=CurrentFile(BSlash(length(BSlash))+1:length(CurrentFile));

% pop up window
% -------------
if nargin < 2
	promptstr    = { 'FileName','FilePath','Append extension' };
	inistr       = { char(CurrentFileName),char(CurrentFilePath),'bfa' };
	result       = inputdlg( promptstr, 'Enter export parameters', 1,  inistr);
	if length( result ) == 0 return; end;

	FileName         = eval( [ '[''' result{1} ''']' ] );
	FilePath         = eval( [ '[''' result{2} ''']' ] );
    OutputExtension  = eval( [ '[''' result{3} ''']' ] );
end;

% call function sample either on raw data or ICA data
% ---------------------------------------------------

ExportInstCFormat(EEG,FileName,FilePath,OutputExtension);

% return the string command
% -------------------------

com = sprintf('pop_ExportERPscoreFormat( %s, ''%s'', ''%s'', ''%s'' );', inputname(1), FileName, FilePath, OutputExtension);

return;
