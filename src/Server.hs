{-# options_ghc -Wno-unused-imports #-}
module Server where

import Data.Function ((&))
import Network.Wai.Middleware.Static (staticPolicy, only)
import Network.Wai.Handler.Warp (setPort, defaultSettings)
import Web.Scotty.Trans (ScottyT, scottyOptsT, Options(..), middleware, get)

import CLI (cli, CLIOpts(..))

server :: IO ()
server = do
  o@(CLIOpts p dir) <- cli
  print o
  let
    setts = defaultSettings &
            setPort p
  scottyOptsT (Options 0 setts) id $ route dir

route :: String -> ScottyT e m ()
route dir = middleware (staticPolicy $ only [("/", dir)])
