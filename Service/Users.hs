{-# LANGUAGE NoMonomorphismRestriction #-}

module Service.Users
(getUser)
where
  
import qualified Data.Users
import qualified Service.ServiceHandler
  
getUser = Service.ServiceHandler.ServiceCall {
  Service.ServiceHandler.name = "getUser",
  Service.ServiceHandler.execution = do
    users <- Data.Users.getUsers
    return $ head users
  }
  


