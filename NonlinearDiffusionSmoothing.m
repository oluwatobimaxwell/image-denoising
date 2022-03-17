
clear;
im = imread('office_noisy.png');
w = double(im);

%setting up finite-difference parameters
alpha = 1;
k = 1;
h = 1;

lambda = (alpha^2)*(k/(h^2));

[m n] = size(w);
% stcking the 2D image matrix into a vector
w_vec = reshape(w,n*n,1);
w_old = w_vec;
w_new = w_vec;

jj=1;

figure;
for k=1:200  % for each iteration  
    for i=1:n*n % Linear system Ax=B solves using Jacobi iterations
        row = ceil(i/n); %compute what row this pixel belongs to in original image
        col = i - (row-1) * n; % compute the column similarly
        
        %different if conditions handles pixels at different location in
        %the image as depending on their location they may or may not have
        %all their neighbor pixels which will be required for finite
        %differences
        if((col > 1) && (col < n) && (row > 1) && (row < n))
            s = -(lambda) * (w_old(i+1) + w_old(i-1) + w_old(i+n) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((row == 1) && (col > 1) && (col < n))
            fprintf('TES of w: %d\n', w_old(i));
            s = -(lambda) * (w_old(i+1) + w_old(i-1) + w_old(i+n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((row == n) && (col > 1) && (col < n))
            s = -(lambda) * (w_old(i+1) + w_old(i-1) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col == 1) && (row > 1) && (row < n))
            s = -(lambda) * (w_old(i+1) + w_old(i+n) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col == n) && (row > 1) && (row < n))
            s = -(lambda) * (w_old(i-1) + w_old(i+n) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==1) && (row==1))
            s = -(lambda) * (w_old(i+1) + w_old(i+n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==n) && (row==1))
            s = -(lambda) * (w_old(i-1) + w_old(i+n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==1) && (row==n))
            s = -(lambda) * (w_old(i+1) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==n) && (row==n))
            s = -(lambda) * (w_old(i-1) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        end
    end
    w_old = w_new; %assigns new values to old values for next iteration 
    %if((k==10)||(k==50)||(k==100)||(k==200)) %showing output at different iterations
    if((k==1)||(k==5)||(k==10)||(k==30)||(k==100))
        subplot(3,2,jj)
        imshow(uint8(reshape(w_new,n,n)));
        imwrite(uint8(reshape(w_new,n,n)),strcat('heat-imp-lenna',int2str(jj),'.bmp'));        
        title(strcat('λ = 1 |',' t =  ',int2str(k)));

        jj=jj+1;
    end
    
end
% subplot 131
% imshow(im);
% subplot 132
% imshow(uint8(reshape(w_new,n,n)));
% subplot 133
% imshow(uint8(filter_function(w,30)));
