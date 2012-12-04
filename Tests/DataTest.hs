module Tests.DataTest
(tests)
where
  
import Test.HUnit
import Data.DataHandler
import Data.Users
import qualified Configuration.Util
import Control.Concurrent.STM

tests = TestList [
  TestLabel "basictest"  
  $ TestCase $ (assertEqual "Sanity" (1,2) (1,2)),
  TestLabel "database test"
  $ TestCase $ do
    Just configuration <- Configuration.Util.readConfiguration "Configuration.yaml"
    configurationTVar <- setupDataMonad configuration
    dataConfiguration <- atomically $ readTVar configurationTVar
    users <- handleWithConfiguration dataConfiguration getUsersCall
    assertBool "Successfully queried" True
  ]  
        
        