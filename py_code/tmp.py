#! /usr/bin/python  

import common
import numpy as np

ubm = common.Gmm()
ubm.load_features('lists/ubm.lst.subset')
ubm.global_statistics()
ubm.initialize_gmm()
ubm.save_gmm()

ubm.expectation('lists/ubm.lst.subset', str(ubm.number_of_mixtures))
        
        
        

