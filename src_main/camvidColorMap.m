function cmap = camvidColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
     0 128 192     % Bicyclist
     128 128 128   % Zero
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end