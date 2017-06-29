%2017-5-23�޼�ѫ
%ͳ�Ƹ������ڼ�ⴰ���ڳ��ֵ�Ƶ��
% ����ת���ɻҶ�ͼ��
% CalPixelFrequencyInWindow
% 
% �ڴ��ڷָ�ϵ���㷨(Windowing)��ͨ��
%
% �������ݣ�
% StimSize            ԭʼ��RGBͼ��Ĵ�С
% detectWindow        ���Ϊ���ߵĴ�����Ϣ
%                     ���ʽΪ[i j k]����[������ ������ ���ڴ�С]
% isMat2Gray          �Ƿ�Ƶ�ʾ���ת��Ϊ�Ҷ�ͼ��ı�־
%
% �����
% pixFreImage         ��Ƶ�ʾ���ת��Ϊ�Ҷ�ͼ��
%
% 
function [pixFreImage]=CalPixelFrequencyInWindow(StimSize,detectWindow,varargin)
narginchk(2,3);   % ��������������
iptcheckinput(StimSize,{'numeric'},{'row','nonempty','integer'},mfilename, 'StimSize',1);
iptcheckinput(detectWindow,{'numeric'},{'2d','real','nonsparse'}, mfilename,'detectWindow',2);

isMat2Gray=0;  % �Ƿ�Ƶ�ʾ���ת��Ϊ�Ҷ�ͼ��ı�־��Ĭ�ϲ�ת��
if(nargin>2)   % ָ���ñ�־
    isMat2Gray=varargin{1};
end

winCnt=size(detectWindow,1);         % ��������
xSize=StimSize(1);                   % ԭʼ��RGBͼ��Ŀ��
ySize=StimSize(2);                   % ԭʼ��RGBͼ��ĸ߶�
pixFreImage=zeros(xSize,ySize);      % �����ڴ����г��ֵ�Ƶ�ʾ���

counter=1;
while(counter<=winCnt)
         i=detectWindow(counter,1);  % ���ߴ��� ������            
         j=detectWindow(counter,2);  % ���ߴ��� ������
         winSize=detectWindow(counter,3);% ���ߴ��� ��С
         
         topMost=i;                  % �����ϱ�Ե
         botMost=i+winSize-1;        % �����±�Ե
         lefMost=j;                  % �������Ե
         rigMost=j+winSize-1;        % �����ұ�Ե

         % �������صı��ֵ��1
         pixFreImage(topMost:botMost,lefMost:rigMost)=pixFreImage(topMost:botMost,lefMost:rigMost)+1;  
         counter=counter+1;
end

if(isMat2Gray) % Ƶ�ʾ���ת��Ϊ�Ҷ�ͼ��         
    pixFreImage=mat2gray(pixFreImage);               
end
