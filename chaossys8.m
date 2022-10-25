%% nest CSBMA
function [chaosSq] = chaossys8(x0,r,L)
Lfactor = factor(L);
aa = 0;
if size(Lfactor,2)>10
    aa = 1;
end
bs = prod(Lfactor(1:ceil(size(Lfactor,2)/2+aa)));
a = 5.421131;
b = 5.733311;
x = x0;
for i = 1:4*bs
    x = x+a;
    x = mod(b*r*x*(1-x),1);
    xs(i) = x;
end

x1 = xs(1:4:end);
a1 = xs(2:4:end)+4.4321341;
b1 = xs(3:4:end)+4.7124311;
r1 = xs(4:4:end)+3.7312457;
for i = 1:L/(bs)
    x1 = x1+a1;
    x1 = mod(b1.*r1.*x1.*(1-x1),1);
    xn(:,i) = x1;
end

chaosSq = xn(:)';