% 2017-5-17�޼�ѫ
% ��ȡHarr-like���� 
% II           ����ͼ��
% HarrLike     Harrģ��
% baseSize     ��׼�ĳߴ��С 
% 
function FeatureVector=extHarrLikeFeature(II,HarrLike,baseSize)
imgWidth=size(II,2);     % ���ڿ��
imgHeight=size(II,1);    % ���ڸ߶�
wdiv=1;                  % ������ һ�����ص�Ϊһ��
hdiv=1;                  % ������ һ�����ص�Ϊһ��
FeatureVector=[];
Feature=[];
delta=1;    %һ��Ϊ1
for harrCnt=1:length(HarrLike)% ��ǰ��ȡ��Harr-like��ʽ
    s=size(HarrLike{harrCnt},1);
    t=size(HarrLike{harrCnt},2);
    R = s:s:floor(imgHeight/s)*s;           % Haar���ڸ�
    C = t:t:floor(imgWidth/t)*t;            % Haar���ڿ�
    NUM = 0;                                % Haar��������
    for I = 1:length(R)
        for J = 1:length(C)
            r = R(I)*hdiv;                     % Haar���ڸ�
            c = C(J)*wdiv;                     % Haar���ڿ�
            nr = imgHeight-r;               % �з����ƶ�����
            nc = imgWidth-c;                % �з����ƶ�����
            for x=1:nc                         % �ڼ���
                for  y=1:nr                    % �ڼ���
                    if (harrCnt==1)
                        white = II(y,x)+II(y+r,x+c/2)-II(y+r,x)-II(y,x+c/2);
                        black = II(y,x+c/2)+II(y+r,x+c)-II(y+r,x+c/2)-II(y,x+c);
                    end   
                    if (harrCnt==2)
                        white = II(y,x)+II(y+r/2,x+c)-II(y,x+c)-II(y+r/2,x);
                        black = II(y+r/2,x)+II(y+r,x+c)-II(y+r/2,x+c)-II(y+r,x);
                    end  
                    if (harrCnt==3)
                        white = II(y+r,x+c/3)+II(y,x)-II(y,x+c/3)-II(y+r,x)+...
                            II(y+r,x+c)+II(y,x+2*c/3)-II(y,x+c)-II(y+r,x+2*c/3);
                        black =2*(II(y+r,x+2*c/3)+II(y,x+c/3)-II(y,x+2*c/3)-II(y+r,x+c/3));
                    end  
                    if (harrCnt==4)
                        white = II(y+r/3,x+c)+II(y,x)-II(y+r/3,x)-II(y,x+c)+...
                            II(y+r,x+c)+II(y+2*r/3,x)-II(y+2*r/3,x+c)-II(y+r,x);
                        black = 2*(II(y+2*r/3,x+c)+II(y+r/3,x)-II(y+r/3,x+c)-II(y+2*r/3,x));
                    end 
                    if (harrCnt==5)
                        white = II(y+r/2,x+c/2)+II(y,x)-II(y+r/2,x)-II(y,x+c/2)...
                            +II(y+r,x+c)+II(y+r/2,x+c/2)-II(y+r/2,x+c)-II(y+r,x+c/2);
                        black = II(y+r,x+c/2)+II(y+r/2,x)-II(y+r/2,x+c/2)-II(y+r,x)...
                            +II(y+r/2,x+c)+II(y,x+c/2)-II(y,x+c)-II(y+r/2,x+c/2);
                    end 
                    Feature=white-black;
                    FeatureVector=[FeatureVector;Feature];
                    NUM = NUM+1;   
                end
            end
        end 
    end 
end 
         

end 

    
    
    
