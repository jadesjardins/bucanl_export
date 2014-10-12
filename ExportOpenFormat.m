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

function out = ExportOpenFormat(EEG,FileName,FilePath,OutputExtension,FormatString,OutputVector);

if nargin < 4
	help ExportOpenFormat;
	return;
end;	

eval(['fidout=fopen(''' char(FilePath) char(FileName) '.' char(OutputExtension) ''',''w'');'])
out=eval(['fprintf(fidout,''' FormatString ''',' OutputVector ');']);

fclose(fidout);