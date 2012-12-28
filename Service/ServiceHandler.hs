{-# LANGUAGE GADTs, StandaloneDeriving #-}

module Service.ServiceHandler
(
 handleWithConfiguration,
ServiceCall(..),
ServiceConfiguration,
ServiceInstruction(..),
setupServiceMonad,
dataCall)
where

import Control.Monad.Operational
import Control.Concurrent.STM
import qualified Data.DataHandler
import qualified Configuration.Types


    
handleWithConfiguration :: ServiceConfiguration -> ServiceCall a -> IO a    
handleWithConfiguration configuration (ServiceCall {execution = exec })  = runServiceMonadWithConfiguration configuration exec

data ServiceConfiguration = ServiceConfiguration { dataConfiguration :: TVar Data.DataHandler.DataConfiguration }

data ServiceCall a = ServiceCall { name :: String, execution :: ServiceMonad a }


data ServiceInstruction a
    where CallService :: ServiceCall a -> ServiceInstruction a
          CallData :: Data.DataHandler.DataCall a -> ServiceInstruction a

dataCall ::  Data.DataHandler.DataCall a -> ServiceMonad a
dataCall call = singleton $ CallData call

type ServiceMonad a = Program ServiceInstruction a
      
runServiceMonadWithConfiguration :: ServiceConfiguration -> ServiceMonad a -> IO a
runServiceMonadWithConfiguration configuration = eval . view
  where
    eval :: ProgramView (ServiceInstruction) a -> IO a
    eval (Return x) = return x
    eval (CallService (ServiceCall {execution=exec}) :>>= k) = do  
      result <- runServiceMonadWithConfiguration configuration exec
      runServiceMonadWithConfiguration configuration $ k result
    eval (CallData call :>>= k) = do
      currentDataConfiguration <- atomically $ readTVar $ dataConfiguration $ configuration
      result <- Data.DataHandler.handleWithConfiguration currentDataConfiguration call  
      runServiceMonadWithConfiguration configuration $ k result


setupServiceMonad :: Configuration.Types.Configuration ->  TVar Data.DataHandler.DataConfiguration -> IO ServiceConfiguration
setupServiceMonad configuration dataConfig = do 
  return ServiceConfiguration { dataConfiguration = dataConfig }


