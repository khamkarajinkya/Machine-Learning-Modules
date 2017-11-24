function [lambda,X] = PCA(input,e)

demean = zeros(size(input,1),size(input,2));
for i = 1:size(input,2)
    demean(:,i) = input(:,i) - mean(input(:,i)); 
end

covI = (demean' * demean)./size(input,1);
n = size(covI,1);
X = rand(n,n);
lambda = rand(n,1);
for i=1:e
    disp('principal component');
    disp(i);
    x = ones(n,1);
    [x,l]  = PI(x,covI,e); %uses function PI in PI.m
    X(:,i) = x; 
    lambda(i,1) = l; 
    covI = covI - l.*(x*x')./norm(x)^2;
end

[lambda,index] = sort(lambda,'descend');
X = X(:,index);
