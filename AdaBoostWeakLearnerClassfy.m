% 2017-5-22�޼�ѫ
% AdaBoost �������һ���������з��࣬���AdaBoost�����������������Ԥ�����
% AdaBoost ������Ϊ��ֵ������
% AdaBoostWeakLearnerClassfy
% 
% ���룺
% Samples      �����������, cntSamples x cntFeatures ����
%              cntSamples    �����������������
%              cntFeatures   �����ռ�ά��
% weakLearner  �����������������˴����õ��Ƕ�ֵ������
% 
% ���:
% predictOutput  AdaBoost����������ÿ��������Ԥ���������ֵΪ0����1
%                �����������1 x cntSamples
% 
%
% 
function [predictOutput]=AdaBoostWeakLearnerClassfy(Samples,weakLearner)
thresh=weakLearner(1);          % ���������� ��ֵ  
p=weakLearner(2);               % ���������� ƫ��
j=weakLearner(3);               % ���������� �����б��

predictOutput=(p.*Samples(:,j)<p*thresh); % ÿ������������������
predictOutput=predictOutput.';
