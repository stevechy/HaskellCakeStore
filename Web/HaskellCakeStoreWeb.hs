{-# LANGUAGE OverloadedStrings #-}

module Web.HaskellCakeStoreWeb
( app, buildApp )
where 


import Network.Wai as Wai
import qualified Web.Handler.HomePage as HomePage
import qualified Web.Handler.CakesPage
import Web.WebHandler as WebHandler
import qualified Configuration.Types
import qualified Data.DataHandler
import qualified Service.ServiceHandler 
import Control.Monad.Trans.Class (lift)
import qualified Web.WebHelper


buildApp :: Configuration.Types.Configuration -> IO ( Wai.Application )
buildApp configuration = do
  dataConfiguration <- Data.DataHandler.setupDataMonad configuration
  serviceConfiguration <- Service.ServiceHandler.setupServiceMonad configuration dataConfiguration
  webConfiguration <- WebHandler.setupHandlerMonad configuration serviceConfiguration 
  return $ app webConfiguration

app :: WebHandler.WebConfiguration ->  Wai.Application
app webConfiguration request = case pathInfo request of
  [] -> WebHandler.handleMonadWithConfiguration webConfiguration HomePage.handleMonad
  "cakes" : rest -> WebHandler.handleMonadWithConfiguration webConfiguration $  Web.Handler.CakesPage.route rest
  path@_ -> do
    lift $ print $ "Not found " ++ (show path)
    return $ Web.WebHelper.notFoundValue $ Web.WebHelper.toBuilder ["Not Found"]


