function cmap = camvidColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
     0 128 192     % 
     128 128 128   % 
     128 192 192   %
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end