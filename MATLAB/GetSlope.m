function [ slope ] = GetSlope( Y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    cacheCount = 35;
    X = [1:1:cacheCount];
    
    A = sum(X.*X);
    B = sum(X);
    C = sum(X.*Y);
    D = sum(Y);
    
    slope = (C*cacheCount - B*D)/(A*cacheCount - B*B);
end

