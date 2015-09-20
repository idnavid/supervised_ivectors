#! /usr/bin/python 
import htkmfc
import pickle
import numpy as np

class Gmm(object):
    def __init__(self):
        self.number_of_mixtures = 1
        self.feature_dimension  = None
        self.means              = None
        self.variances          = None
        self.weights            = None
        ####
        self.training_data      = None
        self.global_mean        = None
        self.global_variance    = None
        
    
    def global_statistics(self):
        """Find initial values for gmm training process."""
        self.global_mean = np.mean(self.training_data,axis = 0).reshape(self.feature_dimension,1)
        self.global_variance = np.cov(self.training_data.T)
    
    def initialize_gmm(self):
        self.weights            = 1
        self.means              = self.global_mean
        self.variances          = self.global_variance
    
    def expectation(self,file_list, mixture_number):
        #The expectation step runs in parallel on SGE. For this we need to create
        # bash commands for each file.  
        expectation_jobs = open('lists/expectation_jobs.txt','w')
        fin = open(file_list)
        for i in fin:
            filename = i.strip()
            bash_command = 'python generate_file_statistics.py %s %s\n'
            expectation_jobs.write(bash_command%(filename, mixture_number))
        fin.close()
        expectation_jobs.close()
    
    
    def maximization(self,N,F,S):
        return None
    
    
    def gmm_mixup(self):
        return None
    

    def save_gmm(self):
        model_file_name = 'models/gmm'+str(self.number_of_mixtures)
        with open(model_file_name, 'wb') as pickle_file:
            pickle.dump(self, pickle_file, protocol=pickle.HIGHEST_PROTOCOL)            


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
        fin.close()
    
    
    def save_features_pickle(self,output_file_name):
        with open(pickle_file_name, 'wb') as pickle_file:
            pickle.dump(self.training_data, pickle_file, protocol=pickle.HIGHEST_PROTOCOL)    
        # I read that HDF uses far less memory as compared to pickle. If RAM usage becomes
        # an issue, use this code. You'll have to install some software for tables.
        #
        #import tables
        #h5file = tables.openFile(output_file_name, mode = 'w')
        #root = h5file.root
        #h5file.createArray(root,"test",self.training_data)
        #h5file.close()
    
    
    

