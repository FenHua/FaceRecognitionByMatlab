% 2017-5-28 �޼�ѫ
% ����ֵ�ָ�
%
% ���ͼ��������ֵ����Thresh������Ϊʱ���ߣ�������Ϊ�Ƿǲ���
% ����ThreshSegementʵ��
% 
% ���룺
% image     ������ֵ�ָ��ͼ��
% thresh    ��ֵ��>=1��
% bias      �ָ��ƫ�ã�Ĭ��Ϊ1
%           bias=+1  ������ֵΪ1��С����ֵΪ0
%           bias=-1  ������ֵΪ0��С����ֵΪ1
% bgImage   ����ͼ��image�ϱ�ʶΪĿ������򱻱���������ʶΪ��������ɾ��
%           Ĭ��Ϊ������ֵ�ָ��ͼ�񣬼�image
% 
% �����
% labBinaryImage ��ʶ����ͼ��,��ֵͼ��,cellԪ��
% labSrcImage    �ڱ���ͼ��������ǣ���ʶ��������,cellԪ��
% 
% labBinaryImage��labSrcImage��Ϊcell
% ÿһ����ֵ��Ӧһ����
% ��ʱ,length(thresh)=length(labBinaryImage)=length(labSrcImage)
% 
% [labBinaryImage,labSrcImage]=MultiThreshSegement(image,thresh);
% [labBinaryImage,labSrcImage]=MultiThreshSegement(image,thresh,bias);
% [labBinaryImage,labSrcImage]=MultiThreshSegement(image,thresh,bias,bgimage);
% 
% 
function [labBinaryImage,labSrcImage]=MultiThreshSegement(image,thresh,varargin)
narginchk(2,4);  % ��������������
validateattributes(image,{'numeric'},{'2d','real','nonsparse'}, mfilename,'image',1);
validateattributes(thresh,{'numeric'},{'row','nonempty','real'},mfilename, 'thresh',2);

bias=1;              % ƫ�ã�Ĭ��Ϊ1
if(nargin>2)         % ָ��ƫ��
    bias=varargin{1};  
end
if(bias~=1)          % ƫ��ֻ����ȡֵ1��-1
    bias=-1;
end
image=double(image); % ����ת�� 
validateattributes(bias,{'numeric'},{'row','nonempty','integer'},mfilename, 'bias',3);

if(nargin>3)        % ��ʾ�ı���ͼ��
    bgImage=varargin{2}; 
else
    bgImage=image;  % Ĭ��Ϊ������ֵ�ָ��ͼ��image
end
validateattributes(bgImage,{'numeric'},{'real','nonsparse'}, mfilename,'bgImage',4);

% �ö����ֵ�ָ����һϵ�б��ͼ��
ThreshNO=length(thresh);          % ��ֵ����  
labBinaryImage=cell(1,ThreshNO);  % �ڶ�ֵͼ���ϱ�ʶ��������,cell
labSrcImage=cell(1,ThreshNO);     % ��ԭʼͼ���ϱ�ʶ��������,cell


for curThreshNO=1:length(thresh)  % һ����ֵ��Ӧ�������ͼ��
    [curlabBinaryImage,curlabSrcImage]=ThreshSegement(image,thresh(curThreshNO),bias,bgImage);
    
    labBinaryImage{curThreshNO}=curlabBinaryImage;
    labSrcImage{curThreshNO}=curlabSrcImage;
end







