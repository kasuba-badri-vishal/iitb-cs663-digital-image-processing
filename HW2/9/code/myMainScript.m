img1=imread("LC1.png");
Img=img1;
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
imwrite(Img,"7X7_local.jpg");
figure,imshow(Img);
