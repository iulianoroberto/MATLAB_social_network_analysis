% Creare un oggetto digraph utilizzando la matrice di adiacenza A_power
G = digraph(A_power);

% Calcolare la larghezza degli archi come proporzionale ai pesi degli archi
edge_widths = 10 * G.Edges.Weight / max(G.Edges.Weight);

% Visualizzare il grafo utilizzando la funzione plot e specificando la larghezza degli archi
figure, plot(G, 'LineWidth', edge_widths);

% Creare un oggetto digraph utilizzando la matrice di adiacenza A_power
G2 = digraph(A_gas);

% Calcolare la larghezza degli archi come proporzionale ai pesi degli archi
edge_widths = 10 * G2.Edges.Weight / max(G2.Edges.Weight);

% Visualizzare il grafo utilizzando la funzione plot e specificando la larghezza degli archi
figure, plot(G2, 'LineWidth', edge_widths);

