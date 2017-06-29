%�޼�ѫ 2017-5-20

clear 
clc
%��ʼ��ȡHaar-Like ����
positiveRange=1:1000;
negativeRange=1:2000;

positiveNum=length(positiveRange);         % ����������
negativeNum=length(negativeRange);         % ����������
n=negativeNum+positiveNum;
stdSize=[20 20];            %MIT�������زĴ�С

HarrLike{1}=[1 -1];         %����5��haar-like����
HarrLike{2}=[1 -1].';
HarrLike{3}=[1 -2 1];
HarrLike{4}=[1 -2 1].';
HarrLike{5}=[1 -1;-1 1];


baseSize=2:2:4;


features=zeros(n,78460); 
for i=positiveRange
    picName=strcat('face',num2str(i),'.bmp');       %�Զ�����ͼƬ������ͼƬ���б���
    %picName='face1.bmp';
    FaceRegion=imread(picName);
    if numel(size(FaceRegion))>2
         FaceRegion=rgb2gray(FaceRegion);           %��rgbͼ��ת��Ϊ�Ҷ�ͼ��
    end 
    FaceRegion=imresize(FaceRegion,stdSize);
    [II]=integralImage(FaceRegion);
    [fea]=extHarrLikeFeature(II,HarrLike,baseSize);
    features(i,:)=fea';
    disp(picName);
end 


for i=negativeRange
    picName=strcat('nonface',num2str(i),'.bmp');
    FaceRegion=imread(picName);
    if numel(size(FaceRegion))>2
         FaceRegion=rgb2gray(FaceRegion);            %��rgbͼ��ת��Ϊ�Ҷ�ͼ��
    end 
    FaceRegion=imresize(FaceRegion,stdSize);
    [II]=integralImage(FaceRegion);
    [fea]=extHarrLikeFeature(II,HarrLike,baseSize);
    features(i+positiveNum,:)=fea';
    disp(picName);
end


Y=[ones(1,positiveNum) zeros(1,negativeNum)];% ���  

HarrLikeFeatures=features;
save HarrLikeFeatures-2.mat HarrLikeFeatures Y 
%}
%��ʼѵ��
trainingRate=0.5;     % ѵ������ռ������������    

T=200;                % ѵ�������ķ�Χ
%T=100;                % ѵ�������ķ�Χ
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

[Hypothesis,AlphaT,trainError,AdaCostTime]=trainAdaBoostLearner(trainX,trainY,T);
[testError,testTP,testFP]=testAdaBoostLearner(testX,testY,Hypothesis,AlphaT,T);

    
    

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

save HarrLikeFeatures-2.mat HarrLikeFeatures Y trainError testError testTP testFP Hypothesis AlphaT AdaCostTime
