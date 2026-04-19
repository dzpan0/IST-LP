% Diogo Pan (110020)
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- ['puzzlesAcampar.pl']. % Ficheiro dado. No Mooshak tera mais puzzles.
% Atencao: nao deves copiar nunca os puzzles para o teu ficheiro de codigo
% Segue-se o codigo


%-------------------------------------------------------------------------------
% ehObjecto(Objecto)

% Verdade se Objecto for um objecto valido de um tabuleiro
%-------------------------------------------------------------------------------

ehObjecto(Objecto) :- var(Objecto), !.

ehObjecto(Objecto) :- member(Objecto, [t, r, a]).


%-------------------------------------------------------------------------------
% ehTabuleiro(Tabuleiro)

% Verdade se Tabuleiro corresponder a um tabuleiro
%-------------------------------------------------------------------------------

ehTabuleiro(Tabuleiro) :- is_list(Tabuleiro), length(Tabuleiro, L), ehTabuleiro(Tabuleiro, L).
ehTabuleiro([], _) :- !.

ehTabuleiro([Lst_Linha|R], L) :- 
    length(Lst_Linha, C), C =:= L,
    is_list(Lst_Linha), maplist(ehObjecto, Lst_Linha), 
    ehTabuleiro(R, L).


%-------------------------------------------------------------------------------
% coordenadaValida(Tabuleiro, (L, C))

% Verdade se (L, C) forem coordenadas validas no tabuleiro Tabuleiro
%-------------------------------------------------------------------------------

coordenadaValida(Tabuleiro, (L, C)) :-
    length(Tabuleiro, N), 
    0 < L, L =< N, 0 < C, C =< N.


%-------------------------------------------------------------------------------
% obtemObjecto(Tabuleiro, (L, C), Objecto)

% Calcula Objecto como o objecto que ocupa a coordenada (L, C) no tabuleiro Tabuleiro
%-------------------------------------------------------------------------------

obtemObjecto(Tabuleiro, (L, C), Objecto) :- 
    coordenadaValida(Tabuleiro, (L, C)), !,
    nth1(L, Tabuleiro, Linha), nth1(C, Linha, Objecto).

obtemObjecto(_, _, _).


%-------------------------------------------------------------------------------
% obtemQuantObjecto(Lst_Objectos, Objecto, Quant)

% Verdade se Lst_Objectos for uma lista de Objectos, Objecto um tipo de objecto
% e Quant a quantidade desse objecto na lista
%-------------------------------------------------------------------------------

obtemQuantObjecto(Lst_Objectos, Objecto, Quant) :-
    var(Objecto), !,
    include(var, Lst_Objectos, Lst_Conta), length(Lst_Conta, Quant).

obtemQuantObjecto(Lst_Objectos, Objecto, Quant) :-
    include(==(Objecto), Lst_Objectos, Lst_Conta), length(Lst_Conta, Quant).


%-------------------------------------------------------------------------------
% vizinhanca((L, C), Vizinhanca) 

% Calcula Vizinhanca como uma lista contendo as coordenadas das posicoes adjacentes a (L, C)
%-------------------------------------------------------------------------------

vizinhanca((L, C), [(LMenos1, C), (L, CMenos1), (L, CMais1), (LMais1, C)]) :- 
    LMenos1 is L-1, LMais1 is L+1, CMenos1 is C-1, CMais1 is C+1.


%-------------------------------------------------------------------------------
% vizinhancaAlargada((L, C), VizinhancaAlargada) 

% Calcula vizinhancaAlargada como uma lista contendo as coordenadas adjacentes e ainda as diagonais da coordenada (L, C)
%-------------------------------------------------------------------------------

vizinhancaAlargada((L, C), VizinhancaAlargada) :-
    LMenos1 is L-1, LMais1 is L+1, CMenos1 is C-1, CMais1 is C+1,
    vizinhanca((L, C), Vizinhanca), 
    append([(LMenos1, CMenos1), (LMais1, CMenos1), (LMenos1, CMais1), (LMais1, CMais1)], Vizinhanca, Res),
    sort(Res, VizinhancaAlargada).


%-------------------------------------------------------------------------------
% criaTodasCoordenadas(N, Coordenadas) 
% Predicado auxiliar de todasCelulas/2

% Calcula Coordenadas como uma lista contendo todas as coordenadas de um tabuleiro NxN
%-------------------------------------------------------------------------------

criaTodasCoordenadas(N, Coordenadas) :- criaTodasCoordenadas(1, 0, N, Coordenadas).
criaTodasCoordenadas(N, N, N, []) :- !.

criaTodasCoordenadas(L, N, N, Coordenadas) :-
    !, ProxL is L+1, criaTodasCoordenadas(ProxL, 0, N, Coordenadas).

criaTodasCoordenadas(L, C, N, Coordenadas) :-
    ProxC is C+1, criaTodasCoordenadas(L, ProxC, N, CoordenadasAux), 
    Coordenadas = [(L, ProxC)|CoordenadasAux].


%-------------------------------------------------------------------------------
% todasCelulas(Tabuleiro, TodasCelulas) 

% Calcula TodasCelulas como uma lista contendo todas as coordenadas existentes no Tabuleiro Tabuleiro
%-------------------------------------------------------------------------------

todasCelulas(Tabuleiro, TodasCelulas) :-
    length(Tabuleiro, N),
    criaTodasCoordenadas(N, TodasCelulas).


%-------------------------------------------------------------------------------
% criaCoordLinha_Objecto(L, Linha, Coordenadas, Objecto) 
% Predicado auxiliar de todasCelulas/3

% Calcula Coordenadas como uma lista contendo todas as coordenadas de Linha (L-esima de um tabuleiro)
% onde existe um objecto do tipo Objecto
%-------------------------------------------------------------------------------

criaCoordLinha_Objecto(L, Linha, Coordenadas, Objecto) :- criaCoordLinha_Objecto(L, Linha, 0, Coordenadas, Objecto).
criaCoordLinha_Objecto(_, [], _, [], _) :- !.

criaCoordLinha_Objecto(L, [ObjectoTabuleiro|R], N, Coordenadas, Objecto) :- 
    ObjectoTabuleiro == Objecto, !, 
    ProxC is N+1, criaCoordLinha_Objecto(L, R, ProxC, CoordenadasAux, Objecto), 
    Coordenadas = [(L, ProxC)|CoordenadasAux].

criaCoordLinha_Objecto(L, [ObjectoTabuleiro|R], N, Coordenadas, Objecto) :- 
    var(Objecto), var(ObjectoTabuleiro), !, 
    ProxC is N+1, criaCoordLinha_Objecto(L, R, ProxC, CoordenadasAux, Objecto), 
    Coordenadas = [(L, ProxC)|CoordenadasAux].

criaCoordLinha_Objecto(L, [_|R], N, Coordenadas, Objecto) :- 
    ProxC is N+1, criaCoordLinha_Objecto(L, R, ProxC, Coordenadas, Objecto).


%-------------------------------------------------------------------------------
% todasCelulas(Tabuleiro, TodasCelulas, Objecto) 

% Calcula TodasCelulas como uma lista contendo todas as coordenadas do tabuleiro 
% Tabuleiro onde existe um objecto do tipo Objecto
%-------------------------------------------------------------------------------

todasCelulas(Tabuleiro, TodasCelulas, Objecto) :- todasCelulas(1, Tabuleiro, TodasCelulas, Objecto).
todasCelulas(_, [], [], _) :- !.

todasCelulas(L, [Lst_Linha|R], TodasCelulas, Objecto) :-
    criaCoordLinha_Objecto(L, Lst_Linha, CoordenadasL, Objecto), 
    ProxL is L+1, todasCelulas(ProxL, R, Celulas, Objecto), append(CoordenadasL, Celulas, TodasCelulas).


%-------------------------------------------------------------------------------
% contaObjecto(Tabuleiro, TranspTabuleiro, ContagemLinhas, ContagemColunas, Objecto)
% Predicado auxiliar de calculaObjectosTabuleiro/4
%-------------------------------------------------------------------------------

contaObjecto([], [], [], [], _) :- !.

contaObjecto([Linha|RestoLinha], [Coluna|RestoColuna], [NLinha|NLAux], [NColuna|NCAux], Objecto) :-
    obtemQuantObjecto(Linha, Objecto, NLinha),
    obtemQuantObjecto(Coluna, Objecto, NColuna),
    contaObjecto(RestoLinha, RestoColuna, NLAux, NCAux, Objecto).


%-------------------------------------------------------------------------------
% calculaObjectosTabuleiro(Tabuleiro, ContagemLinhas, ContagemColunas, Objecto)

% Verdade apenas se Tabuleiro for um tabuleiro e Objecto um objecto valido e 
% calcula ContagemLinhas e ContagemColunas, respetivamente, como listas contendo o 
% numero de objectos do tipo Objecto em cada linha e coluna
%-------------------------------------------------------------------------------

calculaObjectosTabuleiro(Tabuleiro, ContagemLinhas, ContagemColunas, Objecto) :-
    ehTabuleiro(Tabuleiro), ehObjecto(Objecto), transpose(Tabuleiro, TranspTabuleiro),
    contaObjecto(Tabuleiro, TranspTabuleiro, ContagemLinhas, ContagemColunas, Objecto).


%-------------------------------------------------------------------------------
% celulaVazia(Tabuleiro, (L, C))

% Verdade se Tabuleiro for um tabuleiro que nao tem nada ou tem relva nas coordenadas (L, C).
%-------------------------------------------------------------------------------

celulaVazia(Tabuleiro, (L, C)) :-
    ehTabuleiro(Tabuleiro),
    obtemObjecto(Tabuleiro, (L, C), Objecto), 
    (var(Objecto); member(Objecto, [r])), !.


%-------------------------------------------------------------------------------
% insereObjectoCelula(Tabuleiro, TendaOuRelva, (L, C))

% Verdade se Tabuleiro for um tabuleiro e (L, C) as coordenadas onde se quer inserir o objecto TendaOuRelva
%-------------------------------------------------------------------------------

insereObjectoCelula(Tabuleiro, TendaOuRelva, (L, C)) :-
    ehTabuleiro(Tabuleiro), obtemObjecto(Tabuleiro, (L, C), Objecto), 
    var(Objecto), !, Objecto = TendaOuRelva.

insereObjectoCelula(Tabuleiro, _, _) :- ehTabuleiro(Tabuleiro).


%-------------------------------------------------------------------------------
% insereObjectoEntrePosicoes(Tabuleiro, TendaOuRelva, (L, C1), (L, C2))

% Verdade se Tabuleiro for um tabuleiro e (L, C1) e (L, C2) forem coordenadas entre 
% as quais se quer inserir o objecto TendaOuRelva
%-------------------------------------------------------------------------------

insereObjectoEntrePosicoes(_, _, (L, C1), (L, C2)) :- C1 =:= C2+1, !.

insereObjectoEntrePosicoes(Tabuleiro, TendaOuRelva, (L, C1), (L, C2)) :-
    ehTabuleiro(Tabuleiro), 
    insereObjectoCelula(Tabuleiro, TendaOuRelva, (L, C1)),
    ProxC is C1+1,
    insereObjectoEntrePosicoes(Tabuleiro, TendaOuRelva, (L, ProxC), (L, C2)).


%-------------------------------------------------------------------------------
% insereRelva(Tabuleiro, NTotalTendas, NAtualTendas, N)
% Predicado auxiliar de relva/1

% Verdade se Tabuleiro for um Tabuleiro que tem relva em todas as linhas onde ja se
% atingiu o numero maximo de tendas, NTotalTendas e NAtualTendas, respetivamente, listas contendo
% o numero maximo de tendas e o numero atual que existe na linha e N o tamanho do Tabuleiro
%-------------------------------------------------------------------------------

insereRelva(Tabuleiro, NTotalTendas, NAtualTendas, N) :-
    insereRelva(Tabuleiro, NTotalTendas, NAtualTendas, N, 1).

insereRelva(_, [], [], _, _) :- !.

insereRelva(Tabuleiro, [TotalTendas|RestoTotal], [AtualTendas|RestoTendas], N, Ind) :-
    TotalTendas =:= AtualTendas, !,
    insereObjectoEntrePosicoes(Tabuleiro, r, (Ind, 1), (Ind, N)),
    ProxInd is Ind+1,
    insereRelva(Tabuleiro, RestoTotal, RestoTendas, N, ProxInd).

insereRelva(Tabuleiro, [_|RestoTotal], [_|RestoTendas], N, Ind) :-
    ProxInd is Ind+1,
    insereRelva(Tabuleiro, RestoTotal, RestoTendas, N, ProxInd).


%-------------------------------------------------------------------------------
% relva(Puzzle)

% Calcula Puzzle preenchendo com relva as linhas/colunas onde se atingiu o maximo numero
% de tendas possiveis nessa linha/coluna
%-------------------------------------------------------------------------------

relva(Puzzle) :-
    Puzzle = (Tabuleiro, TotalTendasLinhas, TotalTendasColunas),
    calculaObjectosTabuleiro(Tabuleiro, TendasLinhas, TendasColunas, t),
    transpose(Tabuleiro, TranspTabuleiro), length(Tabuleiro, N),
    insereRelva(Tabuleiro, TotalTendasLinhas, TendasLinhas, N),
    insereRelva(TranspTabuleiro, TotalTendasColunas, TendasColunas, N), !.


%-------------------------------------------------------------------------------
% tem_a(Lst_Objectos, Valor)
% Predicado auxiliar de inacessiveis/1

% Verdade se Lst_Objectos for uma lista com pelo menos uma arvore e calcula Valor como true,
% caso nao contenha uma arvora calcula Valor como false 
%-------------------------------------------------------------------------------

tem_a(Lst_Objectos, true) :- 
    obtemQuantObjecto(Lst_Objectos, a, N_a), N_a > 0, !.

tem_a(_, false).


%-------------------------------------------------------------------------------
% inacessiveis(Tabuleiro)

% Calcula Tabuleiro inserindo relva nas posicoes que nao tenham uma arvore na vizinhanca
%-------------------------------------------------------------------------------

inacessiveis(Tabuleiro) :-
    todasCelulas(Tabuleiro, Vazias, _),
    maplist(vizinhanca, Vazias, Vizinhancas),

    % VizinhancasObjectos - Lista de listas de objetos correspondentes as coordenadas de Vizinhanca da lista Vizinhancas
    findall(Objs, (member(Vizinhanca, Vizinhancas), maplist(obtemObjecto(Tabuleiro), Vizinhanca, Objs)), VizinhancasObjectos),
    
    maplist(tem_a, VizinhancasObjectos, ContemArvores),
    findall(Inacessivel, (nth1(Ind, ContemArvores, false), nth1(Ind, Vazias, Inacessivel)), Inacessiveis),
    maplist(insereObjectoCelula(Tabuleiro, r), Inacessiveis).
    

%-------------------------------------------------------------------------------
% aproveita(Puzzle)

% Calcula Puzzle inserindo tendas nas linhas e colunas onde faltavam exatamente o numero
% de posicoes livres existentes na linha/coluna para atingir o maximo de tendas possivel
%-------------------------------------------------------------------------------

aproveita(Puzzle) :-
    Puzzle = (Tabuleiro, TotalTendasLinhas, TotalTendasColunas),
    calculaObjectosTabuleiro(Tabuleiro, TendasLinhas, TendasColunas, t),
    calculaObjectosTabuleiro(Tabuleiro, VaziosLinhas, VaziosColunas, _),

    % NaoCompL e NaoCompC - Listas de indices, respetivamente, das linhas e colunas que nao preencheram ate ao numero maximo de tendas possiveis
    findall(L, (nth1(L, TotalTendasLinhas, NumLT_Total), nth1(L, TendasLinhas, NumLT), nth1(L, VaziosLinhas, NumLRest), NumLT < NumLT_Total, NumLRest is NumLT_Total-NumLT), NaoCompL),
    findall(C, (nth1(C, TotalTendasColunas, NumCT_Total), nth1(C, TendasColunas, NumCT), nth1(C, VaziosColunas, NumCRest), NumCT < NumCT_Total, NumCRest is NumCT_Total-NumCT), NaoCompC),

    length(Tabuleiro, N), transpose(Tabuleiro, TranspTabuleiro),
    findall((CoordL, 1), member(CoordL, NaoCompL), CoordNaoCompL_Inicio),
    findall((CoordL, N), member(CoordL, NaoCompL), CoordNaoCompL_Final),
    findall((CoordL, 1), member(CoordL, NaoCompC), CoordNaoCompC_Inicio),
    findall((CoordL, N), member(CoordL, NaoCompC), CoordNaoCompC_Final),
    maplist(insereObjectoEntrePosicoes(Tabuleiro, t), CoordNaoCompL_Inicio, CoordNaoCompL_Final),
    maplist(insereObjectoEntrePosicoes(TranspTabuleiro, t), CoordNaoCompC_Inicio, CoordNaoCompC_Final), !.


%-------------------------------------------------------------------------------
% limpaVizinhancasTabuleiro(Tabuleiro, VizinhancasAlargadas)
% Predicado auxiliar de limpaVizinhancas

% Verdade se VizinhancasAlargadas for uma lista de listas contendo as coordenadas 
% das vizinhancas alargadas das tendas e calcula Tabuleiro inserindo relva nessas coordenadas
%-------------------------------------------------------------------------------

limpaVizinhancasTabuleiro(_, []) :- !.

limpaVizinhancasTabuleiro(Tabuleiro, [VizinhancaAlargada|Resto]) :-
    maplist(insereObjectoCelula(Tabuleiro, r), VizinhancaAlargada),
    limpaVizinhancasTabuleiro(Tabuleiro, Resto).


%-------------------------------------------------------------------------------
% limpaVizinhancas(Puzzle)

% Calcula Puzzle preenchendo a vizinhanca alargada de todas as tendas com relva
%-------------------------------------------------------------------------------

limpaVizinhancas(Puzzle) :-
    Puzzle = (Tabuleiro, _, _),
    todasCelulas(Tabuleiro, Tendas, t),
    maplist(vizinhancaAlargada, Tendas, VizinhancasAlargadas),
    limpaVizinhancasTabuleiro(Tabuleiro, VizinhancasAlargadas), !.


%-------------------------------------------------------------------------------
% filtraUnicasHipoteses(Vizinhancas, VizinhancasObjectos, UnicasHipoteses)
% Predicado auxiliar de unicaHipotese/1

% Verdade se Vizinhancas e VizinhancasObjectos forem listas de listas, respetivamente, 
% com as coordenadas da vizinhanca das arvores e com os respetivos objectos nas coordenadas
% e calcula UnicasHipoteses como uma lista contendo todas as coordenadas vazias que sao a 
% unica hipotese onde se pode colocar uma tenda
%-------------------------------------------------------------------------------

filtraUnicasHipoteses([], [], []) :- !.

filtraUnicasHipoteses([VizCoords|RVizCoords], [Objectos|RObjectos], [CoordVazia|UnicasHipotesesAux]) :-
    obtemQuantObjecto(Objectos, t, NTendas),
    obtemQuantObjecto(Objectos, _, NVazio),
    NVazio =:= 1, NTendas =:= 0, !, 

    % CoordVazia - Unica coordenada vazia de VizCoords
    nth1(Ind, VizCoords, CoordVazia), nth1(Ind, Objectos, var),

    filtraUnicasHipoteses(RVizCoords, RObjectos, UnicasHipotesesAux).

filtraUnicasHipoteses([_|RVizCoords], [_|RObjectos], UnicasHipoteses) :-
    filtraUnicasHipoteses(RVizCoords, RObjectos, UnicasHipoteses).


%-------------------------------------------------------------------------------
% obtemCoordsValidas(Tabuleiro, Lst_Coordenadas, CoordsValidas)

% Verdade se Lst_Coordenadas for uma lista contendo coordenadas e calcula CoordsValidas 
% como uma lista contendo apenas as coordenadas validas no tabuleiro Tabuleiro
%-------------------------------------------------------------------------------

obtemCoordsValidas(Tabuleiro, Lst_Coordenadas, CoordsValidas) :-
    findall(Coordenada, (member(Coordenada, Lst_Coordenadas), coordenadaValida(Tabuleiro, Coordenada)), CoordsValidas).


%-------------------------------------------------------------------------------
% unicaHipotese(Puzzle)

% Calcula Puzzle preenchendo a unica posicao livre na vizinhanca das arvores, que 
% ainda nao possuiam uma tenda, com uma tenda
%-------------------------------------------------------------------------------

unicaHipotese(Puzzle) :-
    Puzzle = (Tabuleiro, _, _),
    todasCelulas(Tabuleiro, Arvores, a),
    maplist(vizinhanca, Arvores, Vizinhancas),
    maplist(obtemCoordsValidas(Tabuleiro), Vizinhancas, VizinhancasValidas),
    findall(Objs, (member(Vizinhanca, VizinhancasValidas), maplist(obtemObjecto(Tabuleiro), Vizinhanca, Objs)), VizinhancasObjectos),
    filtraUnicasHipoteses(VizinhancasValidas, VizinhancasObjectos, UnicasHipoteses),
    maplist(insereObjectoCelula(Tabuleiro, t), UnicasHipoteses), !.


%-------------------------------------------------------------------------------
% verificaRelacao(LArv, LTen)
% Predicado auxiliar de valida/2

% Verdade se se conseguir verificar uma relacao entre cada arvore de LTen a uma unica tenda de LTen
%-------------------------------------------------------------------------------

verificaRelacao([], []) :- !.

verificaRelacao([CoordArv|RestoArv], LTen) :-
    vizinhanca(CoordArv, VizinhancaArv),

    % VizCoordsTen - Lista de todas as coordenadas das tendas na vizinhanca de uma arvore
    findall(VizCoordTen, (member(VizCoordTen, VizinhancaArv), member(VizCoordTen, LTen)), VizCoordsTen), 

    length(VizCoordsTen, NVizTendas), NVizTendas > 0, !,
    member(X, VizCoordsTen), delete(LTen, X, LTenAux),
    verificaRelacao(RestoArv, LTenAux), !.


%-------------------------------------------------------------------------------
% valida(LArv, LTen)

% Verdade se LArv e LTen forem listas contendo, respetivamente, todas as coordenadas de arvores 
% e tendas e se conseguir estabelecer uma relacao entre cada arvore a uma tenda da sua vizinhanca
%-------------------------------------------------------------------------------

valida(LArv, LTen) :-
    length(LArv, NArvores), length(LTen, NTendas),
    NArvores =:= NTendas, 
    verificaRelacao(LArv, LTen).


%-------------------------------------------------------------------------------
% tentativaTenda(Puzzle)

% Calcula Puzzle inserindo uma tenda numa posicao vazia do tabuleiro 
%-------------------------------------------------------------------------------

tentativaTenda(Puzzle) :-
    Puzzle = (Tabuleiro, _, _),
    todasCelulas(Tabuleiro, Vazio, _), length(Vazio, NVazio),
    NVazio > 0, member(X, Vazio),
    insereObjectoCelula(Tabuleiro, t, X).

tentativaTenda(_).

%-------------------------------------------------------------------------------
% resolve(Puzzle)

% Calcula Puzzle resolvendo-o
%-------------------------------------------------------------------------------

% Verificacoes para a conclusao da resolucao
resolve(Puzzle) :-
    Puzzle = (Tabuleiro, TotalTendasLinhas, TotalTendasColunas),
    todasCelulas(Tabuleiro, Vazio, _), length(Vazio, NVazio),
    NVazio =:= 0, !,
    todasCelulas(Tabuleiro, LArv, a), todasCelulas(Tabuleiro, LTen, t),

    % Verifica se existem tendas na vizinhanca alargada de outras tendas
    maplist(vizinhancaAlargada, LTen, Lst_VA_LTen), append(Lst_VA_LTen, VA_LTen),
    findall(X, (member(X, LTen), member(X, VA_LTen)), Dupli), length(Dupli, NDupli),
    NDupli =:= 0,

    valida(LArv, LTen),
    calculaObjectosTabuleiro(Tabuleiro, TendasLinhas, TendasColunas, t), 
    TendasLinhas == TotalTendasLinhas, TendasColunas == TotalTendasColunas.

% Aplicacao da resolucao
resolve(Puzzle) :-
    Puzzle = (Tabuleiro, _, _),
    inacessiveis(Tabuleiro), unicaHipotese(Puzzle), 
    aproveita(Puzzle), limpaVizinhancas(Puzzle),
    relva(Puzzle),
    tentativaTenda(Puzzle),
    resolve(Puzzle), !.
