% This function is to remove the failed trials in the 100 trials and then
% save them into a new file.
function []=processFile(path,fileName)

targetFile=char(strcat(path,fileName));
outputFile=char(strcat(path,'0_',fileName));
fid=fopen(targetFile); % open the file

display(['the file is ',targetFile]);
fid2=fopen(outputFile,'w');  % create a file to save processed results

while ~feof(fid) % now read the file
    [line]=fgets(fid); % fgetl also works here.
    if isnumeric(str2num(line(1)))==1 && ~isempty(str2num(line(1)))
         fprintf(fid2,'%s',line);
    end
end
fclose('all');   % close the file

