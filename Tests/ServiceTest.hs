module Tests.ServiceTest
(tests)
where
  
  
import Test.HUnit
import qualified Data.DataHandler
import qualified Service.ServiceHandler
import qualified Configuration.Util
import qualified Service.Users
import qualified Service.Cakes
import qualified Data.Cakes
import qualified Model.Cake
import Control.Monad.Operational
import Data.Dynamic

tests = TestList [
  TestLabel "service to database test"
  $ TestCase $ do
    Just configuration <- Configuration.Util.readConfiguration "Configuration.yaml"
    configurationTVar <- Data.DataHandler.setupDataMonad configuration
    serviceConfiguration <- Service.ServiceHandler.setupServiceMonad configuration configurationTVar
    user <- Service.ServiceHandler.handleWithConfiguration serviceConfiguration Service.Users.getUser
    assertBool "Some users" ( (length user) > 0)
  ,
  TestLabel "cake call test"
  $ TestCase $ do
    Just configuration <- Configuration.Util.readConfiguration "Configuration.yaml"
    configurationTVar <- Data.DataHandler.setupDataMonad configuration
    serviceConfiguration <- Service.ServiceHandler.setupServiceMonad configuration configurationTVar
    cakes <- Service.ServiceHandler.handleWithConfiguration serviceConfiguration Service.Cakes.getCakes
    assertBool "Some cakes" ( (length cakes) >= 0)
  ,
   TestLabel "cake add test"
  $ TestCase $ do
    Just configuration <- Configuration.Util.readConfiguration "Configuration.yaml"
    configurationTVar <- Data.DataHandler.setupDataMonad configuration
    serviceConfiguration <- Service.ServiceHandler.setupServiceMonad configuration configurationTVar
    Service.ServiceHandler.handleWithConfiguration serviceConfiguration $ Service.Cakes.addCake "BlackForestTest"
    cakes <- Service.ServiceHandler.handleWithConfiguration serviceConfiguration Service.Cakes.getCakes        
    assertBool "Expecting black forest" $ not $ null $ (filter (\cake -> (Model.Cake.name cake) == "BlackForestTest") cakes)
  ,   
   TestLabel "mock getCakes"
   $ TestCase $ do    
     let interpretGetCakes = eval . view
         eval :: ProgramView (Service.ServiceHandler.ServiceInstruction) a -> IO a
         eval (Return x) = return x         
         eval (Service.ServiceHandler.CallData call :>>= k) = do
           let result = Data.DataHandler.provideResult call (toDyn [Model.Cake.Cake 0 "Black Forest"])
           interpretGetCakes $ k result
     
     result <- interpretGetCakes $ Service.ServiceHandler.execution Service.Cakes.getCakes
     assertBool "Expecting cakes" (result == [Model.Cake.Cake 0 "Black Forest"])
  ]
        