function store_ark_files(matlab_ivectors)
addpath(genpath('~/tools/matlab_code/'))
data = load(matlab_ivectors);

for set = {'dev','model','test'}
    
    % The ivectors in each set are stored separately
    expression = ['ivectors = data.',set{1},'_ivs'];
    evalc(expression);
    
    expression = ['labels = data.',set{1},'_ids'];
    evalc(expression);
    
    FEATURE_MAT = ivectors';
    [n_ivectors,ivector_dimension] = size(FEATURE_MAT);
    
    HEADER_MAT = cell(n_ivectors,5);
    disp(n_ivectors)
    HEADER_MAT(:,1) = labels(1:n_ivectors);
    
    if strcmp(set{1},'test')
        for i = 1:n_ivectors
            path_cell = regexp(HEADER_MAT{i,1},'/','split');
            filename_cell = regexp(path_cell(end),'\.','split');
            basename = filename_cell{1}(1);
            HEADER_MAT(i,1) = basename;
        end
    end

    
    for i = 1:n_ivectors 
        HEADER_MAT{i,2} = [1];
        HEADER_MAT{i,3} = [ivector_dimension];
        HEADER_MAT{i,4} = [i];
        HEADER_MAT{i,5} = [i];
    end
[status] = arkwrite(['models/',set{1},'.ark'],HEADER_MAT,FEATURE_MAT);

end