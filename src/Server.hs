{-# LANGUAGE OverloadedStrings #-}
{-# options_ghc -Wno-unused-imports #-}
module Server where

import Control.Monad.IO.Class (MonadIO(..))
import Data.Function ((&))
import Data.List (intersperse)
import Network.Wai.Middleware.Static (staticPolicy, only, addBase)
import Network.Wai.Handler.Warp (setPort, defaultSettings)
import Network.Wai.Middleware.RequestLogger (logStdout)
import System.Directory (listDirectory)
import Data.Text.Lazy (Text, pack, unpack)
import Web.Scotty.Trans (ScottyT, scottyOptsT, Options(..), middleware, get, text)

import CLI (cli, CLIOpts(..))

server :: IO ()
server = do
  o@(CLIOpts p dir) <- cli
  print o
  let
    setts = defaultSettings &
            setPort p
  scottyOptsT (Options 0 setts) id $ do
    middleware logStdout
    lsDir dir
    route dir

route :: String -> ScottyT e m ()
route dir =
  middleware $ staticPolicy (addBase dir)

lsDir :: (MonadIO m) => FilePath -> ScottyT Text m ()
lsDir dir = get "/" $ do
  ls <- liftIO $ listDirectory dir
  text (pack $ unwords $ intersperse "\n" ls)
