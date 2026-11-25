module Main (main) where

import Classificacao
import Dados
import Leitura
import Tipos

testar :: (Eq a, Show a) => String -> a -> a -> IO ()
testar nome obtido esperado
  | obtido == esperado = putStrLn ("OK " ++ nome)
  | otherwise          = putStrLn ("FALHOU " ++ nome ++ ": " ++ show obtido)

campeonato :: [Partida]
campeonato = either (const []) id (lerCampeonato dadosCampeonato)

tabelaEsperada :: [Linha]
tabelaEsperada =
  [ Linha "Athletico" 5 3 1 1 8 4
  , Linha "Operario"  5 3 1 1 6 5
  , Linha "Parana"    5 2 0 3 5 6
  , Linha "Cianorte"  5 1 2 2 6 7
  , Linha "Coritiba"  5 1 2 2 5 6
  , Linha "Londrina"  5 1 2 2 5 7
  ]

main :: IO ()
main = do
  putStrLn "--- Camada 1 ---"
  let jogo = Partida 1 "Athletico" 2 1 "Parana"
  testar "resultadoPara mandante"    (resultadoPara "Athletico" jogo) (Just Vitoria)
  testar "resultadoPara visitante"   (resultadoPara "Parana" jogo)    (Just Derrota)
  testar "resultadoPara nao jogou"   (resultadoPara "Coritiba" jogo)  Nothing
  testar "times sem repeticao" (times campeonato)
    ["Athletico", "Cianorte", "Coritiba", "Londrina", "Operario", "Parana"]

  putStrLn "--- Camada 2 ---"
  testar "classificacao completa" (classificacao campeonato) tabelaEsperada
  testar "desempate por saldo de gols"
    (map time (take 2 (classificacao campeonato))) ["Athletico", "Operario"]
  testar "classificacao ate a rodada 3"
    (map time (classificacao (ateRodada 3 campeonato)))
    ["Athletico", "Parana", "Operario", "Londrina", "Cianorte", "Coritiba"]
  testar "tabela da rodada 3 difere da final"
    (classificacao (ateRodada 3 campeonato) /= classificacao campeonato) True
  testar "maiorGoleada []" (maiorGoleada []) Nothing
  testar "mediaGols []"    (mediaGols []) Nothing

  putStrLn "--- Camada 3 ---"
  testar "lerCampeonato valido" (fmap length (lerCampeonato dadosCampeonato)) (Right 15)
  testar "CamposInvalidos"  (lerPartida 1 "1;Athletico;2;1") (Left (CamposInvalidos 1))
  testar "NumeroInvalido" (lerPartida 2 "1;Athletico;dois;1;Parana") (Left (NumeroInvalido 2))
  testar "PlacarNegativo"   (lerPartida 3 "1;Athletico;-1;0;Parana") (Left (PlacarNegativo 3))
  testar "MesmoTime"        (lerPartida 4 "1;Athletico;1;1;Athletico") (Left (MesmoTime 4))
  testar "TimeRepetidoNaRodada"
    (lerCampeonato "1;Athletico;1;0;Parana\n1;Athletico;2;2;Cianorte\n")
    (Left (TimeRepetidoNaRodada 1))
  testar "todosOsErros" (todosOsErros dadosComErros)
    [ NumeroInvalido 2, CamposInvalidos 3, MesmoTime 4, PlacarNegativo 5
    , TimeRepetidoNaRodada 3 ]
