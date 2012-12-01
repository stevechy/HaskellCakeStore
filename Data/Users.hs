{-# LANGUAGE NoMonomorphismRestriction  #-}
module Data.Users
(getUsers)

where
  
  
import Database.HDBC 
import Database.HDBC.Sqlite3

getUsers = return ["User1", "User2"]

selectUsers = do
  return ()

