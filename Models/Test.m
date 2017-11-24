tic
clear;
clc;
l = double(imread('fp.jpg'));
dis = reshape(l,[3,size(l,1)*size(l,1)]);
for i = 1:size(dis,1)
    dis(i,:) = (dis(i,:) - min(dis(i,:)))./(max(dis(i,:))-min(dis(i,:)));
end

clear l;

means = rand(3,3);
covariance = rand(3,3,3);
prior = rand(1,3);
pdf = zeros(size(dis,2),3);
posterior = zeros(size(dis,2),3);
Assignment = zeros(size(dis,2),1);
%E-Step

for k =1:3
    disp(k);
    for i = 1:size(dis,2)
        for j=1:size(means,2)
            pdf(i,j) = 1./sqrt((2*pi)^3 * det(covariance(:,:,j))+exp(-15))*exp(-0.5 * sum((dis(:,i)-means(:,j))' /(covariance(:,:,j)+exp(-15)) .*(dis(:,i)-means(:,j)),1));
        end
    end

    pdf = real(pdf);
    for i=1:size(pdf,1)
        pdf(i,:) = pdf(i,:)./sum(pdf(i,:)+exp(-15));
    end

    for i=1:size(posterior,1)
        s = sum(prior.*pdf(i,:));
        for j=1:size(means,2)
            posterior(i,j) = (prior(1,j).*pdf(i,j))./(s+exp(-15));
        end
        [~,index] = max(posterior(i,:));
        Assignment(i) = index; 
    end    
    
%M-Step

%Updating priors
    for i=1:size(prior,2)
        s = sum(posterior(:,i));
        prior(1,i) = prior(1,i)./(s+exp(-15));   
        prior(1,:) = prior(1,:)./sum(prior(1,:));

        %Updating means
        
        for j=1:size(means,1)
            s_ = sum(posterior(:,i)'.*dis(j,:));
            means(j,i) = s_ ./(s+exp(-15));
        end
        means(:,i) = means(:,i)./sum(means(:,i));
        
        %Updating Covaraince
        
        sig = zeros(3);
        for j=1:size(dis,2)
            sig = sig + posterior(j,i).*(dis(:,j)-means(:,i))*(dis(:,j)-means(:,i))';
        end
        covariance(:,:,i) = sig ./(s+exp(-15));
        covariance(:,:,i) = (covariance(:,:,i)-min(covariance(:,:,i))./(max(covariance(:,:,i))-min(covariance(:,:,i))));
    end

clear sig;
clear s;
clear s_;
clear index;
end
toc
