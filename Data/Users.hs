{-# LANGUAGE NoMonomorphismRestriction  #-}
module Data.Users
(getUsers, getUsersCall)

where
  
  
import Database.HDBC 
import qualified Data.DataHandler

getUsers = return ["User1", "User2"]

getUsersCall = Data.DataHandler.DataCall {
  Data.DataHandler.name = "getUsersCall",
  Data.DataHandler.execution = selectUsers
  }

selectUsers = do
  users <- selectUsersTransaction
  return users
  
selectUsersTransaction :: Data.DataHandler.DataMonad [[SqlValue]]
selectUsersTransaction =  Data.DataHandler.withTrans selectUsersQuery

selectUsersQuery :: IConnection conn => conn -> IO [[SqlValue]]
selectUsersQuery connection = do 
  quickQuery' connection "SELECT * from users" []