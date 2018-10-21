function [ J ] = negentropy( image, variant)
%NEGENTROPY Estimates the negentropy of a given image
% The negentropy estimation is based on the approximation of nongaussianity 
% given in Hyvarinen et al. (2004)
% 
% J(y) ~= k1(E{G1(y)})^2 + k2(E{G2(y)} - E{G2(v)})^2
% where
% G1(y) = 1/a1 log cosh(a1 y), where 1 <= a1 <= 2 (usually 1),
% G2(y) = -exp(-y^2/2)
% v is from standard normal distribution.
%
% In what follows, it is assumed that E{G2(v)} = 1.
%
% A.Hyvarinen, J.Karhunen, and E. Oja, Independent component analysis, John
% Wiley & Sons, 2004, vol.46, pages 183-184.
%
% Copyrights: Agata Migalska
% Last change: 24.09.2015 21:48
%---------------------------------------

    % reshape image matrix to a vector
    data = reshape(image, 1, []);
    % zero-mean
    data = data - mean(data);
    % unit variance
    data = data./std(data);
    
    if nargin < 2
        variant = 2;
    end
    if variant == 1
        J = negentropyLaplacian(data);
    elseif variant == 2
        J = negentropyExponent(data);
    elseif variant == 3
        J = negentropyKurtosis(data);
    elseif variant == 4
        J = negentropyEvenFcn(data);
    elseif variant == 5
        J = negentropyOddFcn(data);
    end
    
    function [result] = negentropyEvenFcn(signal)

        g1 = - exp(-signal.^2/2);
        meanG1 = mean(g1);

        % sigmaSq = 1/sqrt(3) - 1/2;
        expectedValue = - 1/sqrt(2);
        
        even = (meanG1 - expectedValue)^2;
        odd = 0;
        result = even + odd;
    end

    function [result] = negentropyOddFcn(signal)
        g2 = signal .* exp(-signal.^2/2);
        meanG2 = mean(g2);
        
        expectedValueG2 = 0;
        even = 0;
        odd = (meanG2 - expectedValueG2)^2;
        result = even + odd;
    end
    
    function [result] = negentropyLaplacian(signal)
        % Negentropy estimation, Eq. (5.47) Hyvarinen et al., ICA,
        % Wiley and Sons, 2001.
        % set up constants
        k1 = 36/(8 * sqrt(3) - 9);
        k2 = 1/(2 - 6/pi);

        % E{G1(y)}
        g1 = signal .* exp(-signal.^2/2);
        expectedG1 = mean(g1);

        % E{G2(y)} - E{G2(v)}
        g2 = abs(signal);
        expectedG2 = mean(g2) - sqrt(2/pi);

        % calculate negentropy
        odd = k1 * expectedG1^2;
        even = k2 * expectedG2^2;
        result = odd + even;
    end
    function [result] = negentropyExponent(signal)
        % Negentropy estimation, Eq. (5.48) Hyvarinen et al., ICA,
        % Wiley and Sons, 2001.
        % set up constants
        k1 = 36/(8 * sqrt(3) - 9);
        k2 = 24/(16 * sqrt(3) - 27);

        % E{G1(y)}
        g1 = signal .* exp(-signal.^2/2);
        expectedG1 = mean(g1);

        % E{G2(y)} - E{G2(v)}
        g2 = exp(-signal.^2./2);
        expectedG2 = mean(g2) - sqrt(1/2);

        % calculate negentropy
        odd = k1 * expectedG1^2;
        even = k2 * expectedG2^2;
        result = odd + even;
        
        
    end
    function [result] = negentropyKurtosis(signal)
        % Negentropy estimation, Eq. (5.35), Hyvarinen et al., ICA, Wiley
        % and Sons, 2001.
        thirdMoment = mean(signal.^3);
        kappa = kurtosis(signal);
        even = 1/48 * kappa^2;
        odd = 1/12 * thirdMoment^2;
        result = even + odd;
    end

    
end

