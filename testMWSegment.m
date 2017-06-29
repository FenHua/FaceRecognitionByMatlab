% 2017-5-28 �޼�ѫ
% ���Ի�������(MoveWindowing)
% testMWSegment
% ��ͨ��������ʵ������ʶ��
% 
% ��������ݱ����� MWindowData ��
% �����ʽΪ��{ͼƬ���}{��ֵ���}Cell
% ÿһ��Ԫ�����ÿ��ͼ��ÿ����ֵ�»�õ�ͳ�����ݣ�
% AreaTPRate ��������ļ����
% AreaFPRate ��������������
% CntTPRate  ���������ļ����
% labDisCnt  ����ͼ���ϻ�õ���������
% StdDisCnt  �˹����ͼ���ϵ���������
% labTPArea  ��������ļ������
% labFPArea  ��������Ĵ���������
% StdDisArea �˹����ͼ���ϵı�׼��������
% costtime   �������л���ʱ��

imBegin=1;
imEnd=1;

% MVParameters        �������ڷ����Ĳ������������²�����

MVParameters.WindowingPatchSize=20:4:80; % ����ʱ�Ĵ��ڴ�С���� ԭ���ݣ�60 80��
MVParameters.xnum=30;                % ˮƽ�����Ͻ�ͼ�񻮷ֵĸ��� 
MVParameters.ynum=30;                % ��ֱ�����Ͻ�ͼ�񻮷ֵĸ��� 

% WindowParameters       ��ͼ�񴰿ڽ����б��ѧϰ�㷨�Ĳ���
load HarrLikeFeatures-2.mat Hypothesis AlphaT
WindowParameters.Method=@ImageBlockRecogByAdaBoost;
WindowParameters.Hypothesis=Hypothesis;
WindowParameters.AlphaT=AlphaT;
WindowParameters.thresh=0.5;

segThresh=0.1:0.1:0.9;       % ��Ƶ��ͼ����зָ�Ķ����ֵ
DiseaseThresh=0.75;          % �ж���ѡ�����Ƿ�Ϊ������������ֵ

tic
imageBak=cell(1,imEnd-imBegin+1);

for i=imBegin:imEnd
    filename='8.bmp';
    image=imread(filename);    % ��ȡԭʼͼ��
    [sizex,sizey]=size(image);
    smallimage=imresize(image,[sizex/2,sizey/2]);
    if numel(size(image))~=2
        image=rgb2gray(image);
    end 
    [detectWindow,detectImage,pixFreImage]...% ��������ʶ��
        =MoveWindowing(image,MVParameters,WindowParameters);

    costtime=toc;

    bias=1;
    [labBinaryImage,labSrcImage]=...         % ����ֵ�ָ�
        MultiThreshSegement(pixFreImage,segThresh,bias,image);

    imageBak{i-imBegin+1}=labSrcImage;
    [combineMap]=dispCombineImage(labSrcImage);
    figure
    imshow(detectImage)
    %newName=strcat('TestPicture/Segment/',num2str(i),...
    %    '-MovingWindow-costtime-',num2str(costtime),'.jpg');
    %imwrite(combineMap,newName,'jpg');     % ���浽�ļ���
    %disp(newName);   
end



