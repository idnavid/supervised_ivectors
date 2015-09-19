#! /usr/bin/python 
import htkmfc
import pickle
import numpy as np

class Gmm(object):
    def __init__(self):
        self.global_mean = None
        self.global_variance = None
        self.feature_dimension = None
        self.number_of_frames = None
        self.means = None
        self.variances = None
        self.weights = None
        self.training_data = None
    
    def load_features(self,file_list):
        """Read text file containing list of file-names and load feature files 
        as numpy arrays."""
        fin = open(file_list,'r')
        for i in fin:
            filename = i.strip()
            features = htkmfc.open(filename)
            data = features.getall()
            if (self.training_data == None):
                self.training_data = data
            else:
                self.training_data = np.vstack((self.training_data,data))
        self.number_of_frames, self.feature_dimension = self.training_data.shape
    
    
    def save_features_pickle(self):
        with open('features.pkl', 'wb') as pickle_file:
            pickle.dump(self.training_data, pickle_file, protocol=pickle.HIGHEST_PROTOCOL)
    
    
    
    
    def global_statistics(self):
        """Find initial values for gmm training process."""
        self.global_mean = np.mean(self.training_data,axis = 0).reshape(self.feature_dimension,1)
        self.global_variance = np.cov(self.training_data.T)
    
    
    def expectation(self):
        frames_per_job = 1000
        number_of_jobs = self.number_of_frames/frames_per_job
        






function [N, F, S, llk] = expectation(data, gmm)
% compute the sufficient statistics
[post, llk] = postprob(data, gmm.mu, gmm.sigma, gmm.w(:));
N = sum(post, 2)';
F = data * post';
S = (data .* data) * post';

function [post, llk] = postprob(data, mu, sigma, w)
% compute the posterior probability of mixtures for each frame
post = lgmmprob(data, mu, sigma, w);
llk  = logsumexp(post, 1);
post = exp(bsxfun(@minus, post, llk));
        
    
	
