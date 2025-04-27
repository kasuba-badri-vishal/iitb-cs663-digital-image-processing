% Define the input and output directories
inputDir = 'project_data/project_data/images';  % Directory containing input images
outputDir = 'output_images'; % Directory to save processed images

% Check if the output directory exists, if not, create it
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Get a list of image files in the input directory
imageFiles = dir(fullfile(inputDir, '*.jpg')); % Assuming images are in JPG format

% Loop through each image file
for k = 1:length(imageFiles)
    filename = imageFiles(k).name;
    filepath = fullfile(inputDir, filename);
    
    % Read the image
    img1 = imread(filepath);
    Img = img1;
    Img=local_histogram(Img);
    %Img=global_his(Img);
    % Your existing image processing code...
    % (Replace the image processing code here)
    % ... 
    
    % Save the processed image to the output directory with the same filename
    outputFilename = fullfile(outputDir, filename);
    imwrite(Img, outputFilename);
    
    fprintf('Processed and saved: %s\n', outputFilename);
end
function Img = local_histogram(Img)
    img1=Img;
    dim_left=7;
    dim_right=7; 
    mid_val=round((dim_left*dim_right)/2);
    var=0;
    for i=1:dim_left
        for j=1:dim_right
            var=var+1;
            if(var==mid_val)
                Pad_M=i-1;
                Pad_N=j-1;
                break;
            end
        end
    end
    B=padarray(img1,[Pad_M,Pad_N]);
    for i= 1:size(B,1)-((Pad_M*2)+1)
        
        for j=1:size(B,2)-((Pad_N*2)+1)
            cdf=zeros(256,1);
            inc=1;
            for x=1:dim_left
                for y=1:dim_right        
                    if(inc==mid_val)
                        ele=B(i+x-1,j+y-1)+1;
                    end
                        pos=B(i+x-1,j+y-1)+1;
                        cdf(pos)=cdf(pos)+1;
                       inc=inc+1;
                end
            end
            for l=2:256
                cdf(l)=cdf(l)+cdf(l-1);
            end
                Img(i,j)=round(cdf(ele)/(dim_left*dim_right)*255);
         end
    end
end

function Img = global_his(Img)
    Img=histeq(Img,71);
end