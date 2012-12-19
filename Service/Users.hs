{-# LANGUAGE NoMonomorphismRestriction #-}

module Service.Users
(getUser,addUser)
where
  
import qualified Data.Users
import Service.ServiceHandler
  
getUser :: ServiceCall String  
getUser = ServiceCall {
  Service.ServiceHandler.name = "getUser",
  Service.ServiceHandler.execution = do
    users <- dataCall Data.Users.getUsersCall
    return $ show users
  }
  

addUser :: String -> ServiceCall ()  
addUser username  = ServiceCall {
  name = "getUser",
  execution = do
    dataCall $ Data.Users.addUser username
    return ()
  }
