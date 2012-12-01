{-# LANGUAGE GADTs #-}

module Data.DataHandler
(handle,
 setupDataMonad,
DataCall(..),
DataConfiguration,
DataMonad,
withTrans)
where

  
import Control.Monad.Operational
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
          WithTransaction :: (Connection -> IO a) -> DataInstruction a

type DataMonad a = Program DataInstruction a

withTrans :: (Connection -> IO a) -> DataMonad a 
withTrans transactionSection = singleton $ WithTransaction transactionSection 

runDataMonad :: DataMonad a -> IO a
runDataMonad = eval.view
  where 
    eval :: ProgramView (DataInstruction) a -> IO a
    eval (Return x) = return x
    eval (CallData (DataCall {execution=exec}) :>>= k )  = 
      do
        result <- runDataMonad exec
        runDataMonad $ k result
    eval ((WithTransaction trans) :>>= k)  =
      do
        conn <- connectSqlite3 "cakeStore.db"
        result <- trans conn
        runDataMonad $ k result 
    
testTrans :: DataInstruction a -> IO ()
testTrans dataInstruction = 
  do
    conn <- connectSqlite3 "test.db"
    case dataInstruction of 
      WithTransaction trans -> do 
        withTransaction conn trans
        return ()
      _ -> return ()
        
setupDataMonad :: Configuration.Types.Configuration -> IO (TVar DataConfiguration)
setupDataMonad config = do
  configuration <- atomically $ newTVar $ DataConfiguration { databaseFile =  "config" }
  return configuration
  
  