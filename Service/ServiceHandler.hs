{-# LANGUAGE GADTs, StandaloneDeriving #-}

module Service.ServiceHandler
(handle,
logHandle,
ServiceCall(..),
setupServiceMonad,
dataCall)
where

import Control.Monad.Operational
import Control.Concurrent.STM
import qualified Data.DataHandler
import qualified Configuration.Types


handle :: ServiceCall a -> IO a
handle (ServiceCall {execution = exec })  = runServiceMonad exec

logHandle :: ServiceCall a -> IO a
logHandle call = do
    print $ name call
    handle call


data ServiceConfiguration = ServiceConfiguration { dataConfiguration :: TVar Data.DataHandler.DataConfiguration }

data ServiceCall a = ServiceCall { name :: String, execution :: ServiceMonad a }


data ServiceInstruction a
    where CallService :: ServiceCall a -> ServiceInstruction a
          CallData :: Data.DataHandler.DataCall a -> ServiceInstruction a

dataCall dataCall = singleton $ CallData dataCall

type ServiceMonad a = Program ServiceInstruction a

runServiceMonad :: ServiceMonad a -> IO a
runServiceMonad = eval . view
  where
    eval :: ProgramView (ServiceInstruction) a -> IO a
    eval (Return x) = return x
    eval (CallService (ServiceCall {execution=exec}) :>>= k) = do  
      result <- runServiceMonad exec
      runServiceMonad $ k result
    eval (CallData call :>>= k) = do
      result <- Data.DataHandler.handle call  
      runServiceMonad $ k result


setupServiceMonad :: Configuration.Types.Configuration ->  TVar Data.DataHandler.DataConfiguration -> IO ServiceConfiguration
setupServiceMonad configuration dataConfig = do 
  return ServiceConfiguration { dataConfiguration = dataConfig }


