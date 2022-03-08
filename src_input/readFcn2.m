function  objectFile = readFcn2(x)
% DOMnode = xmlread(xml_01);

xmltxt = readstruct(x);

objectFile = xmltxt.filename;

