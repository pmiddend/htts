#!/usr/bin/env nix-shell
#!nix-shell -i runghc -p "haskellPackages.ghcWithPackages (pkgs: with pkgs;[cabal-install process haskeline])" -p picotts

import Control.Monad(forever, void)
import System.Console.Haskeline
import System.Process
import Control.Monad.IO.Class(liftIO)

main :: IO ()
main = runInputT defaultSettings (forever loop)
   where
       loop :: InputT IO ()
       loop = do
           minput <- getInputLine "% "
           case minput of
               Nothing -> return ()
               Just "" -> return ()
               Just "quit" -> return ()
               Just input -> do
                 liftIO $ callProcess "pico2wave" ["--lang", "de-DE", "--wave=/tmp/output.wav", input]
                 liftIO $ void $ readProcess "mpv" ["/tmp/output.wav"] ""
