function yellow_mask = fcn_LaneDet_yellowThresholding(image,varargin)
% fcn_LaneDet_yellowThresholding
% Perform yellow thresholding

% FORMAT:
%
%      yellow_hsv = fcn_LaneDet_yellowThresholding(image,varagin)
%
% INPUTS:
%
%      image: a N-by-M-by-3 array of red, green and blue values.
%
%      (optional inputs)
%
%      fig_num: figure number where results are plotted
%
% OUTPUTS:
%
%      yellow_hsv：a NxM-by-3 array
%
% EXAMPLES:
% 
% See the script: script_test_fcn_LaneDet_yellowThresholding for a full test 
% suite.
%
% DEPENDENCIES:
%
%     fcn_LaneDet_checkInputsToFunctions
%     fcn_LaneDet_dataPreparation
%     fcn_LaneDet_removeNoise
% 
%
% This function was written on 2021_06_27 by Xinyu Cao
% Questions or comments? xfc5113@psu.edu
%
% Revision history:
%   2021_06_27:
%   -- wrote the code originally
%   2021_07_29:
%   -- delete the incoorect part, and rename the function
%   2021_08_22:
%   -- change the output of the function
% TODO:
%   V values also need to be cleaned in the future

flag_do_debug = 0; % Flag to debug the results
flag_do_plots = 0; % Flag to plot the results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end
%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _       
%  |_   _|                 | |      
%    | |  _ __  _ __  _   _| |_ ___ 
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |                  
%              |_|                  
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs == 1   
    % Are there the right number of inputs?
    if nargin < 1 || nargin > 2
        error('Incorrect number of input arguments')
    end
    
    % Check the string input, make sure it is characters
    fcn_LaneDet_checkInputsToFunctions(image, 'image_rgb');
    
end

if 2 == nargin
    fig_num = varargin{1};
    figure(fig_num);
    flag_do_plots = 1;
else
    if flag_do_debug
        fig = figure; 
        fig_num = fig.Number;
        flag_do_plots = 1;
    end
end


%% Start of main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call fcn_LaneDet_dataPreparation
image_hsv = fcn_LaneDet_dataPreparation(image);
% Call fcn_LaneDet_removeNoise
clean_image_hsv = fcn_LaneDet_removeNoise(image_hsv);
% Get the size of the multidimensional arrays
sz = size(clean_image_hsv);
Nrows = sz(1);
Ncols = sz(2);
% Reshape the first two pages into a NrowsxNcols-by-2 array
clean_hs_array = reshape(clean_image_hsv(:,:,1:2), Nrows*Ncols, 2);
% Grab all non NaN values in the array
hs_target = clean_hs_array(~isnan(clean_hs_array(:,1)),:);
% Remove the outliers of the array
[hs_clean, hs_TF] = rmoutliers(hs_target);
% Define the thresholding boundary for Hue and Saturation value
h_lower = min(hs_clean(:,1));
h_upper = max(hs_clean(:,1));
s_lower = min(hs_clean(:,2));
s_upper = max(hs_clean(:,2));
% Create the hue and saturation mask
disp([h_upper,h_lower]);
% hue_mask = (clean_image_hsv(:,:,1) <= h_upper)&(clean_image_hsv(:,:,1) >= h_lower);
% sat_mask = (clean_image_hsv(:,:,2) <= s_upper)&(clean_image_hsv(:,:,2) >= s_lower);
% Combine hue and saturation mask
% yellow_mask = hue_mask&sat_mask;
yellow_mask = clean_image_hsv;

%% Any debugging?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _                 
%  |  __ \     | |                
%  | |  | | ___| |__  _   _  __ _ 
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_do_plots
    figure(fig_num)
    imshow(yellow_mask)
    title('Mask')
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end % End of function   


