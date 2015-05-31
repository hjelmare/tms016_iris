clc
clear all

%Load iris code files
files = dir('irisTemplates/randomEyes/');
files = files(3:end); %Removing first two wrong inputs

%Checking nbr of files
nbrFiles = length(files);

result = zeros(nbrFiles*(nbrFiles-1),2);

%Import all data:
tic
for i = 1:nbrFiles
    %filename{i} = importdata(sprintf('irisTemplates/goodEyes/%s',files(i).name));
    filename{i} = load(sprintf('irisTemplates/randomEyes/%s',files(i).name));
end
toc

index = 0;
%Comparing all Iris codes to all minus self
tic
for i = 1:nbrFiles

%for i = 1:2
   fileI = filename{i};
   for j = 1:i-1
       
      fileJ = filename{j};
     
      %Checking match
      %files(i).name
      %files(j).name
      matchRatio = Matching(fileI, fileJ);
      if (matchRatio == 0)
          continue
      end
     
      %Checking if same (class = 2 for a match)
      class = min((files(i).name(1:5) == files(j).name(1:5)) + 1);

      if (class == 2 && matchRatio < 0.55)
          index = index+1;
          i
          j
          fileNameBad{index}.file1 = [files(i).name];
          fileNameBad{index}.file2 = files(j).name;
          matchRatio
      end
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
threshhold = 0.55
sameCorrect = sum(same>threshhold)/length(same)
notSameCorrect = sum(notsame<threshhold)/length(notsame)

