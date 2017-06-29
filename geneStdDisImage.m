% ���ɱ�׼�Ĳ��߱��ͼ��
% geneStdDisImage
% 
% ʹ���˹���ǵ�ͼ���ȥԭʼ��ͼ��
% �õ����ߵĲ�ֵͼ��
% �Բ�ֵͼ�������ֵ�ָ���ɻ�ñ�ʶ�Ĳ�������
%
% ���룺
% DiffImage  ��ֵͼ��
%            �ֹ����ͼ����ԭʼͼ��֮�ͨ�����߲�ֵʶ�����������
% winSize    ������ֵ�ָ�Ĵ��ڴ�С
% thresh     ��ֵ������ֵ���ڴ���ֵ������Ϊ���˹���ǵĲ�������
% 
% �����
% labImage   ����Ĳ��߱��ͼ��1��ʾ��������
% 
% 
% 
% 
function [labImage]=geneStdDisImage(DiffImage,winSize,thresh)
imageHeight=size(DiffImage,1);   % ��ֵͼ������߶�
imageWidth=size(DiffImage,2);    % ��ֵͼ��������
xstep=winSize;                   % �����ڴ�ֱ����ÿ���ƶ�����
ystep=xstep;                     % ������ˮƽ����ÿ���ƶ�����

% ���ͼ�񣬱����ȡ�Ĳ�����Ϣ 0:�޲��ߣ�1:�ѱ����Ϊ���ߴ���
labImage=zeros(imageHeight,imageWidth); 

i=1;
while(i<=(imageHeight-winSize))       % ���Ա�Ե����
    j=1;
    while(j<=(imageWidth-winSize)) 
        window=DiffImage(i:(i+winSize-1),j:(j+winSize-1));% �ڲ�ֵͼ����,��ȡ�ô������������
        center=mean2(window(:,:));
        if(center>=thresh)
             labImage(i:(i+winSize-1),j:(j+winSize-1))=1;  % ��־Ϊ��������
        end
        j=j+ystep;   % �����ƶ�
    end
    i=i+xstep;       % �����ƶ�����һ��
end
