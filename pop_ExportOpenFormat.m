% pop_ExportOpenFormat() - Export data from current dataset, input export format.
%
% Usage:
%   >>  EEG = pop_ExportOpenFormat( EEG, FileName, FilePath, OutputExtension, FormatString, OutputVector );
%
% Inputs:
%   EEG             - input EEG continuous dataset
%   FileName        - Name of Export file.
%   FilePath        - Path of Export file.
%   OutputExtension - Extension of Export file.
%   FormatString    - String describing output format.
%   OutputVector    - Data vector from current dataset to Export.
%
% Outputs:
%   EEG  - output dataset
%
% See also:
%   EEGLAB 
%
% Copyright (C) <2006>  <James Desjardins> Brock University
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

function com = pop_ExportOpenFormat(EEG,FileName,FilePath,OutputExtension,FormatString,OutputVector);

com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            

% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_ExportOpenFormat;
	return;
end;	

for i=1:size(EEG.comments(:,1));
    if 	EEG.comments(i,1:14)=='Original file:'
        CurrentFile=strtrim(EEG.comments(i,15:length(EEG.comments(i,:))))
    end
end

BSlash=find(CurrentFile=='\');

if isempty(BSlash);
    CurrentFilePath=sprintf('%s%s',cd,'\');
    CurrentFileName=CurrentFile;
    clear BSlash
else
    CurrentFilePath=CurrentFile(1:BSlash(length(BSlash)));
    CurrentFileName=CurrentFile(BSlash(length(BSlash))+1:length(CurrentFile));
    clear BSlash
end

% pop up window
% -------------
if nargin < 5
    
    results=inputgui( ...
    {[1] [1] [2 3] [2 3] [2 3] [2 3] [2 3]}, ...
    {...
        {'Style', 'text', 'string', 'Enter export parameters.', 'FontWeight', 'bold'}, ...
        {}, ...
        {'Style', 'text', 'string', 'Export file name:'}, ...
        {'Style', 'edit', 'string', char(CurrentFileName)}, ...
        {'Style', 'text', 'string', 'Export file path:'}, ...
        {'Style', 'edit', 'string', char(CurrentFilePath)}, ...
        {'Style', 'text', 'string', 'Export file extension:'}, ...
        {'Style', 'edit', 'string', 'tcc'}, ...
        {'Style', 'text', 'string', 'Export file format:'}, ...
        {'Style', 'edit', 'string', '%d\r\n'}, ...
        {'Style', 'text', 'string', 'Export data vector:'}, ...
        {'Style', 'edit', 'string', 'EEG.data'}, ...
     }, ...   
     'pophelp(''pop_Reref'');', 'Select Reref Chs -- pop_Reref()' ...
     );
FileName         = eval( [ '[''' results{1} ''']' ] );
FilePath         = eval( [ '[''' results{2} ''']' ] );
OutputExtension  = eval( [ '[''' results{3} ''']' ] );
FormatString   	 = results{4}; %eval( [ '[''' results{4} ''']' ] );% the brackets allow to process matlab arrays
OutputVector  	 = eval( [ '[''' results{5} ''']' ] );% the brackets allow to process matlab arrays
end;



% call function sample either on raw data or ICA data
% ---------------------------------------------------

ExportOpenFormat(EEG,FileName,FilePath,OutputExtension,FormatString,OutputVector);

% return the string command
% -------------------------

com = sprintf('pop_ExportOpenFormat( %s, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'');', inputname(1), FileName, FilePath, OutputExtension, FormatString, OutputVector);

return;
