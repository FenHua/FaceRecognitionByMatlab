% �޼�ѫ2017-5-25
% ����AdaBoost������ ��ͼ���(һ�������ͼ������)�����б�
% ImageBlockRecogByCascadeAdaBoost
% 
% �÷����� ImageBlockRecogByAdaBoost ��ͬһ�ຯ�������Ա�ͳһ����
% 
% ���ڸú������������ظ����ã�����Ч�ʿ��ǣ�û�жԸú����Ĳ����������ͼ��
% 
% Ϊ�˷�����õ�һ���ԣ���������Ҫ�Ĳ���������װ�� Parameters ��
% 
% 
% ����Ϊͼ������ݣ�ÿ�ν�����ȡ��Ҫ�����������б�
% ÿ���������������������о�ʱ�������жϸ����������������Ƿ�����ȡ
% ��������û����ȡ������ȡ������������ϵ������(identifySeriesFeatureByIndex)
% 
% 
% ���룺
% ImageBlock              ����ͼ��飬�����о�ͼ��
% Parameters              ����AdaBoost �������������������£�
% Parameters.Hypothesis   T �� ����AdaBoost������, 1xT cell
% Parameters.AlphaT       ����AdaBoost������Ȩ��, 1xT cell
% Parameters.thresh       ����AdaBoost��������ֵ, 1xT cell
% Parameters.T            ����AdaBoost�ļ���
% �����
% predictOutput           AdaBoost ��ͼ���Ԥ���������ֵΪ0����1
% 
% ���ø�ʽ��
%  [predictOutput]=...
%     ImageBlockRecogByCascadeAdaBoost(ImageBlock,Parameters)
%
% 
function [predictOutput]=...
    ImageBlockRecogByCascadeAdaBoost(ImageBlock,Parameters)
Hypothesis = Parameters.Hypothesis;    % ���������� AdaBoost �㷨ѵ����õ�ǿѧϰ��
AlphaT = Parameters.AlphaT;            % ���� AdaBoost ������Ȩ��
decidethresh = Parameters.thresh;      % ���� AdaBoost ��������ֵ
T = Parameters.T;                      % ���� AdaBoost �ļ���

predictOutput = 0;                     % ���������������������     
cntFeatures = 391;                     % �����ռ�ά��
feature = zeros(1,cntFeatures);        % ��������
extFlags = zeros(1,cntFeatures);       % �����Ƿ�����ȡ�ı�־����

for t=1:T
    tCntHypo = length(AlphaT{t});      % ��t�� ����������
    h = zeros(1,tCntHypo);             % ��t�� tCntHypo ��������������������� 
    tDThresh = decidethresh{t};        % ��t�� ���о��ߵ���ֵ

    for i = 1:tCntHypo                 % ��t�� �����������о�
          thresh = Hypothesis{t}(i,1); % ��t�� �� i �� ���������� ��ֵ
          p = Hypothesis{t}(i,2);      % ��t�� �� i �� ���������� ƫ��
          j = Hypothesis{t}(i,3);      % ��t�� �� i �� ���������� ������j
          if( extFlags(j) == 0 )       % �� �� j �� ������δ��ȡ������ȡ��ϵ������
              [seriesFeatures,seriesIndex] = identifySeriesFeatureByIndex(ImageBlock,j);
              feature(seriesIndex) = seriesFeatures; % ����
              extFlags(seriesIndex) = 1;             % ����ȡ������־ 
          end
          if( (p*feature(j)) < (p*thresh) )  % ��t���������Ķ����������
              h(i) = 1;
          end
    end
    tempH = sum( AlphaT{t}.*h );
    if( tempH >= (tDThresh*sum(AlphaT{t})) ) % ��T�������������ǿ������,�������������� 
          predictOutput = 1;
    else
         predictOutput = 0;
         break;
    end
end

