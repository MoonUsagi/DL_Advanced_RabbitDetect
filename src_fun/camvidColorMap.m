function cmap = camvidColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
     128 220 128   %
     0 128 220     % 
    220 128 128   % 

    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end