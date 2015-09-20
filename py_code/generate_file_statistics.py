from sklearn import mixture
import numpy as np
import sys
import pickle
import htkmfc 

def generate_file_statistics(filename, mixture_number):
    """
        Load GMM at current iteration/mixture and calculate the statistics
        for filename. 
        At the end, store the statistics in the 'stats' directory. 
    """
    # Here we use a sci-kit format gmm, so to be able to use its methods
    gmm = mixture.GMM(int(mixture_number))
    
    model_file_name = 'models/gmm'+mixture_number
    stored_gmm = pickle.load(open( model_file_name, 'rb' ))
    
    gmm.weights_  = stored_gmm.weights
    gmm.means_    = stored_gmm.means
    gmm.covars_   = stored_gmm.variances
    
    # Load features:
    features = htkmfc.open(filename)
    data     = features.getall()
    
    # Calculate Prob(X/gmm)
    print gmm
    print data.shape
    prob_data_given_model = gmm.predict_proba(data)
    
    # Calculate 0th, 1st, and 2nd order statistics
    zeroth_order_stats   = sum(prob_data_given_model)
    first_order_stats    = np.multiply(data,prob_data_given_model.T)
    second_order_stats   = np.multiply(np.pow(data,2),prob_data_given_model.T)
    
    file_stats = [zeroth_order_stats, first_order_stats, second_order_stats]
    
    # Store statistics:
    basename = filename.split('/')[-1]
    output_name = 'stats/stats_'+basename
    with open(output_name, 'wb') as pickle_file:
        pickle.dump(file_stats, pickle_file, protocol=pickle.HIGHEST_PROTOCOL)


if __name__=='__main__':
    filename = sys.argv[1]
    mixture_number = sys.argv[2]
    generate_file_statistics(filename,mixture_number)
