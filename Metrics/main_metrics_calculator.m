% Naming of the nodes
namesBlue = (1:24)+" blue";
namesRed = [11 12 14 16 19 20 24]+" red";

% Combine matrix
A = [A_power, zeros(24, 7); A_interlayer, A_gas];

% Graph of the whole network from A matrix
g = digraph(A, [namesBlue, namesRed]);

% Matrice dicotomica
A_dicotomica = A ~= 0;
g_dicotomico = digraph(A_dicotomica, [namesBlue, namesRed]);

% Delete interlayer edges
A_modified = A;
A_modified(25, 11) = 0;
A_modified(27, 14) = 0;
A_modified(28, 16) = 0;
A_modified(29, 19) = 0;
A_modified(30, 20) = 0;
A_modified(31, 24) = 0;

% Graph of the network without interlayer edges
g_modified = digraph(A_modified, [namesBlue, namesRed]);

% Gas network graph
g_gas_network = digraph(A_gas);
figure, p_gas = plot(g_gas_network);
p_gas.NodeColor = 'r'; % Node color
p_gas.EdgeColor = 'r'; % Edge color
p_gas.MarkerSize = 10; % Marker size
p_gas.LineWidth = 3*g_gas_network.Edges.Weight/max(g_gas_network.Edges.Weight); % Modelling width of edges
title('Gas network modelled as a graph (1D graph)'); % Title of graph
legend('Nodes of gas network and power flux between them'); % Legend of graph

% Power grid graph
g_power_grid = digraph(A_power);
figure, p_power = plot(g_power_grid);
p_power.NodeColor = 'b';
p_power.EdgeColor = 'b';
p_power.MarkerSize = 10;
p_power.LineWidth = 3*g_power_grid.Edges.Weight/max(g_power_grid.Edges.Weight);
title('Power grid modelled as a graph (1D graph)');
legend('Nodes of power grid and power flux between them');

% Creazione del subplot e aggiunta dei grafici
%subplot(1, 2, 1);
%plot(p_gas);
%subplot(1, 2, 2);
%plot(p_power);

% Plot multilayer network (with interlayer)
p = plot(g);
highlight(p, 25:31, NodeColor='red') % Use color red for nodes of the gas network
p.NodeLabel = string([1:24 11 12 14 16 19 20 24]);

% Select weight of edges
pesi_archi = g.Edges.Weight;

% Edges width proportional to weight
p.LineWidth = 5*pesi_archi/max(pesi_archi);

% Nodes dimension
p.MarkerSize = 7;

% 3D visualization of multilayer network
zdata = zeros(31, 1); % inizializza zdata con tutti zeri
red_indices = findnode(g, namesRed); % trova gli indici dei nodi rossi in g
zdata(red_indices) = 1; % assegna il valore 1 agli indici dei nodi rossi in zdata
p.ZData = zdata; % Imposta la proprietà ZData di p uguale a zdata
view(3); % Imposta la visualizzazione 3D (parametro impostato a 3)
% Aggiungi i nomi degli assi
xlabel('asse x');
ylabel('asse y');
zlabel('asse z');
title('Multi-Energy System modelled as Multilayer Network');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MULTILAYER NETWORK WITH INTERLAYER EDGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bet_mn = centrality(g, 'betweenness'); bet_mn = bet_mn/max(bet_mn); % Betweenness (no weights)
bet_mn_w = centrality(g, 'betweenness', 'Cost', 1./(g.Edges.Weight)); bet_mn_w = bet_mn_w/max(bet_mn_w); % Betweenness (yes weights)
closeout_mn = centrality(g, 'outcloseness'); closeout_mn = closeout_mn/max(closeout_mn); % Outcloseness
colsein_mn = centrality(g, 'incloseness'); colsein_mn = colsein_mn/max(colsein_mn); % Incloseness
degreein_mn = indegree(g); degreein_mn = degreein_mn/max(degreein_mn); % Indegree
degreeout_mn = outdegree(g); degreeout_mn = degreeout_mn/max(degreeout_mn); % Outdegree
n = size(A, 1); % Assign to n nodes number of the graph
indeg_weighted_ml = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
outdeg_weighted_ml = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
for i = 1:n
    indeg_weighted_ml(i) = sum(A(:, i)); % Calcola l'indegree del nodo "i" e salvalo nell'array "indeg"
    outdeg_weighted_ml(i) = sum(A(i, :)); % Calcola la weighted outdegree del nodo "i" e salvala nell'array "outdeg_weighted"
end
indeg_column_weighted_ml = reshape(indeg_weighted_ml, [], 1);
indeg_norm_weighted_ml = normalize(indeg_column_weighted_ml, 'range', [0 1]);
outdeg_column_weighted_ml = reshape(outdeg_weighted_ml, [], 1);
outdeg_norm_weighted_ml = normalize(outdeg_column_weighted_ml, 'range', [0 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MULTILAYER NETWORK WITHOUT INTERLAYER EDGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bet_mn_ni = centrality(g_modified, 'betweenness'); bet_mn_ni = bet_mn_ni/max(bet_mn_ni); % Betweenness (no weights)
bet_mn_w_ni = centrality(g_modified, 'betweenness', 'Cost', 1./(g_modified.Edges.Weight)); bet_mn_w_ni = bet_mn_w_ni/max(bet_mn_w_ni); % Betweenness (yes weights)
closeout_mn_ni = centrality(g_modified, 'outcloseness'); closeout_mn_ni = closeout_mn_ni/max(closeout_mn_ni); % Outcloseness
colsein_mn_ni = centrality(g_modified, 'incloseness'); colsein_mn_ni = colsein_mn_ni/max(colsein_mn_ni); % Incloseness
degreein_mn_ni = indegree(g_modified); degreein_mn_ni = degreein_mn_ni/max(degreein_mn_ni); % Indegree
degreeout_mn_ni = outdegree(g_modified); degreeout_mn_ni = degreeout_mn_ni/max(degreeout_mn_ni); % Outdegree
n = size(A_modified, 1); % Assign to n nodes number of the graph
indeg_weighted_ml_ni = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
outdeg_weighted_ml_ni = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
for i = 1:n
    indeg_weighted_ml_ni(i) = sum(A_modified(:, i)); % Calcola l'indegree del nodo "i" e salvalo nell'array "indeg"
    outdeg_weighted_ml_ni(i) = sum(A_modified(i, :)); % Calcola la weighted outdegree del nodo "i" e salvala nell'array "outdeg_weighted"
end
indeg_column_weighted_ml_ni = reshape(indeg_weighted_ml_ni, [], 1);
indeg_norm_weighted_ml_ni = normalize(indeg_column_weighted_ml_ni, 'range', [0 1]);
outdeg_column_weighted_ml_ni = reshape(outdeg_weighted_ml_ni, [], 1);
outdeg_norm_weighted_ml_ni = normalize(outdeg_column_weighted_ml_ni, 'range', [0 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Boxplot of multilayer network with interlayer edges
figure, boxplot([bet_mn bet_mn_w closeout_mn colsein_mn degreein_mn degreeout_mn indeg_column_weighted_ml outdeg_column_weighted_ml]);
title('Multilayer network (with interlayer edges)')
ylabel('Measurement value')
xlabel('All measures')
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Betweenness (no weights)', 'Betweenness', 'Outcloseness', 'Incloseness', 'Indegree', 'Outdegree', 'Indegree (weighted)', 'Outdegree (weighted)'});

% Boxplot of multilayer network without interlayer edges
figure, boxplot([bet_mn_ni bet_mn_w_ni closeout_mn_ni colsein_mn_ni degreein_mn_ni degreeout_mn indeg_column_weighted_ml_ni outdeg_column_weighted_ml_ni]);
title('Multilayer network (without interlayer edges)')
ylabel('Measurement value')
xlabel('All measures')
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Betweenness (no weights)', 'Betweenness', 'Outcloseness', 'Incloseness', 'Indegree', 'Outdegree', 'Indegree (weighted)', 'Outdegree (weighted)'});

% Bar plot
data = [bet_mn_w_ni bet_mn_w bet_mn_ni bet_mn];
x = (1:31)';
multibar = bar(x,data);
set(multibar(1), 'FaceColor','r')
set(multibar(2), 'FaceColor','b')
set(multibar(3), 'FaceColor','y')
set(multibar(4), 'FaceColor','g')
labels = [namesBlue, namesRed];
xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]);
xticklabels(labels);
title('Betweenness');
legend('Weighted (no interlayer)', 'Weighted (yes interlayer)', 'No weights (no interlayer)', 'No weights') % Setto e posiziono la legenda all'esterno del grafo
xlabel('Nodes');
ylabel('Values');

s = plot(g);
n = numnodes(g);
s.NodeCData = 2*bet_mn_w./((n-2)*(n-1));
colormap(jet)
colorbar
title('Betweenness Centrality Scores - Multilayer network weighted')

% Hub and authority scores
hub_ranks = centrality(g_power_grid, 'hubs', 'Importance', g_power_grid.Edges.Weight);
auth_ranks = centrality(g_power_grid, 'authorities', 'Importance', g_power_grid.Edges.Weight);
figure, bar(hub_ranks)
title('Hub scores')
figure, bar(auth_ranks)
title('Auth scores')

% PageRank centrality
pg_ranks = centrality(g, 'pagerank', 'Importance', g.Edges.Weight);
figure, bar(pg_ranks)
title('PageRank centrality')

% Calcolo del grado sulla matrice dicotomica
indegree_dicotomica = indegree(g_dicotomico);

% Distribuzione di grado
for i=1:n-1
    vettore(i)=sum(indegree_dicotomica==i)/n;
end
figure, bar(vettore)

% Densità della rete
density = (numedges(g))/((n*(n-1))/2);

% % Popolo e stampo grafico a barre
% figure, bar([clout_norm, clin_norm, betw_norm, gin_norm, gout_norm, indeg_norm_weighted, outdeg_norm_weighted], 'grouped') % Creo grafico a barre
% xlabel('Nodes');
% ylabel('Values');
% title('Centrality measurement (multilayer network)');
% labels = [namesBlue, namesRed];
% xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ...
%     20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]);
% xticklabels(labels)
% legend('outcloseness', 'incloseness', 'betweenness', 'indegree', 'outdegree', 'indegree(weighted)', 'outdegree(weighted)', 'Location', 'NorthEastOutside') % Setto e posiziono la legenda all'esterno del grafo
% 
% % Stampo un bar plot per ciascuna misura di centralità
% nomi_array = {'clout', 'clout_norm', 'clin', 'clin_norm', 'betw', 'betw_norm', 'gin', 'gin_norm', 'gout', 'gout_norm', 'indeg_column_weighted', 'indeg_norm_weighted', 'outdeg_column_weighted', 'outdeg_norm_weighted'};
% nomi_array_modified = {'betw_norm', 'betw_w', 'betw_w_norm'};
% 
% % Use this loop for multilayr network
% for i = 1:length(nomi_array_modified)
%     % Estrarre l'array corrente dal nome dell'array
%     nome_corrente = nomi_array_modified{i};
%     array_corrente = eval(nome_corrente);
%     figure, bar(array_corrente); % Creo grafico a barre
%     xlabel('Nodes');
%     ylabel(replace(nome_corrente, '_', '\_'));
%     title(['(Multilayer network) Bar plot of ', replace(nome_corrente, '_', '\_')]);
%     labels = [namesBlue, namesRed];
%     xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ...
%         20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]);
%     xticklabels(labels);
%     % Colora le ultime 7 barre di rosso
%     hold on;
%     for j = 25:31
%         h = bar(j, array_corrente(j));
%         h.FaceColor = 'r';
%     end
%     hold off;
%     legend('Power grid', 'Gas network', 'Location', 'NorthEastOutside');
% end

% Use this loop for power grid modelled as 1D graph
% for i = 1:length(nomi_array_modified)
%     % Estrarre l'array corrente dal nome dell'array
%     nome_corrente = nomi_array_modified{i};
%     array_corrente = eval(nome_corrente);
%     figure, bar(array_corrente); % Creo grafico a barre
%     xlabel('Nodes');
%     ylabel(replace(nome_corrente, '_', '\_'));
%     title(['(1D Graph) Bar plot of ', replace(nome_corrente, '_', '\_')]);
%     labels = [namesBlue];
%     xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ...
%         20, 21, 22, 23, 24]);
%     xticklabels(labels);
% end

% Use this loop for gas network modelled as 1D graph
% for i = 1:length(nomi_array_modified)
%     % Estrarre l'array corrente dal nome dell'array
%     nome_corrente = nomi_array_modified{i};
%     array_corrente = eval(nome_corrente);
%     figure, bar(array_corrente); % Creo grafico a barre
%     xlabel('Nodes');
%     ylabel(replace(nome_corrente, '_', '\_'));
%     title(['(1D Graph) Bar plot of ', replace(nome_corrente, '_', '\_')]);
%     labels = [namesRed];
%     xticks([1, 2, 3, 4, 5, 6, 7]);
%     xticklabels(labels);
%     % Colora le barre di rosso
%     hold on;
%     for j = 1:7
%         h = bar(j, array_corrente(j));
%         h.FaceColor = 'r';
%     end
%     hold off;
% end