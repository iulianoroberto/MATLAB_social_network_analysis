% Assegno un'etichetta ad ogni nodo
namesBlue = (1:24) + " blue";
namesRed = [11 12 14 16 19 20 24] + " red";

A = [A_power, zeros(24, 7); A_interlayer, A_gas]; % Combino le matrici di adiacenza
g = digraph(A, [namesBlue, namesRed]); % Creo il grafo diretto a partire da A

A_dicotomica = A ~= 0; % Ottengo la matrice dicotomica a partire da A
g_dicotomico = digraph(A_dicotomica, [namesBlue, namesRed]); % Ottengo il grafo g dalla matrice dicotomica

% Valuto il grado di ingresso sul grafo generato a partire dalla matrice
% dicotomica
gradi_ingresso = indegree(g_dicotomico);
gradi_uscita = outdegree(g_dicotomico);

% Calcolo il grado di ingresso sommando gli elementi della matrice
% dicotomica di ciascuna colonna. Si ricorda che per un grafo diretto il
% grado di ingresso di un nodo i è dato dalla somma della i-esima colonna
% della matrice di adiacenza.
teta_in = sum(A_dicotomica, 1);
teta_out = sum(A_dicotomica, 2); % Sommo per righe (grado di uscita)

% Valuto il grado come somma dei pesi degli archi (in ingresso e in uscita)
teta_in_w = sum(A, 1);
teta_out_w = sum(A, 2); % Sommo per righe (grado di uscita)

n = 31; % Numero di nodi del grafo.
for i=0:n-1 
    % Calcolo la distribuzione di grado in ingresso per teta uguale ad i, 
    % la calcolo sommando tutti i valori di teta uguali a i e dividendo per
    % il numero totale di nodi del grafo. Il vettore p conterrà tutti i 
    % valori della distribuzione di grado di ingresso.
    p_in(i+1) = sum(teta_in==i)/n;
    p_out(i+1) = sum(teta_out==i)/n;
end
figure, bar(p_in) % Stampo la distribuzione di grad di ingresso.
xlabel('teta_{in}');
ylabel('p(teta_{in})');
title('In-degree distribution (valutated on binary matrix)');
figure, bar(p_out) % Stampo la distribuzione di grad di ingresso.
xlabel('teta_{out}');
ylabel('p(teta_{out})');
title('Out-degree distribution (valutated on binary matrix)');

% Calcolo le componenti fortemente connesse
bins = conncomp(g);
[bins,binsizes] = conncomp(g);

h = plot(g);
highlight(h, 25:31, NodeColor='red')
% Seleziona i pesi degli archi
pesi_archi = g.Edges.Weight;
% Imposta la larghezza degli archi proporzionale ai pesi
h.LineWidth = 5*pesi_archi/max(pesi_archi);
% Imposta la dimensione dei nodi
h.MarkerSize=teta_out_w+5;
highlight(h,[25:31],'Marker','s');
MatSorDes = g.Edges.EndNodes;
sor1 = MatSorDes([36 38 40 41 42 44 45 47 48 49],1); des1 = MatSorDes([36 38 40 41 42 44 45 47 48 49],2);
highlight(h,sor1,des1,'EdgeColor','red');
sor2 = MatSorDes([35 37 39 43 46 50],1); des2 = MatSorDes([35 37 39 43 46 50],2);
highlight(h,sor2,des2,'EdgeColor','green');