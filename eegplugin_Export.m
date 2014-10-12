% eegplugin_FileExport() - EEGLAB plugin for Exporting data.
%
% Usage:
%   >> eegplugin_FileExport(fig, try_strings, catch_stringss);
%
% Inputs:
%   fig            - [integer]  EEGLAB figure
%   try_strings    - [struct] "try" strings for menu callbacks.
%   catch_strings  - [struct] "catch" strings for menu callbacks.
%
%
% Copyright (C) <2006> <James Desjardins> Brock University
%
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

% $Log: eegplugin_FileExport.m

function eegplugin_Export(fig,try_strings,catch_strings)


% Find "Export" submenu.
exportmenu=findobj(fig,'tag','export');


% Create cmd for Export functions.
cmd='[LASTCOM] = pop_ExportOpenFormat( EEG );';
finalcmdEOF=[try_strings.no_check cmd catch_strings.store_and_hist];

cmd='[LASTCOM] = pop_ExportERPscoreFormat( EEG );';
finalcmdEEF=[try_strings.no_check cmd catch_strings.store_and_hist];

%cmd='[LASTCOM] = pop_ExporteConnectomeFormat( EEG );';
%finalcmdEeCF=[try_strings.no_check cmd catch_strings.store_and_hist];

cmd='[LASTCOM] = pop_ExportNSRawFormat( EEG );';
finalcmdENS=[try_strings.no_check cmd catch_strings.store_and_hist];

cmd='[LASTCOM] = pop_ExportBESAascFormat( EEG );';
finalcmdEBA=[try_strings.no_check cmd catch_strings.store_and_hist];

cmd='[LASTCOM] = pop_ExportInstCFormat( EEG );';
finalcmdEIC=[try_strings.no_check cmd catch_strings.store_and_hist];


% add specific submenus to "Export" menu.
uimenu(exportmenu,'label','Open Format','callback',finalcmdEOF);
uimenu(exportmenu,'label','ERPscore','callback',finalcmdEEF);
%uimenu(exportmenu,'label','eConnectome','callback',finalcmdEeCF);
uimenu(exportmenu,'label','Net Station Raw (from PC)','callback',finalcmdENS);
uimenu(exportmenu,'label','BESA (*.asc)','callback',finalcmdEBA);
uimenu(exportmenu,'label','Instep .c','callback',finalcmdEIC);
