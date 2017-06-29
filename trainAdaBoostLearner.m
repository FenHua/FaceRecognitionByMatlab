% 2017-5-21 �޼�ѫ
% AdaBoost ѧϰ�㷨 ѵ������,Ŀ�����ڻ��һ��AdaBoostǿѧϰ��
% trainAdaBoostLearner
% AdaBoost ��������Ϊ��ֵ������
% 
% �㷨�ο���Robust Real-time Object Detection.pdf
%
% ѵ��T��,�����õ�1������T�ֵ�����,����������,ѵ�������ʵ�
% 
% AdaBoost ѧϰ�㷨 ����ѵ������Թ���
% AdaBoostClassfy            AdaBoost ѧϰ�㷨 ��һ���������з���
% AdaBoostWeakLearnerClassfy AdaBoost �������һ���������з���
% searchBestWeakLearner      ���������ϻ�����ŵ���ֵ������
% trainAdaBoostLearner       AdaBoost ѧϰ�㷨 ѵ������
% testAdaBoostLearner        AdaBoost ѧϰ�㷨 ���Թ���
% testAdaBoost(ѵ�������)    �������������Ϊѵ��������Լ������ѵ������ AdaBoost ѧϰ�㷨
% AdaBoost(ѵ�������)        ����ѵ��������Լ�,ѵ������AdaBoost������
% 
% testAdaBoost �� AdaBoost ���ƣ�������ѵ�����������
% testAdaBoost ���Զ�Σ����ҽ���������Ϊѵ��������Լ�
% testAdaBoost ͨ������ AdaBoost �������ж�ε� AdaBoost �㷨 ѵ�������
% AdaBoost���� trainAdaBoostLearner ѧϰ������
%         ���� testAdaBoostLearner ���Է�����
% 
% 
% 
% ����:
% X            ѵ�����ݼ�
%              cntSamples X cntFeatures ά����
%              cntSamples ��������ÿ������cntFeatures������ֵ
%              cntSamples    ѵ�����ݼ�����������
%              cntFeatures   �����ռ�ά��
%              ����������
%                     ����1 ����2  ����3  ����4
%              ����1    1     2     1     1
%              ����2    2     3     5     2
%              ����3    5     1     2     1
%              ����4    2     4     5     2
%             
% Y            ÿ�������������ı�ʶ,������, 1 x cntSamples
%              �磺Y = [1 0 1 0]����ʾ��1���������3������Ϊ��������2��4Ϊ������
% T            ѵ������
% cntSelectFeatures 
%              ��ѡ��������Ҫѵ��ָ������������������
%              ������4�����������ʾ��������ѵ������ΪT�Ĺ���
%              ��ʱ��һֱѵ����ֱ��������ѵ����ָ��������
%              ����������� costTime ָ��ȡ������������õ�ʱ��
% 
% �����
% Hypothesis     ѵ����ȡ�ļ���,T x 3 ����
%                ��T������������ÿ����������������� [��ֵ ƫ�� ������]
%                ��4������������ɵ�ǿ���������£�
%                    ��ֵ     ƫ�� ������
%                   -16.4151    1   27
%                     0.0073    1  291
%                     0.4482   -1   14
%                     0.0540    1  315
% 
% AlphaT         ÿ�ּ����Ȩֵ,1xT ����
% trainErrorRate ��ѵ�����ݼ��ϵ�1������T�ֵ�ѵ��������,1xT ����
% costTime       ѵ����1������T�ֵĻ���ʱ��
%
% ���ø�ʽ��
% [Hypothesis,AlphaT,trainErrorRate,costTime]=trainAdaBoostLearner(X,Y,T)
% [Hypothesis,AlphaT,trainErrorRate,costTime]=trainAdaBoostLearner(X,Y,T,cntSelectFeatures)
% 
%  
%  ���� ���ز��� TPRate,FPRate ���ڻ�ͼ���ROC����
% ͬʱ���޸ĵ�����������
% trainAdaBoostLearner, trainFloatBoostLearner, trainSceBoostLearner
%
function [Hypothesis,AlphaT,trainErrorRate,costTime,TPRate,FPRate]=trainAdaBoostLearner(X,Y,T,varargin)
error(nargchk(3,4,nargin)); % ��������3-4������,������ֹ����
validateattributes(X,{'numeric'},{'2d','real','nonsparse'}, mfilename,'X',1);
validateattributes(Y,{'logical','numeric'},{'row','nonempty','integer'},mfilename, 'Y', 2);
validateattributes(T,{'numeric'},{'row','nonempty','integer'},mfilename, 'T',3);
if( length(T) > 1 )              % ָ��ѵ�������Ĳ���T����ӦΪ1������Ϊ������
    error(['ָ��ѵ�������Ĳ���(T)����(' num2str(length(T)) ')ӦΪ1(����Ϊ����).']);
end

[cntSamples,cntFeatures]=size(X); % cntSamples  ѵ�����ݼ�����������
                                  % cntFeatures �����ռ�ά��
inverseControl=0;           % ����ѭ���˳���ʶ��Ϊ0��ʾѵ��T�֣�������Ҫѵ����ָ������������
cntSelectFeatures=0;        % ��Ҫѡ����������� 

if( nargin>3 )              % ������4�����������ʾ��������ѵ������ΪT�Ĺ���
                            % ��ʱ��һֱѵ����ֱ��������ѵ����ָ��������
    cntSelectFeatures=varargin{1};
    inverseControl=1;
    validateattributes(cntSelectFeatures,{'numeric'},{'row','nonempty','integer'},mfilename, 'cntSelectFeatures',4);
    if( length(cntSelectFeatures) > 1 ) % ָ�����������Ĳ�������ӦΪ1������Ϊ������
        error(['ָ�����������Ĳ���(cntSelectFeatures)����(' num2str(length(cntSelectFeatures)) ')ӦΪ1.']);
    end
    if( cntSelectFeatures>=cntFeatures )
        error('��Ҫѡ�����������(cntSelectFeatures)����');
    end
end
if( cntSamples~=length(Y) ) % ѵ������X���뱻�ල
    error('ѵ������X���ȱ������������������ͬ') ;
end

computeCosttimeFlag=1;      % ��ʱ��ʶ����Ϊ1��ʾ��ѵ��ʱ���ʱ
if(computeCosttimeFlag==1)
    tic
end

X=ceil(X*10000)/10000;          % ѵ����������ɾ��β�����ݣ���ֹ�������
positiveCols=find(Y==1);        % ��ѵ���������
negativeCols=find(Y==0);        % ��ѵ���������
%{
if(length(positiveCols)==0)     % �����������
    error('����������Ϊ0,�޷�ѵ��.');
end
if(length(negativeCols)==0)     % ��鸺������
    error('����������Ϊ0,�޷�ѵ��.');
end
%}
weight=ones(cntSamples,1);       % Ȩֵ����;������;һ�д���һ��������Ȩ��
weight(positiveCols)=1/(2*length(positiveCols));      % ��ѵ�������ĳ�ʼȨֵ
weight(negativeCols)=1/(2*length(negativeCols));      % ��ѵ�������ĳ�ʼȨֵ
Hypothesis=zeros(T,3);          % ͨ��T��ѵ����ȡ��T�������裬�ṹΪ:[��ֵ ƫ�� ������]
AlphaT=zeros(1,T);              % T��ѵ����ȡ��ÿ���������Ȩֵ
trainErrorRate=zeros(1,T);      % �� 1 ������ T �ֵ�ѵ��������
costTime=zeros(1,T);            % �� 1 ������ T �ֻ��ѵ�ʱ��

trainOutput=zeros(1,cntSamples); % ��ʱ����:ʹ��ǰt����������ѵ�����ݽ��з���Ľ��  
h=zeros(1,cntSamples);           % ��ʱ����:ʹ�õ�t�����ŷ��������з��� �Ľ��      

TPRate = zeros(1,T);             % ��1��T�ּ����
FPRate = zeros(1,T);             % ��1��T�������

t=1; 
curFeaSize=0;                   % ��ǰ�Ѿ�ѡ�������������
while(true)                     % ѵ������
    minError=cntSamples;        % �����ʳ�ֵ��cntSamples
    weight=weight/(sum(weight));% Ȩֵ��һ��
%     if(outputTips==1)
%         disp(strcat('��ǰ��',num2str(t),'��....'));
%     end
    for j=1:cntFeatures         % ��ÿ������ֵ,��ȡ���ŵķ�����(����)
        [tempError,tempThresh,tempBias]=searchBestWeakLearner(X(:,j),Y.',weight);
                                                      % ������ȡj�����ŵļ���

        if(tempError<minError)                        % ��cntFeatures�����ŵķ�������ѡ���������С�ķ�����
            minError=tempError;                       % ��t�� ��С�Ĵ�����
            Hypothesis(t,:)=[tempThresh,tempBias,j];  % ��t�� ������������
        end
    end
    h=AdaBoostWeakLearnerClassfy(X,Hypothesis(t,:));   % ʹ�õ�t�����������������з���
    
    errorRate=sum(weight(find(h~=Y)));                 % �����t�ַ��������
    AlphaT(t)=log10((1-errorRate)/(errorRate+eps));    % �����t��Ȩ��         
    if(errorRate>eps)                                  % ��С����ȷ�����������Ȩֵ
        weight(find(h==Y))=weight(find(h==Y))*(errorRate/(1-errorRate));                                     
    end
    % �����Ǽ��㵱ǰ����(��t��)��ѵ��������
    [trainOutput]=AdaBoostClassfy(X,Hypothesis,AlphaT,t);
    [curErrorRate,curTPRate,curFPRate]=calPredictErrorRate(Y,trainOutput);
    trainErrorRate(t) = curErrorRate;
    TPRate(t) = curTPRate;
    FPRate(t) = curFPRate;
   
    if(inverseControl==0)            % ����ѵ����������ѭ��
        if(computeCosttimeFlag==1)
            costTime(t)=toc;
        end
        if(t>=T)                     % �ﵽ������ѵ������                       
             break;
        end
    else                             % ������ȡ��������������ѭ��
        [SelectFeaNo]=analysisHypothesisFeature(Hypothesis(1:t,:),0);
        if( length(SelectFeaNo)>curFeaSize )
            curFeaSize=length(SelectFeaNo);
            if( computeCosttimeFlag==1 )
                costTime(curFeaSize)=toc;
            end
        end
        if( curFeaSize>=cntSelectFeatures )% �ﵽ��������������
            break;
        end
    end
    t=t+1;
end

if(computeCosttimeFlag==1)
    costTime=costTime(find(costTime~=0));% ���ѵ��ʱ��
else
    costTime=0;
end

if(t<T)     
    Hypothesis=Hypothesis(1:t,:);      % ǿ������
    AlphaT=AlphaT(1:t);                % ǿ������Ȩ��
    trainErrorRate=trainErrorRate(1:t);% ѵ��������
end

