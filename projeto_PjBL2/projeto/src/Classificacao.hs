module Classificacao
  ( pontos
  , linhaDoTime
  , pontosLinha
  , saldo
  , aproveitamento
  , classificacao
  , ateRodada
  , maiorGoleada
  , mediaGols
  ) where

import Data.List (foldl', maximumBy, sortBy)
import Data.Ord (Down (..), comparing)
import Tipos

pontos :: Resultado -> Int
pontos Vitoria = 3
pontos Empate  = 1
pontos Derrota = 0

linhaDoTime :: [Partida] -> Time -> Linha
linhaDoTime ps t = foldl' acumular (Linha t 0 0 0 0 0 0) (filter (participou t) ps)
  where
    acumular l p = case resultadoPara t p of
      Nothing -> l
      Just r  -> somar r (golsDoTime p) l
    golsDoTime p
      | t == mandante p = (golsMandante p, golsVisitante p)
      | otherwise       = (golsVisitante p, golsMandante p)
    somar r (pro, contra) l = l
      { jogos      = jogos l + 1
      , vitorias   = vitorias l + (if r == Vitoria then 1 else 0)
      , empates    = empates l + (if r == Empate then 1 else 0)
      , derrotas   = derrotas l + (if r == Derrota then 1 else 0)
      , golsPro    = golsPro l + pro
      , golsContra = golsContra l + contra
      }

pontosLinha :: Linha -> Int
pontosLinha l = pontos Vitoria * vitorias l
              + pontos Empate  * empates l
              + pontos Derrota * derrotas l

saldo :: Linha -> Int
saldo l = golsPro l - golsContra l

aproveitamento :: Linha -> Double
aproveitamento l
  | jogos l == 0 = 0
  | otherwise    = 100 * fromIntegral (pontosLinha l)
                       / fromIntegral (pontos Vitoria * jogos l)

classificacao :: [Partida] -> [Linha]
classificacao ps = sortBy criterio (map (linhaDoTime ps) (times ps))
  where
    criterio = comparing (Down . pontosLinha)
            <> comparing (Down . vitorias)
            <> comparing (Down . saldo)
            <> comparing (Down . golsPro)
            <> comparing time

ateRodada :: Int -> [Partida] -> [Partida]
ateRodada n = filter ((<= n) . rodada)

maiorGoleada :: [Partida] -> Maybe Partida
maiorGoleada [] = Nothing
maiorGoleada ps = Just (maximumBy (comparing diferenca) ps)
  where diferenca p = abs (golsMandante p - golsVisitante p)

mediaGols :: [Partida] -> Maybe Double
mediaGols [] = Nothing
mediaGols ps = Just (fromIntegral totalGols / fromIntegral (length ps))
  where totalGols = sum (map (\p -> golsMandante p + golsVisitante p) ps)
