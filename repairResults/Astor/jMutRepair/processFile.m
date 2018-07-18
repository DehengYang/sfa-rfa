function []=processFile(path,fileName)
targetFile=char(strcat(path,fileName));
outputFile=char(strcat(path,'0_',fileName));

fid=fopen(targetFile); 
fid2=fopen(outputFile,'w');

while ~feof(fid) 
    [line]=fgets(fid);
    if isnumeric(str2num(line(1)))==1 && ~isempty(str2num(line(1)))
         fprintf(fid2,'%s',line);
    else
    end
end
fclose('all');

