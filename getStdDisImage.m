% ��ñ�׼�Ĳ��߱��ͼ��
% generateStdDiseaseImage
% 
% ����������ɵ��ù���
% ���뺯��geneStdDisImage����ʹ��
% 
% ͨ����ԭʼͼ����˹���ʶͼ��Ĵ�����ñ�ʶ��Ĳ�������
% 
% ʹ���˹���ǵ�ͼ���ȥԭʼ��ͼ��
% �õ����ߵĲ�ֵͼ��
% �Բ�ֵͼ�������ֵ�ָ���ɻ�ñ�ʶ�Ĳ�������
% 
%
% 
function [labImage]=getStdDisImage(fileNO)
winSize=2;   % ������ֵ�ָ�Ĵ��ڴ�С��ÿ����ȡһ�����ڽ��зָ
thresh=10;   % ������ֵ�ָ�Ĵ�����ֵ
dirPathSource='TestPicture\\TestOrangeCanker\\';   % ԭʼͼ��Ŀ¼
dirPathModify='TestPicture\\TestOrangeCanker2\\';  % �˹����ͼ��Ŀ¼ 
preFilename='TestOrangeCanker-';
fileFormate='.jpg';
filename=strcat(preFilename,num2str(fileNO),fileFormate);% �ļ���

fileSource=strcat(dirPathSource,filename);   % ԭʼͼ���ļ���
fileModified=strcat(dirPathModify,filename); % �˹����ͼ���ļ���

rawimage=rgb2gray(imread(fileSource));       % ԭʼͼ��
manualImage=rgb2gray(imread(fileModified));  % �ֹ����ͼ��
DiffImage=(manualImage-rawimage);            % ԭʼͼ�����ֹ���ǵĲ��ͼ��

% ͨ��ͼ��֮���ʶ����������
[labImage]=geneStdDisImage(DiffImage,winSize,thresh);


