function [Assignment,posterior] = EM1D(dis,n)
means = rand(1,n);
covariance = rand(1,n);
prior = rand(1,n);
pdf = zeros(size(dis,2),n);
posterior = zeros(size(dis,2),n);
Assignment = zeros(size(dis,2),1);
%E-Step

for k =1:10
    disp(k);
    for i = 1:size(dis,2)
        for j=1:size(means,2)
            pdf(i,j) = exp(-0.5 * (dis(:,i)-means(:,j))' ./ (covariance(:,j)+exp(-15)) *(dis(:,i)-means(:,j))./sqrt((2*pi)^3 * covariance(:,j)+exp(-15)));
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
        
        sig = zeros(1);
        for j=1:size(dis,2)
            sig = sig + posterior(j,i).*(dis(:,j)-means(:,i))'*(dis(:,j)-means(:,i));
        end
        covariance(:,i) = sig ./(s+exp(-15));
        covariance(:,:,i) = (covariance(:,i)-min(covariance(:,i))./(max(covariance(:,i))-min(covariance(:,i))));
    end

clear sig;
clear s;
clear s_;
clear index;
end
toc
