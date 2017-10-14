function [fitresult, gof] = SSplineFit_wSParam(X, Y, SmoothParam, doFig)
%CREATEFIT(AGES,YY)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : Ages
%      Y Output: YY
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 16-Feb-2016 23:29:26


%% Fit: 'untitled fit 1'.
[X,I]=sort(X);
Y=Y(I);

I=find(~(Y==0) & ~isnan(Y));
X=X(I); Y=Y(I);

[xData, yData] = prepareCurveData( X, Y );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = SmoothParam;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
% p22=predint(fitresult,xData,0.95,'functional','off');

if doFig
    % Plot fit with data.
    figure( 'Name', 'untitled fit 1' );
    h = plot( fitresult, xData, yData);
%     hold on; plot(xData,p22,'m--')
    legend( h, 'YY vs. Ages', 'untitled fit 1', 'Location', 'NorthEast' );
    % Label axes
    xlabel( 'Ages' );
    ylabel( 'YY' );
    grid on
end

