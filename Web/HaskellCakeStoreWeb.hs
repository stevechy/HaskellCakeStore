module Web.HaskellCakeStoreWeb
( app, buildApp )
where 


import Network.Wai as Wai
import qualified Web.Handler.HomePage as HomePage
import Web.HandlerMonad as HandlerMonad
import qualified Data.Conduit as Conduit
import qualified Configuration.Types
import qualified Data.DataHandler
import qualified Service.ServiceHandler 

data AppConfiguration a = AppConfiguration { responseHandler ::  (HandlerMonad a -> Conduit.ResourceT IO Wai.Response) }

buildApp :: Configuration.Types.Configuration -> IO ( Wai.Application )
buildApp configuration = do
  dataConfiguration <- Data.DataHandler.setupDataMonad configuration
  serviceHandler <- Service.ServiceHandler.setupServiceMonad configuration dataConfiguration
  return app

app :: Wai.Application
--app request = HomePage.handle request
app request = HandlerMonad.runHandlerMonad HomePage.handleMonad



