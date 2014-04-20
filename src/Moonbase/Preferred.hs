module Moonbase.Preferred where

import Control.Applicative

import System.IO.Error
import System.Directory
import Control.Monad.Error
import Control.Monad.Reader

import Data.Either (either)
import qualified Data.Map as M
import System.Environment.XDG.BaseDir (getUserDataDir)
import System.Environment.XDG.DesktopEntry
import System.Environment.XDG.MimeApps

import Moonbase.Core
import Moonbase.Log

userMimeApps :: IO FilePath
userMimeApps
    = do
        dir <- getUserDataDir
        return $ dir ++ "/applications/mimeapps.list"


loadMimeApps' :: Moonbase MimeApps
loadMimeApps'
    = do
        dir <- io getUserDataDir
        io $ createDirectoryIfMissing True (dir ++ "/applications")

        exists <- io $ doesFileExist (dir ++ "/applications/mimeapps.list")

        if exists 
            then do
                infoM "Loading mimeapps file..."
                io (loadMimeApps $ dir ++ "/applications/mimeapps.list")
            else
                infoM "MimeApps doesn't exists: creating newone" >> return newMimeApps 

setPreferred :: Moonbase ()
setPreferred   
    = set =<< loadMimeApps'
    where
        fromPreferred (AppName n) = n ++ ".desktop"
        fromPreferred (Entry e) = getName e ++ ".desktop"
        update app = M.foldlWithKey updateMime app <$> (preferred <$> ask)
        updateMime a m n = addDefault m (fromPreferred n) a
        set app = do
            dir <- io userMimeApps
            up <- update app
            io $ saveMimeApps dir up
    
            
