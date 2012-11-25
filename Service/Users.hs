{-# LANGUAGE NoMonomorphismRestriction #-}

module Service.Users
(getUser)
where
  
import qualified Data.Users
  
getUser = do
  users <- Data.Users.getUsers
  return $ head users
  


