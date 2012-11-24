{-# LANGUAGE GADTs #-}

module Service.ServiceHandler
(handle,
ServiceCall,
getUser)
where

import qualified Service.Users as Users

handle :: ServiceCall a -> IO a
handle GetUser = return Users.getUser

data ServiceCall a
    where GetUser :: ServiceCall String

getUser = GetUser