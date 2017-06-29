% 2017-5-27�޼�ѫ
% չʾ��������ϵ�з�����õ�ƽ��ͳ������
% dispWindowingResult
% 
% ����ͨ�� testMWSegment��testPyramidAnalysis
% �ȷ������
% 
% statsdata ��õ�ƽ��ͳ������
% 
function [statsdata]=dispWindowingResult(varargin)
load MoveWindowSegmentResult1108.mat MWindowResult

plotStyle={'r-*','g-p','b-<','r->','g-o','b-+','r-s','g--h','b-.v','r-^','g-.','b-p'};

if( nargin>=2 )
    MWindowData=varargin{1};
    PyramidAnalysisData=varargin{2};
end

[statsdata{1}]=getAverayStatsData(MWindowResult);
[statsdata{2}]=getAverayStatsData(PyramidAnalysisData);

methodCnt=2;

figure(ceil(20077*rand)),
hold on,grid on,
for i=1:methodCnt
    xValue=statsdata{i}(:,2);
    yValue=statsdata{i}(:,1);
    plot(xValue,yValue,plotStyle{i});
end
xlabel('�����');
ylabel('�����');
title('ROC����');
legend('�������ڷ���','����������');

% 
% ������/����ʵ����ݵ�ƽ��ֵ
% 
% ���ÿ����ֵͳ��ÿ�ַ������ͳ�����ݵ�ƽ��ֵ
% ÿһ����ֵ��Ӧһ��ϵ�е�ƽ��ֵ����ͼƬ���ֵ��
% 
% ���ͳ�����ݱ����ʽΪ��{ͼƬ���}{��ֵ���}Cell
% ÿһ��Ԫ�����ÿ��ͼ��ÿ����ֵ�»�õ�ͳ�����ݣ�
% AreaTPRate ��������ļ����
% AreaFPRate ��������������
% CntTPRate  ���������ļ����
% labDisCnt  ����ͼ���ϻ�õĲ�������
% StdDisCnt  �˹����ͼ���ϵĲ�������
% labTPArea  ��������ļ�����
% labFPArea  ��������Ĵ��������
% StdDisArea �˹����ͼ���ϵı�׼�������
% costtime   �������л���ʱ��
% 
function [statsAnalysisData]=getAverayStatsData(statsData)
imageCnt=length(statsData);                % ������ͼƬ���� 
threshCnt=length(statsData{1});            % ��ֵ����
nArgOut=length(statsData{1}{1});           % ͳ�����ݵĸ��� 
statsAnalysisData=zeros(threshCnt,nArgOut);% ͳ�Ʒ�����ƽ��ֵ���
for curThreshNO=1:threshCnt                % ÿһ����ֵ��Ӧһ��ϵ�е�ƽ��ֵ 
    for i=1:imageCnt
        curArgIndex=1:nArgOut;             % ��ƽ��ֵ�������±�����
        statsAnalysisData(curThreshNO,curArgIndex)=...% ��ÿ��ͼ���õĽ�����
            statsAnalysisData(curThreshNO,curArgIndex)+statsData{i}{curThreshNO};
    end
end
statsAnalysisData=statsAnalysisData./imageCnt;        % ��ÿ��ͼ���õĽ����ƽ��

