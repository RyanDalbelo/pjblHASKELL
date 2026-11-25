# Decisoes de modelagem e limitacoes conhecidas

## Decisoes de modelagem

1. **`Partida` e `Linha` como records.** Campos nomeados impedem trocar, sem perceber,
   os gols do mandante com os do visitante (o que uma tupla de `Int` nao detecta).
2. **`Resultado` como tipo soma** (`Vitoria | Empate | Derrota`). O conjunto de valores
   e fechado e, com `-Wall`, o compilador avisa se um caso ficar sem tratamento.
3. **`Linha` guarda contagens, nao pontos.** Jogos, vitorias, empates, derrotas, gols pro
   e gols contra sao guardados; pontos, saldo e aproveitamento sao *derivados*
   (`pontosLinha`, `saldo`, `aproveitamento`). Assim nao existe estado inconsistente
   (por exemplo, pontos que nao batem com as vitorias).
4. **`resultadoPara` devolve `Maybe Resultado`.** "O time nao jogou" faz parte do tipo
   e quem chama e obrigado a tratar.
5. **`linhaDoTime` usa `foldl'`.** Percorre as partidas da esquerda para a direita com um
   acumulador (a `Linha`). E a versao estrita de `foldl`: mesmo resultado, sem acumular
   computacoes pendentes na memoria. O `filter (participou t)` antes da dobra
   evita olhar partidas de outros times.
6. **Criterios de desempate** (nesta ordem): pontos, vitorias, saldo de gols, gols pro,
   ordem alfabetica. Tudo em uma unica funcao de comparacao:
   `comparing` combinado com `<>` (`Ordering` e um `Monoid`) e `Down` para ordem
   decrescente. O nome no fim garante uma ordem deterministica.
7. **`maiorGoleada` e `mediaGols` devolvem `Maybe`.** Para lista vazia nao existe
   resultado; usar `maximumBy`/`/ length` direto quebraria ou daria `NaN`.
8. **`aproveitamento` usa `fromIntegral` e `/`.** `div` truncaria; Haskell nao converte
   `Int` para `Double` sozinho.
9. **`Erro` carrega um `Int`** (numero da linha, ou da rodada em `TimeRepetidoNaRodada`).
   As mensagens impressas pelo `main` sao os proprios valores de `Erro` (via `show`).
10. **Leitura com `readMaybe`**, nunca `read`: entrada como `dois` ou `2a` vira
    `Left (NumeroInvalido n)` em vez de excecao.
11. **`lerPartida` em notacao `do` na monada `Either`**: o primeiro `Left` interrompe o
    calculo. `lerCampeonato` usa `traverse` para aplicar isso a todas as linhas.
12. **`todosOsErros` usa `map` + `lefts`**, e por isso nao para no primeiro erro.
13. **Nucleo puro, casca de IO.** Todas as funcoes sao puras; so `main` faz IO, e os
    dados vem de uma `String` em `Dados.hs` (o playground nao tem entrada padrao).

## Limitacoes conhecidas

- Nao ha confronto direto entre os criterios de desempate.
- Nomes de times de teste sem acento, para evitar problemas de codificacao no console.
- Campos nao sao aparados: `"Athletico "` (com espaco) seria um time diferente de
  `"Athletico"`. Numeros com espacos sao aceitos por `readMaybe`.
- Textos com final de linha do Windows (`\r\n`) deixariam `\r` no nome do visitante
  quando lidos de arquivo.
- Rodadas com numero zero ou negativo sao aceitas.
- Nao ha verificacao de que cada par de times se enfrenta uma unica vez nem de que
  todos os times jogam o mesmo numero de partidas.
- `todosOsErros` so verifica times repetidos na rodada entre as linhas validas.
- `times` usa `nub` (quadratico); suficiente para campeonatos pequenos.
- Em empate de diferenca de gols, `maiorGoleada` devolve a ultima partida da lista.
