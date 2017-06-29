% 2017-5-26 �޼�ѫ
% �����ͼ�������һ����ʾ,ͼ����cell��ʽ����,ͼ�������ʽ���
% dispCombineImage
% 
% ����
% images        cell�ṹ��ÿһ��Ԫ�汣��һ��ͼ��
%               һ�������ͬ��С
% 
% xBarImageCnt  ��ֱ��������ʾ��ͼ��������Ĭ��Ϊ�Զ�ѡȡ
% yBarImageCnt  ��ֱ��������ʾ��ͼ��������Ĭ��Ϊ�Զ�ѡȡ
% 
% �����
% combineImage  �����е�ͼ��˳���ڸ�ͼ����չʾ
%               չʾǰ�Ƚ��й�һ��
%               �Ե�һ��ͼ��ĸ߶ȺͿ��Ϊ��׼���й�һ��
% 
% ���÷�ʽ��
% [combineImage]=dispCombineImage(images)
% [combineImage]=dispCombineImage(images,xBarImageCnt,yBarImageCnt)
% 
function [combineImage]=dispCombineImage(images,varargin)
narginchk(1,3);% ��������������
validateattributes(images,{'cell'},{'row'}, mfilename,'images',1);

imageCnt=length(images);      % ͼ������
if(imageCnt==0)               % û������ͼ��,�˳�      
    error('û������ͼ��');
end
if(nargin==3)                 % ָ�����ݷ�������ʾ��ͼ������
    xBarImageCnt=varargin{1}; % ��ֱ��������ʾ��ͼ������
    yBarImageCnt=varargin{2}; % ˮƽ��������ʾ��ͼ������
else                          % �Զ�ȷ�� ���ݷ�������ʾ��ͼ������
    xBarImageCnt=ceil(sqrt(imageCnt));
    yBarImageCnt=xBarImageCnt;
end

colorspaceCnt=size(images{1},3);% ��ɫƽ��������1��ʾ�Ҷ�ͼ��3��ʾ��ɫͼ�� 

xSize=size(images{1},1);      % ��ֱ�����һ���ߴ磬�Ե�һ��ͼ��߶�Ϊ��׼  
ySize=size(images{1},2);      % ˮƽ�����һ���ߴ磬�Ե�һ��ͼ����Ϊ��׼

maxsize=800;                  % ÿ��ͼ��߶����ȵ����ֵ
while( xSize>=maxsize || ySize>=maxsize ) % ��֤�����߶Ȳ��������ֵ
    xSize=ceil(xSize/2);      % �߶ȼ���
    ySize=ceil(ySize/2);      % ��ȼ���
end

counter=1;
breakOutFlag=0;              % �Ƿ��˳���־��Ϊ1��ʾ�Ѵ�����ϣ��˳�ѭ��
for i=1:xBarImageCnt
    for j=1:yBarImageCnt
        xRange=(xSize*(i-1)+1):xSize*i; % ��ֱ����λ��
        yRange=(ySize*(j-1)+1):ySize*j; % ˮƽ����λ�� 
        for k=1:colorspaceCnt             % ��ͼ���ÿ��ƽ����й�һ������ 
           combineImage(xRange,yRange,k)=...% �������ͼ����չʾ
               imresize(images{counter}(:,:,k),[xSize,ySize]);
        end
        counter=counter+1;
        if(counter>imageCnt) % ����ͼ�����չʾ��ϣ����˳�ѭ�� 
            breakOutFlag=1;
            break;
        end
    end
    if(breakOutFlag==1)
        break;
    end
end


