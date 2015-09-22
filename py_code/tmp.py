#! /usr/bin/python  

import common
import numpy as np
import os


ubm = common.Gmm()
ubm.load_features('lists/ubm.lst.subset')
ubm.initialize_gmm()
ubm.save_gmm()

for i in range(10):
    ubm.expectation('lists/ubm.lst.subset', str(ubm.number_of_mixtures))
    os.system('~/bin/myJsplit -b 1 -M 10 lists/expectation_jobs.txt')
    tmp_mean = ubm.scikitGmm.means_
    ubm.maximization('lists/ubm.lst.subset')
    print tmp_mean - ubm.scikitGmm.means_
        
        

