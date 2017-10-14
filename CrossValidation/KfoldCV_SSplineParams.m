function [CV, norm_mse_test, norm_mse_train] = KfoldCV_SSplineParams(X,Y,Model,Nfolds,Nbins,SmoothParam)
% K-fold cross validation. Data will be divided into Nfolds folds to be
% used for model training and testing. Each of the Nfolds will be
% iteratively held back as a test set while the model is fit to the
% Nfolds-1 other folds. Mean-squared-error (MSE) values are then
% calculated for each training and test set to compare model fitting and
% prediction.
%
% INPUTS
% X and Y are the input data. They should be row/column vectors of equal
% length
% Model should define a model function name. It should recieve X and
% Y vectors for inputs and output fitresult and gof. Example of a model
% function: [fitresult, gof] = SSplineFit_wSParam(XX, YY, SmoothParam, 0);
% Nfolds is the number of folds to divide the data into. A larger number of
% folds should be used when there is a low number of sample points. Nfolds
% can be a vector of predefined indices defining which fold corresponds to
% each data point in Y.
% Nbins will split the data into bins and ensure that each fold has
% representative data from each bin
% SmoothParam for the matlab Smoothing Spline model

if ~(length(X)==length(Y))
    disp('Error: X and Y need to be vectors of equal length.')
    return;
end
if length(Nfolds)>1 && ~(length(Nfolds)==length(Y)) 
    disp('Error: number of indices in Nfolds does not match data length in Y')
    return;
end

% Exclude data with NAN or zero values for Y
Inds = find(~isnan(Y) & Y>0);
X=X(Inds); Y=Y(Inds);

% Number of included data points
N = length(X);

%% Setup fold indices
if length(Nfolds) == 1
    % If only provided a value for Nfolds create fold indices
    % Group X values into bins
    MinX = min(X);
    MaxX = max(X);
    edges = ((0:1:Nbins)*(1.001*MaxX-0.999*MinX)/(Nbins))+0.999*MinX;
    BINS = discretize(X,edges);
    % Create training and test indices
    Indices = crossvalind('Kfold',BINS,Nfolds);
else
    % If Nfolds is a vector assume it contains definition of fold indices
    Indices = Nfolds(Inds);
    Nfolds = nnz(unique(Nfolds));
end

for i=1:Nfolds
    
    Test=Indices==i;
    Train=~Test;
    
    XTrain = X(Train);
    YTrain = Y(Train);
    
    XTest = X(Test);
    YTest = Y(Test);
    
    eval(['[fitresult, gof] = ' Model '(XTrain, YTrain,SmoothParam,0);']);
    
    mse_train(i) = gof.sse/length(YTrain);
    
    y_model{i}=zeros(size(YTest));
    for j=1:length(XTest)
        y_model{i}(j)=feval(fitresult,XTest(j));
    end
    
    Test_errors{i} = YTest-y_model{i};
    Test_mse(i) = sum(Test_errors{i}.^2)/length(YTest);
    
end

mnY=mean(Y);

CV.test.mse_test = Test_mse;
norm_mse_test = CV.test.mse_test/mnY;
CV.test.norm_mse_test = norm_mse_test;

CV.train.mse_train = mse_train;
norm_mse_train = CV.train.mse_train/mnY;
CV.train.norm_mse_train = norm_mse_train;



