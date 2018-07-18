function []=processFile(path,fileName)
targetFile=char(strcat(path,fileName));
outputFile=char(strcat(path,'0_',fileName));

fid=fopen(targetFile); % open the file
fid2=fopen(outputFile,'w'); % prepare to write into another file.

while ~feof(fid) 
    [line]=fgets(fid); % or fgetl
    if isnumeric(str2num(line(1)))==1 && ~isempty(str2num(line(1)))
         fprintf(fid2,'%s',line);
    end
end
fclose('all'); % close the file.

