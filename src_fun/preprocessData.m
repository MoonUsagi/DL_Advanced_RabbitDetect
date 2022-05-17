function image = preprocessData(image, targetSize)
% Resize the images and scale the pixels to between 0 and 1.
%#codegen

%   Copyright 2020-2021 The MathWorks, Inc.


imgSize = size(image);

% Convert an input image with single channel to 3 channels.
if numel(imgSize) < 1
    image = repmat(image,1,1,3);
end

image = im2single(rescale(image));

image = iLetterBoxImage(image,coder.const(targetSize(1:2)));

end


function Inew = iLetterBoxImage(I,targetSize)
% LetterBoxImage returns a resized image by preserving the width and height
% aspect ratio of input Image I. 'targetSize' is a 1-by-2 vector consisting 
% the target dimension.
%
% Input I can be uint8, uint16, int16, double, single, or logical, and must
% be real and non-sparse.

[Irow,Icol,Ichannels] = size(I);

% Compute aspect Ratio.
arI = Irow./Icol;

% Preserve the maximum dimension based on the aspect ratio.
if arI<1
    IcolFin = targetSize(1,2);
    IrowFin = floor(IcolFin.*arI);
else
    IrowFin = targetSize(1,1);
    IcolFin = floor(IrowFin./arI);
end

% Resize the input image.
Itmp = imresize(I,[IrowFin,IcolFin]);

% Initialize Inew with gray values.
Inew = ones([targetSize,Ichannels],'like',I).*0.5;

% Compute the offset.
if arI<1
    buff = targetSize(1,1)-IrowFin;
else
    buff = targetSize(1,2)-IcolFin;
end

% Place the resized image on the canvas image.
if (buff==0)
    Inew = Itmp;
else
    buffVal = floor(buff/2);
    if arI<1
        Inew(buffVal:buffVal+IrowFin-1,:,:) = Itmp;
    else
        Inew(:,buffVal:buffVal+IcolFin-1,:) = Itmp;
    end
end

end