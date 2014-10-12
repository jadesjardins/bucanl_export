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

function out = ExportBESAascFormat(EEG,FileName,FilePath,OutputExtension,PreStimPts);
PreStimPts=num2str(PreStimPts)
if nargin < 3
	help ExportBESAascFormat;
	return;
end;	

if ~isfield(EEG, 'NTrialsUsed');
    EEG.NTrialsUsed=1;
end

% Header Brock Format Average

Header = 'Npts= ';
Header = sprintf('%s%d', Header, length(EEG.data(1,:,1)));
Temp   = 'TSB=';
Header = sprintf('%s   %s%d', Header, Temp, (-1)*(str2num(PreStimPts)*(1000/EEG.srate)));
Temp   = 'DI= ';
Header = sprintf('%s   %s%d', Header, Temp, 1000/EEG.srate);
Temp   = 'SB= 1';
Header = sprintf('%s   %s', Header, Temp);
Temp   = 'SC= 50';
Header = sprintf('%s   %s', Header, Temp);
Temp   = 'Nchan= ';
Header = sprintf('%s  %s%d\r\n', Header, Temp, EEG.nbchan);
for i=1:EEG.nbchan;
    Header=sprintf('%s%s',Header,EEG.chanlocs(i).labels);
end
%data=(' ');
%for i=1:length(EEG.data(1,1,:));
%    for ii=1:length(EEG.data(:,1,1));
%        for iii=1:length(EEG.data(1,:,1));
%            data=sprintf('%s %s', data, num2str(EEG.data(ii,iii,i)));
%        end
%    end
%end

%TwelvePointThree=double(' %12.3f');
%for i=1:EEG.pnts;
%   PrintVector(i,:)=TwelvePointThree;
%end
%PrintVector=reshape(PrintVector',1,length(TwelvePointThree)*EEG.pnts);
%PrintVector=char(PrintVector);
%%%%%

%%%%% Write to disk 
% BESA Format ERP file
eval(['fidASC=fopen(''' char (FilePath) char(FileName) '.' char(OutputExtension) ''',''w'');']);

%x=reshape(EEG.data',1,prod(size(EEG.data)));
x=reshape(permute(EEG.data,[2,1,3]),1,prod(size(EEG.data)));

%fprintf(fidASC, '%s\r\n %s', Header, num2str(x,'%4.2f '));
fprintf(fidASC, '%s\r\n %s', Header, num2str(x,'%4.2f'));

%eval(['fprintf(fidBFA,''' PrintVector ' '',EEG.data'');']);

%%%%% Close files
fclose(fidASC);
