module Moonbase.Service
    ( startServices
    , stopServices
    , getService
    , isServiceRunning
    , dbusListAllServices
    , dbusListRunningServices
    , dbusStopService
    , dbusStartService
    ) where


import Control.Applicative
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Error

import qualified Data.Map as M

import Moonbase.Core
import Moonbase.Log

startServices :: Moonbase ()
startServices
    = mapM_ start' =<< autostart <$> askConf
    where
        start' (Service n a) = do
            infoM $ "Starting service: " ++ n
            st <- get
            s <- start a
            put $ st { services = M.insert n (Service n s) (services st) }
        start' (OneShot n a) = infoM ("Enable oneshot service: "++n) >> enable a


stopServices :: Moonbase ()
stopServices
    = mapM_ stop' =<< (M.toList . services <$> get)
    where
        stop' (n,Service _ a) = do
            infoM $ "Stoping service: " ++ n
            stop a
            st <- get
            put $ st { services = M.delete n (services st) }
        stop' (n, OneShot _ _) = throwError $ ErrorMessage $ "Trying to stop a oneshot service... wired! (" ++ n ++ " shoudl never be added here"


getService :: String -> Moonbase (Maybe Service)
getService 
    sn = search . autostart <$> askConf
    where
        search (x@(Service n _):xs)
            | n  == sn = Just x
            | otherwise = search xs
        search [] = Nothing

isServiceRunning :: String -> Moonbase Bool
isServiceRunning
    sn = M.member sn . services <$> get

dbusListAllServices :: Moonbase [String]
dbusListAllServices
    = map (\(Service n _) -> n) . autostart <$> askConf


dbusListRunningServices :: Moonbase [String]
dbusListRunningServices
    = M.keys . services <$> get


dbusStopService :: String -> Moonbase ()
dbusStopService
    sn = perform =<< M.lookup sn <$> (services <$> get)
    where
        perform Nothing  = return ()
        perform (Just s) = do
            st <- get
            stop s
            put $ st { services = M.delete sn (services st) }

dbusStartService :: String -> Moonbase ()
dbusStartService
    sn = do
        notRunning <- not <$> isServiceRunning sn
        when notRunning (start' =<< getService sn)
    where
        start' Nothing  = warnM $ "Could not start service: " ++ sn ++ " is unknown"
        start' (Just s) = do
            st <- get
            ns <- start s
            put $ st { services = M.insert sn (Service sn ns) (services st) }
