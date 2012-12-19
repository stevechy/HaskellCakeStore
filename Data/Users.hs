{-# LANGUAGE NoMonomorphismRestriction  #-}
module Data.Users
(getUsersCall)

where
  
  
import Database.HDBC 
import qualified Data.DataHandler

getUsersCall :: Data.DataHandler.DataCall [[SqlValue]]
getUsersCall = Data.DataHandler.DataCall {
  Data.DataHandler.name = "getUsersCall",
  Data.DataHandler.execution = selectUsers
  }
               
selectUsers :: Data.DataHandler.DataMonad [[SqlValue]]
selectUsers = do
  users <- selectUsersTransaction
  return users
  
selectUsersTransaction :: Data.DataHandler.DataMonad [[SqlValue]]
selectUsersTransaction =  Data.DataHandler.withTrans selectUsersQuery

selectUsersQuery :: IConnection conn => conn -> IO [[SqlValue]]
selectUsersQuery connection = do 
  quickQuery' connection "SELECT * from users" []