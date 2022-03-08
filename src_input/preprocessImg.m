function Iout= preprocessImg(filename,inputSize)

I= imread(filename);

Iout = imresize(I,inputSize);

end

