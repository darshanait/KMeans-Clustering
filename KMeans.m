clear all
close all


%  Read a 3 Dimensional Matrix
% I(:,:,1)=[10,20,30,40,10;20,20,30,10,40;40,15,23,29,32];
% I(:,:,2)=[50,70,89,73,55;78,120,212,243,140;145,131,203,89,132];
% I(:,:,3)=[150,46,89,223,135;178,220,112,43,240;245,31,163,119,159];

% I = imread('E:\Disguise Programs\cropped\153.jpg');
close all
I = imread('E:\Disguise Programs\Fuzz Logic\Tumor1.jpg');
I=imresize(I,[256 256]);
org=I;
figure;imshow(I);
I=rgb2hsv(I);
I=double(I);
figure;imshow(I);
noofClusters=6;


% get the initial x and y coordinate value

X=randi(256,1,noofClusters);
Y=randi(256,1,noofClusters);


% Initialize the center values 
oldCenter=zeros([noofClusters,3]);
newCenter=zeros([noofClusters,3]);
for i=1:noofClusters
    
    oldCenter(i,:)=I(X(i),Y(i),:);
end

cluster=zeros([256 256 noofClusters]);

GT=1.0;
LT1=0.5;
LT2=0.5;

Error=zeros([1 2]);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
t1=2;
t2=2;
it=1;
 while t1>LT1 & t2>0.0
               
    for j=1:noofClusters
        cluster(:,:,j)=sqrt((I(:,:,1)-oldCenter(j,1)).^2+(I(:,:,2)-oldCenter(j,2)).^2+(I(:,:,3)-oldCenter(j,3)).^2);
    end
    
    
    
    [Y,clustNo]=min(cluster,[],3);
    
    for j=1:noofClusters
        newCenter(j,1)=mean(R(clustNo(:)==j))
        newCenter(j,2)=mean(G(clustNo(:)==j))
        newCenter(j,3)=mean(B(clustNo(:)==j))
    end
    
    
    for j=1:noofClusters
        Error(:,j)=sqrt(sum((oldCenter(j,:)-newCenter(j,:)).^2));
    end
    
    
    if Error(1)<LT1
        t1=t1-0.001;
    else
        oldCenter(1,:)=newCenter(1,:);
    end
    if Error(2)<LT2
        t2=0;
    else
        oldCenter(2,:)=newCenter(2,:);
    end
    
    
   it=it+1; 
end


cls=[1:noofClusters]
for t=1:noofClusters
	seg=zeros(256,256,3);
	for i=1:256
		for j=1:256
			if clustNo(i,j)==cls(1,t)
						seg(i,j,1)=org(i,j,1);
						seg(i,j,2)=org(i,j,2);
						seg(i,j,3)=org(i,j,3);
			end
		
		end
	end
	figure,imshow(uint8(seg)),title(string(t));   % Output w.r.t cluster number
end









figure;imagesc(clustNo);

