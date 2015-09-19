#! /usr/bin/python  

import common

ubm = common.Gmm()
ubm.load_features('lists/ubm.lst.subset')
ubm.global_statistics()
print ubm.global_variance

