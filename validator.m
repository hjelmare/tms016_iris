
%Load iris code files
files = dir('irisTemplates/');
files = files(3:end); %Removing first two wrong inputs

%Checking nbr of files
nbrFiles = length(files);

result = zeros(nbrFiles*(nbrFiles-1),2);

%Comparing all Iris codes to all minus self
for i = 1:nbrFiles
    filenameI = sprintf('irisTemplates/%s',files(i).name);
    fileI = importdata(filenameI);
   for j = 1:(nbrFiles-1) 
      
      %Creating interval where i is not icluded
      jfile = [1:(i-1), (i+1):nbrFiles];
       
      filenameJ = sprintf('irisTemplates/%s',files(jfile(j)).name);
      fileJ = importdata(filenameJ);
      
      %Checking match 
      matchRatio = Matching(fileI, fileJ);
      
      %Checking if same (class = 2 for a match)
      class = (filenameI(1:6) == filenameJ(1:6)) + 1;
      
      %Storing result
      resNum = (i-1)*(nbrFiles-1) + j;
      result(resNum,class) = matchRatio;      
   end    
end

same = result((result(:,2) > 0),2);
notsame = result((result(:,1) > 0),1);

