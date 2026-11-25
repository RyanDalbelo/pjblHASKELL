# PjBL2 - Tabela de Classificacao de Campeonato (Haskell)

Ambiente utilizado: **GHC local** (testado com GHC 9.4.7), usando apenas a biblioteca `base`.

## Estrutura

```
projeto/
├── src/
│   ├── Tipos.hs          Camada 1: tipos e consultas basicas
│   ├── Classificacao.hs  Camada 2: funcoes de ordem superior
│   ├── Leitura.hs        Camada 3: Maybe, Either e formatacao
│   ├── Dados.hs          campeonato de teste (como String)
│   └── Main.hs           demonstracao das tres camadas
├── tests/Testes.hs       testes com resultado esperado
├── docs/decisoes.md      decisoes de modelagem e limitacoes
└── README.md
```

## Como compilar e executar

Na pasta `projeto/`:

```
mkdir -p build/main
ghc -Wall -isrc -outputdir build/main src/Main.hs -o campeonato
./campeonato
```

## Como rodar os testes

```
mkdir -p build/testes
ghc -Wall -isrc -outputdir build/testes tests/Testes.hs -o testes
./testes
```

Cada teste imprime `OK nome` ou `FALHOU nome: valor obtido`.

## Observacoes

- Nenhum `getLine` e usado: os dados ficam em `Dados.hs`, entao o programa
  roda igual no GHC local e no playground.
- Para usar o playground, cole os modulos em um unico `Main.hs`, na ordem
  Tipos, Classificacao, Leitura, Dados, Main, removendo as linhas `module` e `import` internas.
- Compila sem nenhum aviso com `-Wall`.
