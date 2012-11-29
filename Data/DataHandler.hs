{-# LANGUAGE GADTs #-}

module Data.DataHandler
(handle,
DataCall)
where

  
import Control.Monad.Operational
import qualified Data.Users as Users
import qualified Configuration.Types
import Database.HDBC 
import Database.HDBC.Sqlite3
import Control.Concurrent.STM
import qualified Configuration.Types

handle :: DataCall a -> IO a
handle (DataCall {execution = exec }) = runDataMonad exec

data DataCall a = DataCall { name :: String, execution :: DataMonad a}

data DataConfiguration = DataConfiguration { databaseFile :: String }

data DataInstruction a
    where CallData :: DataCall a -> DataInstruction a

type DataMonad a = Program DataInstruction a

runDataMonad :: DataMonad a -> IO a
runDataMonad = eval.view
  where 
    eval :: ProgramView (DataInstruction) a -> IO a
    eval (Return x) = return x
    eval (CallData (DataCall {execution=exec}) :>>= k )  = 
      do
        result <- runDataMonad exec
        runDataMonad $ k result
        
setupDataMonad :: Configuration.Types.Configuration -> IO (TVar DataConfiguration)
setupDataMonad config = do
  configuration <- atomically $ newTVar $ DataConfiguration { databaseFile =  "config" }
  return configuration