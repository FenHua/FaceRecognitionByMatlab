% AdaBoost ǿѧϰ�㷨 ��һ���������з��࣬���AdaBoost�㷨��������Ԥ�����
% 2017-5-22 �޼�ѫ
% 
% AdaBoostClassfy �� AdaBoostDecisionForSample ���ƣ��䲻֮ͬ������
% AdaBoostClassfy �б�һ������, AdaBoostDecisionForSample �б𵥸��������
% AdaBoostClassfy  ����������д���������������ֵ
% AdaBoostDecisionForSample ������ǵ�������������ֵ
% 
% 
% ���룺
% Samples      �����������, cntSamples x cntFeatures ����
%              cntSamples    �����������������
%              cntFeatures   �����ռ�ά��
% Hypothesis   ������AdaBoostǿ������,��T�������������
% AlphaT       AdaBoost��������Ȩ��
% T            ���������ʹ�õ�AdaBoost��������������
% boostthresh  AdaBoostǿ����������ֵ��Ĭ��Ϊ0.5
% 
% ���:
% predictOutput      AdaBoost��ÿ��������Ԥ���������ֵΪ0����1
%                    ��������1 x cntSamples
% predictConfidence  AdaBoost��ÿ��������Ԥ����������Ŷȣ�ֵ��[0 1]��
%                    ��������1 x cntSamples
% 
% ���ø�ʽ:
% [predictOutput,predictConfidence]=AdaBoostClassfy(Samples,Hypothesis,AlphaT,T)
% [predictOutput,predictConfidence]=AdaBoostClassfy(Samples,Hypothesis,AlphaT,T,boostThresh)
% 
% 
function [predictOutput,predictConfidence]=AdaBoostClassfy(Samples,Hypothesis,AlphaT,T,varargin)
error(nargchk(4,5,nargin));        % ����4-5������,������ֹ����
validateattributes(Samples,{'numeric'},{'2d','real','nonsparse'}, mfilename,'Samples',1);
validateattributes(Hypothesis,{'numeric'},{'2d','real','nonsparse'}, mfilename,'Hypothesis',2);
validateattributes(AlphaT,{'numeric'},{'row','nonempty','real'},mfilename, 'AlphaT',3);

cntSamples=size(Samples,1);        % �����������������
boostthresh=0.5;                   % AdaBoostǿ��������Ĭ����ֵ
if( nargin>4 )                     % ָ��AdaBoostǿ����������ֵ
    boostthresh=varargin{1};
end
validateattributes(T,{'numeric'},{'row','nonempty','integer'},mfilename, 'T',4);
if( length(T) > 1 )              % ָ��ʹ�����������������Ĳ���T����ӦΪ1������Ϊ������
    error(['ָ��ʹ�����������������Ĳ���(T)����(' num2str(length(T)) ')ӦΪ1.']);
end
validateattributes(boostthresh,{'numeric'},{'row','nonempty','real'},mfilename, 'boostthresh',5);
if( length(boostthresh) > 1 )     % ������ֵ����ӦΪ1������Ϊ������
    error(['AdaBoost��������ֵ(thresh)����(' num2str(length(boostthresh)) ')ӦΪ1(����Ϊ����).']);
end

predictOutput=zeros(1,cntSamples); % ÿ��������ǿ���������б������0����1
predictConfidence=zeros(1,cntSamples); % ÿ�����������������Ŷȣ�[0 1]

Hypothesis=Hypothesis(1:T,:);      % ȡǰT���������� 

AlphaT=AlphaT(1:T);                % ǰT����������Ȩ��

for i=1:cntSamples              
    h=zeros(1,T);                  % ���з�����ÿ�������ķ�������� 
    for t=1:T
          thresh=Hypothesis(t,1);  % ��t������������ ��ֵ
          p=Hypothesis(t,2);       % ��t������������ ƫ��
          j=Hypothesis(t,3);       % ��t������������ ������
          if((p*Samples(i,j))<(p*thresh))% ��t�����������Ķ�����i�����
              h(t)=1;
          end
     end
     tempH=sum(AlphaT.*h);      
     if(tempH>=(boostthresh*sum(AlphaT)))          % ��T�������������ǿ������,���������i����� 
          predictOutput(i)=1;
     end
     predictConfidence(i)=tempH/(sum(AlphaT)+eps); % ���Ŷ�
end

