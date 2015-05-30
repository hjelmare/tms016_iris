clc
clear all

%Load iris code files
files = dir('irisTemplates/testParameter/');
files = files(3:end); %Removing first two wrong inputs

%Checking nbr of files
nbrFiles = length(files);

result = zeros(nbrFiles*(nbrFiles-1),2);

%Import all data:
tic
for i = 1:nbrFiles
    %filename{i} = importdata(sprintf('irisTemplates/goodEyes/%s',files(i).name));
    filename{i} = load(sprintf('irisTemplates/testParameter/%s',files(i).name));
end
toc


%Comparing all Iris codes to all minus self
tic
for i = 1:nbrFiles

%for i = 1:2
   fileI = filename{i};
   for j = 1:nbrFiles-1
      
      %Creating interval where i is not icluded
      jfile = [1:(i-1), (i+1):nbrFiles];
       
      fileJ = filename{jfile(j)};
      
      %Checking match  
      matchRatio = Matching(fileI, fileJ);
     
      %Checking if same (class = 2 for a match)
      class = min((files(i).name(1:6) == files(j).name(1:6)) + 1);

      
      %Storing result
      resNum = (i-1)*(nbrFiles-1) + j;
      result(resNum,class) = matchRatio;      
   end    
end
toc


same = result((result(:,2) > 0),2);
notsame = result((result(:,1) > 0),1);
subplot(2,1,1)
hist(same,50)
axis([0.4 0.9 0 15])
title('same')
subplot(2,1,2)
hist(notsame,50)
axis([0.4 0.9 0 40])
title('not same')

%%
threshhold = 0.65
sameCorrect = sum(same>threshhold)/length(same)
notSameCorrect = sum(notsame<threshhold)/length(notsame)

