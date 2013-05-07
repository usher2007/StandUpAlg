close all, clear all, clc;
fileDir = '..\DataRes\';
scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[0 30 scrsz(3) scrsz(4)-95]);

positions = zeros(1,25);
for i=1:4148
    clf;
    fileName = strcat(fileDir,num2str(i));
    fileName = strcat(fileName,'.bmp');
    pic = imread(fileName);
    EachCol = sum(pic);
    PicSize = size(pic);
    AvgCol = mean(EachCol)*ones(1,PicSize(1,2));
    left = 1;
    right = PicSize(1,2);
    TmpLeft = 0;
    TmpRight = 0;
    ConCount = 0;
    GapCount = -1;
    MaxGap = 50;
    MinCon = 30;
    forePix = zeros(1,576);
    for j=1:PicSize(1,2)
        if EachCol(1,j) > 3*AvgCol
            if GapCount > MaxGap || GapCount < 0
                TmpLeft = j;
                TmpRight = j;
                ConCount = 0;
            else
                TmpRight = j;
            end
            GapCount = 0;
            ConCount = ConCount + 1;
            if ConCount > MinCon
                left = TmpLeft;
                right = TmpRight;
            end
        else
            if GapCount >= 0
                GapCount = GapCount + 1;
            end
        end
    end
    
    
    
    EachRow = sum(pic(:,left:right), 2);
    AvgRow = mean(EachRow)*ones(1,PicSize(1,1));
    candidates = find(EachRow > 3*AvgRow');
    CanLen = length(candidates);
    
    prevCandIndx = 0;
    maxCandGap = 100;
    foreCountSum = 0;
    humanWidth = 30;
    finalCount = 0;
    finalWeight = 0;
    finalSum = 0; 
    finalSum2 = 0;
    for j=1:CanLen
        if candidates(j) - prevCandIndx > maxCandGap
            prevCandIndx = candidates(j);
            if foreCountSum > humanWidth
                finalCount = finalCount + foreCountSum;
                for k=1:foreCountSum
                    finalSum = finalSum + forePix(1,k)*EachRow(forePix(1,k));
                    finalSum2 = finalSum2 + EachRow(forePix(1,k));
                    finalWeight = finalWeight + EachRow(forePix(1,k));
                end
                foreCountSum = 0;
                %forePix = zeros(1,576);
            else
                foreCountSum = 0;
                %forePix = zeros(1,576);
            end
        else
            foreCountSum = foreCountSum + 1;
            forePix(1, foreCountSum) = candidates(j);
        end
    end
    pos = 0;
    weight = 0;
    if finalCount ~= 0 && finalWeight ~= 0
        weight = finalSum2 / finalCount;
        pos = finalSum / finalWeight;
    end
    plot(EachRow);
    hold;
    plot(2*AvgRow,'r');
    plot(pos, weight, 'r+', 'linewidth', 2);
    axis([0 576 0 35000]);
    
    positions(1,1:24) = positions(1,2:25);
    if weight > 1000
        positions(1,25) = pos;
    else
        positions(1,25) = position(1,24);
    end
    if i > 25
        
    end
    saveas(gcf,num2str(i),'bmp');
end