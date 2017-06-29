% 2017-5-26 �޼�ѫ
% AdaBoost ѧϰ�㷨 ���Թ���
% testAdaBoostLearner
% ͨ�� AdaBoost ���������з��࣬Ȼ�����ͳ�ƴ�����
% �������ͨ������ AdaBoostClassfy ʵ��
% 
% AdaBoost ѧϰ�㷨 ����ѵ������Թ���
% AdaBoostClassfy            AdaBoost ѧϰ�㷨 ��һ���������з���
% AdaBoostWeakLearnerClassfy AdaBoost �������һ���������з���
% searchBestWeakLearner      ���������ϻ�����ŵ���ֵ������
% trainAdaBoostLearner       AdaBoost ѧϰ�㷨 ѵ������
% testAdaBoostLearner        AdaBoost ѧϰ�㷨 ���Թ���
% testAdaBoost(ѵ�������)    �������������Ϊѵ��������Լ������ѵ������AdaBoostѧϰ�㷨
% AdaBoost(ѵ�������)        ����ѵ��������Լ�,ѵ������AdaBoost������
% 
% testAdaBoost �� AdaBoost ���ƣ�������ѵ�����������
% testAdaBoost ���Զ�Σ����ҽ���������Ϊѵ��������Լ�
% testAdaBoost ͨ������ AdaBoost �������ж�ε� AdaBoost �㷨 ѵ�������
% AdaBoost���� trainAdaBoostLearner ѧϰ������
%         ���� testAdaBoostLearner ���Է�����
% 
% 
% ����:
% testX        �������ݼ�,cntSamples X cntFeatures ά����
%              cntSamples��������ÿ������cntFeatures������ֵ
%              cntSamples    �����������������
%              cntFeatures   �����ռ�ά��
% testY        �����������,ÿ�������������ı�ʶ
% Hypothesis   ѵ����ȡ��AdaBoost������
%              ��T������������ÿ����������������� [��ֵ ƫ�� ������]
% AlphaT       AdaBoost��������Ȩ��,Tά����
% T            ������������
% T            ������������������ȳ���T�����ȡǰT�������������в���
% T            �������������������С��T�����Զ�ʹ�����з��������в���
% thresh       AdaBoost����������ֵ,Ĭ����ֵ0.5
% 
% �����
% testErrorRate �ڲ������ݼ�X�ϵ�1������T�ֵĲ��Դ�����
% TPRate        �ڲ��Լ��ϵ�1������T�ֵ� True-Positive ����
% FPRate        �ڲ��Լ��ϵ�1������T�ֵ� Negative-True ����
% 
% ���ø�ʽ�� 
% [testErrorRate,TPRate,FPRate]=testAdaBoostLearner(testX,testY,Hypothesis,AlphaT)
% [testErrorRate,TPRate,FPRate]=testAdaBoostLearner(testX,testY,Hypothesis,AlphaT,T)
% [testErrorRate,TPRate,FPRate]=testAdaBoostLearner(testX,testY,Hypothesis,AlphaT,T,thresh)
% 
% 
function [testErrorRate,TPRate,FPRate]=testAdaBoostLearner(testX,testY,Hypothesis,AlphaT,varargin)
error(nargchk(4,6,nargin));          % ����������飬��������4-6������,������ֹ����
validateattributes(testX,{'numeric'},{'2d','real','nonsparse'}, mfilename,'testX',1);
validateattributes(testY,{'logical','numeric'},{'row','nonempty','integer'},mfilename, 'testY',2);
validateattributes(Hypothesis,{'numeric'},{'2d','real','nonsparse'}, mfilename,'Hypothesis',3);
validateattributes(AlphaT,{'numeric'},{'row','nonempty','real'},mfilename, 'AlphaT',4);

cntHypothesis=size(Hypothesis,1);    % ����������
if( nargin>4 )                       % ָ�������õķ�����������
    T = varargin{1};
    validateattributes(T,{'numeric'},{'row','nonempty','integer'},mfilename, 'T',5);
    if( cntHypothesis>T )            % ������ T ����Ч�� 
        Hypothesis=Hypothesis(1:T,:);% ��ȡǰT����������
        AlphaT=AlphaT(1:T);
    elseif( cntHypothesis<T )        % ʹ�����з��������в���
        disp('���棺������� T��ʹ�÷��������� ����...');
        T=cntHypothesis;
    end
else                                 % Ĭ�ϲ�ȡ���е��������� 
    T=cntHypothesis;
end
cntHypothesis=size(Hypothesis,1);    % ����������

thresh=0.5;                          % Ĭ�ϵ���ֵ
if( nargin>5 )                       % ָ����������ֵ
    thresh=varargin{2};
    validateattributes(thresh,{'numeric'},{'row','nonempty','real'},mfilename, 'thresh',6);
    if( length(thresh) > 1 )         % ��ֵ����ӦΪ1������Ϊ������
        error(['AdaBoost��������ֵ(thresh)����(' num2str(length(thresh)) ')ӦΪ1(����Ϊ����).']);
    end
    if(thresh>0.99||thresh<0.01)
        disp(['���棺���������ֵ(' num2str(thresh) ')��Ч������Ĭ����ֵ0.5...']);
        thresh=0.5; 
    end
end

if( cntHypothesis~=length(AlphaT) )% ����������������Ȩ������alphaT������ͬ
    error('����������������Ȩ������alphaT������ͬ��');
end

nSamples=size(testX,1);         % �����������������
testErrorRate=zeros(1,T);       % ��1������T�ֵ�ѵ��������
TPRate=zeros(1,T);              % ��1������T�ֵ� True-Positive   ����
FPRate=zeros(1,T);              % ��1������T�ֵ� Negative-True  ����

testOutput=zeros(1,nSamples);   % ��ʱ����:ʹ��ǰt���������Բ������ݽ��з���Ľ��  
h=zeros(1,nSamples);            % ��ʱ����:ʹ�õ�t�����ŷ��������з��� �Ľ��      

for t=1:T                       % ������������T
   [testOutput]=AdaBoostClassfy(testX,Hypothesis,AlphaT,t,thresh);
                                % ��ȡ���������ķ������           
   [errorRate,curTPRate,curFPRate]=calPredictErrorRate(testY,testOutput);
                                % ��������ʡ������������� 
   testErrorRate(t)=errorRate;
   TPRate(t)=curTPRate;
   FPRate(t)=curFPRate;
end

