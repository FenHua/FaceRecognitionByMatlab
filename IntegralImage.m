% 2017-5-17 �޼�ѫ
% ��ԭʼ����ͼ��Ļ���ͼ��
% ����ͼ���һ�к͵�һ��ֵ��Ϊ0
% �����������ȡ��������ֵ
function [II]=IntegralImage(srcImage)
srcImage=double(srcImage);
imgWidth=size(srcImage,1);
imgHeight=size(srcImage,2);
II=zeros(imgWidth+1,imgHeight+1);
for i=1:imgWidth
    for j=1:imgHeight
        if i==1 && j==1             %����ͼ�����Ͻ�
            II(i,j)=srcImage(i,j);
        elseif i==1 && j~=1         %����ͼ���һ��
            II(i,j)=II(i,j-1)+srcImage(i,j);
        elseif i~=1 && j==1         %����ͼ���һ��
            II(i,j)=II(i-1,j)+srcImage(i,j);
        else                        %����ͼ����������
            II(i,j)=srcImage(i,j)+II(i-1,j)+II(i,j-1)-II(i-1,j-1);  
        end
    end
end

end 

