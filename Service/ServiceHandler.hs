{-# LANGUAGE GADTs, StandaloneDeriving #-}

module Service.ServiceHandler
(handle,
logHandle,
ServiceCall(..))
where

import Control.Monad.Operational
import qualified Data.DataHandler


handle :: ServiceCall a -> IO a
handle (ServiceCall {execution = exec })  = runServiceMonad exec

logHandle :: ServiceCall a -> IO a
logHandle call = do
    print $ name call
    handle call


data ServiceCall a = ServiceCall { name :: String, execution :: ServiceMonad a }


data ServiceInstruction a
    where CallService :: ServiceCall a -> ServiceInstruction a
          CallData :: ServiceInstruction [String]

type ServiceMonad a = Program ServiceInstruction a

runServiceMonad :: ServiceMonad a -> IO a
runServiceMonad = eval . view
  where
    eval :: ProgramView (ServiceInstruction) a -> IO a
    eval (Return x) = return x
    eval (CallService (ServiceCall {execution=exec}) :>>= k) = do  
      result <- runServiceMonad exec
      runServiceMonad $ k result
    eval (CallData :>>= k) = runServiceMonad $ k ["results"]



