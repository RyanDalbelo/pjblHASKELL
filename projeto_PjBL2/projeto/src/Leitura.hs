module Leitura
  ( Erro (..)
  , separar
  , lerPartida
  , lerCampeonato
  , todosOsErros
  , tabelaFormatada
  ) where

import Classificacao (pontosLinha, saldo)
import Data.Char (isSpace)
import Data.Either (lefts, rights)
import Data.List (nub, sort)
import Text.Read (readMaybe)
import Tipos

data Erro
  = CamposInvalidos Int
  | NumeroInvalido Int
  | PlacarNegativo Int
  | MesmoTime Int
  | TimeRepetidoNaRodada Int
  deriving (Show, Eq)

separar :: Char -> String -> [String]
separar sep s = case break (== sep) s of
  (campo, [])        -> [campo]
  (campo, _ : resto) -> campo : separar sep resto

lerPartida :: Int -> String -> Either Erro Partida
lerPartida n linha = case separar ';' linha of
  [r, m, gm, gv, v] -> do
    rod   <- numero r
    golsM <- numero gm
    golsV <- numero gv
    if golsM < 0 || golsV < 0 then Left (PlacarNegativo n) else Right ()
    if m == v then Left (MesmoTime n) else Right ()
    return (Partida rod m golsM golsV v)
  _ -> Left (CamposInvalidos n)
  where
    numero :: String -> Either Erro Int
    numero = maybe (Left (NumeroInvalido n)) Right . readMaybe

linhasUteis :: String -> [(Int, String)]
linhasUteis = filter (util . snd) . zip [1 ..] . lines
  where
    util l = case dropWhile isSpace l of
      []        -> False
      ('#' : _) -> False
      _         -> True

rodadasRepetidas :: [Partida] -> [Int]
rodadasRepetidas ps =
  [ r | r <- sort (nub (map rodada ps)), repetido (timesDaRodada r) ]
  where
    timesDaRodada r = concatMap (\p -> [mandante p, visitante p])
                                (filter ((== r) . rodada) ps)
    repetido ts = length ts /= length (nub ts)

lerCampeonato :: String -> Either Erro [Partida]
lerCampeonato texto =
  traverse (uncurry lerPartida) (linhasUteis texto) >>= verificar
  where
    verificar ps = case rodadasRepetidas ps of
      []      -> Right ps
      (r : _) -> Left (TimeRepetidoNaRodada r)

todosOsErros :: String -> [Erro]
todosOsErros texto =
  lefts resultados ++ map TimeRepetidoNaRodada (rodadasRepetidas (rights resultados))
  where resultados = map (uncurry lerPartida) (linhasUteis texto)

tabelaFormatada :: [Linha] -> String
tabelaFormatada ls = unlines (cabecalho : zipWith formatar [1 :: Int ..] ls)
  where
    cabecalho = colunas "Pos" "Time" "Pts" "J" "V" "E" "D" "SG"
    formatar pos l = colunas (show pos) (time l) (show (pontosLinha l))
      (show (jogos l)) (show (vitorias l)) (show (empates l))
      (show (derrotas l)) (show (saldo l))
    colunas pos t pts j v e d sg = unwords
      [ direita 3 pos, esquerda 12 t, direita 3 pts, direita 2 j
      , direita 2 v, direita 2 e, direita 2 d, direita 3 sg ]
    direita w s = replicate (w - length s) ' ' ++ s
    esquerda w s = s ++ replicate (w - length s) ' '
