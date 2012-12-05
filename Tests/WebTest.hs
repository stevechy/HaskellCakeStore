module Tests.WebTest
(tests)
where
  
  
import Test.HUnit
import qualified Data.DataHandler
import qualified Service.ServiceHandler
import qualified Configuration.Util
import qualified Service.Users
import qualified Web.WebHandler
import qualified Web.WebHelper
import Control.Monad.Trans.Resource
import Data.ByteString.Lazy.UTF8
import Blaze.ByteString.Builder
import Data.Conduit
import Network.Wai

tests = TestList [
  TestLabel "web to service to database test"
  $ TestCase $ do
    Just configuration <- Configuration.Util.readConfiguration "Configuration.yaml"
    configurationTVar <- Data.DataHandler.setupDataMonad configuration
    serviceConfiguration <- Service.ServiceHandler.setupServiceMonad configuration configurationTVar
    webConfiguration <- Web.WebHandler.setupHandlerMonad configuration serviceConfiguration 
    let handler = do
          Web.WebHandler.renderView $ Web.WebHelper.toBuilder ["One","Two"]
    ResponseBuilder _ _ returnValue <- runResourceT $ Web.WebHandler.handleMonadWithConfiguration webConfiguration handler
    assertEqual "Return value" (toLazyByteString returnValue) (fromString "OneTwo")
  ]