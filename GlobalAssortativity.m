load('C:\Users\rober\Desktop\SistemiMultiagente\Script_Matlab_Progetto\Roberto\ProgettoSistemiMultiagente\data_multienergy.mat')
% Assegno delle etichette a ogni nodo
namesBlue = (1:24)+" blue"; % I nodi della rete elettrica li contrassegno come "blue"
namesRed = [11 12 14 16 19 20 24]+" red"; % Quelli della rete di gas come "red"G.Nodes.GeneratoreElettrico(1) = '1';

% Combino le matrici di adiacenza
A = [A_power, zeros(24, 7); A_interlayer, A_gas]; % Unisco A_power (24x24) con una matrice di zeri 24x7 e ottengo una matrice 24x31. Poi unisco A_intralayer (7x24) con A_gas (7x7) e ootengo una matrice 7x31. Infine unisco queste due matrici ottenento una matrice A 31x31.
G = digraph(A, [namesBlue, namesRed]); % Creo un oggetto "directed graph" (grafo orientato) utilizzando A e le atichette definite prima.

% Valuto punteggio hub e autorità tramite il comando centrality
hub_ranks_importance = centrality(G, 'hubs', 'Importance', G.Edges.Weight);
auth_ranks_importance = centrality(G, 'authorities', 'Importance', G.Edges.Weight);
hub_ranks = centrality(G, 'hubs');
auth_ranks = centrality(G, 'authorities');

% Compute the betweenness
bet_mn_w = centrality(G, 'betweenness', 'Cost', 1./(G.Edges.Weight)); bet_mn_w = bet_mn_w/max(bet_mn_w); % Betweenness (yes weights)

% Compute the closeness
closeout_mn = centrality(G, 'outcloseness', 'Cost', 1./(G.Edges.Weight)); closeout_mn = closeout_mn/max(closeout_mn); % Outcloseness
colsein_mn = centrality(G, 'incloseness', 'Cost', 1./(G.Edges.Weight)); colsein_mn = colsein_mn/max(colsein_mn); % Incloseness

% Calcolo degree (weighted) e normalizzo
n = size(A, 1); % Numero di nodi nel grafo
indeg_weighted = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
outdeg_weighted = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
for i = 1:n
    indeg_weighted(i) = sum(A(:, i)); % Calcola l'indegree del nodo "i" e salvalo nell'array "indeg"
    outdeg_weighted(i) = sum(A(i, :)); % Calcola la weighted outdegree del nodo "i" e salvala nell'array "outdeg_weighted"
end
indeg_column_weighted = reshape(indeg_weighted, [], 1); indeg_column_weighted = normalize(indeg_column_weighted, 'range', [0 1]);
outdeg_column_weighted = reshape(outdeg_weighted, [], 1); outdeg_column_weighted = normalize(outdeg_column_weighted, 'range', [0 1]);

% Calcolo degree e normalizzo
gin = indegree(G);
gout = outdegree(G); 

% SET THE FEATURES
rho = assortativity_coefficient(G, bet_mn_w, bet_mn_w); % Invoke function

% This function computing assortativity
function rho = assortativity_coefficient(G, feature_X, feature_Y)
    % Calcolo peso totale
    W = sum(G.Edges.Weight);
    
    % Term pre-computing
    buffer_1 = 0; buffer_2 = 0;
    for i=1:size(G.Edges) 
        buffer_1 = buffer_1 + ((G.Edges.Weight(i) * feature_X(G.Nodes.Name == string(G.Edges.EndNodes(i))))/W);
        buffer_2 = buffer_2 + ((G.Edges.Weight(i) * feature_Y(G.Nodes.Name == string(G.Edges.EndNodes(i,2))))/W);
    end
    X_source_av = buffer_1;
    Y_target_av = buffer_2;

    buffer_3 = 0; buffer_4 = 0;
    for i=1:size(G.Edges)
        buffer_3 = buffer_3 + ((G.Edges.Weight(i) * (feature_X(G.Nodes.Name == string(G.Edges.EndNodes(i))) - X_source_av)^2)/W);
        buffer_4 = buffer_4 + ((G.Edges.Weight(i) * (feature_Y(G.Nodes.Name == string(G.Edges.EndNodes(i,2))) - Y_target_av)^2)/W);
    end
    Sigma_x = sqrt(buffer_3);
    Sigma_y = sqrt(buffer_4);
    
    % Final computing
    buffer_5 = 0;
    for i=1:size(G.Edges)
        buffer_5 = buffer_5 + (G.Edges.Weight(i) * (feature_X(G.Nodes.Name == string(G.Edges.EndNodes(i))) - X_source_av) * (feature_Y(G.Nodes.Name == string(G.Edges.EndNodes(i,2))) - Y_target_av));
    end
    rho = buffer_5/(W*Sigma_x*Sigma_y);
end

% This function give labels to nodes
function nodes_labelling
    G.Nodes.GeneratoreElettrico(1) = '1';
    G.Nodes.CaricoElettrico(1) = '1';
    G.Nodes.GeneratoreGas(1) = '0';
    G.Nodes.CaricoGas(1) = '0';
    G.Nodes.GeneratoreElettrico(2) = '1';
    G.Nodes.CaricoElettrico(2) = '1';
    G.Nodes.GeneratoreGas(2) = '0';
    G.Nodes.CaricoGas(2) = '0';
    G.Nodes.GeneratoreElettrico(3) = '1';
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
    G.Nodes.CaricoElettrico(7) = '0';
    G.Nodes.GeneratoreGas(7) = '0';
    G.Nodes.CaricoGas(7) = '0';
    G.Nodes.GeneratoreElettrico(8) = '0';
    G.Nodes.CaricoElettrico(8) = '1';
    G.Nodes.GeneratoreGas(8) = '0';
    G.Nodes.CaricoGas(8) = '0';
    G.Nodes.GeneratoreElettrico(9) = '1';
    G.Nodes.CaricoElettrico(9) = '1';
    G.Nodes.GeneratoreGas(9) = '0';
    G.Nodes.CaricoGas(9) = '0';
    G.Nodes.GeneratoreElettrico(10) = '1';
    G.Nodes.CaricoElettrico(10) = '1';
    G.Nodes.GeneratoreGas(10) = '0';
    G.Nodes.CaricoGas(10) = '0';
    G.Nodes.GeneratoreElettrico(11) = '1';
    G.Nodes.CaricoElettrico(11) = '1';
    G.Nodes.GeneratoreGas(11) = '0';
    G.Nodes.CaricoGas(11) = '0';
    G.Nodes.GeneratoreElettrico(12) = '1';
    G.Nodes.CaricoElettrico(12) = '1';
    G.Nodes.GeneratoreGas(12) = '0';
    G.Nodes.CaricoGas(12) = '0';
    G.Nodes.GeneratoreElettrico(13) = '1';
    G.Nodes.CaricoElettrico(13) = '1';
    G.Nodes.GeneratoreGas(13) = '0';
    G.Nodes.CaricoGas(13) = '0';
    G.Nodes.GeneratoreElettrico(14) = '1';
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
    G.Nodes.GeneratoreElettrico(17) = '1';
    G.Nodes.CaricoElettrico(17) = '1';
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
    G.Nodes.GeneratoreElettrico(20) = '1';
    G.Nodes.CaricoElettrico(20) = '1';
    G.Nodes.GeneratoreGas(20) = '0';
    G.Nodes.CaricoGas(20) = '0';
    G.Nodes.GeneratoreElettrico(21) = '1';
    G.Nodes.CaricoElettrico(21) = '1';
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
    G.Nodes.GeneratoreElettrico(24) = '1';
    G.Nodes.CaricoElettrico(24) = '1';
    G.Nodes.GeneratoreGas(24) = '0';
    G.Nodes.CaricoGas(24) = '0';
    G.Nodes.GeneratoreElettrico(25) = '1'; %11 Gas
    G.Nodes.CaricoElettrico(25) = '0';
    G.Nodes.GeneratoreGas(25) = '0';
    G.Nodes.CaricoGas(25) = '1';
    G.Nodes.GeneratoreElettrico(26) = '0'; %12 Gas
    G.Nodes.CaricoElettrico(26) = '0';
    G.Nodes.GeneratoreGas(26) = '1';
    G.Nodes.CaricoGas(26) = '1';
    G.Nodes.GeneratoreElettrico(27) = '1'; %14 Gas
    G.Nodes.CaricoElettrico(27) = '0';
    G.Nodes.GeneratoreGas(27) = '1';
    G.Nodes.CaricoGas(27) = '1';
    G.Nodes.GeneratoreElettrico(28) = '1'; %16 Gas
    G.Nodes.CaricoElettrico(28) = '0';
    G.Nodes.GeneratoreGas(28) = '1';
    G.Nodes.CaricoGas(28) = '0';
    G.Nodes.GeneratoreElettrico(29) = '1'; %19 Gas
    G.Nodes.CaricoElettrico(29) = '0';
    G.Nodes.GeneratoreGas(29) = '1';
    G.Nodes.CaricoGas(29) = '1';
    G.Nodes.GeneratoreElettrico(30) = '1'; %20 Gas
    G.Nodes.CaricoElettrico(30) = '0';
    G.Nodes.GeneratoreGas(30) = '1';
    G.Nodes.CaricoGas(30) = '0';
    G.Nodes.GeneratoreElettrico(31) = '1'; %24 Gas
    G.Nodes.CaricoElettrico(31) = '0';
    G.Nodes.GeneratoreGas(31) = '0';
    G.Nodes.CaricoGas(31) = '1';
    end










