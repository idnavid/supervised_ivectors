function scores = UEF_plda_implementation(dev_ivs, spk_labs,model_ivs1,test_ivs)
addpath(genpath('/home/nxs113020/cch_plda/PLDA_package/src')); % Add 'src' folder to path

params.Vdim = 200; % Dimensionality of speaker latent variable
params.Udim = 0; % Dimensionality of speaker latent variable
params.PLDA_type = 'two-cov'; % 'std' for standard PLDA
                           % 'simp' for simplified PLDA and
                           % 'two-cov' for two-covariance model
params.doMDstep = 1; % Indicator whether to do minimum-divergence step

numIter = 10;   % Number of training iterations
LDA_dim = 0; % Dimensionality for LDA. If it is 0 then do not apply LDA.
               % It should be less than the number of individuals in the
               % training set.

% Read PLDA training data:
train_data = dev_ivs';
train_labels = zeros(size(spk_labs));
for i = 1:length(spk_labs)
    train_labels(i) = str2double(spk_labs{i}(5:end));
end

% Read model/enrolment ivectors
enrol_data = model_ivs1';

% Read test ivectors
test_data = test_ivs';

% LDA
if LDA_dim > 0
    [eigvector, eigvalue] = LDA(train_labels, [], train_data);
    train_data = train_data*eigvector(:,1:LDA_dim);
    enrol_data = enrol_data * eigvector(:,1:LDA_dim);
    test_data = test_data*eigvector(:,1:LDA_dim);
end

% Compute the mean and whitening transformation over training set only
m     = mean(train_data);
S     = cov(train_data);
[Q,D] = eig(S);
W     = diag(1./sqrt(diag(D)))*Q';

% Center and whiten all i-vectors
train_data = bsxfun(@minus, train_data, m) * W';
enrol_data = bsxfun(@minus, enrol_data, m) * W';
test_data  = bsxfun(@minus, test_data, m) * W';

% Project all i-vectors into unit sphere
train_data = bsxfun(@times, train_data, 1./sqrt(sum(train_data.^2,2))); 
enrol_data  = bsxfun(@times, enrol_data, 1./sqrt(sum(enrol_data.^2,2)));
test_data  = bsxfun(@times, test_data, 1./sqrt(sum(test_data.^2,2)));

enrol_data_avr = enrol_data;
matrixID = create_incidence_matrix(train_labels);


%% PLDA
if strcmp(params.PLDA_type, 'two-cov')
    [model, stats] = two_cov_initialize(train_data', matrixID);
    for i=1:numIter
        model = two_cov_em(matrixID, model, stats);
    end 
	scores = two_cov_verification(model, enrol_data_avr, test_data); 
else
    [train_data, model, stats] = em_initialize(train_data, matrixID, params);
    for i=1:numIter
        model = em_algorithm(matrixID, params, model, stats); 
    end
    scores = verification(model, enrol_data_avr, test_data);
end
