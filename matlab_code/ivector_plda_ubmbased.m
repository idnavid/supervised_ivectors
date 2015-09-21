% Matlab script to run ivector/plda experiment on SRE10 trials. 
% The features are in htk format. 
% This is a preliminary experiment to obtain a baseline for the main
% project which is to build a supervised ivector training system. 

% Navid Shoukouhi
% UTD - CRSS
addpath(genpath('/home/nxs113020/MSR_Identity_dir/MSR_Identity_Toolkit_v1.0/code'));
%% Step0: Opening MATLAB pool
nworkers = 12;
nworkers = min(nworkers, feature('NumCores'));
isopen = matlabpool('size')>0;
if ~isopen, matlabpool(nworkers); end

%% Train UBM

dataList = 'lists/ubm.lst.subset';
nmix        = 1024;
final_niter = 10;
ds_factor   = 1;
ubm = gmm_em(dataList, nmix, final_niter, ds_factor, nworkers);
save('models/ubm','ubm');
% ubmMat = load('models/ubm');
% ubm = ubmMat.ubm;
%% Learning the total variability subspace from background data

tv_dim = 400; 
niter  = 5;
dataList = 'lists/ubm.lst.subset';
fid = fopen(dataList, 'rt');
C = textscan(fid, '%s');
fclose(fid);
feaFiles = C{1};
stats = cell(length(feaFiles), 1);
parfor file = 1 : length(feaFiles),
    [N, F] = compute_bw_stats(feaFiles{file}, ubm);
    stats{file} = [N; F];
end
T = train_tv_space(stats, ubm, tv_dim, niter, nworkers);
% tvMat = load('models/TV');
% T = tvMat.T;
%% Training the Gaussian PLDA model with development i-vectors

lda_dim = 200;
nphi    = 200;
niter   = 10;
dataList = 'lists/plda.lst';
fid = fopen(dataList, 'rt');
C = textscan(fid, '%s %s');
fclose(fid);
feaFiles = C{1};
dev_ivs = zeros(tv_dim, length(feaFiles));
parfor file = 1 : length(feaFiles),
    dev_ivs(:, file) = extract_ivector(stats{file}, ubm, T);
end
% reduce the dimensionality with LDA
spk_labs = C{2};
V = lda(dev_ivs, spk_labs);
dev_ivs = V(:, 1 : lda_dim)' * dev_ivs;
%------------------------------------
plda = gplda_em(dev_ivs, spk_labs, nphi, niter);

%% 