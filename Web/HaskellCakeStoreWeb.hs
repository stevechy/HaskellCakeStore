module Web.HaskellCakeStoreWeb
( app, buildApp )
where 


import Network.Wai as Wai
import qualified Web.Handler.HomePage as HomePage
import Web.HandlerMonad as HandlerMonad
import qualified Data.Conduit as Conduit

data AppConfiguration a = AppConfiguration { responseHandler ::  (HandlerMonad a -> Conduit.ResourceT IO Wai.Response) }

buildApp :: IO ( Wai.Application )
buildApp = do
  dataHandler <- return ()
  serviceHandler <- return ()
  return app

app :: Wai.Application
--app request = HomePage.handle request
app request = HandlerMonad.runHandlerMonad HomePage.handleMonad



