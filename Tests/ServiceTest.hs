module Tests.ServiceTest
(tests)
where
  
  
import Test.HUnit
import qualified Data.DataHandler
import qualified Service.ServiceHandler
import qualified Configuration.Util
import qualified Service.Users

tests = TestList [
  TestLabel "service to database test"
  $ TestCase $ do
    Just configuration <- Configuration.Util.readConfiguration "Configuration.yaml"
    configurationTVar <- Data.DataHandler.setupDataMonad configuration
    serviceConfiguration <- Service.ServiceHandler.setupServiceMonad configuration configurationTVar
    user <- Service.ServiceHandler.handleWithConfiguration serviceConfiguration Service.Users.getUser
    assertBool "Some users" ( (length user) > 0)
  ]
        