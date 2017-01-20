function [ct] = how_many ( prefix, x, ct_f )

% init ctr
ct = zeros ( 1, numel ( ct_f ) );

% for all frames to count
for i = 1:numel(ct_f)
    
    % read image and convert to gray
    fileName = sprintf('%s%05d.png', prefix, ct_f(i));
    input_im = rgb2gray ( imread(fileName) );
    
    % compute diff from mean image
    diff_im = uint8(abs(int16 ( input_im ) - int16 ( x.mean_im )));
    
    % threshold on some threshold trained
    t = 73;
    t_im = diff_im > t;
    
    % divide by some random value 
    %ct(i) = floor(sum(t_im(:)) / 500);
    
    A=t_im; %Initializes the matrix A with zeros (black)
    
    %finds the position of a non-zero (white) in the matrix
    posA=find(A==1);
    %place 1 in the non-zero element
    posA=posA(1);
    
    %zeros() creates an array filled with zeros
    %size(#,#) indicates size of each dimension
    l=zeros([size(A,1) size(A,2)]); %produces an A by 1 and A by 2 vector of zeros
    
    Z=0;
    %while posA is empty, counter each component by 1
    while(~isempty(posA))
        Z=Z+1;%Label for each component
        posA=posA(1);
    %initialize matrix X with zeros
    X=false([size(A,1) size(A,2)]);
    %place 1 in non-zero element 
    X(posA)=1;
    
    %creates a square structuring element whose width is 40 pixels
    %strel()--used to create a flat structuring element for grayscale
    S=strel('square',39);
    
    %dilates the strel image on matrix X
    %dilates-stretches and blends the pixels
    %dilation adds pixels to the object's boundaries
    Y=A&imdilate(X,S);

        %checks whether y=x. If not then x=y and redos the dilation process
        while(~isequal(X,Y))
            X=Y;
            Y=A&imdilate(X,S);
        end
        
    %Find the non-zero elements position in the Y
    Pos=find(Y==1);

    %place zero in those positions in matrix A.
    A(Pos)=0;
    
    %label the components
    %in matrix Label place a number Z in those positions
    %Label(Pos)=Z; %Z labels the connected components

    posA=find(A==1);
    end %end of first while loop
    
    %sets an array of zeros
    %Im=zeros([size(A,1) size(A,2)]);
    
    %finds the positions in the matrix with 1
    %F=find(Label==1);
    %Im(F)=1;
    %figure,imshow(Im);
    
    %F=find(Label==2|Label==3|Label==6|Label==7|Label==9);
    %Im1=zeros([size(A,1) size(A,2)]);
    %Im1(F)=1;
    %figure,imshow(Im1);
    
    %sprintf() formats the data into a string
    %totalstr=sprintf('totalstr:%d',Z);
    %display(totalstr);
    %total=str2num(totalstr);
    %display(Z);
    
    ct(i) = Z;
    
end
