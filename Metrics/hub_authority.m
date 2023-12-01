% Calcolo la matrice A
A = [A_power, zeros(24, 7); A_interlayer, A_gas];
A_binaria = A ~= 0; % Matrice dicotomica associata ad A

% Creo il grafo dalla matrice di adiacenza
G = digraph(A);

% Valuto punteggio hub e autorità tramite il comando centrality
hub_ranks_importance = centrality(G, 'hubs', 'Importance', G.Edges.Weight);
auth_ranks_importance = centrality(G, 'authorities', 'Importance', G.Edges.Weight);
hub_ranks = centrality(G, 'hubs');
auth_ranks = centrality(G, 'authorities');

% Calcolo matrice di cocitazione A*A^T
COCIT = A*(A'); 
% Calcolo matrice di accoppiamneto bibliografico A^T*A
ABIBLIO = (A')*A;

% Calcolo autovalori e autovettori delle due matrici
% Returns diagonal matrix D of eigenvalues and matrix V whose columns are 
% the corresponding right eigenvectors, so that A*V = V*D.
[V_COCIT,D_COCIT] = eig(COCIT);
[V_ABIBLIO,D_ABIBLIO] = eig(ABIBLIO);

% Calcolo sonlo alcuni degli autovalori
[V1,D] = eigs(COCIT,1,'LM'); % compute the largest magnitude eigenvalue
dominant_eigenvalue = D(1,1);

% Individuo l'autovalore dominante della matrice di cocitazione
% rho indica il valore dell'autovalore mentre la variabile ind contiene
% l'indice della posizione dell'autovalore nella matrice diagonale degli
% autovalori
[rho_COCIT,ind_COCIT] = max(diag(abs(D_COCIT)));
[rho_ABIBLIO,ind_ABIBLIO] = max(diag(abs(D_ABIBLIO)));

% Autovettore dominante della matrice di cocitazione
% Individuo l'autovettore dominante della matrice di cocitazione tramite
% l'idnice ind individuato in precedenza
dominant_eigenvector_COCIT = V_COCIT(:,ind_COCIT);
dominant_eigenvector_ABIBLIO= V_ABIBLIO(:,ind_ABIBLIO);

% Normalizzo gli elementi dell'autovettore dominante facendo in modo che la
% somma delle sue componenti sia pari a 1
for i=1:length(dominant_eigenvector_COCIT)
    dominant_eigenvector_norm_COCIT(i)=dominant_eigenvector_COCIT(i)/sum(dominant_eigenvector_COCIT);
    dominant_eigenvector_norm_ABIBLIO(i)=dominant_eigenvector_ABIBLIO(i)/sum(dominant_eigenvector_ABIBLIO);
end

% CENTRALITA' DI HUB --> AUT. DOM. MATRICE DI COCITAZIONE
% CENTRALITA' DI AUTORITA' --> AUT. DOM. MATRICE DI ACCOPPIAMENTO BIBLIOGRAFICO

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

% Assegno un nome ad ogni nodo
namesBlue = (1:24) + " blue";
namesRed = [11 12 14 16 19 20 24] + " red";

figure;

matrice_orizzontale_hub = horzcat(hub_ranks_importance, hub_ranks);
subplot(2, 1, 1);
bar(matrice_orizzontale_hub);
title('Hub ranks')
labels = [namesBlue, namesRed];
xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]);
xticklabels(labels);
title('Hub scores')
legend('Importance','No importance')

matrice_orizzontale_autority = horzcat(auth_ranks_importance, auth_ranks);
subplot(2, 1, 2);
bar(matrice_orizzontale_autority);
labels = [namesBlue, namesRed];
xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]);
xticklabels(labels);
title('Authority scores')
legend('Importance','No importance')

% Seleziona i pesi degli archi
pesi_archi = G.Edges.Weight;

figure;
subplot(1, 2, 1);
p = plot(G);
colormap jet
p.NodeCData = hub_ranks;
h = colorbar;
h.Label.String = "Hub score";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
title('Hub ranks')
% Imposta la dimensione dei nodi
p.MarkerSize = outdeg_column_weighted+2;
% Imposta la larghezza degli archi proporzionale ai pesi
p.LineWidth = 5*pesi_archi/max(pesi_archi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1, 2, 2);
p = plot(G);
colormap jet
p.NodeCData = hub_ranks_importance;
h = colorbar;
h.Label.String = "Hub score";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
title('Hub ranks (importance)')
% Imposta la dimensione dei nodi
p.MarkerSize = outdeg_column_weighted+2;
% Imposta la larghezza degli archi proporzionale ai pesi
p.LineWidth = 5*pesi_archi/max(pesi_archi);

figure;
subplot(1, 2, 1);
f2 = plot(G);
colormap jet
f2.NodeCData = auth_ranks;
f2.NodeLabel = string([1:24 11 12 14 16 19 20 24]);
h = colorbar;
h.Label.String = "Authority score";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
title('Authority ranks')
% Imposta la dimensione dei nodi
f2.MarkerSize = 7;
f2.MarkerSize = indeg_column_weighted+2;
% Imposta la larghezza degli archi proporzionale ai pesi
f2.LineWidth = 5*pesi_archi/max(pesi_archi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1, 2, 2);
f2 = plot(G);
colormap jet
f2.NodeCData = auth_ranks_importance;
f2.NodeLabel = string([1:24 11 12 14 16 19 20 24]);
h = colorbar;
h.Label.String = "Authority score";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
title('Authority ranks (importance)')
% Imposta la dimensione dei nodi
f2.MarkerSize = 7;
f2.MarkerSize = indeg_column_weighted+2;
% Imposta la larghezza degli archi proporzionale ai pesi
f2.LineWidth = 5*pesi_archi/max(pesi_archi);

figure;
subplot(2, 1, 1);
scatter(indeg_column_weighted,hub_ranks_importance,[],outdeg_column_weighted,'filled')
h = colorbar;
h.Label.String = "Weighted otdegree";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
colormap jet
xlabel('Weighted indegree')
ylabel('Hub scores (importance)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2, 1, 2);
scatter(indeg_column_weighted,auth_ranks_importance,[],outdeg_column_weighted,'filled')
h = colorbar;
h.Label.String = "Weighted otdegree";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
colormap jet
xlabel('Weighted indegree')
ylabel('Authority scores (importance)')


D1 = hub_ranks_importance';
D2 = outdeg_norm_weighted';
D3 = auth_ranks_importance';
D4 = indeg_norm_weighted';
P = [D1; D2; D3; D4];
figure;
% Spider plot
s = spider_plot_class(P);

s.AxesLimits = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
s.AxesZero = 'off';
s.MinorGrid = 'off';
s.AxesScaling = 'linear';
s.AxesDisplay = 'one';
s.Marker = 'none';
s.FillOption = 'on';
s.FillTransparency = 0.1;
s.LegendLabels = {'Hub score', 'Weighted outdegree', 'Authority score', 'Weighted indegree'};
