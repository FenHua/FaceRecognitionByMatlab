% 2017-5-28�޼�ѫ
% ��ͨ��������ʵ��ͼ��ָ�
% MoveWindowing
% 
% �������:
% image               ����ͼ��
% MVParameters        �������ڷ����Ĳ�����������
% ::WindowingPatchSize  ����ʱ�Ĵ��ڴ�С����
% ::xynum               ���ڻ��������н�ͼ�񻮷ֵĸ���
% 
% WinParameters       ��ͼ�񴰿ڽ����б��ѧϰ�㷨�Ĳ���
%                       ��ͬ��ѧϰ�㷨�в�ͬ�Ĳ��������� AdaBoost �������²��� 
% ::Method              ImageBlockRecogByAdaBoost��ָ�� AdaBoost ѧϰ�㷨��ͼ�������б�   
% ::Hypothesis          T������������ AdaBoost �㷨ѵ����õ�ǿѧϰ��
% ::AlphaT              ������������Ȩ��
% ::thresh              ��������������ֵ��Ĭ��Ϊ0.5
% 
% WinParameters         ֻ������Ĳ����Ǳ���ָ���ģ�
% ::Method              ��ͼ�񴰿ڽ����б��ѧϰ�㷨����
% ����������ѧϰ�㷨����
% 
% ���磬���� ImageBlockRecognizedByAdaBoost �Դ����б�ʱ������Ӧ���룺 
% MVParameters.WindowingPatchSize=[60 80]; ����ʱ�Ĵ��ڴ�С����
% MVParameters.xnum=30;                    ˮƽ�����Ͻ�ͼ�񻮷ֵĸ��� 
% MVParameters.ynum=30;                    ��ֱ�����Ͻ�ͼ�񻮷ֵĸ��� 
% 
% WindowParameters.Method=@ImageBlockRecognizedByAdaBoost;
% WindowParameters.Hypothesis=AreaHypothesis;
% WindowParameters.AlphaT=AreaAlphaT;
% WindowParameters.thresh=0.5;
% 
% 
% ����:
% detectWindow          ���Ϊ�����Ĵ�����Ϣ
%                       ���ʽΪ[i j WinSize]����[������ ������ ���ڴ�С]
% detectImage           ���ͼ����ԭʼͼ���ϱ�ʶ���������ڵ�ͼ��
% pixFreImage           �����ڴ����г��ִ�����Ƶ��ͼ�� 
% 
% ���ã�
% [detectWindow,detectImage,pixFreImage]=
%               MoveWindowing(image,MVParameters,WindowParameters)
% 

function [detectWindow,detectImage,pixFreImage]=MoveWindowing(image,MVParameters,WindowParameters)
narginchk(3,3);  % ��������������
validateattributes(image,{'numeric'},{'real','nonsparse'}, mfilename,'image',1);

WindowingPatchSize=MVParameters.WindowingPatchSize; % ����ʱ�Ĵ��ڴ�С����
xnum=MVParameters.xnum;                % ���ڻ��������д�ֱ������ͼ�񻮷ֵĸ��� 
ynum=MVParameters.ynum;                % ���ڻ���������ˮƽ������ͼ�񻮷ֵĸ��� 
validateattributes(WindowingPatchSize,{'numeric'},{'row','integer'}, mfilename,'WindowingPatchSize',2);
validateattributes(xnum,{'numeric'},{'row','real','integer'}, mfilename,'xynum',2);
validateattributes(ynum,{'numeric'},{'row','real','integer'}, mfilename,'xynum',2);

[xSize,ySize]=size(image); %�����ǻҶ�ͼ��
%image=rgb2gray(image);

%imageSize=[xSize,ySize];
disp('��������ʶ��...');

xstep=ceil(xSize/xnum);        % ��ֱ�����ƶ��ߴ�
ystep=ceil(ySize/ynum);        % ˮƽ�����ƶ��ߴ�
detectWindow=[];               % ��������������Ϣ

MWCounter=1;
for i=1:xstep:xSize            % ��ٷ���������
    for j=1:ystep:ySize
        detectWindow1=[];  
        disp(MWCounter);
        MWCounter=MWCounter+1; % ���ڼ��������� 
        for k=1:length(WindowingPatchSize) % �ı䴰�ڴ�С����
            xx=i+WindowingPatchSize(k)-1;  % �����ұ�Ե
            yy=j+WindowingPatchSize(k)-1;  % �����±�Ե
            if(xx>xSize||yy>ySize)         % ����Խ�߽�    
                break;
            end
            windata=image(i:xx,j:yy);    % ��������   
            % ����ָ����ѧϰ�㷨���Ըô����Ƿ�Ϊ��������
            [output]=feval(WindowParameters.Method,windata,WindowParameters); 
            
            if(output==1)     % ��������Ϊ����������
                tempWinInfo=[i j WindowingPatchSize(k)];% ����������Ϣ
                detectWindow1=[detectWindow1;tempWinInfo];% ������������
            end
        end
        size(detectWindow1,1)
        %detectWindow1=detectWindow1
        detectWindow=[detectWindow;detectWindow1];% ������������
        
    end
end


if(nargin>1)   % �����ʶ���������ڵ�ͼ��
    detectImage=LabelDetectWindow(image,detectWindow);
end

if(nargin>2)  %  ��������ڴ����г��ִ�����Ƶ��ͼ��    
    pixFreImage=CalPixelFrequencyInWindow(size(image),detectWindow,1);
end
