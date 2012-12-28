{-# LANGUAGE OverloadedStrings #-}
module Tests.DataTest
(tests)
where
  
import Test.HUnit
import Data.DataHandler
import Data.Users
import qualified Configuration.Util
import Control.Concurrent.STM
import Database.HDBC

tests = TestList [
  TestLabel "database test"
  $ TestCase $ do
    Just configuration <- Configuration.Util.readConfiguration "Configuration.yaml"
    configurationTVar <- setupDataMonad configuration
    dataConfiguration <- atomically $ readTVar configurationTVar
    users <- handleWithConfiguration dataConfiguration getUsersCall    
    assertBool "Successfully queried" (users == [[SqlByteString "1",SqlByteString "DatabaseBob"]])
  ]  
        
        