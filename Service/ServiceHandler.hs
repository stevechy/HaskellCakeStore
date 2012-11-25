{-# LANGUAGE GADTs, StandaloneDeriving #-}

module Service.ServiceHandler
(handle,
logHandle,
ServiceCall,
getUser)
where

import qualified Service.Users as Users

handle :: ServiceCall a -> IO a
handle GetUser =  Users.getUser

logHandle :: ServiceCall a -> IO a
logHandle call = do
    print $ show $ call
    handle call


data ServiceCall a
    where GetUser :: ServiceCall String

deriving instance Show (ServiceCall a) 

getUser = GetUser