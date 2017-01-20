function [x] = train_how_many ( prefix, f0, f1, gt_ct )


% constant for mean image
c = 1.0 / single(floor((f1-f0+1)/2));


for i = f0:2:f1

    % read image and convert to gray
    fileName = sprintf('%s%05d.png', prefix, i );
    input_im = rgb2gray ( imread(fileName) );
    
    
    % update mean image
    if ( i == f0 )
        x.mean_im = c * single(input_im);
        
    else
        x.mean_im = x.mean_im + c * single(input_im);
    end

end

% convert to uint8 for future usage
x.mean_im = uint8 ( x.mean_im );