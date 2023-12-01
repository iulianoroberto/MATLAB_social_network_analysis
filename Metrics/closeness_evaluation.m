% Naming of the nodes
namesBlue = (1:24)+" blue";
namesRed = [11 12 14 16 19 20 24]+" red";

% Combine matrix
A = [A_power, zeros(24, 7); A_interlayer, A_gas];
g = digraph(A, [namesBlue, namesRed]); % Graph of the whole network from A matrix

% Matrice dicotomica
A_dicotomica = A ~= 0;
g_dicotomico = digraph(A_dicotomica, [namesBlue, namesRed]);

numero_archi_esistenti = numedges(g_dicotomico);

% Delete interlayer edges
A_modified = A;
A_modified(25, 11) = 0;
A_modified(27, 14) = 0;
A_modified(28, 16) = 0;
A_modified(29, 19) = 0;
A_modified(30, 20) = 0;
A_modified(31, 24) = 0;
g_modified = digraph(A_modified, [namesBlue, namesRed]); % Graph of the network without interlayer edges

% Evaluation of closeness
%outcloseness_array = centrality(g, 'outcloseness', 'Cost', 1./(g.Edges.Weight));
%outcloseness_array = centrality(g_dicotomico, 'outcloseness');
incloseness_array_W = centrality(g, 'incloseness', 'Cost', 1./(g.Edges.Weight));
incloseness_array_UW = centrality(g_dicotomico, 'incloseness');

incloseness_array_W = normalize(incloseness_array_W, 'range', [0 1]);
incloseness_array_UW = normalize(incloseness_array_UW, 'range', [0 1]);

% Creazione dello scatterplot
scatter(incloseness_array_W, incloseness_array_UW);

% Calcolo del coefficiente di correlazione utilizzando corr
correlation_coefficient = corr(incloseness_array_W, incloseness_array_UW);
disp(['Il coefficiente di correlazione è: ', num2str(correlation_coefficient)]);

% Representation
figure, bar(incloseness_array); % Creo grafico a barre
xlabel('Nodes');
ylabel('Incloseness');
title('(Multilayer network) Bar plot of incloseness');
labels = [namesBlue, namesRed];
xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]);
xticklabels(labels);
% Colora le ultime 7 barre di rosso
hold on;
for j = 25:31
    h = bar(j, incloseness_array(j));
    h.FaceColor = 'r';
end
hold off;
legend('Power grid', 'Gas network', 'Location', 'NorthEastOutside');