function histequal(x)
f=imread("LC1.png");
g=histeq(f,71);
imwrite(g,"LC1_global.png");
%imwrite(f,"LC2_histo_global.jpg");
%figure, imshow(g);
