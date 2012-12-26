{-# LANGUAGE OverloadedStrings #-}

module Web.Handler.CakesPage
(route)
where

import qualified Web.View.Cake
import qualified Web.WebHandler
import qualified Service.Cakes
import qualified Data.Text

route :: [Data.Text.Text] -> Web.WebHandler.HandlerMonad ()
route [] = listCakes
route _ = listCakes


listCakes :: Web.WebHandler.HandlerMonad ()
listCakes = do        
  cakes <- Web.WebHandler.callService Service.Cakes.getCakes
  Web.WebHandler.renderView $ Web.View.Cake.render $ cakes
  return ()
  

