% 2017-5-17testHarrLikeFea

positiveRange=1:1000;
negativeRange=1:6:6000;


positiveNum=length(positiveRange);         % ����������
negativeNum=length(negativeRange);         % ����������

stdSize=[24 24];

HarrLike{1}=[1 -1];
HarrLike{2}=[1 -1].';
HarrLike{3}=[1 -1 1];
HarrLike{4}=[1 -1 1].';
HarrLike{5}=[0 1;-1 0];
HarrLike{6}=[1 0;0 -1];
HarrLike{7}=[1 -1;-1 1];
HarrLike{8}=[1 1 1;1 -1 1;1 1 1];
HarrLike{9}=[0 0 1;0 -1 0;1 0 0];
HarrLike{10}=[1 0 0;0 -1 0;0 0 1];

baseSize=2:2:4;

tic

features=[]; 
% ��ȡ������ϵ������
for i=positiveRange
    picName=strcat('PositiveSamples-',num2str(i),'.jpg');
    diseaseRegion=imread(picName);
    diseaseRegion=rgb2gray(diseaseRegion);
    diseaseRegion=imresize(diseaseRegion,stdSize);
    [II]=IntegralImage(diseaseRegion);
    [fea]=extHarrLikeFeature(II,HarrLike,baseSize);
    features=combine(features,fea);
    disp(picName);
end

% ��ȡ������ϵ������
for i=negativeRange
    picName=strcat('NegativeSamples-',num2str(i),'.jpg');
    diseaseRegion=imread(picName);
    diseaseRegion=rgb2gray(diseaseRegion);
    diseaseRegion=imresize(diseaseRegion,stdSize);
    [II]=IntegralImage(diseaseRegion);
    [fea]=extHarrLikeFeature(II,HarrLike,baseSize);
    features=combine(features,fea);
    disp(picName);
end

Y=[ones(1,positiveNum) zeros(1,negativeNum)];% ���  

harrlikeCosttime=toc
HarrLikeFeatures=features;
save HarrLikeFeatures-1.mat HarrLikeFeatures Y harrlikeCosttime





trainingRate=0.5;     % ѵ������ռ������������    

T=200;                % ѵ�������ķ�Χ
T=100;                % ѵ�������ķ�Χ
%  
% trainError=zeros(1,T);    % ѵ�������ʾ���
% testError=zeros(1,T);    % ѵ�������ʾ���
% testTP=zeros(1,T);        % TRUE-Positive   �������� 
% testFP=zeros(1,T);        % FALSE-Positive  ��������
% AdaCostTime=cell(1);      % ����ʱ��


rows=size(features,1);

% ȷʵѵ�����������
trainingRows=1:2:rows;            
testingRows=2:2:rows;

trainX=features(trainingRows,:);         % ���ѵ������
trainY=Y(trainingRows);                  % ѵ�����ݵ����
testX=features(testingRows,:);           % ��ò�������
testY=Y(testingRows);                    % �������ݵ����

[Hypothesis,AlphaT,trainError,AdaCostTime]=AdaBoostTrain(trainX,trainY,T);
[testError,testTP,testFP]=AdaBoostTest(testX,testY,Hypothesis,AlphaT,T);

    
    

% ����һ��������ͼ�ĳ���
% ��ͼ����ʾ ���ѵ�������ʺͲ��Դ����� 
figure(1002);hold on,
grid on,
xlabel('ѵ������');
ylabel('AdaBoost������������) ');
testingNum=ceil((1-trainingRate)*size(features,1)); %������������
trainingNum=size(features,1)-testingNum;            %ѵ����������
title(strcat('AdaBoostѵ������Դ�����',' ( ѵ��',num2str(trainingNum),'��,����',num2str(testingNum),'�� )'));

testRange=1:T;
plot(testRange,mean(trainError,1),'r-');
plot(testRange,mean(testError,1),'b-');
legend('Harr-Like����ѵ��������','Harr-Like�������Դ�����');

save HarrLikeFeatures-1.mat HarrLikeFeatures Y harrlikeCosttime trainError testError testTP testFP Hypothesis AlphaT AdaCostTime



