#! /usr/bin/python 
import htkmfc
import pickle
import numpy as np
from sklearn import mixture

class Gmm(object):
    def __init__(self):
        self.number_of_mixtures = 1
        self.feature_dimension  = None
        ####
        self.training_data      = None
        ####
        self.scikitGmm          = mixture.GMM(self.number_of_mixtures)
        
        
    def initialize_gmm(self):
        self.scikitGmm.fit(self.training_data)        
    
    def expectation(self,file_list, mixture_number):
        #The expectation step runs in parallel on SGE. For this we need to create
        # bash commands for each file.  
        expectation_jobs = open('lists/expectation_jobs.txt','w')
        fin = open(file_list)
        for i in fin:
            filename = i.strip()
            bash_command = 'python /scratch/nxs113020/supervised_ivectors/py_code/generate_file_statistics.py %s %s\n'
            expectation_jobs.write(bash_command%(filename, mixture_number))
        fin.close()
        expectation_jobs.close()
        return None
    
    def maximization(self,file_list):
        fin = open(file_list)
        N = np.zeros((self.number_of_mixtures,1))
        F = np.zeros((self.feature_dimension,1))
        S = np.zeros((self.feature_dimension,1))
        for i in fin:
            filename = i.strip()
            basename = filename.split('/')[-1]
            statname = '/erasable/nxs113020/stats/'+basename+'.stats'
            filestats = pickle.load(open(statname, 'rb' ))
            n = filestats[0]
            f = filestats[1]
            s = filestats[2]
            N += n
            F += f
            S += s
        fin.close()
        weights   = N/float(sum(N))
        means     = F/N
        variances = (S/N) - np.power(means,2)
        
        self.scikitGmm.means_   = means
        self.scikitGmm.covars_  = variances
        self.scikitGmm.weights_ = weights
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
    
    
    

