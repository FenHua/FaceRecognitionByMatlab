% 2017-5-28�޼�ѫ
% �Ա��ͼ�������ֵ�ָ�
%
% ���ͼ��������ֵ����Thresh������Ϊʱ���ߣ�������Ϊ�Ƿǲ���
% 
% ���룺
% image     ������ֵ�ָ��ͼ��
% thresh    �ָ����ֵ
% bias      �ָ��ƫ�ã�Ĭ��Ϊ1
%           bias=+1  ������ֵΪ1��С����ֵΪ0
%           bias=-1  ������ֵΪ0��С����ֵΪ1
% bgImage   ����ͼ��image�ϱ�ʶΪĿ������򱻱���������ʶΪ��������ɾ��
%           Ĭ��Ϊ������ֵ�ָ��ͼ�񣬼�image
% 
% �����
% labBinaryImage ��ʶ����ͼ�񡢶�ֵͼ��
% labSrcImage    �ڱ���ͼ��������ǣ���ʶ��������
% 
% [labBinaryImage,labSrcImage]=ThreshSegement(image,thresh);
% [labBinaryImage,labSrcImage]=ThreshSegement(image,thresh,bias);
% [labBinaryImage,labSrcImage]=ThreshSegement(image,thresh,bias,bgimage);
% 
% 
function [labBinaryImage,labSrcImage]=ThreshSegement(image,thresh,varargin)
narginchk(2,4);  % ��������������
validateattributes(image,{'numeric'},{'2d','real','nonsparse'}, mfilename,'image',1);
validateattributes(thresh,{'numeric'},{'row','nonempty','real'},mfilename, 'thresh',2);
thresh=thresh(1);    % ֻȡ��һ����ֵ
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
    if( (size(bgImage,1)~=size(image,1))||(size(bgImage,2)~=size(image,2)) )
        error('����ͼ���С����ָ�ͼ����ȫһ�¡�');
    end
else
    bgImage=image;  % Ĭ��Ϊ������ֵ�ָ��ͼ��image
end
validateattributes(bgImage,{'numeric'},{'real','nonsparse'}, mfilename,'bgImage',4);


% ��ֵ�ָ�����������ͼ��
labBinaryImage=zeros(size(image));  % �ڶ�ֵͼ���ϱ�ʶ��������

labBinaryImage(find(bias*image>=bias*thresh))=1;


if ( nargout>1 )                   % �������ͼ���ϱ�ʶ��������
    for cur=1:size(bgImage,3)      % ��ÿ��ƽ������б��
        curLabSrcImage=bgImage(:,:,cur); 
        curLabSrcImage(find(bias*image<bias*thresh))=0;
        labSrcImage(:,:,cur)=curLabSrcImage;
    end
end







