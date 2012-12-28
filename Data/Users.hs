{-# LANGUAGE NoMonomorphismRestriction  #-}
module Data.Users
(getUsersCall, addUser)

where
  
  
import Database.HDBC 
import qualified Data.DataHandler

addUser :: String -> Data.DataHandler.DataCall Integer
addUser username = Data.DataHandler.DataCall {
  Data.DataHandler.name = "addUser",
  Data.DataHandler.execution = Data.DataHandler.withTrans $ addUserTransaction username,
  Data.DataHandler.provideResult = Data.DataHandler.provideBlank 
  }
                   
addUserTransaction username connection = run connection  ("INSERT INTO users (name) VALUES ('" ++ username ++"')") []

getUsersCall :: Data.DataHandler.DataCall [[SqlValue]]
getUsersCall = Data.DataHandler.DataCall {
  Data.DataHandler.name = "getUsersCall",
  Data.DataHandler.execution = selectUsers,
  Data.DataHandler.provideResult = Data.DataHandler.provideBlank 
  }
               
selectUsers :: Data.DataHandler.DataMonad [[SqlValue]]
selectUsers = do
  let selectUsersQuery connection = quickQuery' connection "SELECT * from users" []
  users <-  Data.DataHandler.withTrans selectUsersQuery 
  return users
  
  