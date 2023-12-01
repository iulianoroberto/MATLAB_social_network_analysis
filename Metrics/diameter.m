namesBlue = (1:24)+" blue";
namesRed = [11 12 14 16 19 20 24]+" red";

A = [A_power, zeros(24, 7); A_interlayer, A_gas]; % Ottengo la matrice A
A_dicotomica = A ~= 0; % Ottengo la matrice dicotomica a partire dalla matrice A

% Crea una matrice vuota con le stesse dimensioni di A
out = zeros(size(A));
% Itera su tutti gli elementi di A
for i = 1:size(A,1)
    for j = 1:size(A,2)
        % Se l'elemento è diverso da 0, imposta il suo inverso in out
        if A(i,j) ~= 0
            out(i,j) = 1/A(i,j);
        end
    end
end

G = digraph(out); % Creo il grafo a partire dalla matrice dicotomica

% La funzione distances ritorna una matrice dove il generico elemento
% d(i,j) è la lunghezza del percorso minimo tra il nodo i e il nodo j. Se
% il grafo è pesato allora questi pesi sono usati come distanze tra gli
% archi del grafo.
D = distances(G); 

% Alla matrice D assegno il valore 0 in corrispondenza dei valori infiniti
% che si hanno quando non è presente alcun cammino da un nodo i a un nodo
% j.
D(D==Inf) = 0;
maximum = max(max(D));
[x,y]=find(D==maximum);

% Assegno alla variabile diametro il massimo del valore contenuto in D che
% in questo caso corrisponde a 7
diam = max(max(D));

% La funzione shortestpath(G,s,t) calcola il percorso minimo che parte dal
% nodo sorgente s e giunge nel nodo target t. 
[Path,Diam,EdgePath] = shortestpath(G,18,2);

figure, p=plot(G); highlight(p,Path,'EdgeColor','r');
% Plot multilayer network (with interlayer)
highlight(p, 25:31, NodeColor='red') % Use color red for nodes of the gas network
p.NodeLabel = string([1:24 11 12 14 16 19 20 24]);