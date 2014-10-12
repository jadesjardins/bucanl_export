function SaveList(input);

[FileName, FilePath] = uiputfile('*.pcc','Save Phase Coherence Channels List As:','PhaseCohChList.pcc');
eval(['fidList=fopen(''' FilePath FileName ''', ''w'');']);
fprintf(fidList, '%s', input');