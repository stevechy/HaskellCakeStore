module Web.HaskellCakeStoreWeb
( app, buildApp )
where 


import Network.Wai as Wai
import qualified Web.Handler.HomePage as HomePage
import Web.WebHandler as WebHandler
import qualified Data.Conduit as Conduit
import qualified Configuration.Types
import qualified Data.DataHandler
import qualified Service.ServiceHandler 
import Control.Monad.Trans.Class (lift)
import qualified Web.WebHelper

data AppConfiguration a = AppConfiguration { responseHandler ::  (HandlerMonad a -> Conduit.ResourceT IO Wai.Response) }

buildApp :: Configuration.Types.Configuration -> IO ( Wai.Application )
buildApp configuration = do
  dataConfiguration <- Data.DataHandler.setupDataMonad configuration
  serviceHandler <- Service.ServiceHandler.setupServiceMonad configuration dataConfiguration
  return app

app :: Wai.Application
app request = case pathInfo request of
  [] -> WebHandler.runHandlerMonad HomePage.handleMonad
  path@_ -> do
    lift $ print $ "Not found " ++ (show path)
    return $ Web.WebHelper.notFoundValue $ Web.WebHelper.toBuilder ["Not Found"]


