A = [A_power, zeros(24, 7); A_interlayer, A_gas]; % Ottengo la matrice A
A_binaria = A ~= 0; % Matrice binaria associata ad A

A_binaria = double(A_binaria);
G = digraph(A_binaria);
plot(G);

out_degree = outdegree(G); % Calcolo il grado di uscita
D_out = diag(out_degree); % Matrice diagonale con gradi di uscita

I = eye(31);
alfa = 0.5;
vettore_unitario = ones(1, 31);

c_pg_rank = ((I-alfa*A_binaria'*(D_out^(-1)))^(-1)).*(((1-alfa)/(31))*vettore_unitario);

pg_ranks = centrality(G,'pagerank');