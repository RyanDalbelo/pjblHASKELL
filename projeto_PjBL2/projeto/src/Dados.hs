module Dados (dadosCampeonato, dadosComErros) where

dadosCampeonato :: String
dadosCampeonato = unlines
  [ "# rodada;mandante;gols mandante;gols visitante;visitante"
  , "1;Athletico;2;1;Parana"
  , "1;Cianorte;0;0;Operario"
  , "1;Coritiba;1;1;Londrina"
  , ""
  , "2;Athletico;4;0;Operario"
  , "2;Parana;1;0;Londrina"
  , "2;Cianorte;2;2;Coritiba"
  , ""
  , "3;Athletico;1;1;Londrina"
  , "3;Operario;2;0;Coritiba"
  , "3;Parana;3;1;Cianorte"
  , ""
  , "4;Coritiba;0;1;Athletico"
  , "4;Londrina;2;1;Cianorte"
  , "4;Operario;1;0;Parana"
  , ""
  , "5;Athletico;0;2;Cianorte"
  , "5;Coritiba;2;0;Parana"
  , "5;Londrina;1;3;Operario"
  ]

dadosComErros :: String
dadosComErros = unlines
  [ "# entrada com erros"
  , "1;Athletico;dois;1;Parana"
  , "1;Cianorte;0;0"
  , "1;Coritiba;1;1;Coritiba"
  , "2;Operario;-1;0;Londrina"
  , "3;Athletico;1;0;Parana"
  , "3;Athletico;2;2;Cianorte"
  ]
