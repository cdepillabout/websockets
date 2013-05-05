{-# LANGUAGE OverloadedStrings #-}

import Control.Monad (forever)
import Control.Concurrent (forkIO)
import Control.Monad.Trans (liftIO)
import qualified Data.Text.IO as T
import qualified Network.WebSockets as WS


app :: WS.WebSockets WS.Hybi10 ()
app = do
    liftIO $ print "Connected"
    forever loop
  where
    loop = do
        msg <- WS.receiveData
        liftIO $ T.putStrLn msg

main :: IO ()
main = do
    WS.connect "127.0.0.1" 9160 "/" app
