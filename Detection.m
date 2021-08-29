function [aa,SN_fill,FaceDat] = faceDetection(I)
Faces=[];
numFaceFound=0;
I=double(I);
H=size(I,1);
W=size(I,2);
C=255*imadjust(I/255,[0.3;1],[0;1]);
YCbCr=rgb2ycbcr(C);
Cr=YCbCr(:,:,3);
S=zeros(H,W);
[SkinIndexRow,SkinIndexCol] =find(10<Cr & Cr<255);
for i=1:length(SkinIndexRow)
    S(SkinIndexRow(i),SkinIndexCol(i))=1;
end
m_S = size(S);
S(m_S(1)-7:m_S(1),:) = 0;
SN=zeros(H,W);
for i=1:H-5
    for j=1:W-5
        localSum=sum(sum(S(i:i+4, j:j+4)));
        SN(i:i+5, j:j+5)=(localSum>20);
    end
end
 Iedge=edge(uint8(SN));
SE = strel('square',9);
SN_edge = (imdilate(Iedge,SE));
SN_fill = imfill(SN_edge,'holes');
[L,lenRegions] = bwlabel(SN_fill,4);
AllDat  = regionprops(L,'BoundingBox','FilledArea');
AreaDat = cat(1, AllDat.FilledArea);
[maxArea, maxAreaInd] = max(AreaDat);
FaceDat = AllDat(maxAreaInd);
FaceBB = [FaceDat.BoundingBox(1),FaceDat.BoundingBox(2),...
    FaceDat.BoundingBox(3)-1,FaceDat.BoundingBox(4)-1];
aa=imcrop(rgb2gray(uint8(I)).*uint8(SN_fill),FaceBB);
figure,imshow(aa);
title('Identified Face');
end
