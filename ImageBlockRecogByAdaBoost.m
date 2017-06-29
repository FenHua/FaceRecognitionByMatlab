%�޼�ѫ2017-5-25
%���� AdaBoost ������ͼ�������о�
% ImageBlockRecognizedByAdaBoost
% 
% ���ڸú������������ظ����ã�����Ч�ʿ��ǣ�û�жԸú����Ĳ����������ͼ��
% 
% Ϊ�˷�����õ�һ����
% ��������Ҫ�Ĳ���������װ�� Parameters ��
% 
% ����ʵ���˶��������з���ĺ���Ϊ��AdaBoostDecisionForSample
%                                ImageBlockRecognizedByAdaBoost
% 
% 
% ����Ϊͼ������ݣ�ÿ�ν�����ȡ��Ҫ�����������б�
% ÿ���������������������о�ʱ�������жϸ����������������Ƿ�����ȡ
% ��������û����ȡ������ȡ������������ϵ������(identifySeriesFeatureByIndex)
% 
% 
% ���룺
% ImageBlock              ����ͼ��飬�����о�ͼ��
% Parameters              AdaBoost ѧϰ�㷨�Ĳ������������£�
% Parameters.Hypothesis   T������������AdaBoost�㷨ѵ����õ�ǿѧϰ��
% Parameters.AlphaT       ������������Ȩ��
% Parameters.thresh       ��������������ֵ��Ĭ��Ϊ0.5
% 
% �����
% predictOutput           AdaBoost ��ͼ���Ԥ���������ֵΪ0����1
% predictConfidence       AdaBoost ��ͼ���Ԥ����������Ŷȣ�ֵ��[0 1]��
% 
% ���ã�
% [predictOutput,predictConfidence]=ImageBlockRecogByAdaBoost(ImageBlock,Parameters)
% 
% 
function [predictOutput,predictConfidence]=...
    ImageBlockRecogByAdaBoost(ImageBlock,Parameters)

Hypothesis=Parameters.Hypothesis; % T������������AdaBoost�㷨ѵ����õ�ǿѧϰ��
AlphaT=Parameters.AlphaT;         % ������������Ȩ��
decidethresh=Parameters.thresh;   % �о�ʱ����ֵ��Ĭ��Ϊ0.5

predictOutput=0;                  % ������ǿ�����������     
%predictConfidence=0;              % ������ 
T=length(AlphaT);                 % ����������
h=zeros(1,T);                     % ���з���������������� 

baseSize=2:2:4;
HarrLike{1}=[1 -1];         %����haar-like����
HarrLike{2}=[1 -1].';
HarrLike{3}=[1 -1 1];
HarrLike{4}=[1 -1 1].';
HarrLike{5}=[1 -1;-1 1];


cntFeatures=T;                     % �����ռ�ά��
%feature=zeros(1,cntFeatures);      % ��������
%extFlags=zeros(1,cntFeatures);    % �����Ƿ�����ȡ�ı�־����
image=imresize(ImageBlock,[20 20]);%ʹ����Ϊ��20 20��С��
[II]=integralImage(image);
feature=extHarrLikeFeature(II,HarrLike,baseSize);
for t=1:T
      thresh=Hypothesis(t,1);     % ��t���������� ��ֵ
      p=Hypothesis(t,2);          % ��t���������� ƫ��
      j=Hypothesis(t,3);          % ��t���������� ������
      
      %{
      if( extFlags(t)==0 )        % ����j��������δ��ȡ������ȡ��ϵ������
        [seriesFeatures,seriesIndex]=identifySeriesFeatureByIndex(ImageBlock,t);
         feature(seriesIndex)=seriesFeatures; % ����
         extFlags(seriesIndex)=1;             % ����ȡ������־ 
      end 
      %}
   
      if((p*feature(j))<(p*thresh))% ��t���������Ķ����������
          h(t)=1;
      end
    
end 
    
      tempH=sum(AlphaT.*h);                 % T�����������*Ȩ��
      if(tempH>=(decidethresh*sum(AlphaT))) % ��T�������������ǿ������,�������������� 
        predictOutput=1;
      end


predictConfidence=tempH/sum(AlphaT);  % ����������

end 

