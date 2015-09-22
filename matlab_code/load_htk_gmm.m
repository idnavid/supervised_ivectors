% MATLAB function to load a UBM in htk format 
% and store in a gmm struct as used in MSR_identity. 
% 
% The code uses Ron Weiss's read_htk_hmm matlab implementation.
%
% Since it takes too long to train a ubm in MATLAB, 
% I used HTKgmmTrain on the cluster to train the UBM 
% in parallel using HTK binaries. 
 
function gmm = load_htk_gmm(filename) 
addpath('/home/nxs113020/tools/matlab_code');
hmms = read_htk_hmm(filename);
gmm.mu = hmms.gmms.means;
gmm.sigma = hmms.gmms.covars;
gmm.w = exp(hmms.gmms.priors);

