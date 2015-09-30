function store_ark_files(matlab_ivectors)
addpath(genpath('~/tools/matlab_code/'))
data = load(matlab_ivectors);

for set = {'dev','model','test'}
    
    % The ivectors in each set are stored separately
    expression = ['ivectors = data.',set{1},'_ivs'];
    evalc(expression);
    
    expression = ['labels = data.',set{1},'_ids'];
    evalc(expression);
    
    FEATURE_MAT = ivectors;
    
    HEADER_MAT = cell(length(labels),4);
    
    HEADER_MAT(:,1) = labels;
end