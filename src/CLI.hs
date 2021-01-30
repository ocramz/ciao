{-# options_ghc -Wno-unused-imports #-}
module CLI (cli, CLIOpts(..)) where

import Options.Applicative (Parser, showHelpOnError , customExecParser, prefs, execParser, info, helper, (<**>), fullDesc, progDesc, header, option, auto, strOption, switch, long, short, metavar, help, showDefault, value, )

cli :: IO CLIOpts
cli = customExecParser p opts
  where
    p = prefs showHelpOnError
    opts = info (cliP <**> helper)
           ( fullDesc
             <> progDesc "Print a greeting for TARGET"
             <> header "hello - a test for optparse-applicative" )

data CLIOpts = CLIOpts {
    cliPort :: Int
  , cliDir :: FilePath
                       } deriving (Eq)
instance Show CLIOpts where
  show (CLIOpts p d) = unwords ["listening on port :", show p, "\ndirectory :", d]

cliP :: Parser CLIOpts
cliP = CLIOpts <$> portP <*> dirP

portP :: Parser Int
portP = option auto (
  long "port" <>
  short 'p' <>
  help "TCP port" <>
  value 3000 <>
  showDefault <>
  metavar "INT"
                   )

dirP :: Parser FilePath
dirP = strOption (
  long "dir" <>
  short 'd' <>
  help "directory to serve" <>
  value "/var/www" <>
  showDefault <>
  metavar "FILEPATH"
                 )


-- main :: IO ()
-- main = greet =<< execParser opts
--   where
--     opts = info (sample <**> helper)
--       ( fullDesc
--      <> progDesc "Print a greeting for TARGET"
--      <> header "hello - a test for optparse-applicative" )
