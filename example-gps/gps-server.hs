{-# LANGUAGE OverloadedStrings #-}
import Data.Char (isPunctuation, isSpace)
import Data.Monoid (mappend)
import Data.Text (Text)
import Control.Exception (fromException)
import Control.Monad (forM_, forever)
import Control.Concurrent (MVar, newMVar, modifyMVar_, readMVar, forkIO, threadDelay)
import Control.Monad.IO.Class (liftIO)
import System.Random (StdGen, randomRIO, newStdGen, getStdGen, randoms, random, randomR)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Network.WebSockets as WS

type Client = (Text, WS.Sink WS.Hybi00)

type ServerState = [Client]

newServerState :: ServerState
newServerState = []

numClients :: ServerState -> Int
numClients = length

clientExists :: Client -> ServerState -> Bool
clientExists client = any ((== fst client) . fst)

addClient :: Client -> ServerState -> ServerState
addClient client clients = client : clients

removeClient :: Client -> ServerState -> ServerState
removeClient client = filter ((/= fst client) . fst)

broadcast :: Text -> ServerState -> IO ()
broadcast message clients = do
    T.putStrLn message
    forM_ clients $ \(_, sink) -> WS.sendSink sink $ WS.textData message

randLat :: StdGen -> (Double, StdGen)
randLat gen =
    let (double, newgen) = randomR (35.665304, 35.724972) gen :: (Double, StdGen)
    in (double, newgen)

randLon :: StdGen -> (Double, StdGen)
randLon gen =
    let (double, newgen) = randomR (139.694939, 139.787292) gen :: (Double, StdGen)
    in (double, newgen)

main :: IO ()
main = do
    state <- newMVar newServerState
    --WS.runServer "0.0.0.0" 9160 $ application state
    WS.runServer "0.0.0.0" 9160 spamreal

spamreal :: WS.Request -> WS.WebSockets WS.Hybi00 ()
spamreal rq = do
	WS.acceptRequest rq
	spam

spam :: WS.TextProtocol p => WS.WebSockets p ()
spam = do
    liftIO $ putStrLn "Connected"
    forever $ do
        gen <- liftIO $ newStdGen
        let (lat, newgen) = randLat gen
        let latstr = show lat
        let (lon, newgen') = randLon newgen
        let lonstr = show lon
        liftIO $ threadDelay $ 3000000
        liftIO $ putStrLn ("Sending " `mappend` latstr `mappend` " "
            `mappend` lonstr)
        WS.sendTextData ((T.pack (latstr `mappend` " " `mappend` lonstr)) :: Text)
