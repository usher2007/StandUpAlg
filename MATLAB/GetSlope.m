function [ slope ] = GetSlope( Y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    X = [1:1:25];
    
    A = sum(X.*X);
    B = sum(X);
    C = sum(X.*Y);
    D = sum(Y);
    
    slope = (C*25 - B*D)/(A*25 - B*B);
end

