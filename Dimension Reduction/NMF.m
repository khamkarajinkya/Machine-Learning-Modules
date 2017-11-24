function [Wn,Hn] = NMF(Xabs,N) 

P = N;
Wn = rand(size(Xabs,1),P);
Hn = rand(P,size(Xabs,2));

%Update Rule
  
for i = 1:1000
Hn = Hn .* (Wn' * Xabs)./((Wn' * Wn * Hn)+eps(-5));
Wn = Wn .* (Xabs * Hn')./((Wn * (Hn * Hn')+eps(-5)));
end
