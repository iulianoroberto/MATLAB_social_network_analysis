% Assegno delle etichette a ogni nodo
namesBlue = (1:24)+" blue"; % I nodi della rete elettrica li contrassegno come "blue"
namesRed = [11 12 14 16 19 20 24]+" red"; % Quelli della rete di gas come "red"G.Nodes.GeneratoreElettrico(1) = '1';

% Combino le matrici di adiacenza
A = [A_power, zeros(24, 7); A_interlayer, A_gas]; % Unisco A_power (24x24) con una matrice di zeri 24x7 e ottengo una matrice 24x31. Poi unisco A_intralayer (7x24) con A_gas (7x7) e ootengo una matrice 7x31. Infine unisco queste due matrici ottenento una matrice A 31x31.
G = digraph(A, [namesBlue, namesRed]); % Creo un oggetto "directed graph" (grafo orientato) utilizzando A e le atichette definite prima.

% Compute the betweenness
bet_mn_w = centrality(G, 'betweenness', 'Cost', 1./(G.Edges.Weight)); bet_mn_w = bet_mn_w/max(bet_mn_w); % Betweenness (yes weights)

% Compute the closeness
closeout_mn = centrality(G, 'outcloseness'); closeout_mn = closeout_mn/max(closeout_mn); % Outcloseness
closein_mn = centrality(G, 'incloseness'); closein_mn = closein_mn/max(closein_mn); % Incloseness
 
% Calcolo degree e normalizzo
gin = indegree(G);
gin_norm = gin / max(gin);
gout = outdegree(G);
gout_norm = gout / max(gout);

% Calcolo degree (weighted) e normalizzo
n = size(A, 1); % Numero di nodi nel grafo
indeg_weighted = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
outdeg_weighted = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
for i = 1:n
    indeg_weighted(i) = sum(A(:, i)); % Calcola l'indegree del nodo "i" e salvalo nell'array "indeg"
    outdeg_weighted(i) = sum(A(i, :)); % Calcola la weighted outdegree del nodo "i" e salvala nell'array "outdeg_weighted"
end
indeg_column_weighted = reshape(indeg_weighted, [], 1); indeg_column_weighted_norm = normalize(indeg_column_weighted, 'range', [0 1]);
outdeg_column_weighted = reshape(outdeg_weighted, [], 1); outdeg_column_weighted_norm = normalize(outdeg_column_weighted, 'range', [0 1]);

% Valuto punteggio hub e autorità tramite il comando centrality
hub_ranks_importance = centrality(G, 'hubs', 'Importance', G.Edges.Weight);
auth_ranks_importance = centrality(G, 'authorities', 'Importance', G.Edges.Weight);
hub_ranks = centrality(G, 'hubs');
auth_ranks = centrality(G, 'authorities');

% Give labels to nodes
G.Nodes.GeneratoreElettrico(1) = '1';
G.Nodes.CaricoElettrico(1) = '1';
G.Nodes.GeneratoreGas(1) = '0';
G.Nodes.CaricoGas(1) = '0';
G.Nodes.GeneratoreElettrico(2) = '1';
G.Nodes.CaricoElettrico(2) = '1';
G.Nodes.GeneratoreGas(2) = '0';
G.Nodes.CaricoGas(2) = '0';
G.Nodes.GeneratoreElettrico(3) = '0';
G.Nodes.CaricoElettrico(3) = '1';
G.Nodes.GeneratoreGas(3) = '0';
G.Nodes.CaricoGas(3) = '0';
G.Nodes.GeneratoreElettrico(4) = '0';
G.Nodes.CaricoElettrico(4) = '1';
G.Nodes.GeneratoreGas(4) = '0';
G.Nodes.CaricoGas(4) = '0';
G.Nodes.GeneratoreElettrico(5) = '0';
G.Nodes.CaricoElettrico(5) = '1';
G.Nodes.GeneratoreGas(5) = '0';
G.Nodes.CaricoGas(5) = '0';
G.Nodes.GeneratoreElettrico(6) = '0';
G.Nodes.CaricoElettrico(6) = '1';
G.Nodes.GeneratoreGas(6) = '0';
G.Nodes.CaricoGas(6) = '0';
G.Nodes.GeneratoreElettrico(7) = '1';
G.Nodes.CaricoElettrico(7) = '1';
G.Nodes.GeneratoreGas(7) = '0';
G.Nodes.CaricoGas(7) = '0';
G.Nodes.GeneratoreElettrico(8) = '0';
G.Nodes.CaricoElettrico(8) = '1';
G.Nodes.GeneratoreGas(8) = '0';
G.Nodes.CaricoGas(8) = '0';
G.Nodes.GeneratoreElettrico(9) = '0';
G.Nodes.CaricoElettrico(9) = '1';
G.Nodes.GeneratoreGas(9) = '0';
G.Nodes.CaricoGas(9) = '0';
G.Nodes.GeneratoreElettrico(10) = '0';
G.Nodes.CaricoElettrico(10) = '1';
G.Nodes.GeneratoreGas(10) = '0';
G.Nodes.CaricoGas(10) = '0';
G.Nodes.GeneratoreElettrico(11) = '0';
G.Nodes.CaricoElettrico(11) = '0';
G.Nodes.GeneratoreGas(11) = '0';
G.Nodes.CaricoGas(11) = '0';
G.Nodes.GeneratoreElettrico(12) = '0';
G.Nodes.CaricoElettrico(12) = '0';
G.Nodes.GeneratoreGas(12) = '0';
G.Nodes.CaricoGas(12) = '0';
G.Nodes.GeneratoreElettrico(13) = '1';
G.Nodes.CaricoElettrico(13) = '1';
G.Nodes.GeneratoreGas(13) = '0';
G.Nodes.CaricoGas(13) = '0';
G.Nodes.GeneratoreElettrico(14) = '0';
G.Nodes.CaricoElettrico(14) = '1';
G.Nodes.GeneratoreGas(14) = '0';
G.Nodes.CaricoGas(14) = '0';
G.Nodes.GeneratoreElettrico(15) = '1';
G.Nodes.CaricoElettrico(15) = '1';
G.Nodes.GeneratoreGas(15) = '0';
G.Nodes.CaricoGas(15) = '0';
G.Nodes.GeneratoreElettrico(16) = '1';
G.Nodes.CaricoElettrico(16) = '1';
G.Nodes.GeneratoreGas(16) = '0';
G.Nodes.CaricoGas(16) = '0';
G.Nodes.GeneratoreElettrico(17) = '0';
G.Nodes.CaricoElettrico(17) = '0';
G.Nodes.GeneratoreGas(17) = '0';
G.Nodes.CaricoGas(17) = '0';
G.Nodes.GeneratoreElettrico(18) = '1';
G.Nodes.CaricoElettrico(18) = '1';
G.Nodes.GeneratoreGas(18) = '0';
G.Nodes.CaricoGas(18) = '0';
G.Nodes.GeneratoreElettrico(19) = '0';
G.Nodes.CaricoElettrico(19) = '1';
G.Nodes.GeneratoreGas(19) = '0';
G.Nodes.CaricoGas(19) = '0';
G.Nodes.GeneratoreElettrico(20) = '0';
G.Nodes.CaricoElettrico(20) = '1';
G.Nodes.GeneratoreGas(20) = '0';
G.Nodes.CaricoGas(20) = '0';
G.Nodes.GeneratoreElettrico(21) = '1';
G.Nodes.CaricoElettrico(21) = '0';
G.Nodes.GeneratoreGas(21) = '0';
G.Nodes.CaricoGas(21) = '0';
G.Nodes.GeneratoreElettrico(22) = '1';
G.Nodes.CaricoElettrico(22) = '0';
G.Nodes.GeneratoreGas(22) = '0';
G.Nodes.CaricoGas(22) = '0';
G.Nodes.GeneratoreElettrico(23) = '1';
G.Nodes.CaricoElettrico(23) = '0';
G.Nodes.GeneratoreGas(23) = '0';
G.Nodes.CaricoGas(23) = '0';
G.Nodes.GeneratoreElettrico(24) = '0';
G.Nodes.CaricoElettrico(24) = '0';
G.Nodes.GeneratoreGas(24) = '0';
G.Nodes.CaricoGas(24) = '0';
G.Nodes.GeneratoreElettrico(25) = '1'; %11 Gas
G.Nodes.CaricoElettrico(25) = '0';
G.Nodes.GeneratoreGas(25) = '0';
G.Nodes.CaricoGas(25) = '1';
G.Nodes.GeneratoreElettrico(26) = '0'; %12 Gas
G.Nodes.CaricoElettrico(26) = '0';
G.Nodes.GeneratoreGas(26) = '1';
G.Nodes.CaricoGas(26) = '0';
G.Nodes.GeneratoreElettrico(27) = '1'; %14 Gas
G.Nodes.CaricoElettrico(27) = '0';
G.Nodes.GeneratoreGas(27) = '0';
G.Nodes.CaricoGas(27) = '1';
G.Nodes.GeneratoreElettrico(28) = '1'; %16 Gas
G.Nodes.CaricoElettrico(28) = '0';
G.Nodes.GeneratoreGas(28) = '1';
G.Nodes.CaricoGas(28) = '1';
G.Nodes.GeneratoreElettrico(29) = '1'; %19 Gas
G.Nodes.CaricoElettrico(29) = '0';
G.Nodes.GeneratoreGas(29) = '0';
G.Nodes.CaricoGas(29) = '1';
G.Nodes.GeneratoreElettrico(30) = '1'; %20 Gas
G.Nodes.CaricoElettrico(30) = '0';
G.Nodes.GeneratoreGas(30) = '1';
G.Nodes.CaricoGas(30) = '1';
G.Nodes.GeneratoreElettrico(31) = '1'; %24 Gas
G.Nodes.CaricoElettrico(31) = '0';
G.Nodes.GeneratoreGas(31) = '0';
G.Nodes.CaricoGas(31) = '1';

for i=1:size(G.Nodes)
    absorbed_power(i) = indeg_column_weighted(i)-outdeg_column_weighted(i);
end

% La formula che voglio implementare è questa:
%
%  ρ_d=((j_X)^2 * (K_X - μ_X) + (j_Y)^2 * (K_Y - μ_Y))/(2 * M * σ_X * σ_Y)
%
% Con:
%
% - j_X è il valore della misura di centralità X per il nodo j;
% - j_Y è il valore della misura di centralità Y per il nodo j;
% - K_X è la media della misura di centralità X dei nodi puntati dal nodo j;
% - K_Y è la media della misura di centralità Y dei nodi che puntano al nodo j;
% - μ_X è la media della misura di centralità X considerando tutti i nodi del grafo;
% - μ_Y è la media della misura di centralità Y considerando tutti i nodi del grafo;
% - M è il numero di archi del grafo;
% - σ_X è la deviazione standard della misura di centralità X;
% - σ_Y è la deviazione standard della misura di centralità Y.

% Scelta delle misure di centralità
X = outdeg_column_weighted;
Y = indeg_column_weighted;

% Numero di archi del grafo
M = numedges(G);

% Media della misure di centralità X
buffer_0 = 0; vector_0 = [];
for i=1:size(G.Edges)
    source_node = string(G.Edges.EndNodes(i,1));
    id_source_node = find(G.Nodes.Name == source_node);
    buffer_0 = buffer_0 + Y(id_source_node);
    vector_0 = [vector_0, Y(id_source_node)];
end
mu_q_in = buffer_0/M;

% Media della misure di centralità Y
buffer_1 = 0; vector_1 = [];
for i=1:size(G.Edges)
    source_node = string(G.Edges.EndNodes(i,1));
    id_source_node = find(G.Nodes.Name == source_node);
    buffer_1 = buffer_1 + X(id_source_node);
    vector_1 = [vector_1, X(id_source_node)];
end
mu_q_out = buffer_1/M;

% Deviazione standard delle misure di centralità X e Y
sigma_in = std(vector_0);
sigma_out = std(vector_1);

% Creazione vettore che ospiterà i valori di assortatività locale ρ_d per ciascun nodo
rho_d = [];

% Calcolo dell'assortatività locale per ciascun nodo j∈V.
for j = 1:size(G.Nodes)
    neighbors_from = [];
    neighbors_to = [];
    for i = 1:size(G.Edges)
        % Individuo i nodi che puntano al nodo considerato
        if string(G.Edges.EndNodes(i,2)) == string(G.Nodes.Name(j))
            index_from = find(G.Nodes.Name == string(G.Edges.EndNodes(i,1)));
            neighbors_from = [neighbors_from, Y(index_from)];
        end
        % Individuo i nodi puntati dal nodo considerato
        if string(G.Edges.EndNodes(i,1)) == string(G.Nodes.Name(j))
            index_to = find(G.Nodes.Name == string(G.Edges.EndNodes(i,2)));
            neighbors_to = [neighbors_to, X(index_to)];
        end
    end
    
    % Calcolo j_in e j_out
    if size(neighbors_from) ~= 0
        j_in = mean(neighbors_from);
    else
        j_in = 0;
    end
    if size(neighbors_to) ~= 0
        j_out = mean(neighbors_to);
    else
        j_out = 0;
    end
    
    % Calcola ρ_d per il nodo j.
    rho_d = [rho_d ((X(j)^2 * (j_in - mu_q_in) + Y(j)^2 * (j_out - mu_q_out)) / (2 * M * sigma_in * sigma_out))];
    
end

% Trasformo da vettore riga a colonna perché è più leggibile
rho_d = rho_d';
rho_d_norm = normalize(rho_d, 'range', [-10 10]);