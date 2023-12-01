load('C:\Users\rober\Desktop\SistemiMultiagente\Script_Matlab_Progetto\Roberto\ProgettoSistemiMultiagente\data_multienergy.mat')
% A = [2, 0.07, 1; 3, 0.09, 1.5; 3 0.08 1.84; 4, 0.11, 4.34; 3, 0.08, 0.84; 4, 0.1, 2.17; 4, 0.1 4.34; 3, 0.08 0.84];
ADM = [A_power, zeros(24, 7); A_interlayer, A_gas];
% Assegno un nome ad ogni nodo
namesBlue = (1:24) + " blue";
namesRed = [11 12 14 16 19 20 24] + " red";
% Graph of the whole network from A matrix
g = digraph(ADM, [namesBlue, namesRed]);

% Build MCDM (call function)
MCDM = obtainMCDM(g, ADM);
% Rank (call function)
rank =  ranking(MCDM);
rank = rank';

figure, bar(rank); % Creo grafico a barre
xlabel('Nodes');
ylabel('Rank');
labels = [namesBlue, namesRed];
xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ...
     20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]);
xticklabels(labels);
%grid on;
% Colora le ultime 7 barre di rosso
hold on;
for j = 25:31
    h = bar(j, rank(j));
    h.FaceColor = 'r';
end
hold off;
legend('Power grid', 'Gas network', 'Location', 'NorthEastOutside');

function MCDM = obtainMCDM(g, A)    
    % Valuto punteggio hub e autorità tramite il comando centrality
    hub_ranks_importance = centrality(g, 'hubs', 'Importance', g.Edges.Weight);
    hub_ranks_importance_norm = normalize(hub_ranks_importance, 'range', [0.1 1]);
    auth_ranks_importance = centrality(g, 'authorities', 'Importance', g.Edges.Weight);
    auth_ranks_importance_norm = normalize(auth_ranks_importance, 'range', [0.1 1]);
    hub_ranks = centrality(g, 'hubs');
    auth_ranks = centrality(g, 'authorities');
    
    % Calcolo la betweenness
    bet_mn_w = centrality(g, 'betweenness', 'Cost', 1./(g.Edges.Weight)); bet_mn_w = bet_mn_w/max(bet_mn_w); % Betweenness (yes weights)
    bet_mn_w_norm = normalize(bet_mn_w, 'range', [0.1 1]);
    % Calcolo le closeness
    closeout_mn = centrality(g, 'outcloseness'); closeout_mn = closeout_mn/max(closeout_mn); % Outcloseness
    closeout_mn_norm = normalize(closeout_mn, 'range', [0.1 1]);
    colsein_mn = centrality(g, 'incloseness'); colsein_mn = colsein_mn/max(colsein_mn); % Inclosenessù
    closein_mn_norm = normalize(colsein_mn, 'range', [0.1 1]);
    % Calcolo outdegree
    degreeout_mn = outdegree(g); degreeout_mn = degreeout_mn/max(degreeout_mn); % Outdegree
    degreeout_mn_norm = normalize(degreeout_mn, 'range', [0.1 1]);
    degreein_mn = indegree(g); degreein_mn = degreein_mn/max(degreein_mn); % Indegree
    degreein_mn_norm = normalize(degreein_mn, 'range', [0.1 1]);
    
    % Calcolo degree (weighted) e normalizzo
    n = size(A, 1); % Numero di nodi nel grafo
    indeg_weighted = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
    outdeg_weighted = zeros(1, n); % Inizializza l'array "indeg" a zero per contenere l'indegree di tutti i nodi
    for i = 1:n
        indeg_weighted(i) = sum(A(:, i)); % Calcola l'indegree del nodo "i" e salvalo nell'array "indeg"
        outdeg_weighted(i) = sum(A(i, :)); % Calcola la weighted outdegree del nodo "i" e salvala nell'array "outdeg_weighted"
    end
    indeg_column_weighted = reshape(indeg_weighted, [], 1);
    indeg_norm_weighted = normalize(indeg_column_weighted, 'range', [0.1 1]);
    outdeg_column_weighted = reshape(outdeg_weighted, [], 1);
    outdeg_norm_weighted = normalize(outdeg_column_weighted, 'range', [0.1 1]);
    
    % Set multi criteria decision matrix
    MCDM = cat(2, bet_mn_w_norm, outdeg_norm_weighted, closeout_mn_norm, closein_mn_norm, auth_ranks_importance_norm, hub_ranks_importance_norm);
end

function HCUNodeRank = ranking(A)
    [n_rows, n_coloumns] = size(A);

    % Matrix A normalized
    for i=1:n_rows
        for j=1:n_coloumns
            % Normalization of MCDM
            colonna = A(:, j);
            somma_quadrati = sum(colonna .^ 2);
            A_norm(i,j) = A(i,j)/(sqrt(somma_quadrati));
        end
    end
    %A_norm = round(A_norm, 2);
    
    % Computation of weight for each centrality criterion
    for i=1:n_rows
        for j=1:n_coloumns
            Inf_Ent(i,j) = A_norm(i,j)/(sum(A_norm(:, j)));
        end
    end
    %Inf_Ent = round(Inf_Ent, 2);
    
    % Computation of information entropy for each centrality criterion
    for j=1:n_coloumns
        sum_1 = 0;
        for i=1:n_rows
            term = Inf_Ent(i,j)*log(Inf_Ent(i,j));
            sum_1 = sum_1 + term;
        end
        IE(j) = -(1/log(10))*sum_1;
    end
    
    %IE = [1.24, 1.25, 1.08];
    
    % Computation of weight of a centrality criterion
    for j=1:n_coloumns
        disp(j)
        riga = 1-IE;
        WT(j) = (1-IE(j))/(sum(riga));
    end
    %WT = round(WT, 2);
    
    % Obtain weighted centrality matrix
    for j=1:n_coloumns
        for i=1:n_rows
            W(i,j) = A_norm(i,j) * WT(j);
        end
    end
    %W = round(W, 2);
    
    % Computation of ideal positive and ideal negative solutions
    for j=1:n_coloumns
        V_positive(j) = (max(W(:, j)));
        V_negative(j) = (min(W(:, j)));
    end
    
    % Computation of separation measures
    
    for i=1:n_rows
            S_positive(i) = norm(W(i, :) - V_positive);
            S_negative(i) = norm(W(i, :) - V_negative);
    end
    %S_positive = round(S_positive, 2);
    %S_negative = round(S_negative, 2);
    
    % Obtain HCURank
    for i=1:n_rows
        HCUNodeRank(i) = S_negative(i)/(S_positive(i)+S_negative(i));
    end
end
