function [C,minDist,minDistIndex] = eigenFaceRecognition(TrainImg,TestImg,NumTrainImg,NumTestImg )
[C,S,L]=princomp(TrainImg,'econ');                   
EigenRange = [1:30];   % Defined the range of Eigenvalues that would be selected
C = C(:,EigenRange);
ProjectedTestImg = TestImg * C;
EucDist = zeros(NumTestImg,NumTrainImg);
for projectedImgIndex = 1:NumTestImg
    TestImage = ProjectedTestImg(projectedImgIndex,:);
    for i = 1:NumTrainImg
        EucDist(projectedImgIndex,i) = sqrt((TestImage'-S(i,EigenRange)')' ...
            *(TestImage'-S(i,EigenRange)'));
    end
end
[minDist,minDistIndex] = min(EucDist,[],2);
end
