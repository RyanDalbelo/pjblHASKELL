module Tipos
  ( Time
  , Resultado (..)
  , Partida (..)
  , Linha (..)
  , participou
  , resultadoPara
  , times
  ) where

import Data.List (nub, sort)

type Time = String

data Resultado = Vitoria | Empate | Derrota
  deriving (Show, Eq)

data Partida = Partida
  { rodada       :: Int
  , mandante     :: Time
  , golsMandante :: Int
  , golsVisitante :: Int
  , visitante    :: Time
  } deriving (Show, Eq)

data Linha = Linha
  { time       :: Time
  , jogos      :: Int
  , vitorias   :: Int
  , empates    :: Int
  , derrotas   :: Int
  , golsPro    :: Int
  , golsContra :: Int
  } deriving (Show, Eq)

participou :: Time -> Partida -> Bool
participou t p = t == mandante p || t == visitante p

resultadoPara :: Time -> Partida -> Maybe Resultado
resultadoPara t p
  | t == mandante p  = Just (comparar (golsMandante p) (golsVisitante p))
  | t == visitante p = Just (comparar (golsVisitante p) (golsMandante p))
  | otherwise        = Nothing
  where
    comparar proprios adversarios = case compare proprios adversarios of
      GT -> Vitoria
      EQ -> Empate
      LT -> Derrota

times :: [Partida] -> [Time]
times = sort . nub . concatMap (\p -> [mandante p, visitante p])
