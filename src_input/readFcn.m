function  [bboxList,objectFile] = readFcn(x)

xmltxt = readstruct(x);

objectPos = xmltxt.object;

t= [objectPos.bndbox];

outputlist = reshape(struct2array(t),[],size(t,2))';
W = abs(outputlist(:,3) - outputlist(:,1));
H = abs(outputlist(:,4) - outputlist(:,2));
xmin = outputlist(:,1);
ymin = outputlist(:,2);
bboxList = [xmin,ymin,W,H];
objectFile = xmltxt.filename;
