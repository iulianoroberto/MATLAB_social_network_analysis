% Calcolo la matrice A
A = [A_power, zeros(24, 7); A_interlayer, A_gas];
A_binaria = A ~= 0; % Matrice dicotomica associata ad A

% Assegno un nome ad ogni nodo
namesBlue = (1:24) + " blue";
namesRed = [11 12 14 16 19 20 24] + " red";

% Graph of the whole network from A matrix
g = digraph(A, [namesBlue, namesRed]);

% Calcolo la betweenness
bet_mn_w = centrality(g, 'betweenness', 'Cost', 1./(g.Edges.Weight)); bet_mn_w_pesata = bet_mn_w/max(bet_mn_w); % Betweenness (yes weights)
%number_of_bins = 1 + log2(n);
histfit(bet_mn_w_pesata,6,'kernel');
xlabel('Bins for betweenness');
title('Fitting Kernel Function on Distribution of Betweenness');

% Calcolo le closeness
closeout_mn = centrality(g, 'outcloseness'); closeout_mn = closeout_mn/max(closeout_mn); % Outcloseness
colsein_mn = centrality(g, 'incloseness'); colsein_mn = colsein_mn/max(colsein_mn); % Incloseness
% Calcolo outdegree
degreeout_mn = outdegree(g); degreeout_mn = degreeout_mn/max(degreeout_mn); % Outdegree
degreein_mn = indegree(g); degreein_mn = degreein_mn/max(degreein_mn); % Indegree

% Calcolo degree (weighted) e normalizzo
n = size(A, 1); % Numero di nodi nel grafo
indeg_weighted = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
outdeg_weighted = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
for i = 1:n
    indeg_weighted(i) = sum(A(:, i)); % Calcola l'indegree del nodo "i" e salvalo nell'array "indeg"
    outdeg_weighted(i) = sum(A(i, :)); % Calcola la weighted outdegree del nodo "i" e salvala nell'array "outdeg_weighted"
end
indeg_column_weighted = reshape(indeg_weighted, [], 1);
indeg_norm_weighted = normalize(indeg_column_weighted, 'range', [0 1]);
outdeg_column_weighted = reshape(outdeg_weighted, [], 1);
outdeg_norm_weighted = normalize(outdeg_column_weighted, 'range', [0 1]);

for i=1:size(g.Nodes)
    absorbed_power(i) = indeg_column_weighted(i)-outdeg_column_weighted(i);
end

hub_ranks_importance = centrality(g, 'hubs', 'Importance', g.Edges.Weight);
auth_ranks_importance = centrality(g, 'authorities', 'Importance', g.Edges.Weight);
hub_ranks = centrality(g, 'hubs');
auth_ranks = centrality(g, 'authorities');

matrice_combinata = cat(2, outdeg_norm_weighted, closeout_mn, colsein_mn, bet_mn_w, auth_ranks_importance, hub_ranks_importance);
% matrice_combinata = cat(2, degreeout_mn, bet_mn_w, degreein_mn);

% Creo il grafo dalla matrice di adiacenza
G = digraph(A);

B = A*A';

figure;
subplot(2,1,1);
Z = linkage(B, 'complete');
H = dendrogram(Z, 0, 'Labels', [namesBlue, namesRed], 'ColorThreshold', 'default');
set(H, 'LineWidth', 1)
subplot(2,1,2);
Z = linkage(matrice_combinata, 'complete');
H = dendrogram(Z, 0, 'Labels', [namesBlue, namesRed], 'ColorThreshold', 0.7);
set(H, 'LineWidth', 1)
