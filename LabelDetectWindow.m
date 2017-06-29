% 2017-5-28 �޼�ѫ
% ��ԭʼͼ����ϲ��߱߿���
% 
% ���룺
% image         ��Ҫ���б�ǵ�ͼ��
% detectWindow  ���Ϊ�����Ĵ�����Ϣ
%               ���ʽΪ[i j WinSize]����[������ ������ ���ڴ�С]
% 
% �����
% labelImage    ��ԭʼͼ���ϼ��ϴ��ڵı��ͼ��
% 
function [labelImage]=LabelDetectWindow(image,detectWindow)
winCnt=size(detectWindow,1); % ������������
counter=1;                   % ������

labelImage=image;            % ���ͼ��

LabelLineColor=255;          % �������ɫ

while(counter<=winCnt)
     i=detectWindow(counter,1);  % �������� ������            
     j=detectWindow(counter,2);  % �������� ������
     winSize=detectWindow(counter,3);% �������� ��С

     topMost=i;                  % �����ϱ�Ե
     botMost=i+winSize-1;        % �����±�Ե
     lefMost=j;                  % �������Ե
     rigMost=j+winSize-1;        % �����ұ�Ե

     % �ӱ߿�
     labelImage(topMost:botMost,lefMost,:)=LabelLineColor; % ��߿�
     labelImage(topMost:botMost,rigMost,:)=LabelLineColor; % �ұ߿�
     labelImage(topMost,lefMost:rigMost,:)=LabelLineColor; % �ϱ߿�
     labelImage(botMost,lefMost:rigMost,:)=LabelLineColor; % �±߿�
     counter=counter+1;
end
