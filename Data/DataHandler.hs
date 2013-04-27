{-# LANGUAGE GADTs #-}

module Data.DataHandler
(
 handleWithConfiguration,
 setupDataMonad,
 databaseFile,
DataCall(..),
DataConfiguration,
DataMonad,
withTrans,
provideBlank)
where

  
import Control.Monad.Operational
import qualified Configuration.Types
import Database.HDBC.Sqlite3
import Database.HDBC
import Control.Concurrent.STM
import Data.Typeable
import Data.Dynamic
import Control.Exception
import Data.Pool
import Data.Time.Clock


handleWithConfiguration :: DataConfiguration -> DataCall a -> IO a
handleWithConfiguration dataConfiguration (DataCall {execution = exec }) = runDataMonadWithConfiguration dataConfiguration exec 

data DataCall a = Typeable a => DataCall { name :: String, execution :: DataMonad a, provideResult :: Dynamic -> a}

data DataConfiguration = DataConfiguration { databaseFile :: String , databasePool :: Pool (Connection)}

data DataInstruction a 
    where CallData :: DataCall a -> DataInstruction a
          WithTransaction :: (Connection -> IO a) -> DataInstruction a

type DataMonad a = Program DataInstruction a

provideBlank :: Typeable a => Dynamic -> a
provideBlank dynamic = let Just value = fromDynamic dynamic 
                       in value

withTrans :: (Connection -> IO a) -> DataMonad a 
withTrans transactionSection = singleton $ WithTransaction transactionSection 
        
runDataMonadWithConfiguration :: DataConfiguration -> DataMonad a -> IO a
runDataMonadWithConfiguration dataConfiguration = eval.view
  where 
    eval :: ProgramView (DataInstruction) a -> IO a
    eval (Return x) = return x
    eval (CallData (DataCall {execution=exec}) :>>= k )  = 
      do
        result <- runDataMonadWithConfiguration dataConfiguration exec
        runDataMonadWithConfiguration dataConfiguration $ k result
    eval ((WithTransaction trans) :>>= k)  =
      do
        result <- withResource (databasePool dataConfiguration)
                          (\conn -> withTransaction conn trans )
        runDataMonadWithConfiguration dataConfiguration $ k result 
    
connectToDatabase databaseFile = connectSqlite3 $ databaseFile 
closeConnection conn =  disconnect conn
        
setupDataMonad :: Configuration.Types.Configuration -> IO (TVar DataConfiguration)
setupDataMonad config = do
  let databaseFile = Configuration.Types.databaseFile config
  connectionPool <- createPool (connectToDatabase databaseFile) closeConnection 1 (fromInteger 1) 10
  let dataConfiguration = DataConfiguration { databaseFile = databaseFile , databasePool = connectionPool  }
  configuration <- atomically $ newTVar $ dataConfiguration
  return configuration
  
  