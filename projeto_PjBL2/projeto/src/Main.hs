module Main (main) where

import Classificacao
import Dados
import Leitura

main :: IO ()
main = do
  case lerCampeonato dadosCampeonato of
    Left erro -> print erro
    Right ps -> do
      putStrLn "=== Tabela final ==="
      putStr (tabelaFormatada (classificacao ps))

      putStrLn "\n=== Tabela apos a rodada 3 ==="
      putStr (tabelaFormatada (classificacao (ateRodada 3 ps)))

      putStrLn "\n=== Estatisticas ==="
      putStrLn ("Maior goleada: " ++ show (maiorGoleada ps))
      putStrLn ("Media de gols por partida: " ++ show (mediaGols ps))

  putStrLn "\n=== Entrada com erros ==="
  putStrLn ("Primeiro erro: " ++ either show (const "nenhum") (lerCampeonato dadosComErros))
  putStrLn "Todos os erros:"
  mapM_ print (todosOsErros dadosComErros)
