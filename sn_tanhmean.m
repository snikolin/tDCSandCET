function mean_output = sn_tanhmean(input,dim,s)
% This function applies the tanh trimmed mean method. 
% To visualise the weighting this applies to data:
%   Example:
%       s = 0.7; N = 400; k = 2/N * 3; m = median(1:N);
%       wgt = zeros(1,N);
%       for i = 1:N
%           if i < m
%               wgt(i) = tanh(k*i) - s;
%           elseif i >= m
%               wgt(i) = tanh((2*m - i)*k) - s;
%           end
%       end
%       wgt(wgt < 0) = 0;
%       wgt = wgt/sum(wgt);
%       figure; plot(wgt)
%
% input: matrix of data to be averaged
% dim:  dimension of the matrix to be averaged
% s:    the severity of the data trimming procedure (how much data will be excluded

%% Check function arguments
if ~any(s)
    s = 0.5; % set as default value
end

%% Generate weights
N   = size(input,dim);
k   = 6/N; % 2/N * 3 (3 defines tanh plateau)
m   = median(1:N);
wgt = zeros(1,N);

for i = 1:N
    if i < m
        wgt(i) = tanh(k*i) - s;
    elseif i >= m
        wgt(i) = tanh((2*m - i)*k) - s;
    end
end

wgt(wgt < 0)    = 0;
wgt             = wgt/sum(wgt);

%% Apply weights to data
% Sort input according to dimension for averaging

% identify the number of matrix dimensions
matrixdim = length(size(input));

% sort the data along dimension of interest
temp = sort(input,dim);

% permute temp so matrix of interest is first
otherdim = setdiff(1:matrixdim,dim);
temp = permute(temp,[dim otherdim]);

% reorder the
if matrixdim == 2
    for a = 1:N
        temp(a,:) = temp(a,:)*wgt(a);
    end
elseif matrixdim == 3
    for a = 1:N
        temp(a,:,:) = temp(a,:,:)*wgt(a);
    end
elseif matrixdim == 4
    for a = 1:N
        temp(a,:,:,:) = temp(a,:,:,:)*wgt(a);
    end
elseif matrixdim == 5
    for a = 1:N
        temp(a,:,:,:,:) = temp(a,:,:,:,:)*wgt(a);
    end
else
    error('matrix is too later - tweak the code');
end

mean_output = squeeze(sum(temp,1));

% % Old        
% for a = 1:N
%     temp(:,:,a) = temp(:,:,a)*wgt(a);
% end
% mean_output = sum(temp,dim);

