% 2017-5-22 �޼�ѫ
% AdaBoost ��ͼ���(һ�������ͼ������)�����б�
% AdaBoostDecisionForImageBlock
% ͨ������ AdaBoostDecisionForSample ʵ�ֶ�ͼ�����о�
% 
% AdaBoostDecisionForSample �� AdaBoostDecisionForImageBlock ����
% ���Ƕ��ǶԵ������������б𣬵����ǵ����������ͬ��
% AdaBoostDecisionForSample      �������ͼ������������ֵ( �������� )
% AdaBoostDecisionForImageBlock  �������ͼ��������ͼ������( RGB��ɫ�ռ�ֵ )
%                                ������ֵ��δ��ȡ
% 
% AdaBoostDecisionForSample �� AdaBoostClassfy ��һ��������
% ��������������Ķ��Ǵ���������������ֵ�������������������ͬ��
% AdaBoostClassfy            ��һ�����������б�
% AdaBoostDecisionForSample  �Ե������������б�
% 
% 
% AdaBoostDecisionForImageBlock �� ImageBlockRecogByAdaBoost ����
% ���Ƕ��ǶԵ������������б𣬲�������Ҳ��Ϊͼ�����ݣ�����ֵ��δ��ȡ
% ��֮ͬ�����ڣ�
% AdaBoostDecisionForImageBlock һ����ȡ��������
%          Ȼ��ͨ������ AdaBoostDecisionForSample ʵ�������б�
% ImageBlockRecogByAdaBoost     ���о�������������ȡ����
%          ֻ�е���Ҫ������ֵû����ȡʱ������ȡ����
%          ���⣬Ϊ�˷����ϲ���ã���������Ҫ�����в�������װ��һ������ Parameters ��
% 
% ���룺
% ImageBlock   ����ͼ��飬�����о�ͼ��
% Hypothesis   T������������AdaBoost�㷨ѵ����õ�ǿѧϰ��
% AlphaT       ������������Ȩ��
% decidethresh �о�ʱ����ֵ��Ĭ��Ϊ0.5
% 
% �����
% predictOutput      AdaBoost ��ͼ���Ԥ���������ֵΪ0����1
% predictConfidence  AdaBoost ��ͼ���Ԥ����������Ŷȣ�ֵ��[0 1]��
% 
% ���ã�
% [predictOutput,predictConfidence]=...
%     AdaBoostDecisionForImageBlock(ImageBlock,Hypothesis,AlphaT)
% [predictOutput,predictConfidence]=...
%     AdaBoostDecisionForImageBlock(ImageBlock,Hypothesis,AlphaT,decidethresh)
% 
% see:ImageBlockRecognizedByAdaBoost
% 
function [predictOutput,predictConfidence]=AdaBoostDecisionForImageBlock(ImageBlock,Hypothesis,AlphaT,varargin)
error(nargchk(3,4,nargin));        % �������� 3-4 ������,������ֹ����
iptcheckinput(ImageBlock,{'numeric'},{'real'}, mfilename,'ImageBlock',1);
iptcheckinput(Hypothesis,{'numeric'},{'2d','real'}, mfilename,'Hypothesis',2);
iptcheckinput(AlphaT,{'numeric'},{'row','nonempty','real'},mfilename, 'AlphaT',3);

decidethresh=0.5;                   % AdaBoostǿ��������Ĭ����ֵ
if( nargin>3 )                     % ָ��AdaBoostǿ����������ֵ
    decidethresh=varargin{1};
end
iptcheckinput(decidethresh,{'numeric'},{'row','nonempty','real'},mfilename, 'decidethresh',4);
if( length(decidethresh) > 1 )     % ������ֵ����ӦΪ1������Ϊ������
    error(['AdaBoost��������ֵ(thresh)����(' num2str(length(decidethresh)) ')ӦΪ1(����Ϊ����).']);
end


% % [Sample]=extractFeature(ImageBlock);
% TODO 
% �˴�Ϊ���� C++  
% TODO
% TODO

[Sample]=extractFeatureForCpp(ImageBlock);

[predictOutput,predictConfidence]=...
    AdaBoostDecisionForSample(Sample,Hypothesis,AlphaT,decidethresh);

% Parameters.Hypothesis=Hypothesis;% T������������AdaBoost�㷨ѵ����õ�ǿѧϰ�� 
% Parameters.AlphaT=AlphaT;        % ������������Ȩ��
% Parameters.thresh=decidethresh;   % �о�ʱ����ֵ��Ĭ��Ϊ0.5

% [predictOutput,predictConfidence]=... % ���� ImageBlockRecognizedByAdaBoost
%     ImageBlockRecognizedByAdaBoost(ImageBlock,Parameters);



