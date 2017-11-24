function [means,assign_cluster]=Kmeans(d,c,method)
n = size(d,1);
dim = size(d,2);

for i=1:dim
    d(:,i) = (d(:,i) - min(d(:,i)))/ (max(d(:,i)) - min(d(:,i)));
end

%assign cluster centers
clusters = rand(c,dim);

%Cluster assignments
assign = zeros(size(d,1),1);

%finding the least assignment 
least = zeros(c,1);

l = ones(size(d,1),1);
assign = [assign l];

iteration = 1;

while ~isequal(assign(:,2),assign(:,1))
    disp("Iteration number:");
    disp(iteration);
    iteration  = iteration+1;
    assign(:,2) = assign(:,1);
    for j=1:n
        if strcmp(method,'Euclidean')
            least = Euclidean(d(j,:),clusters);
        end
        if strcmp(method,'Cosine')
            least = Cosine(d(j,:),clusters);
        end
        if strcmp(method,'Manhattan')
            least = Manhattan(d(j,:),clusters);
        end
        li = find(least == min(least),1,'last');
        assign(j,1) = li;
    end
    for j=1:c
        if ismember(j,assign(:,1))
            [val,~] = find(assign(:,1) == j);
            t = double(numel(assign(val,1)));
            for i = 1:dim
                clusters(j,i) = double(sum(d(val,i)))/t;
            end
        end
    end
end   
means = clusters;
assign_cluster= assign;

end

function [dist] = Euclidean(p,c)
    dist = zeros(size(c,1),1);
    n = size(c,2);
    for i = 1:size(c,1)
        s = 0;
        for j=1:n
            s = s + (p(j) - c(i,j))^2;
        end
        dist(i) = sqrt(s);
    end
end

function [dist] = Manhattan(p,c)
    dist = zeros(size(c,1),1);
    n = size(c,2);
    for i = 1:size(c,1)
        s = 0;
        for j=1:n
            s = s + abs(p(j) - c(i,j));
        end
        dist(i) = s;
    end
end

function [dist] = Cosine(p,c)
    dist = zeros(size(c,1),1);
    n = size(p,2);
    for i = 1:size(c,1)
        s = 0;
        for j=1:n
            s = s + p(j)*c(i,j);
        end
        s = s/(sqrt(sum(p.^2))* sqrt(sum(c(i,:).^2)));
        dist(i) = 1 - s;
    end
end




