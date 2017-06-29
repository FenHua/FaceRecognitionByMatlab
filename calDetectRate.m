% 2017-5-23�޼�ѫ
% �������ʶ��Ĳ����������˹���ע������Ĳ��
% calDetectRate
% 
% ���㲡�ߵļ���ʡ�����ʱ��
% ���㲡������ļ���ʺ������
% 
% ���������
% AreaTPRate ��������ļ����
% AreaFPRate ��������������
% CntTPRate  ���������ļ����
% labDisCnt  ����ͼ���ϻ�õĲ�������
% StdDisCnt  �˹����ͼ���ϵĲ�������
% labTPArea  ��������ļ�����
% labFPArea  ��������Ĵ��������
% StdDisArea �˹����ͼ���ϵı�׼�������
% 
% 
% ���������
% detectrate       ���м���������ɵ�����, �����ʽ
%                  AreaTPRate AreaFPRate CntTPRate labDisCnt  
%                  StdDisCnt labTPArea labFPArea StdDisArea
% detectProperties ���м���������ɵĽṹ�� 
% 
% ���������
% StdImage      ͨ���˹����ͼ���õı�׼���߱�ʾͼ�� 
% labStim       ͨ��ʶ���㷨��õĲ��߱��ͼ��,0Ϊ����,����Ϊ�ǲ���
% Thresh        �ж���ѡ�����Ƿ�Ϊ���ߵ���ֵ
%               ֻ�д��ڸ�ֵ������Ϊ�ҵ��������Ĳ���
% 
% [detectrate,detectProperties]=calDetectRate(StdImage,labImage)
% [detectrate,detectProperties]=calDetectRate(StdImage,labImage,Thresh);
% 

function [detectrate,detectProperties]=calDetectRate(StdImage,labImage,varargin)
iptchecknargin(2,3,nargin,mfilename);   % ��������������
iptcheckinput(StdImage,{'numeric'},{'2d','real','nonsparse'}, mfilename,'StdImage',1);
iptcheckinput(labImage,{'numeric'},{'2d','real','nonsparse'}, mfilename,'labImage',2);

Thresh=0.6;       % �ж���ѡ�����Ƿ�Ϊ���ߵ���ֵ
if(nargin>2)      % ָ���ж�����Ϊ���ߵ���ֵ
    Thresh=varargin{1};
end

[StdImage,StdDisCnt]=bwlabel(StdImage,8); % �����ͨ����
if(StdDisCnt==0)                                 
    error('��ҶƬ�ϲ����ڲ��ߣ��޷���������~');
end
StdDisArea=length(find(StdImage~=0));    % �˹����ͼ���ϵı�׼�������

labDisCnt=0;  % ͼ���ϼ���õĲ�������                             
labTPArea=0;  % ��������ļ�����

for i=1:StdDisCnt                        % �˹����ͼ���ϵı�׼��������
    [rows cols]=find(StdImage==i);
    curDisArea=0;

    for j=1:length(rows)
        if(labImage(rows(j),cols(j))~=0)
            curDisArea=curDisArea+1;
            labImage(rows(j),cols(j))=-1;
        end
    end
    labTPArea=labTPArea+curDisArea;     % ��������ļ�����
    curDisAreaRate=curDisArea/length(rows);% ��ⲡ����ռ����
                
    if(curDisAreaRate>=Thresh)          % ������ֵ�������Ӳ����� 
        labDisCnt=labDisCnt+1;
    end
end

labFPArea=length(find(labImage>0));    % ���������������

AreaTPRate=labTPArea/(StdDisArea+eps); % ��������ļ����
AreaFPRate=labFPArea/length(find(StdImage==0)); % ��������������
CntTPRate=labDisCnt/(StdDisCnt+eps);   % ���������ļ����

% ��������ʽ������������
detectrate=[AreaTPRate,AreaFPRate,CntTPRate,labDisCnt,StdDisCnt,labTPArea,labFPArea,StdDisArea];
 
if(nargout>1)  % �Խṹ����ʽ������������
    detectProperties.AreaTPRate=AreaTPRate; % ��������ļ����
    detectProperties.AreaFPRate=AreaFPRate; % ��������������
    detectProperties.CntTPRate=CntTPRate;   % ���������ļ����
    detectProperties.labDisCnt=labDisCnt;   % ����ͼ���ϻ�õĲ�������
    detectProperties.StdDisCnt=StdDisCnt;   % �˹����ͼ���ϵĲ�������
    detectProperties.labTPArea=labTPArea;   % ��������ļ�����
    detectProperties.labFPArea=labFPArea;   % ��������Ĵ��������
    detectProperties.StdDisArea=StdDisArea; % �˹����ͼ���ϵı�׼�������
end

