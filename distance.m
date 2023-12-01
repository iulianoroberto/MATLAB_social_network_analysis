A=rand(10)>0.75; G=digraph(A,'omitselfloop');
D=distances(G); D(D==Inf)=0;
diametro=max(max(D));
[Path,Diam,EdgePath]=shortestpath(G,3,7)
figure, p=plot(G); highlight(p,Path,'EdgeColor','g');