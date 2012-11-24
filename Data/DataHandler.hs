{-# LANGUAGE GADTs #-}

module Data.DataHandler
(handle,
DataCall)
where

import qualified Data.Users as Users


handle :: DataCall a -> IO a
handle GetUsers = return Users.getUsers

data DataCall a 
     where GetUsers :: DataCall [String]