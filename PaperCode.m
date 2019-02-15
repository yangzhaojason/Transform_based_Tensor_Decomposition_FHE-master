%��������Ͻ׶�
%���ǵ�ʵ��������video���й�Aerial data���������ݣ�����֪����sensory data ��Intelligent building��Intelligent Transportation case��
%�漰ȫ̬ͬ�ӽ���ʵ�� 
%�������Ҫ��linux���������ú�HElib�⣬Ȼ�����Test_General�Ĵ���

%�漰�Ļ�������
obj = VideoReader('Aerial_data.mp4');
numFrames = obj.NumberOfFrames;% ֡������ 7495
n=3; %��������Լ��趨
D=ones(110,128,n);%����һ���յ���ά����
i=1;
array=[]; %��������������Ϊ�˼�¼��ȡ��֡��ֵ
for k = 500 : 2500 : numFrames% ���ֽس�����֡��������n����һ�¾��� 500 : 2500 1:49
     array(i)=k; 
     frame = read(obj,k);%��ȡ�ڼ�֡
     %ÿ��һ�Ű���ת���ɻҶ�ͼƬ
     A=rgb2gray(frame); 
     J=imresize(A,[110,128]);
     A1=double(J);
     D(:,:,i)=A1;
     i=i+1;
     %figure(k);
     %imshow(A);
     %-----------
     %figure(k);
     %imshow(frame);%��ʾ֡
     %imwrite(J,strcat('/Users/apple/Desktop/1/',num2str(k),'.jpg'),'jpg');% ����֡
end
%display(array);
B1=[D(:,:,2);D(:,:,3);D(:,:,1)];
%imshow(uint8(B1));
%���ļ��ж�ȡ����ѡ�����Ƭ---��ȡ��Ƭ��һ��------- ������һ����Ƭ
% [filename, pathname] = uigetfile('*.jpg', '��ȡͼƬ�ļ�'); %ѡ��ͼƬ�ļ�
% if isequal(filename,0)   %�ж��Ƿ�ѡ��
%    msgbox('û��ѡ���κ�ͼƬ');
% else
%    pathfile=fullfile(pathname, filename);  %���ͼƬ·��
%    M=imread(pathfile);     %��ͼƬ�������
%    %imshow(M);    %����ͼƬ
% end
%ѭ������һ���ļ������е���Ƭ-----��ȡ��Ƭ������------- M��������е�������Ƶ��������Ƭ
% fileform = '/Users/apple/Desktop/1/*.jpg';
% filepathsrc = '/Users/apple/Desktop/1/';
% file = dir(fileform); %�������ָ���ļ����µ��������ļ��к��ļ����������һ��Ϊ�ļ��ṹ��������
% M=[];
% for i = 1:length(file)
%         m = imread([filepathsrc, file(i).name]);
%         M = [M;m];
% end
%----------------------------------------------------------------------------
%T-SVD�ֽ�
x_hat=fft(D,[],3);
for i=1:size(D,n)
    [U1,S1,V1]=svd(x_hat(:,:,i));
    if i==1
        D1=ones(size(U1,1),size(U1,2),size(D,3));
        D2=ones(size(S1,1),size(S1,2),size(D,3));
        D3=ones(size(V1,1),size(V1,2),size(D,3));
    end
    D1(:,:,i) = U1;
    D2(:,:,i) = S1;
    D3(:,:,i) = V1;
end
U=ifft(D1,[],3);
S=ifft(D2,[],3);
V=ifft(D3,[],3);   
%����compression degree(Dimensionality Reduction Ratio)
%---����ƽ��̶ȣ���άʵ�飩
    %ѡȡǰ��__����������ֵ  ԭʼ110*128
    for n1 = 1:5  %��1��
        for n2 = 1:5 %��2��
            for n3=1:3
            S_1(n1,n2,n3) = S(n1,n2,n3);  
            end
        end  
    end 
    %����������
    for n1 = 1:110  
        for n2 = 1:5  %��3��
            for n3 = 1:3
            U_1(n1,n2,n3) = U(n1,n2,n3);  
            end
        end  
    end  
    %����������
    for n1 = 1:128
        for n2 = 1:5 %��4��
            for n3= 1:3
            V_1(n1,n2,n3) = V(n1,n2,n3);  
            end
        end  
    end  
   %����������product??New Tensor Multiplication
   %display(size(S_1));
    c = t_product(U_1,S_1); %c��������Ǹ�tensor
    % V_1��ת��
    h2 = ones(5,128,3); %��5��-1λ��
    for j=1:size(D,n)
        h2(:,:,j)=V_1(:,:,j)'; %110*126*3
    end
    for k=2:size(D,n)
        t1=h2(:,:,k);
        h2(:,:,k)=h2(:,:,2+2-k);
        h2(:,:,2+2-k)=t1;
    end
   c = t_product(c,h2);
   result=[c(:,:,1);c(:,:,2);c(:,:,3)];
   %imshow(uint8(result));
   %---------
    %��������
    T_error=result-B1;
    display(T_error);
    %�����ع������
    n = norm(T_error, 'fro' );
    %display(n);
    %ԭʼ��������Frobenius����
    n_B=norm(B1,'fro');
    %Tensor Approximation Ratio(reconstruction error degree)
    e=n/n_B; 
    display(e);
    RES=20*log10(e);
    display(RES);
    p = size(D,1)*size(D,2)*size(D,3)/(n2*(size(D,1)+size(D,2)+1));
    display(1/p);
%-------------------------------------
%�漰��traditional svd��tSVD-slice�ֽ�ıȽ�
    %traditional svd method
    addpath /Users/apple/Downloads/tensor_toolbox 
    obj = VideoReader('Aerial_data.mp4');
    numFrames = obj.NumberOfFrames;% 7495
    D=ones(110,128,3); %����һ���յ���ά����
    i=1;
    for k = 500 : 2500 : numFrames
         frame = read(obj,k);%��ȡ�ڼ�֡
         %ÿ��һ�Ű���ת���ɻҶ�ͼƬ
         A=rgb2gray(frame); 
         J=imresize(A,[110,128]);
         A1=double(J);
         D(:,:,i)=A1;
         i=i+1;
    end
    A=tensor(D);
    tic
    A1=tenmat(A,1);  %����mode-1չ���ɾ��� n1*(n2*n3)
    %A1=A1';
    [U,S,V]=svd(A1.data); 
    %toc
    %ѡȡǰ��__����������ֵ��������
    %tic
    U1=U(:,1:53); %(1)�޸�
    S1=S(1:53,1:53); %(2)�޸�
    V1=V(:,1:53); %(3)�޸�
    AA=U1*S1'*V1';
    toc
    A1=double(A1);  
    SVD_Error = AA-A1;
    n_svd = norm(SVD_Error, 'fro' );
    n_B_svd = norm(A1,'fro');
    e_svd = n_svd/n_B_svd; 
    display(e_svd);
    RES_svd=20*log10(e_svd);
    display(RES_svd);
    %--------------------
    %tSVD-tubal method
    obj = VideoReader('Aerial_data.mp4');
    numFrames = obj.NumberOfFrames;
    n=3;
    D=ones(110,128,n);%����һ���յ���ά����
    i=1;
    for k = 500 : 2500 : numFrames
         frame = read(obj,k);%��ȡ�ڼ�֡
         A=rgb2gray(frame); 
         J=imresize(A,[110,128]);
         A1=double(J);
         D(:,:,i)=A1;
         i=i+1;
    end
    tic %��fftƵ��仯  t-product�㷨
     for i=1:size(D,n)
        [U1,S1,V1]=svd(D(:,:,i));
        if i==1
            D1=ones(size(U1,1),size(U1,2),size(D,n));
            D2=ones(size(S1,1),size(S1,2),size(D,n));
            D3=ones(size(V1,1),size(V1,2),size(D,n));
        end
        D1(:,:,i) = U1;
        D2(:,:,i) = S1;
        D3(:,:,i) = V1;
     end
     %ʵ�н�ά����
     for n1 = 1:35 %��1��
        for n2 = 1:35 %��2��
            for n3=1:3
            S_1(n1,n2,n3) = D2(n1,n2,n3);  
            end
        end  
    end 
    %����������
    for n1 = 1:110  
        for n2 = 1:35 %��3��
            for n3 = 1:3
            U_1(n1,n2,n3) = D1(n1,n2,n3); 
            end
        end  
    end  
    %����������
    for n1 = 1:128
        for n2 = 1:35 %��4��
            for n3=1:3
            V_1(n1,n2,n3) = D3(n1,n2,n3);
            end
        end  
    end  
%     %����˷�
    for m = 1:1:3
        mid(:,:,m) = U_1(:,:,m)*S_1(:,:,m);
    end
    for n=1:1:3
        result1(:,:,n)= mid(:,:,n)*V_1(:,:,n)';
    end
    toc
    %new tensor product
%     c = t_product(U_1,S_1); %c��������Ǹ�tensor
%     % V_1��ת��
%     h2 = ones(35,128,3); %��5��-1λ��
%     for j=1:size(D,n)
%         h2(:,:,j)=V_1(:,:,j)'; %110*126*3
%     end
%     for k=2:size(D,n)
%         t1=h2(:,:,k);
%         h2(:,:,k)=h2(:,:,2+2-k);
%         h2(:,:,2+2-k)=t1;
%     end
%    c = t_product(c,h2);
%    result=[c(:,:,1);c(:,:,2);c(:,:,3)];
    %-------����ĳ���----------
    B1=[D(:,:,2);D(:,:,3);D(:,:,1)];
    %imshow(uint8(B1));
    %imshow(uint8(D));
    result=[result1(:,:,2);result1(:,:,3);result1(:,:,1)];
    %imshow(uint8(result));
    %��������
    T_error=result-B1;
    %display(T_error);
    %�����ع������
    n = norm(T_error, 'fro' );
    n_B=norm(B1,'fro');
    e=n/n_B; 
    display(e);
    RES=20*log10(e);
    display(RES);
%----------------------------------------------
%�漰��������ʱ��running time compare traditional svd
    %traditional svd time
    addpath /Users/apple/Downloads/tensor_toolbox 
    obj = VideoReader('Aerial_data.mp4');
    numFrames = obj.NumberOfFrames; 
    D=ones(100,200,30);%����һ���յ���ά���� %��һ��Ҫ�޸ĵĵط�
    i=1;
    for k = 500 : 2500 : numFrames%
         frame = read(obj,k);%��ȡ�ڼ�֡
         %ÿ��һ�Ű���ת���ɻҶ�ͼƬ
         A=rgb2gray(frame); 
         J=imresize(A,[100,200]); %�ڶ���Ҫ�޸ĵĵط�
         A1=double(J);
         D(:,:,i)=A1;
         i=i+1;
    end
    A=tensor(D);
    tic
    A1=tenmat(A,1);  
    [U,S,V]=svd(A1.data); 
    toc  %[1,2,3]:0.016323  [10,20,3]:0.026745 [10,20,30]:0.027036  [10,200,30]:0.701844 [100,200,30]:5.219157  [100,200,300]Error using svd
    %Requested 60000x60000 (26.8GB) array exceeds maximum array size preference. Creation of arrays greater than
    %this limit may take a long time and cause MATLAB to become unresponsive. See array size limit or preference
    %panel for more information.
    %S-tSVD
    obj = VideoReader('Aerial_data.mp4');
    numFrames = obj.NumberOfFrames;% 9243 
    D=ones(10,200,30);%����һ���յ���ά����
    i=1;
    for k = 1 : 309: numFrames% 3081 309 31
         frame = read(obj,k);%��ȡ�ڼ�֡
         %ÿ��һ�Ű���ת���ɻҶ�ͼƬ
         A=rgb2gray(frame); 
         J=imresize(A,[10,200]);
         A1=double(J);
         D(:,:,i)=A1;
         i=i+1;
    end
    x_hat=fft(D,[],3); %����ѭ��������Ա�����Ҷ�任����Խǻ�
    tic
    for i=1:size(D,3)
        [U1,S1,V1]=svd(x_hat(:,:,i));
        if i==1
            D1=ones(size(U1,1),size(U1,2),size(D,3));
            D2=ones(size(S1,1),size(S1,2),size(D,3));
            D3=ones(size(V1,1),size(V1,2),size(D,3));
        end
        D1(:,:,i) = U1;
        D2(:,:,i) = S1;
        D3(:,:,i) = V1;
    end
    toc %[1,2,3]:0.010292 [10,20,3]:0.010729 [10,20,30]:0.015893 [100,200,30]:0.353426 [100,200,300]:1.760767 [1000,2000,3000]:22.595927
    U=ifft(D1,[],3);
    S=ifft(D2,[],3);
    V=ifft(D3,[],3);
%------------------------------------------
%�漰��������ֽ�֮��������ؾ�������ֵ
    max_S2=max(max(S(:,:,2)));
    display(max_S2);
    min_S22=min(min(S(:,:,2)));
    display(min_S22);
    %S����������k����ÿһ����Ƭ����Ϣ
    a1=1:1:50;
    b1=1:1:50;
    [x1,y1]=meshgrid(a1,b1);
    M_S001=ones(50,50); %110*128
    %display(S(1,1,1));
    for j=1:50
        for k=1:50
        M_S001(k,j)=S(k,j,21);
        end
    end
    p001=mesh(x1,y1,M_S001);
    c=mean(M_S001(:)); %ȫ��ƽ��
    display(c)
    title('S(:,:,21)')
    %S������k����������Ƭ��Ϣ
     T_S2=S(:,2,:);
     display(T_S2); %110*1*155
     M_S2=ones(110,155);
    %  for i=1:155
    %       M_S2(:,i)=T_S2(:,:,i); %110��1��
    %  end
     for i=1:110
         for j=1:155
             M_S2(i,j)=T_S2(i,1,j);
         end
     end
     c2=mean(M_S2(:)); %ȫ��ƽ��
     display(c2); 
     p2=mesh(x,y,M_S2);
     title('S(:,2,:)');
     
     %S������j����������Ƭ��Ϣ
     S_matrix1=S(:,1,:);
     S_matrix2=S(:,2,:);
     S_matrix3=S(:,3,:);
     S_matrix4=S(:,4,:);
     S_vactor1=S_matrix1(:); %42240*1
     S_vactor2=S_matrix2(:);
     S_vactor3=S_matrix3(:);
     S_vactor4=S_matrix4(:);
     I_index_number1=find(S_vactor1~=0); %..*1
     I_index_number2=find(S_vactor2~=0);
     I_index_number3=find(S_vactor3~=0);
     I_index_number4=find(S_vactor4~=0);
     x=1:155;
     plot(x,S_vactor1(I_index_number1,1),'.-r','MarkerSize',10);
     hold on
     plot(x,S_vactor2(I_index_number2,1),'.-b','MarkerSize',10);
     hold on
     plot(x,S_vactor3(I_index_number3,1),'.-k','MarkerSize',10);
     hold on
     plot(x,S_vactor4(I_index_number4,1),'.-g','MarkerSize',10);
     xlabel('Experiment');
     ylabel('Singular Value');
     %set(gca,'xTick',1:160);
     legend('Slice one','Slice two','Slice three','Slice four');

