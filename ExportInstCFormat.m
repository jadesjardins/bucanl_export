% ExportOpenFormat() - description of the function
%
% Usage:
%   >>  out = ExportOpenFormat( in1, in2, in3 );
% Inputs:
%   in1     - Continuous data vector.
%   in2     - Epoch length NPts.
%   in3     - Overlap offset.
%    
% Outputs:
%   out     - Segmented data vector.
%
% See also: 
%   POP_SEGMENTION, EEGLAB 

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

function out = ExportInstCFormat(EEG,FileName,FilePath,OutputExtension);

if nargin < 3
	help ExportInstCFormat;
	return;
end;	

dataout=reshape(round(EEG.data./0.48828125),length(EEG.data(1,:))*length(EEG.data(:,1)),1);
size(dataout)
OutVector=[EEG.header;dataout;EEG.footer];

%%%%% Write to disk 
% Instep Continuous File
eval(['fidInstC=fopen(''' char (FilePath) char(FileName) '.' char(OutputExtension) ''',''w'');'])

fwrite(fidInstC,OutVector,'int16');

%fprintf(fidBFA, '%s\r\n', Header);
%eval(['fprintf(fidBFA,''' PrintVector '\r\n'',EEG.data'')']);

%%%%% Close files
fclose(fidInstC);
